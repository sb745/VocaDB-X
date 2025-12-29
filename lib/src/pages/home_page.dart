import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/widgets.dart';

/// Home page is same as VocaDB  website. Home page display list of highlighted songs, Recently added albums, Random popular albums and upcoming events
class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  void _onTapSong(SongModel song) => AppPages.toSongDetailPage(song);

  void _onTapAlbum(AlbumModel album) => AppPages.toAlbumDetailPage(album);

  void _onTapReleaseEvent(ReleaseEventModel releaseEventModel) =>
      AppPages.toReleaseEventDetailPage(releaseEventModel);

  void _onTapSongSearchIcon() => Get.toNamed(Routes.SONGS);

  void _onTapArtistSearchIcon() => Get.toNamed(Routes.ARTISTS);

  void _onTapAlbumSearchIcon() => Get.toNamed(Routes.ALBUMS);

  void _onTapTagSearchIcon() => Get.toNamed(Routes.TAG_CATEGORIES);

  void _onTapEventSearchIcon() => Get.toNamed(Routes.RELEASE_EVENTS);

  Widget _buildMenuSection() {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        runSpacing: 24.0,
        children: <Widget>[
          _ShortcutMenuButton(
              title: 'songs'.tr,
              iconData: Icons.music_note,
              onPressed: _onTapSongSearchIcon),
          _ShortcutMenuButton(
              title: 'artists'.tr,
              iconData: Icons.person,
              onPressed: _onTapArtistSearchIcon),
          _ShortcutMenuButton(
              title: 'albums'.tr,
              iconData: Icons.album,
              onPressed: _onTapAlbumSearchIcon),
          _ShortcutMenuButton(
              title: 'tags'.tr,
              iconData: Icons.label,
              onPressed: _onTapTagSearchIcon),
          _ShortcutMenuButton(
              title: 'events'.tr,
              iconData: Icons.event,
              onPressed: _onTapEventSearchIcon),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SpaceDivider.small(),
          _buildMenuSection(),
          SpaceDivider.small(),
          Section(
            title: 'highlighted'.tr,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz),
                onSelected: (String selectedValue) => AppPages.openPVPlayListPage(
                    controller.highlighted(),
                    title: 'highlighted'.tr),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                      value: 'playall', child: Text('playAll'.tr)),
                ],
              )
            ],
            child: Obx(() => SongListView(
                displayPlaceholder: controller.highlighted.isEmpty,
                scrollDirection: Axis.horizontal,
                onSelect: (song) => _onTapSong(song),
                onReachLastItem: () {},
                songs: controller.highlighted)),
          ),
          Section(
            title: 'recentAlbums'.tr,
            child: Obx(() => AlbumListView(
                  displayPlaceholder: controller.recentAlbums.isEmpty,
                  scrollDirection: Axis.horizontal,
                  onSelect: (a) => _onTapAlbum(a),
                  onReachLastItem: () {},
                  emptyWidget: SizedBox.shrink(),
                  albums: controller.recentAlbums,
                )),
          ),
          Section(
            title: 'randomPopularAlbums'.tr,
            child: Obx(() => AlbumListView(
                displayPlaceholder: controller.randomAlbums.isEmpty,
                scrollDirection: Axis.horizontal,
                onSelect: (a) => _onTapAlbum(a),
                onReachLastItem: () {},
                emptyWidget: SizedBox.shrink(),
                albums: controller.randomAlbums)),
          ),
          Section(
            title: 'upcomingEvent'.tr,
            child: Obx(() => ReleaseEventColumnView(
                  onSelect: _onTapReleaseEvent,
                  events: controller.recentReleaseEvents.toList(),
                )),
          ),
        ],
      ),
    );
  }
}

/// Shortcut menu to each entry search page on home page
class _ShortcutMenuButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPressed;

  const _ShortcutMenuButton(
      {required this.title, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: onPressed,
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
            size: 24.0,
          ),
        ),
        Text(title)
      ],
    );
  }
}
