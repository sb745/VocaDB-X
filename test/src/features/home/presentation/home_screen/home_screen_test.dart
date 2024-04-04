import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import 'home_robot.dart';

void main() {
  testWidgets('Render home screen correctly', (tester) async {
    final r = HomeRobot(tester);
    final songRepository = MockSongRepository();
    final albumRepository = MockAlbumRepository();
    final releaseEventRepository = MockReleaseEventRepository();

    await r.pumpHomeScreen(
      songRepository: songRepository,
      albumRepository: albumRepository,
      releaseEventRepository: releaseEventRepository,
    );

    // Verify Shortcut menus
    await r.expectShortcutSongSearchIsVisible(true);
    await r.expectShortcutArtistSearchIsVisible(true);
    await r.expectShortcutAlbumSearchIsVisible(true);
    await r.expectShortcutTagSearchIsVisible(true);
    await r.expectShortcutEventSearchIsVisible(true);

    await r.scrollDown();

    verify(songRepository.fetchSongsHighlighted).called(1);
    verify(albumRepository.fetchNew).called(1);
    verify(albumRepository.fetchTop).called(1);
    verify(releaseEventRepository.fetchRecentEvents).called(1);
  });
}
