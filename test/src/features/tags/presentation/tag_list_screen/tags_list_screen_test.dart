import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocadb_app/src/features/tags/data/constants/fake_tags_list.dart';
import 'package:vocadb_app/src/features/tags/domain/tags_list_params.dart';

import '../../../../mocks.dart';
import 'tags_list_screen_robot.dart';

void main() {
  testWidgets('tags list screen ...', (tester) async {
    registerFallbackValue(FakeTagsListParams());

    final r = TagsListScreenRobot(tester);
    final tagRepository = MockTagRepository();

    when(() => tagRepository.fetchTagsList(
          params: any(named: 'params', that: isNotNull),
        )).thenAnswer((_) => Future.value(kFakeTagsList));

    await r.pumpTagsListScreen(tagRepository: tagRepository);

    await r.expectTagsDisplayCountAtLeast(3);

    expect(
        verify(() =>
                tagRepository.fetchTagsList(params: captureAny(named: 'params')))
            .captured,
        [
          const TagsListParams(),
        ]);
  });
}
