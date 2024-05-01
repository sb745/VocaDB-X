import 'package:flutter/material.dart';
import 'package:vocadb_app/src/common_widgets/dropdown_tile.dart';

class DropdownSongTypes extends StatelessWidget {
  const DropdownSongTypes({super.key, required this.value, this.onChanged});

  static const dropdownKey = Key('dropdown-song-types-key');

  final String value;

  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownTile(
      dropdownButtonKey: dropdownKey,
      value: value,
      label: 'Song Types',
      onChanged: onChanged,
      items: const [
        DropdownMenuItem<String>(
          value: '',
          child: Text('Unspecified'),
        ),
        DropdownMenuItem<String>(
          value: 'Original',
          child: Text('Original song'),
        ),
        DropdownMenuItem<String>(
          value: 'Remaster',
          child: Text('Remaster'),
        ),
        DropdownMenuItem<String>(
          value: 'Remix',
          child: Text('Remix'),
        ),
        DropdownMenuItem<String>(
          value: 'Cover',
          child: Text('Cover'),
        ),
        DropdownMenuItem<String>(
          value: 'Instrumental',
          child: Text('Instrumental'),
        ),
        DropdownMenuItem<String>(
          value: 'Mashup',
          child: Text('Mashup'),
        ),
        DropdownMenuItem<String>(
          value: 'MusicPV',
          child: Text('Music PV'),
        ),
        DropdownMenuItem<String>(
          value: 'DramaPV',
          child: Text('Drama PV'),
        ),
        DropdownMenuItem<String>(
          value: 'Other',
          child: Text('Other'),
        ),
      ],
    );
  }
}
