import 'package:vocadb_app/models.dart';

class ArtistEventModel {
  int id;
  String name;
  String roles;
  String effectiveRoles;
  String categories;
  ArtistModel? artist;

  ArtistEventModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        roles = json['roles'],
        effectiveRoles = json['effectiveRoles'],
        categories = json['categories'],
        artist = (json.containsKey('artist'))
            ? ArtistModel.fromJson(json['artist'])
            : null;

  int? get artistId => (artist == null) ? id : artist?.id;

  String? get artistName => (artist == null) ? name : artist?.name;

  String? get artistImageUrl =>
      (artist == null) ? null : artist?.imageUrl;

  String get artistRole => (effectiveRoles != 'Default' &&
          !isProducer &&
          !isVocalist &&
          !isLabel)
      ? effectiveRoles
      : categories;

  bool get isProducer => (categories == 'Producer');

  bool get isVocalist => (categories == 'Vocalist');

  bool get isLabel => (categories == 'Label');
}
