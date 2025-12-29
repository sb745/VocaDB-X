import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/widgets.dart';

class FavoriteArtistPage extends StatefulWidget {
  const FavoriteArtistPage({super.key});

  @override
  State<FavoriteArtistPage> createState() => _FavoriteArtistPageState();
}

class _FavoriteArtistPageState extends State<FavoriteArtistPage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger refresh when entering this page
    _refreshData();
  }

  void _refreshData() {
    try {
      final controller = Get.find<FavoriteArtistController>();
      print('FavoriteArtistPage: Triggering manual refresh');
      // Reset pagination and fetch fresh data
      controller.noFetchMore.value = false;
      controller.fetchApi().then((newResults) {
        controller.results.clear();
        controller.results.addAll(newResults);
        print('FavoriteArtistPage: Refreshed with ${newResults.length} items');
      }).catchError((error) {
        print('FavoriteArtistPage: Error refreshing: $error');
      });
    } catch (e) {
      print('FavoriteArtistPage: Controller not found: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteArtistController>(
      builder: (controller) => _FavoriteArtistPageView(controller: controller),
    );
  }
}

class _FavoriteArtistPageView extends StatelessWidget {
  final FavoriteArtistController controller;

  const _FavoriteArtistPageView({required this.controller});

  void _onTapArtist(ArtistModel artist) => AppPages.toArtistDetailPage(artist);

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
                Text('favoriteArtists'.tr),
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
              onPressed: () => Get.to(FavoriteArtistFilterPage()))
        ]),
        body: Obx(
          () => (controller.initialLoading.value)
              ? CenterLoading()
              : (controller.errorMessage.string.isNotEmpty)
                  ? CenterText(controller.errorMessage.string)
                  : ArtistListView(
                      artists:
                          controller.results().map((e) => e.artist).whereType<ArtistModel>().toList(),
                      onSelect: _onTapArtist,
                      onReachLastItem: controller.onReachLastItem,
                      emptyWidget: CenterText('searchResultNotMatched'.tr)),
        ));
  }
}
