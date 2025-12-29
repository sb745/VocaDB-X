import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget for display list of songs as vertical or horizontal
class AlbumListView extends StatelessWidget {
  const AlbumListView(
      {super.key,
      required this.albums,
      required this.onSelect,
      required this.onReachLastItem,
      required this.emptyWidget,
      this.scrollDirection = Axis.vertical,
      this.displayPlaceholder = false});

  /// List of songs to display.
  final List<AlbumModel> albums;

  /// Default is vertical
  final Axis scrollDirection;

  /// A callback function when user react to last item. Only worked on list view with vertical direction.
  final Function onReachLastItem;

  /// Set to True for display list of placeholders.
  final bool displayPlaceholder;

  /// A callback function that called when user tap any item
  final void Function(AlbumModel) onSelect;

  /// Height of list content widget if set as horizontal.
  static const double _rowHeight = 180;

  /// A widget that display when songs is empty
  final Widget emptyWidget;

  /// Return item for display in vertical list
  Widget _verticalItemBuilder(BuildContext context, int index) =>
      AlbumTile.fromEntry(
        albums[index],
        onTap: () => onSelect(albums[index]),
      );

  /// Return item for display in horizontal list
  Widget _horizontalItemBuilder(BuildContext context, int index) =>
      AlbumCard.album(albums[index],
          onTap: () => onSelect(albums[index]));

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return emptyWidget;
    }

    if (scrollDirection == Axis.vertical) {
      return InfiniteListView(
        itemCount: albums.length,
        itemBuilder: _verticalItemBuilder,
        onReachLastItem: onReachLastItem,
      );
    }

    if (displayPlaceholder) {
      return AlbumPlaceholderListView();
    }

    return SizedBox(
        height: _rowHeight,
        child: ListView.builder(
            itemCount: albums.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: _horizontalItemBuilder));
  }
}
