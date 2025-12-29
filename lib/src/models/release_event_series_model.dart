import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class ReleaseEventSeriesModel extends EntryModel {
  @override
  EntryType get entryType => EntryType.ReleaseEventSeries;
  
  String? description;
  String? category;
  String? pictureMime;
  List<ReleaseEventModel>? events;

  ReleaseEventSeriesModel({super.id});

  ReleaseEventSeriesModel.fromJson(super.json)
      : description = json['description'],
        category = json['category'],
        pictureMime = json['pictureMime'],
        events = (json['events'] != null && json['events'] is List)
            ? JSONUtils.mapJsonArray<ReleaseEventModel>(
                json['events'], (v) => ReleaseEventModel.fromJson(v)).where((e) => e != null).cast<ReleaseEventModel>().toList()
            : null,
        super.fromJson();

  static List<ReleaseEventSeriesModel> jsonToList(List items) {
    return items.map((i) => ReleaseEventSeriesModel.fromJson(i)).toList();
  }

  String get originUrl => '$baseUrl/Es/$id';
}
