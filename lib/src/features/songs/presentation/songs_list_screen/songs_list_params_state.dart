import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/settings/data/user_settings_repository.dart';
import 'package:vocadb_app/src/features/songs/domain/songs_list_params.dart';

class SongsListParamsState extends StateNotifier<SongsListParams> {
  SongsListParamsState({String lang = 'Default'})
      : super(SongsListParams(lang: lang));
  void updateSongTypes(String? value) =>
      state = state.copyWith(songTypes: value);
  void updateQuery(String value) => state = state.copyWith(query: value);
  void updateSort(String value) => state = state.copyWith(sort: value);
  void clearQuery() => state = state.copyWith(query: null);
}

final songsListParamsStateProvider = StateNotifierProvider.autoDispose<
    SongsListParamsState, SongsListParams>((ref) {
  final preferredLang = ref.watch(userSettingsRepositoryProvider
      .select((value) => value.currentPreferredLang));
  return SongsListParamsState(lang: preferredLang);
});
