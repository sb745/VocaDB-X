import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget for generate release events in [Column] instead of [ListView]. Use it only when need to display release event content inside parent [ListView] widget.
class ReleaseEventColumnView extends StatelessWidget {
  const ReleaseEventColumnView({super.key, required this.events, required this.onSelect});

  /// List of events to display.
  final List<ReleaseEventModel> events;

  /// The callback function that called when user tap any item.
  final Function(ReleaseEventModel) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events
          .map((e) => ReleaseEventTile.releaseEvent(
                e,
                onTap: () => onSelect(e),
              ))
          .toList(),
    );
  }
}
