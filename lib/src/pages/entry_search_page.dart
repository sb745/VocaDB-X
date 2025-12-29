import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/src/pages/entry_search_filter_page.dart';
import 'package:vocadb_app/widgets.dart';

void _showKeyboard(FocusNode focusNode) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    focusNode.requestFocus();
  });
}

class EntrySearchPage extends StatefulWidget {
  const EntrySearchPage({super.key});

  @override
  State<EntrySearchPage> createState() => _EntrySearchPageState();
}

class _EntrySearchPageState extends State<EntrySearchPage> {
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    
    // Listen to openQuery changes to show keyboard
    final controller = Get.find<EntrySearchController>();
    ever(controller.openQuery, (isOpen) {
      if (isOpen) {
        _showKeyboard(_searchFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSelect(EntryModel entryModel) {
    switch (entryModel.entryType) {
      case EntryType.Song:
        AppPages.toSongDetailPage(SongModel.fromEntry(entryModel));
        break;

      case EntryType.Artist:
        AppPages.toArtistDetailPage(ArtistModel.fromEntry(entryModel));
        break;

      case EntryType.Album:
        AppPages.toAlbumDetailPage(AlbumModel.fromEntry(entryModel));
        break;

      case EntryType.Tag:
        AppPages.toTagDetailPage(TagModel.fromEntry(entryModel));
        break;

      case EntryType.ReleaseEvent:
        AppPages.toReleaseEventDetailPage(
            ReleaseEventModel.fromEntry(entryModel));
        break;

      default:
        print('Unsupported entry $entryModel');
    }
  }

  Widget _buildTextInput(BuildContext context, EntrySearchController controller) {
    // Delay to ensure widget is built before requesting focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
    
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller.textSearchController,
            focusNode: _searchFocusNode,
            onChanged: controller.query.call,
            style: Theme.of(context).primaryTextTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'search'.tr),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, EntrySearchController controller) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: Obx(() => controller.openQuery.value
          ? _buildTextInput(context, controller)
          : GestureDetector(
              onTap: () => controller.openQuery(true),
              child: Text('search'.tr),
            )),
    );
  }

  Widget _buildSearchAction(BuildContext context, EntrySearchController controller) {
    return Obx(
      () => controller.openQuery.value
          ? IconButton(
              icon: Icon(Icons.clear), onPressed: () => controller.clearQuery())
          : IconButton(
              icon: Icon(Icons.search),
              onPressed: () => controller.openQuery(true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EntrySearchController>();
    
    return Scaffold(
        appBar: AppBar(title: _buildTitle(context, controller), actions: <Widget>[
          _buildSearchAction(context, controller),
          IconButton(
              icon: Icon(Icons.tune),
              onPressed: () => Get.to(EntrySearchFilterPage())),
        ]),
        body: Obx(
          () => (controller.query.string.isEmpty)
              ? CenterText('findAnything'.tr)
              : (controller.errorMessage.string.isNotEmpty)
                  ? CenterText(controller.errorMessage.string)
                  : EntryListView(
                      entries: controller.results.toList(),
                      onSelect: (entry) => entry != null ? _onSelect(entry) : null,
                      emptyWidget: CenterText('searchResultNotMatched'.tr)),
        ));
  }
}
