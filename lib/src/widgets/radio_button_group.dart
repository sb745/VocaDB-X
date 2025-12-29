import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';

/// A widget to create simple radio button group.
class RadioButtonGroup extends StatelessWidget {
  /// String value that will display as text on header
  final String label;

  /// The current or selected value
  final String value;

  /// The list of mapping name/value to display as radio button
  final List<RadioButtonItem> items;

  /// A callback on value changed
  final Function(String)? onChanged;

  const RadioButtonGroup({super.key, required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    List<Widget> radioItems = [];

    radioItems.add(ListTile(
      title: Text(label),
    ));

    radioItems.addAll(items
        .map((e) => ListTile(
              title: Text(e.label ?? 'Unknown'),
              leading: Radio<String>(
                value: e.value ?? 'Unknown',
                groupValue: value,
                onChanged: onChanged != null ? (String? value) => onChanged!(value!) : null,
              ),
              onTap: onChanged != null ? () => onChanged!(e.value ?? 'Unknown') : null,
            ))
        .toList());

    return Column(
      children: radioItems,
    );
  }
}
