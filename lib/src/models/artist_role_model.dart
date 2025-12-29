class ArtistRoleModel {
  final int? id;

  final String? name;

  final String? role;

  final String? imageUrl;

  const ArtistRoleModel({this.id, this.name, this.role, this.imageUrl});

  bool get isProducer => (role == 'Producer');

  bool get isVocalist => (role == 'Vocalist');

  bool get isOtherRole => (!isProducer && !isVocalist);
}
