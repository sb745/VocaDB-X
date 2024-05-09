
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/common_widgets/async_value_widget.dart';
import 'package:vocadb_app/src/common_widgets/search_appbar.dart';
import 'package:vocadb_app/src/features/artists/data/artist_repository.dart';
import 'package:vocadb_app/src/features/artists/domain/artist.dart';
import 'package:vocadb_app/src/features/artists/presentation/artists_list/artist_list_view.dart';
import 'package:vocadb_app/src/features/artists/presentation/artists_list_screen/artists_list_params_state.dart';
import 'package:vocadb_app/src/features/releaseEvents/data/release_event_repository.dart';
import 'package:vocadb_app/src/features/releaseEvents/domain/release_event.dart';
import 'package:vocadb_app/src/features/releaseEvents/presentation/release_events_list/release_events_list_view.dart';
import 'package:vocadb_app/src/features/releaseEvents/presentation/release_events_list_screen/release_events_list_params_state.dart';
import 'package:vocadb_app/src/routing/app_route_context.dart';

class ReleaseEventsListScreen extends ConsumerWidget {
  const ReleaseEventsListScreen({super.key, this.onSelectEvent});

  static const filterKey = Key('icon-filter-key');

  final Function(ReleaseEvent)? onSelectEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SearchAppBar(
        titleText: 'Events',
        onSubmitted: (value) {
          ref.read(releaseEventsListParamsStateProvider.notifier).updateQuery(value);
        },
        onCleared: () {
          ref.read(releaseEventsListParamsStateProvider.notifier).clearQuery();
        },
      ),
      body: Consumer(builder: ((context, ref, child) {
        final value = ref.watch(releaseEventsListProvider);
        return AsyncValueWidget(
            value: value,
            data: (data) {
              return ReleaseEventsListView(
                events: data,
                onSelect: (event) => onSelectEvent?.call(event),
              );
            });
      })),
    );
  }
}

// State
final releaseEventsListProvider = FutureProvider.autoDispose<List<ReleaseEvent>>((ref) {
  final params = ref.watch(releaseEventsListParamsStateProvider);
  final releaseEventRepository = ref.watch(releaseEventRepositoryProvider);
  return releaseEventRepository.fetchReleaseEventsList(params: params);
});
