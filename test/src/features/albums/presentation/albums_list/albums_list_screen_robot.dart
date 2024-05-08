import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocadb_app/src/features/albums/data/album_repository.dart';
import 'package:vocadb_app/src/features/albums/presentation/album_tile/album_tile.dart';
import 'package:vocadb_app/src/features/albums/presentation/albums_list/albums_list_screen.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';

class AlbumsListScreenRobot {
  final WidgetTester tester;

  AlbumsListScreenRobot(this.tester);

  Future<void> pumpAlbumsListScreen(
      {AlbumRepository? albumRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (albumRepository != null)
            albumRepositoryProvider.overrideWithValue(albumRepository),
          userSettingsRepositoryProvider
              .overrideWithValue(UserSettingsRepository())
        ],
        child: const MaterialApp(
          home: AlbumsListScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  Future<void> expectAlbumsDisplayCountAtLeast(int count) async {
    final finder = find.byType(AlbumTile);
    expect(finder, findsAtLeastNWidgets(count));
  }
}
