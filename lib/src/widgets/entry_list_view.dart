import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget dispaly list of entries and group by entry type
class EntryListView extends StatelessWidget {
  final List<EntryModel?>? entries;

  final Function(EntryModel?)? onSelect;

  /// A widget that display when songs is empty
  final Widget? emptyWidget;

  const EntryListView({super.key, this.entries, this.onSelect, this.emptyWidget});

  List<Widget> _generateItems() {
    List<Widget> items = [];

    EntryList entryList = EntryList(entries!.whereType<EntryModel>().toList());

    if (entryList.songs.isNotEmpty) {
      items.add(ListTile(
        title: Text('Songs'),
      ));

      items.addAll(entryList.songs.map((e) => SongTile.fromEntry(
            e,
            onTap: () => onSelect?.call(e),
            leading: null,
            heroTag: '',
          )));
    }

    if (entryList.artists.isNotEmpty) {
      items.add(ListTile(title: Text('Artists')));

      items.addAll(entryList.artists
          .map((e) => ArtistTile.fromEntry(e, onTap: () => onSelect?.call(e), subtitle: '',)));
    }

    if (entryList.albums.isNotEmpty) {
      items.add(ListTile(
        title: Text('Albums'),
      ));

      items.addAll(entryList.albums
          .map((e) => AlbumTile.fromEntry(e, onTap: () => onSelect?.call(e))));
    }

    if (entryList.tags.isNotEmpty) {
      items.add(ListTile(
        title: Text('Tags'),
      ));

      List<EntryModel> es = entryList.tags.toList();

      List<TagModel> tagModelList =
          es.map((e) => TagModel.fromEntry(e)).toList();

      items.add(TagGroupView(
        tags: tagModelList,
        onPressed: (tag) => onSelect?.call(tag),
      ));
    }

    if (entryList.releaseEvents.isNotEmpty) {
      items.add(ListTile(
        title: Text('Events'),
      ));

      items.addAll(entryList.releaseEvents.map(
          (e) => ReleaseEventTile.fromEntry(e, onTap: () => onSelect?.call(e))));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (entries!.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    final List<Widget> items = _generateItems();
    return ListView.builder(
        itemCount: items.length, itemBuilder: (context, index) => items[index]);
  }
}
