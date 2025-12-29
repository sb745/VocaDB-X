import 'package:intl/intl.dart';
import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class ReleaseEventModel extends EntryModel {
  @override
  EntryType get entryType => EntryType.ReleaseEvent;
  
  String? description;
  String? category;
  String? venueName;
  DateTime? date;
  DateTime? endDate;
  ReleaseEventSeriesModel? series;
  List<ArtistEventModel>? artists;

  ReleaseEventModel({
    super.id,
    super.name,
    super.eventCategory,
    super.mainPicture,
  }) : super(
            entryType: EntryType.ReleaseEvent);

  ReleaseEventModel.fromJson(super.json)
      : description = json['description'],
        category = json['category'],
        venueName = json['venueName'],
        date = (json.containsKey('date') && json['date'] != null) 
            ? DateTime.tryParse(json['date'].toString())
            : null,
        endDate = (json.containsKey('endDate') && json['endDate'] != null)
            ? DateTime.tryParse(json['endDate'].toString())
            : null,
        series = (json.containsKey('series') && json['series'] != null)
            ? ReleaseEventSeriesModel.fromJson(json['series'])
            : null,
        artists = (json['artists'] != null && json['artists'] is List)
            ? JSONUtils.mapJsonArray<ArtistEventModel>(
                json['artists'], (v) => ArtistEventModel.fromJson(v)).where((e) => e != null).cast<ArtistEventModel>().toList()
            : null,
        super.fromJson();

  ReleaseEventModel.fromEntry(EntryModel entry)
      : super(
            id: entry.id,
            name: entry.name,
            artistString: entry.artistString,
            songType: entry.songType,
            mainPicture: entry.mainPicture,
            discType: entry.discType,
            eventCategory: entry.eventCategory,
            artistType: entry.artistType,
            entryType: EntryType.ReleaseEvent);

  static List<ReleaseEventModel> jsonToList(List items) {
    if (items.isEmpty) {
      return [];
    }
    return items.map((i) => ReleaseEventModel.fromJson(i)).toList();
  }

  String? get displayCategory {
    return series?.category ?? category;
  }

  String? get dateFormatted =>
      (date == null) ? null : DateFormat('yyyy-MM-dd').format(date!);

  String get originUrl => '$baseUrl/E/$id';
}
