import 'package:intl/intl.dart';
import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class ArtistModel extends EntryModel {
  @override
  String? additionalNames;
  String? releaseDate;
  String? description;
  ArtistRelations? relations;
  ArtistModel? baseVoicebank;
  List<ArtistLinkModel>? artistLinksReverse;
  List<ArtistLinkModel>? artistLinks;

  ArtistModel.fromJson(super.json)
      : additionalNames = json['additionalNames'],
        description = json['description'],
        releaseDate = json['releaseDate'],
        relations = (json.containsKey('relations') && json['relations'] != null)
            ? ArtistRelations.fromJson(json['relations'] ?? {})
            : null,
        baseVoicebank = (json.containsKey('baseVoicebank') &&
                json['baseVoicebank'] is! int && json['baseVoicebank'] != null)
            ? ArtistModel.fromJson(json['baseVoicebank'])
            : null,
        artistLinks = (json['artistLinks'] != null && json['artistLinks'] is List)
            ? JSONUtils.mapJsonArray<ArtistLinkModel>(
                json['artistLinks'],
                (v) => (v is int) ? null : ArtistLinkModel.fromJson(v)).where((e) => e != null).cast<ArtistLinkModel>().toList()
            : null,
        artistLinksReverse = (json['artistLinksReverse'] != null && json['artistLinksReverse'] is List)
            ? JSONUtils.mapJsonArray<ArtistLinkModel>(
                json['artistLinksReverse'],
                (v) => (v is int) ? null : ArtistLinkModel.fromJson(v)).where((e) => e != null).cast<ArtistLinkModel>().toList()
            : null,
        super.fromJson(entryType: EntryType.Artist);

  ArtistModel.fromEntry(EntryModel entry)
      : additionalNames = entry.additionalNames,
        description = null,
        releaseDate = null,
        relations = null,
        baseVoicebank = null,
        artistLinks = null,
        artistLinksReverse = null,
        super(
            id: entry.id,
            name: entry.name,
            artistString: entry.artistString,
            songType: entry.songType,
            mainPicture: entry.mainPicture,
            discType: entry.discType,
            eventCategory: entry.eventCategory,
            artistType: entry.artistType,
            entryType: EntryType.Artist);

  ArtistModel(
      {super.id, super.name, super.artistType, super.mainPicture})
      : additionalNames = null,
        description = null,
        releaseDate = null,
        relations = null,
        baseVoicebank = null,
        artistLinks = null,
        artistLinksReverse = null,
        super(
            entryType: EntryType.Artist);

  String get originUrl => '$baseUrl/Ar/$id';

  static List<ArtistModel> jsonToList(List items) {
    return items.map((i) => ArtistModel.fromJson(i)).toList();
  }

  String? get releaseDateFormatted => (releaseDate == null)
      ? null
      : DateFormat('yyyy-MM-dd').format(DateTime.parse(releaseDate!));

  @override
  String get imageUrl => '$baseUrl/Artist/Picture/$id';

  List<ArtistModel> get voiceProviders => (artistLinks ?? [])
      .where((a) => a.linkType == 'VoiceProvider')
      .map<ArtistModel>((a) => a.artist!)
      .toList();

  List<ArtistModel> get illustrators => (artistLinks ?? [])
      .where((a) => a.linkType == 'Illustrator')
      .map<ArtistModel>((a) => a.artist!)
      .toList();

  List<ArtistModel> get groups => (artistLinks ?? [])
      .where((a) => a.linkType == 'Group')
      .map<ArtistModel>((a) => a.artist!)
      .toList();

  List<ArtistModel> get voiceProvidedList => (artistLinksReverse ?? [])
      .where((a) => a.linkType == 'VoiceProvider')
      .map<ArtistModel>((a) => a.artist!)
      .toList();

  List<ArtistModel> get illustratedList => (artistLinksReverse ?? [])
      .where((a) => a.linkType == 'Illustrator')
      .map<ArtistModel>((a) => a.artist!)
      .toList();

  List<ArtistModel> get members => (artistLinksReverse ?? [])
      .where((a) => a.linkType == 'Group')
      .map<ArtistModel>((a) => a.artist!)
      .toList();

  List<TagModel> get tags =>
      (tagGroups != null) ? tagGroups!.where((t) => t.tag != null).map((t) => t.tag!).toList() : [];

  bool get isContainsDetail =>
      ((description != null && description!.isNotEmpty) ||
          (artistLinksReverse != null && artistLinksReverse!.isNotEmpty) ||
          (artistLinks != null && artistLinks!.isNotEmpty) ||
          (releaseDate != null && releaseDate!.isNotEmpty));
}
