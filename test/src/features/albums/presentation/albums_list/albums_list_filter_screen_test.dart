import 'package:flutter_test/flutter_test.dart';

import 'albums_list_filter_screen_robot.dart';

void main() {
  group('albums filter screen', () {
    testWidgets('change album type', (tester) async {
      String? selectedValue;
      final r = AlbumsListFilterScreenRobot(tester);

      await r.pumpAlbumsListFilterScreen(
        onAlbumsTypesChanged: (value) => selectedValue = value,
      );

      await r.selectAlbumTypes('E.P.');
      expect(selectedValue, 'EP');
    });

    testWidgets('change album sort', (tester) async {
      String? selectedValue;
      final r = AlbumsListFilterScreenRobot(tester);

      await r.pumpAlbumsListFilterScreen(
        onAlbumsTypesChanged: (value) => selectedValue = value,
      );

      await r.selectSort('Addition date');
      expect(selectedValue, 'AdditionDate');
    });
  });
}
