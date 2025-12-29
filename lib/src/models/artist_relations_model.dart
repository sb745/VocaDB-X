import 'package:vocadb_app/models.dart';

class ArtistRelations {
  List<SongModel> latestSongs;
  List<SongModel> popularSongs;
  List<AlbumModel> latestAlbums;
  List<AlbumModel> popularAlbums;

  ArtistRelations.fromJson(Map<String, dynamic> json)
      : latestSongs = ((json['latestSongs'] as List?) ?? [])
            .map((d) => (d is int) ? null : SongModel.fromJson(d))
            .where((item) => item != null)
            .cast<SongModel>()
            .toList(),
        popularSongs = ((json['popularSongs'] as List?) ?? [])
            .map((d) => (d is int) ? null : SongModel.fromJson(d))
            .where((item) => item != null)
            .cast<SongModel>()
            .toList(),
        latestAlbums = ((json['latestAlbums'] as List?) ?? [])
            .map((d) => (d is int) ? null : AlbumModel.fromJson(d))
            .where((item) => item != null)
            .cast<AlbumModel>()
            .toList(),
        popularAlbums = ((json['popularAlbums'] as List?) ?? [])
            .map((d) => (d is int) ? null : AlbumModel.fromJson(d))
            .where((item) => item != null)
            .cast<AlbumModel>()
            .toList();
}
