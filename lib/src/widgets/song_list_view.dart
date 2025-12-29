import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget for display list of songs as vertical or horizontal
class SongListView extends StatelessWidget {
  const SongListView(
      {super.key,
      required this.songs,
      this.scrollDirection = Axis.vertical,
      required this.onSelect,
      required this.onReachLastItem,
      this.emptyWidget,
      this.displayPlaceholder = false});

  /// List of songs to display.
  final List<SongModel> songs;

  /// Default is vertical
  final Axis scrollDirection;

  /// A callback function that called when user tap any item
  final void Function(SongModel) onSelect;

  /// A callback function when user react to last item. Only worked on list view with vertical direction.
  final Function onReachLastItem;

  /// Set to True for display list of placeholders.
  final bool displayPlaceholder;

  /// A widget that display when songs is empty
  final Widget? emptyWidget;

  /// Height of list content widget if set as horizontal.
  static const double _rowHeight = 180;

  /// Return item for display in vertical list
  Widget _verticalItemBuilder(BuildContext context, int index) => SongTile.song(
        songs[index],
        onTap: () => onSelect(songs[index]),
        leading: null,
        heroTag: '',
      );

  /// Return item for display in horizontal list
  Widget _horizontalItemBuilder(BuildContext context, int index) =>
      SongCard.song(songs[index],
          onTap: () => onSelect(songs[index]));

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    if (scrollDirection == Axis.vertical) {
      return InfiniteListView(
        itemCount: songs.length,
        itemBuilder: _verticalItemBuilder,
        onReachLastItem: onReachLastItem,
      );
    }

    if (displayPlaceholder) {
      return SongPlaceholderListView();
    }

    return SizedBox(
        height: _rowHeight,
        child: ListView.builder(
            itemCount: songs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: _horizontalItemBuilder));
  }
}
