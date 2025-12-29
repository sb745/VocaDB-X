import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/services.dart';
import 'package:vocadb_app/widgets.dart';

class ReleaseEventDetailPage extends StatelessWidget {
  const ReleaseEventDetailPage({super.key});

  ReleaseEventDetailController initController() {
    final httpService = Get.find<HttpService>();
    return ReleaseEventDetailController(
        eventRepository: ReleaseEventRepository(httpService: httpService));
  }

  @override
  Widget build(BuildContext context) {
    final ReleaseEventDetailController controller = initController();
    final ReleaseEventDetailArgs args = Get.arguments;
    final String? id = Get.parameters['id'];

    return PageBuilder<ReleaseEventDetailController>(
      tag: "event_$id",
      controller: controller,
      builder: (c) => ReleaseEventDetailPageView(controller: c, args: args),
    );
  }
}

class ReleaseEventDetailPageView extends StatelessWidget {
  final ReleaseEventDetailController controller;

  final ReleaseEventDetailArgs args;

  const ReleaseEventDetailPageView({super.key, required this.controller, required this.args});

  void _onSelectTag(TagModel tag) => AppPages.toTagDetailPage(tag);

  void _onTapShareButton() => Share.share(controller.event().originUrl);

  void _onTapInfoButton() => launch(controller.event().originUrl);

  void _onTapSong(SongModel song) => AppPages.toSongDetailPage(song);

  void _onTapArtist(ArtistRoleModel a) =>
      AppPages.toArtistDetailPage(ArtistModel(
          id: a.id,
          name: a.name,
          mainPicture: MainPictureModel(urlThumb: a.imageUrl)));

  void _onTapAlbum(AlbumModel album) => AppPages.toAlbumDetailPage(album);

  void _onTapHome() => Get.offAll(MainPage());

  void _onTapEntrySearch() => Get.toNamed(Routes.ENTRIES);

  void _onTapMapButton() {
    String q = controller.event().venueName ?? '';
    String uri = Uri.encodeFull('geo:0,0?q=$q');
    canLaunch(uri).then((can) => (can)
        ? launch(uri)
        : launch(Uri.encodeFull('https://maps.apple.com/?q=$q')));
  }

  void _onTapEventSeries() {
    final series = controller.event().series;
    if (series != null) {
      AppPages.toReleaseEventSeriesDetailPage(series);
    }
  }

  Widget _buttonBarBuilder() {
    List<Widget> buttons = [];

    buttons.add(TextButton(
      onPressed: _onTapShareButton,
      child: Column(
        children: [Icon(Icons.share), Text('share'.tr)],
      ),
    ));

    buttons.add(TextButton(
      onPressed: null,
      child: Column(
        children: [Icon(Icons.place), Text('map'.tr)],
      ),
    ));

    buttons.add(TextButton(
      onPressed: _onTapInfoButton,
      child: Column(
        children: [Icon(Icons.info), Text('info'.tr)],
      ),
    ));

    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _onTapEntrySearch,
              ),
              IconButton(
                icon: Icon(Icons.home),
                onPressed: _onTapHome,
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                controller.event().name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: SafeArea(
                child: Opacity(
                  opacity: 0.7,
                  child: Visibility(
                    visible: controller.event().imageUrl != null,
                    child: CustomNetworkImage(
                      controller.event().imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            )),
        Obx(
          () => SliverList(
              delegate: SliverChildListDelegate([
            _buttonBarBuilder(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceDivider.small(),
                TagGroupView(
                  onPressed: _onSelectTag,
                  tags: controller
                          .event()
                          .tagGroups
                          ?.map((t) => t.tag)
                          .whereType<TagModel>()
                          .toList() ??
                      [],
                ),
                SpaceDivider.small(),
                TextInfoSection(
                  title: 'name'.tr,
                  text: controller.event().name,
                  divider: SpaceDivider.small(),
                ),
                TextInfoSection(
                  title: 'category'.tr,
                  text:
                      'eventCategory.${controller.event().displayCategory}'.tr,
                  divider: SpaceDivider.small(),
                ),
                TextInfoSection(
                  title: 'date'.tr,
                  text: controller.event().dateFormatted,
                  divider: SpaceDivider.small(),
                ),
                TextInfoSection(
                  title: 'venue'.tr,
                  text: controller.event().venueName,
                  divider: SpaceDivider.small(),
                ),
                if (controller.event().description != null &&
                    controller.event().description!.isNotEmpty)
                  InfoSection(
                    title: 'description'.tr,
                    visible: true,
                    child: SelectableText(
                      controller.event().description!,
                    ),
                  ),
                Divider(),
                Section(
                  title: 'participatingArtists'.tr,
                  visible: controller.event().artists?.isNotEmpty,
                  divider: Divider(),
                  child: ArtistGroupByRoleList.fromArtistEventModel(
                    artistEvents: controller.event().artists ?? [],
                    onTap: _onTapArtist,
                    displayRole: false,
                  ),
                ),
                Section(
                  title: 'songs'.tr,
                  visible: controller.songs().isNotEmpty,
                  divider: Divider(),
                  child: SongListView(
                    scrollDirection: Axis.horizontal,
                    onSelect: _onTapSong,
                    onReachLastItem: () {},
                    songs: controller.songs(),
                  ),
                ),
                Section(
                  title: 'albums'.tr,
                  visible: controller.albums().isNotEmpty,
                  divider: Divider(),
                  child: AlbumListView(
                    scrollDirection: Axis.horizontal,
                    albums: controller.albums(),
                    onSelect: _onTapAlbum,
                    onReachLastItem: () {},
                    emptyWidget: SizedBox.shrink(),
                  ),
                ),
                Section(
                  title: 'series'.tr,
                  visible: controller.event().series != null,
                  divider: Divider(),
                  child: ReleaseEventSeriesTile(
                    name: controller.event().series?.name ?? '',
                    onTap: _onTapEventSeries,
                  ),
                ),
                WebLinkGroupList(webLinks: controller.event().webLinks)
              ],
            )
          ])),
        )
      ],
    ));
  }
}
