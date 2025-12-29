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

class ArtistDetailPage extends StatelessWidget {
  const ArtistDetailPage({super.key});

  ArtistDetailController initController() {
    final httpService = Get.find<HttpService>();
    final authService = Get.find<AuthService>();
    return ArtistDetailController(
        artistRepository: ArtistRepository(httpService: httpService),
        userRepository: UserRepository(httpService: httpService),
        authService: authService);
  }

  @override
  Widget build(BuildContext context) {
    final ArtistDetailController controller = initController();
    final ArtistDetailArgs args = Get.arguments;
    final String? id = Get.parameters['id'];

    return PageBuilder<ArtistDetailController>(
      tag: "a_$id",
      controller: controller,
      builder: (c) => ArtistDetailPageView(controller: c, args: args),
    );
  }
}

class ArtistDetailPageView extends StatelessWidget {
  final ArtistDetailController controller;

  final ArtistDetailArgs args;

  const ArtistDetailPageView({super.key, required this.controller, required this.args});

  void _onSelectTag(TagModel tag) => AppPages.toTagDetailPage(tag);

  void _onTapLikeButton() {
    print('Like button tapped. Current state: ${controller.liked.value}');
    controller.liked.toggle();
    print('New state: ${controller.liked.value}');
  }

  void _onTapShareButton() => Share.share(controller.artist().originUrl);

  void _onTapInfoButton() => launch(controller.artist().originUrl);

  void _onTapSong(SongModel song) => AppPages.toSongDetailPage(song);

  void _onTapArtist(ArtistModel artist) => AppPages.toArtistDetailPage(artist);

  void _onTapAlbum(AlbumModel album) => AppPages.toAlbumDetailPage(album);

  void _onTapHome() => Get.offAll(MainPage());

  void _onTapEntrySearch() => Get.toNamed(Routes.ENTRIES);

  Widget _buildLikeButton(BuildContext context) {
    final authService = Get.find<AuthService>();
    final likeButtonLabel = controller.liked.value ? 'Liked' : 'like'.tr;
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = Theme.of(context).colorScheme.onSurface;
    
    return ActiveFlatButton(
      icon: Icon(
        Icons.favorite,
        color: controller.liked.value ? activeColor : inactiveColor,
      ),
      label: likeButtonLabel,
      active: controller.liked.value,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      onPressed: (authService.currentUser.value.id != null) ? _onTapLikeButton : null,
    );
  }

