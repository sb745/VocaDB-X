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

class AlbumDetailPage extends StatelessWidget {
  const AlbumDetailPage({super.key});

  AlbumDetailController initController() {
    final httpService = Get.find<HttpService>();
    final authService = Get.find<AuthService>();
    return AlbumDetailController(
        albumRepository: AlbumRepository(httpService: httpService),
        userRepository: UserRepository(httpService: httpService),
        authService: authService);
  }

  @override
  Widget build(BuildContext context) {
    final AlbumDetailController controller = initController();
    final AlbumDetailArgs args = Get.arguments;
    final String? id = Get.parameters['id'];

    return PageBuilder<AlbumDetailController>(
      tag: "al_$id",
      controller: controller,
      builder: (c) => AlbumDetailPageView(controller: c, args: args),
    );
  }
}

class AlbumDetailPageView extends StatelessWidget {
  final AlbumDetailController controller;

  final AlbumDetailArgs args;

  const AlbumDetailPageView({super.key, required this.controller, required this.args});

  void _onTapTrack(TrackModel track) => AppPages.toSongDetailPage(track.song!);

  void _onTapShareButton() => Share.share(controller.album().originUrl);

  void _onTapInfoButton() => launch(controller.album().originUrl);

  void _onTapHome() => Get.offAll(MainPage());

  void _onTapEntrySearch() => Get.toNamed(Routes.ENTRIES);

  void _onTapArtist(ArtistRoleModel artistRoleModel) {
    if (artistRoleModel.id != null) {
      Get.to(ArtistDetailPage(), 
        arguments: ArtistDetailArgs(id: artistRoleModel.id!));
    }
  }

  void _onSelectTag(TagModel tag) => AppPages.toTagDetailPage(tag);

  void _onTapCollectButton() {
    controller.updateAlbumCollection();
  }

  Widget _buttonBarBuilder() {
    final authService = Get.find<AuthService>();

    List<Widget> buttons = [];

    buttons.add(Obx(() => ActiveFlatButton(
      icon: Icon(Icons.favorite),
      label: controller.collected.value ? 'Collected' : 'collect'.tr,
      active: controller.collected.value,
      onPressed: authService.currentUser().id == null
          ? () {}
          : _onTapCollectButton,
    )));

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
          floating: true,
          title: Text(controller.album().name ?? ''),
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
        ),
        Obx(
          () => SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              width: 160,
              height: 160,
              child: CustomNetworkImage(
                controller.album().imageUrl,
              ),
            ),
            SpaceDivider.small(),
            Column(
              children: [
                Visibility(
                  visible: controller.album().ratingCount != null &&
                      controller.album().ratingCount! > 0,
                  child: Text(
                      '${controller.album().ratingAverage} ★ (${controller.album().ratingCount})'),
                ),
                SpaceDivider.small(),
                Text(
                  controller.album().name.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SpaceDivider.small(),
                Text(controller.album().artistString.toString()),
                SpaceDivider.micro(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.album().releaseDateFormatted != null
                          ? '${('discType.${controller.album().discType}').tr} • ${'discOnSaleDate'.trArgs([
                              controller.album().releaseDateFormatted!
                            ])}'
                          : ('discType.${controller.album().discType}').tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              ],
            ),
            SpaceDivider.micro(),
            _buttonBarBuilder(),
            TagGroupView(
              onPressed: _onSelectTag,
              tags: controller.album().tags.whereType<TagModel>().toList() ?? [],
            ),
            ExpandableContent(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextInfoSection(
                      title: 'name'.tr,
                      text: controller.album().name,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextInfoSection(
                      title: 'description'.tr,
                      text: controller.album().description,
                    ),
                  ),
                  Divider(),
                  ArtistGroupByRoleList.fromArtistAlbumModel(
                    onTap: _onTapArtist,
                    artistAlbums: controller.album().artists ?? [],
                    // prefixHeroTag: 'album_detail_${args.id}',
                  ),
                ],
              ),
            ),
            Divider(),
            TrackListView(
              tracks: controller.album().tracks ?? [],
              onSelect: _onTapTrack,
            ),
            Divider(),
            WebLinkGroupList(webLinks: controller.album().webLinks ?? []),
            Obx(() => (controller.comments.isNotEmpty)
                ? Column(
                    children: [
                      Divider(),
                      _buildCommentsSection(context),
                    ],
                  )
                : SizedBox.shrink()),
            SpaceDivider.medium()
          ])),
        )
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
              entityType: 'album',
              entityId: controller.album().id!,
              entityName: controller.album().name ?? 'Album',
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
