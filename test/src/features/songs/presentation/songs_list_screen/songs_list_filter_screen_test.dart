import 'package:flutter_test/flutter_test.dart';
import 'package:vocadb_app/src/features/songs/presentation/widgets/dropdown_song_sort.dart';
import 'package:vocadb_app/src/features/songs/presentation/widgets/dropdown_song_types.dart';

import '../../../../mocks.dart';
import 'songs_list_screen_robot.dart';

void main() {
  testWidgets('Render song list filter screen without error', (tester) async {
    final r = SongsListScreenRobot(tester);

    final songRepository = MockSongRepository();

    await r.pumpSongsListFilterScreen(songRepository: songRepository);

    expect(find.byType(DropdownSongTypes), findsOneWidget);
    expect(find.byType(DropdownSongSort), findsOneWidget);
  });
}