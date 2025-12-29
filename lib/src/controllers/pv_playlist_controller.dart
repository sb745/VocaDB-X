import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PVPlayListController extends GetxController {
  final songs = <SongModel>[].obs;

  final currentIndex = 0.obs;

  late YoutubePlayerController youtubeController;

  PVPlayListController();

  @override
  void onInit() {
    initArgs();
    initYoutubeController();
    super.onInit();
  }

  @override
  void onClose() {
    youtubeController.dispose();
    super.onClose();
  }

  void initYoutubeController() {
    currentIndex(SongList(songs()).getFirstWithYoutubePVIndex(0));
    String? url = songs()[currentIndex()].youtubePV?.url;
    
    // Use a placeholder video ID if no URL is available
    String videoId = (url != null) ? (YoutubePlayer.convertUrlToId(url) ?? '') : '';

    youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: (url != null) && SharedPreferenceService.autoPlayValue,
      ),
    );
  }

  void initArgs() {
    PVPlayListArgs args = Get.arguments;
    songs(args.songs);
  }

  void onEnded() {
    next();
    PVModel? pv = songs()[currentIndex()].youtubePV;
    if (pv != null && pv.url != null) {
      String? videoId = YoutubePlayer.convertUrlToId(pv.url!);
      if (videoId != null) {
        youtubeController.load(videoId);
      }
    }
  }

  void next() {
    int newIndex = currentIndex() + 1;

    if (newIndex >= songs().length) {
      newIndex = 0;
    }

    int nextPlayableIndex =
        SongList(songs()).getFirstWithYoutubePVIndex(newIndex);

    if (nextPlayableIndex == -1) {
      nextPlayableIndex = SongList(songs()).getFirstWithYoutubePVIndex(0);
    }

    currentIndex(newIndex);
  }

  void onSelect(int index) {
    currentIndex(index);
    PVModel? pv = songs()[index].youtubePV;
    if (pv != null && pv.url != null) {
      String? videoId = YoutubePlayer.convertUrlToId(pv.url!);
      if (videoId != null) {
        youtubeController.load(videoId);
      }
    }
  }
}
