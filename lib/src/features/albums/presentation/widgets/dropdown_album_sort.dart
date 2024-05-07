import 'package:flutter/material.dart';
import 'package:vocadb_app/src/common_widgets/dropdown_tile.dart';

class DropdownAlbumSort extends StatelessWidget {
  const DropdownAlbumSort({super.key, required this.value, this.onChanged});

  static const dropdownKey = Key('dropdown-album-sort-key');

  final String value;

  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownTile(
      dropdownButtonKey: dropdownKey,
      value: value,
      label: 'Sort',
      onChanged: onChanged,
      items: const [
        DropdownMenuItem<String>(
          value: 'Name',
          child: Text('Name'),
        ),
        DropdownMenuItem<String>(
          value: 'AdditionDate',
          child: Text('Addition date'),
        ),
        DropdownMenuItem<String>(
          value: 'ReleaseDate',
          child: Text('Release date'),
        ),
        DropdownMenuItem<String>(
          value: 'RatingAverage',
          child: Text('Rating average'),
        ),
        DropdownMenuItem<String>(
          value: 'RatingTotal',
          child: Text('Total score'),
        ),
        DropdownMenuItem<String>(
          value: 'CollectionCount',
          child: Text('Collection count'),
        ),
      ],
    );
  }
}
