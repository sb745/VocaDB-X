import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/widgets.dart';

class FavoriteSongPage extends StatefulWidget {
  const FavoriteSongPage({super.key});

  @override
  State<FavoriteSongPage> createState() => _FavoriteSongPageState();
}

class _FavoriteSongPageState extends State<FavoriteSongPage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger refresh when entering this page
    _refreshData();
  }

  void _refreshData() {
    try {
      final controller = Get.find<FavoriteSongController>();
      print('FavoriteSongPage: Triggering manual refresh');
      // Reset pagination and fetch fresh data
      controller.noFetchMore.value = false;
      controller.fetchApi().then((newResults) {
        controller.results.clear();
        controller.results.addAll(newResults);
        print('FavoriteSongPage: Refreshed with ${newResults.length} items');
      }).catchError((error) {
        print('FavoriteSongPage: Error refreshing: $error');
      });
    } catch (e) {
      print('FavoriteSongPage: Controller not found: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteSongController>(
      builder: (controller) => _FavoriteSongPageView(controller: controller),
    );
  }
}

class _FavoriteSongPageView extends StatelessWidget {
  final FavoriteSongController controller;

  const _FavoriteSongPageView({required this.controller});

  void _onTapSong(SongModel song) => AppPages.toSongDetailPage(song);

  Widget _buildTextInput(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller.textSearchController,
            onChanged: controller.query.call,
            style: Theme.of(context).primaryTextTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'search'.tr),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: Obx(() => (controller.openQuery.value)
          ? _buildTextInput(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('favoriteSongs'.tr),
                SizedBox(height: 4),
                Text(
                  'Updates every 5 mins',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            )),
    );
  }

  Widget _buildSearchAction(BuildContext context) {
    return Obx(
      () => (controller.openQuery.value)
          ? IconButton(
              icon: Icon(Icons.clear), onPressed: () => controller.clearQuery())
          : IconButton(
              icon: Icon(Icons.search),
              onPressed: () => controller.openQuery(true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle(context), actions: <Widget>[
        _buildSearchAction(context),
        IconButton(
            icon: Icon(Icons.tune),
            onPressed: () => Get.to(FavoriteSongFilterPage()))
      ]),
      body: Obx(
        () => (controller.initialLoading.value)
            ? CenterLoading()
            : (controller.errorMessage.string.isNotEmpty)
                ? CenterText(controller.errorMessage.string)
                : SongListView(
                    songs: controller.results().map((e) => e.song).whereType<SongModel>().toList(),
                    onSelect: _onTapSong,
                    onReachLastItem: controller.onReachLastItem,
                    emptyWidget: CenterText('searchResultNotMatched'.tr)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppPages.openPVPlayListPage(
            controller.results().map((e) => e.song).whereType<SongModel>().toList(),
            title: 'favoriteSongs'.tr),
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
