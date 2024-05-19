
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/common_widgets/async_value_widget.dart';
import 'package:vocadb_app/src/common_widgets/search_appbar.dart';
import 'package:vocadb_app/src/features/tags/data/tag_repository.dart';
import 'package:vocadb_app/src/features/tags/domain/tag.dart';
import 'package:vocadb_app/src/features/tags/presentation/tag_list_screen/tags_list_params_state.dart';

class TagsListScreen extends ConsumerWidget {
  const TagsListScreen({super.key, this.onSelectTag});

  static const filterKey = Key('icon-filter-key');

  final Function(Tag)? onSelectTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SearchAppBar(
        titleText: 'Tags',
        onSubmitted: (value) {
          ref.read(tagsListParamsStateProvider.notifier).updateQuery(value);
        },
        onCleared: () {
          ref.read(tagsListParamsStateProvider.notifier).clearQuery();
        },
      ),
      body: Consumer(builder: ((context, ref, child) {
        final value = ref.watch(tagsListProvider);
        return AsyncValueWidget(
            value: value,
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].name ?? '{Unknown}'),
                  subtitle: Text(data[index].categoryName ?? '{Unknown}'),
                ),);
            });
      })),
    );
  }
}

// State
final tagsListProvider = FutureProvider.autoDispose<List<Tag>>((ref) {
  final params = ref.watch(tagsListParamsStateProvider);
  final tagRepository = ref.watch(tagRepositoryProvider);
  return tagRepository.fetchTagsList(params: params);
});
