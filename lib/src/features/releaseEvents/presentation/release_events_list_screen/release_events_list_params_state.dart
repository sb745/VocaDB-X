import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/releaseEvents/domain/release_events_list_params.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';

class ReleaseEventsListParamsState extends StateNotifier<ReleaseEventsListParams> {
  ReleaseEventsListParamsState({String lang = 'Default'})
      : super(ReleaseEventsListParams(lang: lang));
  void updateQuery(String value) => state = state.copyWith(query: value);
  void updateSort(String value) => state = state.copyWith(sort: value);
  void clearQuery() => state = state.copyWith(query: null);
}

final releaseEventsListParamsStateProvider = StateNotifierProvider.autoDispose<
    ReleaseEventsListParamsState, ReleaseEventsListParams>((ref) {
  final preferredLang = ref.watch(userSettingsRepositoryProvider
      .select((value) => value.currentPreferredLang));
  return ReleaseEventsListParamsState(lang: preferredLang);
});
