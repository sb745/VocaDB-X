import 'package:vocadb_app/models.dart';

class AlbumUserModel {
  AlbumModel? album;
  String? purchaseStatus;
  String? mediaType;
  int? rating;

  AlbumUserModel.fromJson(Map<String, dynamic> json)
      : album = json.containsKey('album')
            ? AlbumModel.fromJson(json['album'])
            : null,
        purchaseStatus = json['purchaseStatus']?.toString() ?? 'Nothing',
        mediaType = json['mediaType']?.toString(),
        rating = json['rating'] is int ? json['rating'] as int? : null;

  static List<AlbumUserModel> jsonToList(List items) {
    return (items == null)
        ? []
        : items.map((i) => AlbumUserModel.fromJson(i)).toList();
  }
}
