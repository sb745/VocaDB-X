import 'package:vocadb_app/models.dart';

class ArtistSongModel {
  int? id;
  String? name;
  String? roles;
  String? effectiveRoles;
  String? categories;
  ArtistModel? artist;

  ArtistSongModel({
    this.id,
    this.name,
    this.roles,
    this.effectiveRoles,
    this.categories,
    this.artist,
  });

  ArtistSongModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        roles = json['roles'],
        effectiveRoles = json['effectiveRoles'],
        categories = json['categories'],
        artist = (json.containsKey('artist') && json['artist'] != null)
            ? ArtistModel.fromJson(json['artist'])
            : null;

  int get artistId => (artist == null) ? 0 : artist!.id!;

  String get artistName => (artist == null) ? (name ?? 'Unknown Artist') : (artist!.name ?? 'Unknown Artist');

  String? get artistImageUrl =>
      (artist == null) ? null : artist!.imageUrl;

  String? get artistRole =>
      (categories == 'Other') ? effectiveRoles : categories;

  bool get isProducer => (categories == 'Producer');

  bool get isVocalist => (categories == 'Vocalist');
}
