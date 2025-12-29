import 'package:flutter/material.dart';

/// Tag widget
class Tag extends StatelessWidget {
  /// A widget to display prior to the chip's label.
  final Widget? avatar;

  /// A string value display in tag. Return empty container if label value is null or empty.
  final String? label;

  /// Called when the user taps the deleteIcon to delete the chip.
  final VoidCallback? onDeleted;

  /// Callback when pressed
  final VoidCallback? onPressed;

  const Tag({super.key, this.label, this.onPressed, this.onDeleted, this.avatar});

  @override
  Widget build(BuildContext context) {
    if (label == null || label!.isEmpty) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(right: 4.0),
      child: InputChip(
        avatar: avatar,
        deleteIcon: (onDeleted == null) ? null : Icon(Icons.cancel),
        label: Text(label!),
        onPressed: onPressed,
        onDeleted: onDeleted,
      ),
    );
  }
}
