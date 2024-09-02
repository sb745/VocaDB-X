import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocadb_app/src/features/releaseEvents/data/constants/fake_release_events_list.dart';
import 'package:vocadb_app/src/features/releaseEvents/domain/release_events_list_params.dart';

import '../../../../mocks.dart';
import 'release_events_list_screen_robot.dart';

void main() {
  testWidgets('Release events list screen ...', (tester) async {
    registerFallbackValue(FakeReleaseEventsListParams());

    final r = ReleaseEventsListScreenRobot(tester);
    final releaseEventRepository = MockReleaseEventRepository();

    when(() => releaseEventRepository.fetchReleaseEventsList(
          params: any(named: 'params', that: isNotNull),
        )).thenAnswer((_) => Future.value(kFakeReleaseEventsList));

    await r.pumpReleaseEventsListScreen(releaseEventRepository: releaseEventRepository);

    await r.expectReleaseEventsDisplayCountAtLeast(2);

    expect(
        verify(() =>
                releaseEventRepository.fetchReleaseEventsList(params: captureAny(named: 'params')))
            .captured,
        [
          const ReleaseEventsListParams(),
        ]);
  });
}
