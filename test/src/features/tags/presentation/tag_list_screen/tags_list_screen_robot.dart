import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';
import 'package:vocadb_app/src/features/tags/data/tag_repository.dart';
import 'package:vocadb_app/src/features/tags/presentation/tag_list_screen/tags_list_screen.dart';

class TagsListScreenRobot {
  final WidgetTester tester;

  TagsListScreenRobot(this.tester);

  Future<void> pumpTagsListScreen(
      {TagRepository? tagRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (tagRepository != null)
            tagRepositoryProvider.overrideWithValue(tagRepository),
          userSettingsRepositoryProvider
              .overrideWithValue(UserSettingsRepository())
        ],
        child: const MaterialApp(
          home: TagsListScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  Future<void> expectTagsDisplayCountAtLeast(int count) async {
    final finder = find.byType(ListTile);
    expect(finder, findsAtLeastNWidgets(count));
  }
}
