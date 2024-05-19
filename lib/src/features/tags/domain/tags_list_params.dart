import 'package:freezed_annotation/freezed_annotation.dart';

part 'tags_list_params.freezed.dart';
part 'tags_list_params.g.dart';

@freezed
class TagsListParams with _$TagsListParams {
  @JsonSerializable(includeIfNull: false)
  const factory TagsListParams({
    String? query,
    String? categoryName,
    @Default(0) int start,
    @Default(10) int maxResults,
    @Default('None') String sort,
    @Default('Name') String nameMatchMode,
    @Default('Default') String lang,
  }) = _TagsListParams;

  factory TagsListParams.fromJson(Map<String, dynamic> json) =>
      _$TagsListParamsFromJson(json);
}
