import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

class ReleaseEventListView extends StatelessWidget {
  const ReleaseEventListView(
      {super.key,
      required this.events,
      this.onSelect,
      this.onReachLastItem,
      this.emptyWidget});

  /// List of events to display.
  final List<ReleaseEventModel> events;

  final Function(ReleaseEventModel)? onSelect;

  /// A callback function when user react to last item. Only worked on list view with vertical direction.
  final Function? onReachLastItem;

  /// A widget that display when songs is empty
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    return InfiniteListView(
        onReachLastItem: onReachLastItem,
        itemCount: events.length,
        itemBuilder: (context, index) => ReleaseEventTile.releaseEvent(
              events[index],
              onTap: () => onSelect?.call(events[index]),
            ));
  }
}
