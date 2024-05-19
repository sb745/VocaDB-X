// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tags_list_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TagsListParams _$TagsListParamsFromJson(Map<String, dynamic> json) {
  return _TagsListParams.fromJson(json);
}

/// @nodoc
mixin _$TagsListParams {
  String? get query => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  int get start => throw _privateConstructorUsedError;
  int get maxResults => throw _privateConstructorUsedError;
  String get sort => throw _privateConstructorUsedError;
  String get nameMatchMode => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagsListParamsCopyWith<TagsListParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagsListParamsCopyWith<$Res> {
  factory $TagsListParamsCopyWith(
          TagsListParams value, $Res Function(TagsListParams) then) =
      _$TagsListParamsCopyWithImpl<$Res, TagsListParams>;
  @useResult
  $Res call(
      {String? query,
      String? categoryName,
      int start,
      int maxResults,
      String sort,
      String nameMatchMode,
      String lang});
}

/// @nodoc
class _$TagsListParamsCopyWithImpl<$Res, $Val extends TagsListParams>
    implements $TagsListParamsCopyWith<$Res> {
  _$TagsListParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? categoryName = freezed,
    Object? start = null,
    Object? maxResults = null,
    Object? sort = null,
    Object? nameMatchMode = null,
    Object? lang = null,
  }) {
    return _then(_value.copyWith(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int,
      maxResults: null == maxResults
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      nameMatchMode: null == nameMatchMode
          ? _value.nameMatchMode
          : nameMatchMode // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TagsListParamsCopyWith<$Res>
    implements $TagsListParamsCopyWith<$Res> {
  factory _$$_TagsListParamsCopyWith(
          _$_TagsListParams value, $Res Function(_$_TagsListParams) then) =
      __$$_TagsListParamsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? query,
      String? categoryName,
      int start,
      int maxResults,
      String sort,
      String nameMatchMode,
      String lang});
}

/// @nodoc
class __$$_TagsListParamsCopyWithImpl<$Res>
    extends _$TagsListParamsCopyWithImpl<$Res, _$_TagsListParams>
    implements _$$_TagsListParamsCopyWith<$Res> {
  __$$_TagsListParamsCopyWithImpl(
      _$_TagsListParams _value, $Res Function(_$_TagsListParams) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = freezed,
    Object? categoryName = freezed,
    Object? start = null,
    Object? maxResults = null,
    Object? sort = null,
    Object? nameMatchMode = null,
    Object? lang = null,
  }) {
    return _then(_$_TagsListParams(
      query: freezed == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int,
      maxResults: null == maxResults
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
      sort: null == sort
          ? _value.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as String,
      nameMatchMode: null == nameMatchMode
          ? _value.nameMatchMode
          : nameMatchMode // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$_TagsListParams implements _TagsListParams {
  const _$_TagsListParams(
      {this.query,
      this.categoryName,
      this.start = 0,
      this.maxResults = 10,
      this.sort = 'None',
      this.nameMatchMode = 'Name',
      this.lang = 'Default'});

  factory _$_TagsListParams.fromJson(Map<String, dynamic> json) =>
      _$$_TagsListParamsFromJson(json);

  @override
  final String? query;
  @override
  final String? categoryName;
  @override
  @JsonKey()
  final int start;
  @override
  @JsonKey()
  final int maxResults;
  @override
  @JsonKey()
  final String sort;
  @override
  @JsonKey()
  final String nameMatchMode;
  @override
  @JsonKey()
  final String lang;

  @override
  String toString() {
    return 'TagsListParams(query: $query, categoryName: $categoryName, start: $start, maxResults: $maxResults, sort: $sort, nameMatchMode: $nameMatchMode, lang: $lang)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagsListParams &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.maxResults, maxResults) ||
                other.maxResults == maxResults) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.nameMatchMode, nameMatchMode) ||
                other.nameMatchMode == nameMatchMode) &&
            (identical(other.lang, lang) || other.lang == lang));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, query, categoryName, start,
      maxResults, sort, nameMatchMode, lang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagsListParamsCopyWith<_$_TagsListParams> get copyWith =>
      __$$_TagsListParamsCopyWithImpl<_$_TagsListParams>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TagsListParamsToJson(
      this,
    );
  }
}

abstract class _TagsListParams implements TagsListParams {
  const factory _TagsListParams(
      {final String? query,
      final String? categoryName,
      final int start,
      final int maxResults,
      final String sort,
      final String nameMatchMode,
      final String lang}) = _$_TagsListParams;

  factory _TagsListParams.fromJson(Map<String, dynamic> json) =
      _$_TagsListParams.fromJson;

  @override
  String? get query;
  @override
  String? get categoryName;
  @override
  int get start;
  @override
  int get maxResults;
  @override
  String get sort;
  @override
  String get nameMatchMode;
  @override
  String get lang;
  @override
  @JsonKey(ignore: true)
  _$$_TagsListParamsCopyWith<_$_TagsListParams> get copyWith =>
      throw _privateConstructorUsedError;
}
