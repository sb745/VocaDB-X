import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/albums/domain/albums_list_params.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';

class AlbumsListParamsState extends StateNotifier<AlbumsListParams> {
  AlbumsListParamsState({String lang = 'Default'})
      : super(AlbumsListParams(lang: lang));
  void updateDiscTypes(String? value) =>
      state = state.copyWith(discTypes: value);
  void updateQuery(String value) => state = state.copyWith(query: value);
  void updateSort(String value) => state = state.copyWith(sort: value);
  void clearQuery() => state = state.copyWith(query: null);
}

final albumsListParamsStateProvider = StateNotifierProvider.autoDispose<
    AlbumsListParamsState, AlbumsListParams>((ref) {
  final preferredLang = ref.watch(userSettingsRepositoryProvider
      .select((value) => value.currentPreferredLang));
  return AlbumsListParamsState(lang: preferredLang);
});
