import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget for display list of artists
class ArtistListView extends StatelessWidget {
  const ArtistListView(
      {super.key,
      required this.artists,
      required this.onSelect,
      required this.onReachLastItem,
      required this.emptyWidget});

  /// List of artists to display.
  final List<ArtistModel> artists;

  /// A callback function when user react to last item. Only worked on list view with vertical direction.
  final Function onReachLastItem;

  final Function(ArtistModel) onSelect;

  /// A widget that display when songs is empty
  final Widget emptyWidget;

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return emptyWidget;
    }

    return InfiniteListView(
      itemCount: artists.length,
      itemBuilder: (context, index) => ArtistTile.fromEntry(artists[index],
          onTap: () => onSelect(artists[index])),
      onReachLastItem: onReachLastItem,
    );
  }
}
