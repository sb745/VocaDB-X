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
import 'package:vocadb_app/utils.dart';
import 'package:vocadb_app/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongDetailPage extends StatelessWidget {
  const SongDetailPage({super.key});

  SongDetailController initController() {
    final httpService = Get.find<HttpService>();
    final authService = Get.find<AuthService>();
    return SongDetailController(
        songRepository: SongRepository(httpService: httpService),
        userRepository: UserRepository(httpService: httpService),
        authService: authService);
  }

  @override
  Widget build(BuildContext context) {
    final SongDetailController controller = initController();
    final SongDetailArgs args = Get.arguments;
    final String? id = Get.parameters['id'];

    return PageBuilder<SongDetailController>(
      tag: "s_$id",
      controller: controller,
      builder: (c) => SongDetailPageView(controller: c, args: args),
    );
  }
}

class SongDetailPageView extends StatelessWidget {
  final SongDetailController controller;

  final SongDetailArgs args;

  const SongDetailPageView({super.key, required this.controller, required this.args});

  void _onSelectTag(TagModel tag) => AppPages.toTagDetailPage(tag);

  void _onTapLikeButton() {
    print('Like button tapped. Current state: ${controller.liked.value}');
    controller.liked.toggle();
    print('New state: ${controller.liked.value}');
  }

  void _onTapLyricButton() => controller.showLyric(true);

  void _onTapShareButton() => Share.share(controller.song().originUrl);

  void _onTapInfoButton() => launch(controller.song().originUrl);

  void _onSelectSong(SongModel song) => AppPages.toSongDetailPage(song);

  void _onTapEntrySearch() => Get.toNamed(Routes.ENTRIES);

  void _onTapArtist(ArtistRoleModel a) =>
      AppPages.toArtistDetailPage(ArtistModel(
          id: a.id,
          name: a.name,
          mainPicture: MainPictureModel(urlThumb: a.imageUrl)));

  void _onTapAlbum(AlbumModel album) => AppPages.toAlbumDetailPage(album);

  void _onTapCloseLyricContent() => controller.showLyric(false);

  Widget _buildVideoContent() {
    return Obx(() {
      // Don't render anything if there's no valid video ID
      if (!controller.hasValidVideoId.value) {
        return SizedBox.shrink();
      }

      // If player is initialized, show the YouTube player
      if (controller.playerInitialized.value) {
        return SizedBox(
          height: 220,
          child: YoutubePlayer(
            controller: controller.youtubeController,
            onReady: () {
              controller.youtubeController.addListener(() => {});
            },
          ),
        );
      }

      // Show thumbnail with play button if player not initialized (autoplay disabled)
      PVModel? pv = controller.song().youtubePV;
      if (pv != null && pv.url != null) {
        return _buildVideoThumbnail();
      }

      // No video available, return empty
      return SizedBox.shrink();
    });
  }

