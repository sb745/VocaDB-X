import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/common_widgets/async_value_widget.dart';
import 'package:vocadb_app/src/common_widgets/search_appbar.dart';
import 'package:vocadb_app/src/features/albums/data/album_repository.dart';
import 'package:vocadb_app/src/features/albums/domain/album.dart';
import 'package:vocadb_app/src/features/albums/presentation/albums_list/album_list_view.dart';
import 'package:vocadb_app/src/features/albums/presentation/albums_list/albums_list_params_state.dart';
import 'package:vocadb_app/src/routing/app_route_context.dart';

class AlbumsListScreen extends ConsumerWidget {
  const AlbumsListScreen({super.key, this.onSelectAlbum});

  static const filterKey = Key('icon-filter-key');

  final Function(Album)? onSelectAlbum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SearchAppBar(
        titleText: 'Albums',
        actions: [
          IconButton(
            key: filterKey,
            icon: const Icon(Icons.tune),
            onPressed: () => context.goAlbumsListFilterScreen(),
          ),
        ],
        onSubmitted: (value) {
          ref.read(albumsListParamsStateProvider.notifier).updateQuery(value);
        },
        onCleared: () {
          ref.read(albumsListParamsStateProvider.notifier).clearQuery();
        },
      ),
      body: Consumer(builder: ((context, ref, child) {
        final value = ref.watch(albumsListProvider);
        return AsyncValueWidget(
            value: value,
            data: (data) {
              return AlbumListView(
                albums: data,
                onSelect: (artist) => onSelectAlbum?.call(artist),
              );
            });
      })),
    );
  }
}

// State
final albumsListProvider = FutureProvider.autoDispose<List<Album>>((ref) {
  final params = ref.watch(albumsListParamsStateProvider);
  final albumRepository = ref.watch(albumRepositoryProvider);
  return albumRepository.fetchAlbums(params: params);
});
