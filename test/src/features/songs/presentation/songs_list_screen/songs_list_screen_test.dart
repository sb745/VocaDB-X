import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocadb_app/src/features/songs/data/constants/fake_songs_list.dart';
import 'package:vocadb_app/src/features/songs/domain/songs_list_params.dart';

import '../../../../mocks.dart';
import 'songs_list_screen_robot.dart';

void main() {
  testWidgets('song list screen test', (tester) async {
    registerFallbackValue(FakeSongsListParams());

    final r = SongsListScreenRobot(tester);
    final songRepository = MockSongRepository();

    when(() => songRepository.fetchSongsList(
          params: any(named: 'params', that: isNotNull),
        )).thenAnswer((_) => Future.value(kFakeSongsList));

    await r.pumpSongsListScreen(songRepository: songRepository);

    await r.expectSongsDisplayCountAtLeast(3);

    expect(
        verify(() =>
                songRepository.fetchSongsList(params: captureAny(named: 'params')))
            .captured,
        [
          const SongsListParams(),
        ]);
  });

}