import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';
import 'package:vocadb_app/src/features/tags/domain/tags_list_params.dart';

class TagsListParamsState extends StateNotifier<TagsListParams> {
  TagsListParamsState({String lang = 'Default'})
      : super(TagsListParams(lang: lang));
  void updateQuery(String value) => state = state.copyWith(query: value);
  void updateCategoryName(String value) => state = state.copyWith(categoryName: value);
  void updateSort(String value) => state = state.copyWith(sort: value);
  void clearQuery() => state = state.copyWith(query: null);
}

final tagsListParamsStateProvider = StateNotifierProvider.autoDispose<
    TagsListParamsState, TagsListParams>((ref) {
  final preferredLang = ref.watch(userSettingsRepositoryProvider
      .select((value) => value.currentPreferredLang));
  return TagsListParamsState(lang: preferredLang);
});
