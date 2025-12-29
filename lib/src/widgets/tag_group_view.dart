import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget to generate tags by list of tag model.
class TagGroupView extends StatefulWidget {
  /// The list of tag models.
  final List<TagModel> tags;

  /// Callback when pressed.
  final Function(TagModel) onPressed;

  /// A horizontal margin size. Default is 16.0
  final double margin;

  /// Minimum tags to display. Set to zero to display all
  final int minimumDisplayCount;

  const TagGroupView(
      {super.key, required this.tags,
      required this.onPressed,
      this.margin = 16.0,
      this.minimumDisplayCount = 5});

  @override
  _TagGroupViewState createState() => _TagGroupViewState();
}

class _TagGroupViewState extends State<TagGroupView> {
  bool displayAll = false;

  void _onMorePressed() {
    setState(() {
      displayAll = true;
    });
  }

  Widget _mapTagWidget(TagModel tagModel) {
    return Tag(
        label: tagModel.name,
        onPressed: () => (widget.onPressed != null)
            ? widget.onPressed(tagModel)
            : null);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    if (widget.minimumDisplayCount > 0 &&
        !displayAll &&
        widget.tags.length > widget.minimumDisplayCount) {
      items = widget.tags
          .take(widget.minimumDisplayCount)
          .map(_mapTagWidget)
          .toList();
      items.add(InputChip(
        label: Text('More (${widget.tags.length})'),
        onPressed: _onMorePressed,
      ));
    } else {
      items = widget.tags.map(_mapTagWidget).toList();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.margin),
      child: Wrap(
        children: items,
      ),
    );
  }
}
