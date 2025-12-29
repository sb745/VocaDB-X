import 'package:vocadb_app/models.dart';

class SongDetailArgs {
  /// An id of song.
  final int id;

  /// Optional song data for pre-display before fetch.
  final SongModel? song;

  const SongDetailArgs({required this.id, this.song});
}
