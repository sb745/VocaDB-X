import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocadb_app/src/common_widgets/search_appbar.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';
import 'package:vocadb_app/src/features/songs/data/song_repository.dart';
import 'package:vocadb_app/src/features/songs/presentation/song_tile/song_tile.dart';
import 'package:vocadb_app/src/features/songs/presentation/songs_list_screen/songs_list_filter_screen.dart';
import 'package:vocadb_app/src/features/songs/presentation/songs_list_screen/songs_list_screen.dart';

class SongsListScreenRobot {
  final WidgetTester tester;

  SongsListScreenRobot(this.tester);

  Future<void> pumpSongsListScreen(
      {SongRepository? songRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (songRepository != null)
            songRepositoryProvider.overrideWithValue(songRepository),
          userSettingsRepositoryProvider
              .overrideWithValue(UserSettingsRepository())
        ],
        child: const MaterialApp(
          home: SongsListScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  Future<void> pumpSongsListFilterScreen(
      {SongRepository? songRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (songRepository != null)
            songRepositoryProvider.overrideWithValue(songRepository),
          userSettingsRepositoryProvider
              .overrideWithValue(UserSettingsRepository())
        ],
        child: const MaterialApp(
          home: SongsFilterScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  Future<void> expectSongsDisplayCountAtLeast(int count) async {
    final finder = find.byType(SongTile);
    expect(finder, findsAtLeastNWidgets(count));
  }
  
  Future<void> expectSongsDisplayCount(int count) async {
    final finder = find.byType(SongTile);
    expect(finder, findsNWidgets(count));
  }

  Future<void> tapSearchIcon() async {
    final finder = find.byKey(SearchAppBar.iconSearchKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> typingSearchText(String text) async {
    final finder = find.byKey(SearchAppBar.searchInputKey);
    expect(finder, findsOneWidget);
    await tester.enterText(finder, text);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
  }
}
