import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocadb_app/src/features/releaseEvents/data/release_event_repository.dart';
import 'package:vocadb_app/src/features/releaseEvents/presentation/release_event_tile/release_event_tile.dart';
import 'package:vocadb_app/src/features/releaseEvents/presentation/release_events_list_screen/release_events_list_screen.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';

class ReleaseEventsListScreenRobot {
  final WidgetTester tester;

  ReleaseEventsListScreenRobot(this.tester);

  Future<void> pumpReleaseEventsListScreen(
      {ReleaseEventRepository? releaseEventRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (releaseEventRepository != null)
            releaseEventRepositoryProvider.overrideWithValue(releaseEventRepository),
          userSettingsRepositoryProvider
              .overrideWithValue(UserSettingsRepository())
        ],
        child: const MaterialApp(
          home: ReleaseEventsListScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  Future<void> expectReleaseEventsDisplayCountAtLeast(int count) async {
    final finder = find.byType(ReleaseEventTile);
    expect(finder, findsAtLeastNWidgets(count));
  }
}
