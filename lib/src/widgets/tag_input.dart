import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/routes.dart';

/// An tag input widget for filter page
class TagInput extends StatelessWidget {
  /// Label input. Default is Tags
  final String label;

  /// Existing tag values
  final List<TagModel> values;

  /// Called when the user taps the deleteIcon.
  final Function(TagModel) onDeleted;

  /// Called when the user select tag.
  final Function(TagModel) onSelect;

  const TagInput(
      {super.key, this.label = 'Tags', required this.values, required this.onDeleted, required this.onSelect});

  Widget _tagBuilder(TagModel tagModel) {
    return ListTile(
      leading: Icon(Icons.label),
      title: Text(tagModel.name ?? 'Unknown Tag'),
      trailing: (onDeleted == null)
          ? null
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => onDeleted(tagModel),
            ),
    );
  }

  void _onBrowse() {
    Get.toNamed(Routes.TAGS, arguments: TagSearchArgs(selectionMode: true))!
        .then(_postBrowse);
  }

  void _postBrowse(value) {
    if (value != null) {
      onSelect(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    items.add(ListTile(
      title: Text('tags'.tr),
    ));

    if (values.isNotEmpty) {
      items.addAll(values.map((e) => _tagBuilder(e)).toList());
    }

    items.add(ListTile(
      onTap: _onBrowse,
      leading: Icon(Icons.add),
      title: Text('add'.tr),
    ));

    return Column(
      children: items,
    );
  }
}
