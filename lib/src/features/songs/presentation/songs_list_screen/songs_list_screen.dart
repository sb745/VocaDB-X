
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/common_widgets/async_value_widget.dart';
import 'package:vocadb_app/src/common_widgets/search_appbar.dart';
import 'package:vocadb_app/src/features/songs/data/song_repository.dart';
import 'package:vocadb_app/src/features/songs/domain/song.dart';
import 'package:vocadb_app/src/features/songs/presentation/songs_list/songs_list_view.dart';
import 'package:vocadb_app/src/features/songs/presentation/songs_list_screen/songs_list_params_state.dart';
import 'package:vocadb_app/src/routing/app_route_context.dart';

class SongsListScreen extends ConsumerWidget {
  const SongsListScreen({super.key, this.onSelectSong});

  static const filterKey = Key('icon-filter-key');

  final Function(Song)? onSelectSong;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SearchAppBar(
        titleText: 'Songs',
        actions: [
          IconButton(
            key: filterKey,
            icon: const Icon(Icons.tune),
            onPressed: () => context.goSongsListFilterScreen(),
          ),
        ],
        onSubmitted: (value) {
          ref.read(songsListParamsStateProvider.notifier).updateQuery(value);
        },
        onCleared: () {
          ref.read(songsListParamsStateProvider.notifier).clearQuery();
        },
      ),
      body: Consumer(builder: ((context, ref, child) {
        final value = ref.watch(songsListProvider);
        return AsyncValueWidget(
            value: value,
            data: (data) {
              return SongListView(
                songs: data,
                onSelect: (song) => {}
              );
            });
      })),
    );
  }
}

// State
final songsListProvider = FutureProvider.autoDispose<List<Song>>((ref) {
  final params = ref.watch(songsListParamsStateProvider);
  final songRepository = ref.watch(songRepositoryProvider);
  return songRepository.fetchSongsList(params: params);
});
