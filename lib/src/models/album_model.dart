import 'dart:collection';

import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';
import "package:collection/collection.dart";

class AlbumModel extends EntryModel {
  List<TrackModel>? tracks;
  List<ArtistAlbumModel>? artists;
  String? catalogNumber;
  String? description;
  double? ratingAverage;
  int? ratingCount;
  ReleaseDateModel? releaseDate;

  AlbumModel({super.id, super.name, super.artistString})
      : super(
            entryType: EntryType.Album);

  AlbumModel.fromJson(super.json)
      : catalogNumber = json['catalogNumber'],
        description = json['description'],
        ratingAverage = (json['ratingAverage'] is int)
            ? double.parse(json['ratingAverage'].toString())
            : json['ratingAverage'],
        ratingCount = json['ratingCount'],
        tracks = (json['tracks'] != null && json['tracks'] is List)
            ? JSONUtils.mapJsonArray<TrackModel>(
                json['tracks'], (v) => TrackModel.fromJson(v)).where((e) => e != null).cast<TrackModel>().toList()
            : null,
        artists = (json['artists'] != null && json['artists'] is List)
            ? JSONUtils.mapJsonArray<ArtistAlbumModel>(
                json['artists'], (v) => ArtistAlbumModel.fromJson(v)).where((e) => e != null).cast<ArtistAlbumModel>().toList()
            : null,
        releaseDate = (json.containsKey('releaseDate') && json['releaseDate'] != null)
            ? ReleaseDateModel.fromJson(json['releaseDate'])
            : null,
        super.fromJson(entryType: EntryType.Album);

  AlbumModel.fromEntry(EntryModel entry)
      : super(
            id: entry.id,
            name: entry.name,
            artistString: entry.artistString,
            songType: entry.songType,
            mainPicture: entry.mainPicture,
            discType: entry.discType,
            eventCategory: entry.eventCategory,
            artistType: entry.artistType,
            entryType: EntryType.Album);

  static List<AlbumModel> jsonToList(List items) {
    if (items.isEmpty) {
      return [];
    }
    return items.map((i) => AlbumModel.fromJson(i)).toList();
  }

  List<ArtistAlbumModel> get producers =>
      (artists ?? []).where((a) => a.isProducer).toList();

  List<ArtistAlbumModel> get vocalists =>
      (artists ?? []).where((a) => a.isVocalist).toList();

  List<ArtistAlbumModel> get labels =>
      (artists ?? []).where((a) => a.isLabel).toList();

  List<ArtistAlbumModel> get otherArtists => (artists ?? [])
      .where((a) => !a.isVocalist && !a.isProducer && !a.isLabel)
      .toList();

  @override
  get imageUrl => (mainPicture != null && mainPicture!.urlThumb != null)
      ? mainPicture!.urlThumb!
      : '$baseUrl/Album/CoverPicture/$id';

  String get originUrl => '$baseUrl/Al/$id';

  String? get releaseDateFormatted => releaseDate?.formatted;

  bool get isContainsYoutubeTrack =>
      (tracks ?? []).any((t) => t.song != null && t.song!.youtubePV != null);

  List<TagModel?> get tags =>
      (tagGroups != null) ? tagGroups!.where((t) => t.tag != null).map((t) => t.tag).toList() : [];

  List<AlbumDiscModel> discs() {
    final trackList = tracks ?? [];
    return SplayTreeMap.of(groupBy(trackList, (t) => t.discNumber))
        .values
        .map((v) => AlbumDiscModel(v[0].discNumber!.toInt(), List<TrackModel>.from(v)))
        .toList();
  }
}
