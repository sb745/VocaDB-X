import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class TagModel extends EntryModel {
  String? categoryName;
  @override
  String? additionalNames;
  String? description;
  String? urlSlug;
  TagModel? parent;
  List<TagModel?> relatedTags;

  TagModel({super.id, super.name})
      : relatedTags = [],
        super(entryType: EntryType.Tag);

  TagModel.fromEntry(EntryModel entryModel)
      : relatedTags = [],
        super(
            id: entryModel.id, name: entryModel.name, entryType: EntryType.Tag);

  TagModel.fromJson(super.json)
      : parent = (json.containsKey('parent') && json['parent'] != null)
            ? TagModel.fromJson(json['parent'])
            : null,
        description = json['description'],
        categoryName = json['categoryName'],
        urlSlug = json['urlSlug'],
        additionalNames = json['additionalNames'],
        relatedTags = (json['relatedTags'] != null && json['relatedTags'] is List)
            ? (JSONUtils.mapJsonArray<TagModel>(
                json['relatedTags'], (v) => TagModel.fromJson(v)).where((e) => e != null).toList() ?? [])
            : [],
        super.fromJson(entryType: EntryType.Tag);

  static List<TagModel> jsonToList(List items) {
    return items.map((i) => TagModel.fromJson(i)).toList();
  }

  @override
  String get imageUrl => mainPicture?.urlThumb?.replaceAll('-t.', '.') ?? super.imageUrl;

  String get originUrl => '$baseUrl/T/$id';
}
