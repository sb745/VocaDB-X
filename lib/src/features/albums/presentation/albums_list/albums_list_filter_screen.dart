import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/albums/presentation/albums_list/albums_list_params_state.dart';
import 'package:vocadb_app/src/features/albums/presentation/widgets/dropdown_album_sort.dart';
import 'package:vocadb_app/src/features/albums/presentation/widgets/dropdown_album_type.dart';
import 'package:vocadb_app/src/features/tags/presentation/tag_widgets/tag_input.dart';

class AlbumsFilterScreen extends StatelessWidget {
  const AlbumsFilterScreen(
      {super.key, this.onSortChanged, this.onAlbumTypesChanged});

  final Function(String?)? onAlbumTypesChanged;

  final Function(String?)? onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(albumsListParamsStateProvider);

          return ListView(
            children: [
              DropdownAlbumType(
                value: state.discTypes ?? '',
                onChanged: (value) =>
                    onAlbumTypesChanged?.call(value) ??
                    ref
                        .read(albumsListParamsStateProvider.notifier)
                        .updateDiscTypes(value!),
              ),
              DropdownAlbumSort(
                value: 'Name',
                onChanged: (value) =>
                    onAlbumTypesChanged?.call(value) ??
                    ref
                        .read(albumsListParamsStateProvider.notifier)
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
