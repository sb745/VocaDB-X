import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/songs/presentation/songs_list_screen/songs_list_params_state.dart';
import 'package:vocadb_app/src/features/songs/presentation/widgets/dropdown_song_sort.dart';
import 'package:vocadb_app/src/features/songs/presentation/widgets/dropdown_song_types.dart';
import 'package:vocadb_app/src/features/tags/presentation/tag_widgets/tag_input.dart';

class SongsFilterScreen extends StatelessWidget {
  const SongsFilterScreen(
      {super.key, this.onSortChanged, this.onSongTypesChanged});

  final Function(String?)? onSongTypesChanged;

  final Function(String?)? onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(songsListParamsStateProvider);

          return ListView(
            children: [
              DropdownSongTypes(
                value: state.songTypes ?? '',
                onChanged: (value) =>
                    onSongTypesChanged?.call(value) ??
                    ref
                        .read(songsListParamsStateProvider.notifier)
                        .updateSongTypes(value!),
              ),
              DropdownSongSort(
                value: 'Name',
                onChanged: (value) =>
                    onSortChanged?.call(value) ??
                    ref
                        .read(songsListParamsStateProvider.notifier)
                        .updateSort(value!),
              ),
              const Divider(),
              const TagInput(),
            ],
          );
        },
      ),
    );
  }
}
