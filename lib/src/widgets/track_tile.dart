import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';

class TrackTile extends StatelessWidget {
  final int? trackNumber;

  final String? name;

  final String? artistName;

  final GestureTapCallback? onTap;

  const TrackTile({
    super.key,
    this.trackNumber,
    this.name,
    this.artistName,
    this.onTap,
  });

  TrackTile.fromTrackModel(TrackModel trackModel, {super.key, this.onTap})
      : trackNumber = trackModel.trackNumber,
        name = trackModel.name,
        artistName = trackModel.song?.artistString;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text((trackNumber ?? 0).toString()),
      enabled: (onTap != null),
      onTap: onTap,
      title: Text(name ?? 'Unknown Track', maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(artistName ?? ' ',
          maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
