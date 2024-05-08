import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocadb_app/src/features/albums/presentation/albums_list/albums_list_filter_screen.dart';
import 'package:vocadb_app/src/features/albums/presentation/widgets/dropdown_album_sort.dart';
import 'package:vocadb_app/src/features/albums/presentation/widgets/dropdown_album_type.dart';

class AlbumsListFilterScreenRobot {
  final WidgetTester tester;

  AlbumsListFilterScreenRobot(this.tester);

  Future<void> pumpAlbumsListFilterScreen({
    Function(String?)? onAlbumsTypesChanged,
    Function(String?)? onSortChanged,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AlbumsFilterScreen(
            onAlbumTypesChanged: onAlbumsTypesChanged,
            onSortChanged: onSortChanged,
          ),
        ),
      ),
    );
  }

  Future<void> selectAlbumTypes(String value) async {
    final albumTypeDropdownBtnFinder =
        find.byKey(DropdownAlbumType.dropdownKey);
    expect(albumTypeDropdownBtnFinder, findsOneWidget);

    await tester.tap(albumTypeDropdownBtnFinder);
    await tester.pump();

    final selectedFinder = find.text(value).last;
    expect(selectedFinder, findsOneWidget);
    await tester.tap(selectedFinder);
    await tester.pump();
  }

  Future<void> selectSort(String value) async {
    final albumSortDropdownBtnFinder =
        find.byKey(DropdownAlbumSort.dropdownKey);
    expect(albumSortDropdownBtnFinder, findsOneWidget);

    await tester.tap(albumSortDropdownBtnFinder);
    await tester.pump();

    final selectedFinder = find.text(value).last;
    expect(selectedFinder, findsOneWidget);
    await tester.tap(selectedFinder);
    await tester.pump();
  }
}
