import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/widgets/custom_network_image.dart';

/// A widget for display album information in vertical list
class AlbumTile extends StatelessWidget {
  /// Name of album that will display as title in card
  final String name;

  /// Name of artist that will display on second line
  final String artist;

  /// Album image url to display in widget
  final String imageUrl;

  /// Callback when tap
  final GestureTapCallback onTap;

  /// Album image size both width and height
  static const double imageSize = 50;

  const AlbumTile({super.key, required this.name, required this.artist, required this.imageUrl, required this.onTap});

  AlbumTile.fromEntry(EntryModel entry, {super.key, required this.onTap})
      : name = entry.name ?? 'Unknown Album',
        imageUrl = entry.imageUrl,
        artist = entry.artistString ?? '';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: imageSize,
        height: imageSize,
        child: CustomNetworkImage(
          imageUrl,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(name, overflow: TextOverflow.ellipsis),
      subtitle: Text(artist, overflow: TextOverflow.ellipsis),
    );
  }
}