  Widget _buttonBarBuilder(BuildContext context) {
    final authService = Get.find<AuthService>();

    List<Widget> buttons = [];

    buttons.add(
      SizedBox(
        width: 80.0,
        child: Obx(() => _buildLikeButton(context)),
      ),
    );

    buttons.add(FilledButton(
      onPressed: _onTapShareButton,
      child: Column(
        children: [Icon(Icons.share), Text('share'.tr)],
      ),
    ));

    buttons.add(FilledButton(
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
              title: Text(controller.artist().name.toString()),
              background: SafeArea(
                child: Opacity(
                  opacity: 0.7,
                  child: CustomNetworkImage(
                    controller.artist().imageUrl,
                  ),
                ),
              ),
            )),
        SliverList(
            delegate: SliverChildListDelegate([
          _buttonBarBuilder(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.artist().name.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Visibility(
                          visible: controller.artist().additionalNames != null,
                          child:
                              Text(controller.artist().additionalNames ?? '')),
                      Text('artistType.${controller.artist().artistType}'.tr ??
                          ''),
                    ],
                  ),
                ),
              ),
              SpaceDivider.small(),
              Obx(
                () => TagGroupView(
                  onPressed: _onSelectTag,
                  tags: controller.artist().tags,
                ),
              ),
              SpaceDivider.small(),
              Obx(
                () => Visibility(
                  visible: (controller.artist().releaseDate != null &&
                      controller.artist().description != null &&
                      controller.artist().artistLinks != null &&
                      controller.artist().artistLinksReverse != null),
                  child: ExpandableContent(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: controller.artist().releaseDate != null,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextInfoSection(
                              title: 'releasedDate'.tr,
                              text: controller.artist().releaseDateFormatted,
                            ),
                          ),
                        ),
                        SpaceDivider.small(),
                        Visibility(
                          visible: controller.artist().description != null,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextInfoSection(
                              title: 'description'.tr,
                              text: controller.artist().description,
                            ),
                          ),
                        ),
                        SpaceDivider.small(),
                        Visibility(
                          visible: controller.artist().artistLinks != null &&
                              controller.artist().artistLinks!.isNotEmpty,
                          child: ArtistLinkListView(
                              artistLinks: controller.artist().artistLinks ?? [],
                              onSelect: (artistLinkModel) =>
                                  artistLinkModel.artist != null ? _onTapArtist(artistLinkModel.artist!) : null),
                        ),
                        Visibility(
                          visible: controller.artist().artistLinksReverse !=
                                  null &&
                              controller.artist().artistLinksReverse!.isNotEmpty,
                          child: ArtistLinkListView(
                              reverse: true,
                              artistLinks:
                                  controller.artist().artistLinksReverse ?? [],
                              onSelect: (artistLinkModel) =>
                                  artistLinkModel.artist != null ? _onTapArtist(artistLinkModel.artist!) : null),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),
              Obx(
                () => Visibility(
                  visible: controller.artist().relations != null &&
                      (controller.artist().relations?.latestSongs.isNotEmpty ?? false),
                  child: Column(
                    children: [
                      Section(
                        title: 'recentSongsPVs'.tr,
                        child: SongListView(
                          scrollDirection: Axis.horizontal,
                          songs: controller.artist().relations?.latestSongs ?? [],
                          onSelect: (s) => _onTapSong(s),
                          onReachLastItem: () {},
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.artist().relations != null &&
                      (controller.artist().relations?.popularSongs.isNotEmpty ?? false),
                  child: Column(
                    children: [
                      Section(
                        title: 'popularSongs'.tr,
                        child: SongListView(
                          scrollDirection: Axis.horizontal,
                          onSelect: (s) => _onTapSong(s),
                          songs: controller.artist().relations?.popularSongs ?? [],
                          onReachLastItem: () {},
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.artist().relations != null &&
                      (controller.artist().relations?.latestAlbums.isNotEmpty ?? false),
                  child: Column(
                    children: [
                      Section(
                        title: 'recentAlbums'.tr,
                        child: AlbumListView(
                          scrollDirection: Axis.horizontal,
                          albums: controller.artist().relations?.latestAlbums ?? [],
                          onSelect: (al) => _onTapAlbum(al),
                          onReachLastItem: () {},
                          emptyWidget: Container(),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.artist().relations != null &&
                      (controller.artist().relations?.popularAlbums.isNotEmpty ?? false),
                  child: Column(
                    children: [
                      Section(
                        title: 'popularAlbums'.tr,
                        child: AlbumListView(
                          scrollDirection: Axis.horizontal,
                          albums: controller.artist().relations?.popularAlbums ?? [],
                          onSelect: (al) => _onTapAlbum(al),
                          onReachLastItem: () {},
                          emptyWidget: Container(),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                    visible: controller.artist().webLinks != null &&
                        controller.artist().webLinks!.isNotEmpty,
                    child: WebLinkGroupList(
                        webLinks: controller.artist().webLinks ?? [])),
              ),
              Obx(() => (controller.comments.isNotEmpty)
                  ? Column(
                      children: [
                        Divider(),
                        _buildCommentsSection(context),
                      ],
                    )
                  : SizedBox.shrink()),
            ],
          )
        ]))
      ],
    ));
  }

  Widget _buildCommentsSection(BuildContext context) {
    final recentComments = controller.comments.take(5).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('comments'.tr, style: Theme.of(context).textTheme.titleMedium),
          GestureDetector(
            onTap: () => AppPages.toCommentsPage(CommentsArgs(
              entityType: 'artist',
              entityId: controller.artist().id!,
              entityName: controller.artist().name ?? 'Artist',
            )),
            child: Text(
              'viewAllComments'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          SpaceDivider.small(),
          ...recentComments.map((comment) => _buildCommentTile(comment)).toList(),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: LimitedBox(
        maxWidth: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(comment.authorImageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),
            SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          comment.authorName ?? 'Unknown',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        comment.createdFormatted ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    comment.message ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