  Widget _buildVideoThumbnail() {
    PVModel? pv = controller.song().youtubePV;
    if (pv == null || pv.url == null) return SizedBox.shrink();

    // Extract video ID to generate thumbnail URL
    String? videoId = YoutubePlayer.convertUrlToId(pv.url!);
    if (videoId == null || videoId.isEmpty) return SizedBox.shrink();

    return GestureDetector(
      onTap: () => controller.initYoutubeController(),
      child: Container(
        height: 220,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thumbnail image
            Image.network(
              'https://img.youtube.com/vi/$videoId/0.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(Icons.video_library, color: Colors.white70),
                  ),
                );
              },
            ),
            // Overlay with play button
            Container(
              color: Colors.black26,
              width: double.infinity,
              height: double.infinity,
            ),
            Icon(
              Icons.play_circle_filled,
              size: 80,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongImage() {
    return Container();
  
    return Container(
        width: double.infinity,
        height: 160,
        color: Colors.black,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CustomNetworkImage(
                  controller.song().imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CustomNetworkImage(
                controller.song().imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ));
  }

  Widget _buildLikeButton(BuildContext context) {
    final authService = Get.find<AuthService>();
    final likeButtonLabel = controller.liked.value ? 'Liked' : 'Like';
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

  Widget _buildButtonRow(BuildContext context) {
    final authService = Get.find<AuthService>();
    final likeButtonWidth = 80.0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Like button - wrapped in Obx for independent updates
        SizedBox(
          width: likeButtonWidth,
          child: Obx(() => _buildLikeButton(context)),
        ),
        if (controller.song().lyrics != null &&
            controller.song().lyrics!.isNotEmpty)
          TextButton(
            onPressed: _onTapLyricButton,
            child: Column(
              children: [Icon(Icons.subtitles), Text('lyrics'.tr)],
            ),
          ),
        TextButton(
          onPressed: _onTapShareButton,
          child: Column(
            children: [Icon(Icons.share), Text('share'.tr)],
          ),
        ),
        TextButton(
          onPressed: _onTapInfoButton,
          child: Column(
            children: [Icon(Icons.info), Text('info'.tr)],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.song().name ?? 'Song Detail'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _onTapEntrySearch()),
            IconButton(
                icon: Icon(Icons.home), onPressed: () => Get.offAll(MainPage()))
          ],
        ),
        body: Obx(() => (controller.showLyric())
            ? _buildLyricContent()
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      _buildVideoContent(),
                      _buildSongDetailContent(context),
                    ],
                  ),
                ),
              )));
  }

  Widget _buildLyricContent() {
    return LyricContent(
      lyrics: controller.song().lyrics ?? [],
      onTapClose: _onTapCloseLyricContent,
    );
  }

  Widget _buildSongDetailContent(BuildContext context) {
    if (controller.initialLoading.value) {
      return CenterLoading();
    }

    return Column(
      children: [
          _buildSongImage(),
          _buildButtonRow(context),
          _SongDetailInfo(
            name: controller.song().name.toString(),
            additionalNames: controller.song().additionalNames.toString(),
            songType: 'songType.${controller.song().songType}'.tr,
            publishedDate: controller.song().publishDateAsDateTime ?? DateTime.now(),
          ),
          SpaceDivider.small(),
          TagGroupView(
            onPressed: _onSelectTag,
            tags: controller.song().tags,
          ),
          Divider(),
          ArtistGroupByRoleList.fromArtistSongModel(
            onTap: (a) => _onTapArtist(a),
            artistSongs: controller.song().artists ?? [],
          ),
          Divider(),
          PVGroupList(
            pvs: controller.song().pvs ?? [],
            searchQuery: controller.song().pvSearchQuery ?? '',
            onTap: (pv) => launch(pv.url.toString()),
          ),
          Divider(),
          Visibility(
            visible: controller.song().albums!.isNotEmpty,
            child: Column(
              children: [
                Section(
                  title: 'albums'.tr,
                  child: AlbumListView(
                    scrollDirection: Axis.horizontal,
                    albums: controller.song().albums ?? [],
                    onSelect: (a) => _onTapAlbum(a),
                    onReachLastItem: () {},
                    emptyWidget: SizedBox.shrink(),
                  ),
                ),
                Divider()
              ],
            ),
          ),
          Obx(() => Visibility(
                visible: controller.altSongs.isNotEmpty,
                child: Column(
                  children: [
                    Section(
                      title: 'alternateVersion'.tr,
                      child: SongListView(
                        scrollDirection: Axis.horizontal,
                        onSelect: (s) => _onSelectSong(s),
                        songs: controller.altSongs.toList(),
                        onReachLastItem: () {},
                      ),
                    ),
                    Divider()
                  ],
                ),
              )),
          Obx(() => Visibility(
                visible: controller.relatedSongs.isNotEmpty,
                child: Column(
                  children: [
                    Section(
                      title: 'likeMatches'.tr,
                      child: SongListView(
                        scrollDirection: Axis.horizontal,
                        onSelect: (s) => _onSelectSong(s),
                        songs: controller.relatedSongs.toList(),
                        onReachLastItem: () {},
                      ),
                    ),
                    Divider()
                  ],
                ),
              )),
          Obx(() => (controller.song().webLinks!.isNotEmpty ||
                  controller.comments.isNotEmpty)
              ? Column(
                  children: [
                    if (controller.song().webLinks!.isNotEmpty)
                      WebLinkGroupList(webLinks: controller.song().webLinks),
                    if (controller.comments.isNotEmpty) ...[
                      Divider(),
                      _buildCommentsSection(context),
                    ]
                  ],
                )
              : SizedBox.shrink())
        ],
    );
  }

  Widget _buildCommentsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('comments'.tr, style: Theme.of(context).textTheme.titleMedium),
          GestureDetector(
            onTap: () => AppPages.toCommentsPage(CommentsArgs(
              entityType: 'song',
              entityId: controller.song().id!,
              entityName: controller.song().name ?? 'Song',
            )),
            child: Text(
              'viewAllComments'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          SpaceDivider.small(),
          ...controller.comments.take(5).map((comment) => _buildCommentTile(comment)).toList(),
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
            // User avatar
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
            // Comment content
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

class _SongDetailInfo extends StatelessWidget {
  final String? name;

  final String? additionalNames;

  final String? songType;

  final DateTime? publishedDate;

  const _SongDetailInfo(
      {this.name, this.additionalNames, this.songType, this.publishedDate});

  String _stringPublishedDate() {
    return (publishedDate == null)
        ? ''
        : ' • ${'publishedOn'.trArgs([
            DateTimeUtils.toSimpleFormat(publishedDate)
          ])}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name ?? '', style: Theme.of(context).textTheme.titleLarge),
          Text(additionalNames ?? ''),
          SpaceDivider.micro(),
          Text('${songType ?? ''}${_stringPublishedDate()}'),
        ],
      ),
    );
  }
}

class ActiveFlatButton extends StatelessWidget {
  final Icon? icon;

  final String label;

  final Function? onPressed;

  final bool active;

  final Color? activeColor;

  final Color? inactiveColor;

  const ActiveFlatButton(
      {super.key, 
      this.icon, 
      required this.label, 
      this.onPressed, 
      this.active = false,
      this.activeColor,
      this.inactiveColor});

  @override
  Widget build(BuildContext context) {
    final Color textColor = active 
        ? (activeColor ?? Theme.of(context).primaryColor)
        : (inactiveColor ?? Theme.of(context).colorScheme.onSurface);
    
    return TextButton(
      onPressed: onPressed as void Function()?,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
      ),
      child: Column(
        children: [if (icon != null) icon!, Text(label, style: TextStyle(color: textColor))],
      ),
    );
  }
}
