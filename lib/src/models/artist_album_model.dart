import 'package:vocadb_app/models.dart';

class ArtistAlbumModel {
  int? id;
  String? name;
  String? roles;
  String? effectiveRoles;
  String? categories;
  ArtistModel? artist;

  ArtistAlbumModel({
    this.id,
    this.name,
    this.roles,
    this.effectiveRoles,
    this.categories,
    this.artist,
  });

  ArtistAlbumModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        roles = json['roles'],
        effectiveRoles = json['effectiveRoles'],
        categories = json['categories'],
        artist = (json.containsKey('artist') && json['artist'] != null)
            ? ArtistModel.fromJson(json['artist'])
            : null;

  int get artistId => (artist == null) ? (id ?? 0) : (artist!.id ?? 0);

  String get artistName => (artist == null) ? (name ?? 'Unknown Artist') : (artist!.name ?? 'Unknown Artist');

  String? get artistImageUrl =>
      (artist == null) ? null : artist!.imageUrl;

  String? get artistRole => (effectiveRoles != 'Default' &&
          !isProducer &&
          !isVocalist &&
          !isLabel)
      ? effectiveRoles
      : categories;

  bool get isProducer => (categories == 'Producer');

  bool get isVocalist => (categories == 'Vocalist');

  bool get isLabel => (categories == 'Label');
}
