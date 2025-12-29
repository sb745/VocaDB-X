import 'package:intl/intl.dart';
import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class SongModel extends EntryModel {
  String? thumbUrl;
  List<PVModel>? pvs;
  List<ArtistSongModel>? artists;
  List<AlbumModel>? albums;
  int? originalVersionId;
  String? publishDate;
  List<LyricModel>? lyrics;

  SongModel(
      {super.id,
      super.name,
      super.songType,
      super.artistString,
      this.pvs,
      this.thumbUrl})
      : super(
            entryType: EntryType.Song);

  SongModel.fromEntry(EntryModel entry)
      : thumbUrl = null,
        pvs = null,
        artists = null,
        albums = null,
        originalVersionId = null,
        publishDate = null,
        lyrics = null,
        super(
            id: entry.id,
            name: entry.name,
            artistString: entry.artistString,
            songType: entry.songType,
            mainPicture: entry.mainPicture,
            discType: entry.discType,
            eventCategory: entry.eventCategory,
            artistType: entry.artistType,
            entryType: EntryType.Song);

  SongModel.fromJson(super.json)
      : thumbUrl = (json['thumbUrl'] != null) ? UrlUtils.toHttps(json['thumbUrl'] as String) : null,
        originalVersionId = json['originalVersionId'],
        publishDate = json['publishDate'] as String?,
        pvs = (json['pvs'] != null && json['pvs'] is List)
            ? JSONUtils.mapJsonArray<PVModel>(
                json['pvs'], (v) => (v is int) ? null : PVModel.fromJson(v)).where((e) => e != null).cast<PVModel>().toList()
            : null,
        artists = (json['artists'] != null && json['artists'] is List)
            ? JSONUtils.mapJsonArray<ArtistSongModel>(json['artists'],
                (v) => (v is int) ? null : ArtistSongModel.fromJson(v)).where((e) => e != null).cast<ArtistSongModel>().toList()
            : null,
        albums = (json['albums'] != null && json['albums'] is List)
            ? JSONUtils.mapJsonArray<AlbumModel>(
                json['albums'], (v) => (v is int) ? null : AlbumModel.fromJson(v)).where((e) => e != null).cast<AlbumModel>().toList()
            : null,
        lyrics = (json['lyrics'] != null && json['lyrics'] is List)
            ? JSONUtils.mapJsonArray<LyricModel>(
                json['lyrics'], (v) => (v is int) ? null : LyricModel.fromJson(v)).where((e) => e != null).cast<LyricModel>().toList()
            : null,
        super.fromJson(entryType: EntryType.Song);

  static List<SongModel> jsonToList(List items) {
    if (items.isEmpty) {
      return [];
    }
    return items.map((i) => SongModel.fromJson(i)).toList();
  }

  PVModel? get youtubePV {
    if (pvs == null || pvs!.isEmpty) return null;
    
    try {
      return pvs!.firstWhere(
          (pv) => pv.service?.toLowerCase() == 'youtube' && pv.pvType == 'Original');
    } catch (e) {
      try {
        return pvs!.firstWhere(
            (pv) => pv.service?.toLowerCase() == 'youtube');
      } catch (e) {
        return null;
      }
    }
  }

  List<TagModel> get tags =>
      (tagGroups != null) ? tagGroups!.where((t) => t.tag != null).map((t) => t.tag!).toList() : [];

  List<ArtistSongModel> get producers =>
      (artists ?? []).where((a) => a.isProducer).toList();

  List<ArtistSongModel> get vocalists =>
      (artists ?? []).where((a) => a.isVocalist).toList();

  List<ArtistSongModel> get otherArtists =>
      (artists ?? []).where((a) => !a.isVocalist && !a.isProducer).toList();

  bool get hasOriginalVersion =>
      (originalVersionId != null && originalVersionId! > 0);

  String? get publishDateFormatted => (publishDate == null)
      ? null
      : DateFormat('yyyy-MM-dd').format(DateTime.parse(publishDate!));

  DateTime? get publishDateAsDateTime =>
      (publishDate == null) ? null : DateTime.parse(publishDate!);

  bool get hasLyrics => lyrics != null && lyrics!.isNotEmpty;

  String get originUrl => '$baseUrl/S/$id';

  @override
  String get imageUrl => thumbUrl ?? super.imageUrl;

  String get pvSearchQuery => ((pvs ?? []).isNotEmpty)
      ? pvs![0].name ?? ''
      : '${artistString ?? ""}+${defaultName ?? ""}';

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();

    if (pvs != null) {
      json['pvs'] = pvs!.map((pv) => pv.toJson()).toList();
    }

    if (thumbUrl != null) {
      json['thumbUrl'] = thumbUrl;
    }

    return json;
  }
}

class SongList {
  final List<SongModel> songs;

  SongList(this.songs);

  SongModel? getFirstWithYoutubePV({int start = 0}) {
    try {
      if (start == 0) {
        return songs.firstWhere((s) => s.youtubePV != null);
      }
      int index = songs.indexWhere((s) => s.youtubePV != null, start);
      return (index == -1) ? null : songs[index];
    } catch (e) {
      return null;
    }
  }

  int getFirstWithYoutubePVIndex(int start) {
    int index = songs.indexWhere((s) => s.youtubePV != null, start);

    return index;
  }

  int getLastWithYoutubePVIndex(int start) {
    int index = songs.lastIndexWhere((s) => s.youtubePV != null, start);

    return index;
  }
}

class RankDuration {
  static const int DAILY = 24;
  static const int WEEKLY = 168;
  static const int MONTHLY = 720;
  static const int OVERALL = 0;
}
