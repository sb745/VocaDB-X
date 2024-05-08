import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocadb_app/src/features/albums/data/constants/fake_albums_list.dart';
import 'package:vocadb_app/src/features/albums/domain/albums_list_params.dart';

import '../../../../mocks.dart';
import 'albums_list_screen_robot.dart';

void main() {
  testWidgets('albums list screen ...', (tester) async {
    registerFallbackValue(FakeAlbumsListParams());

    final r = AlbumsListScreenRobot(tester);
    final albumRepository = MockAlbumRepository();

    when(() => albumRepository.fetchAlbums(
          params: any(named: 'params', that: isNotNull),
        )).thenAnswer((_) => Future.value(kFakeAlbumsList));

    await r.pumpAlbumsListScreen(albumRepository: albumRepository);

    await r.expectAlbumsDisplayCountAtLeast(3);

    expect(
        verify(() =>
                albumRepository.fetchAlbums(params: captureAny(named: 'params')))
            .captured,
        [
          const AlbumsListParams(),
        ]);
  });
}
