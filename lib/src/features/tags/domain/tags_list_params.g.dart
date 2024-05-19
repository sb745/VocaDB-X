// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_list_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TagsListParams _$$_TagsListParamsFromJson(Map<String, dynamic> json) =>
    _$_TagsListParams(
      query: json['query'] as String?,
      categoryName: json['categoryName'] as String?,
      start: json['start'] as int? ?? 0,
      maxResults: json['maxResults'] as int? ?? 10,
      sort: json['sort'] as String? ?? 'None',
      nameMatchMode: json['nameMatchMode'] as String? ?? 'Name',
      lang: json['lang'] as String? ?? 'Default',
    );

Map<String, dynamic> _$$_TagsListParamsToJson(_$_TagsListParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('query', instance.query);
  writeNotNull('categoryName', instance.categoryName);
  val['start'] = instance.start;
  val['maxResults'] = instance.maxResults;
  val['sort'] = instance.sort;
  val['nameMatchMode'] = instance.nameMatchMode;
  val['lang'] = instance.lang;
  return val;
}
