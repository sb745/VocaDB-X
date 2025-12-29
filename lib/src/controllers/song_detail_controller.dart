import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongDetailController extends GetxController {
  final initialLoading = true.obs;

  final song = SongModel().obs;

  final altSongs = <SongModel>[].obs;

  final relatedSongs = <SongModel>[].obs;

  final comments = <CommentModel>[].obs;

  final showLyric = false.obs;

  final liked = false.obs;

  final playerInitialized = false.obs;

  final hasValidVideoId = false.obs;

  final SongRepository? songRepository;

  final UserRepository? userRepository;

  final AuthService? authService;

  late YoutubePlayerController youtubeController;

  SongDetailController(
      {this.songRepository, this.userRepository, this.authService});

  @override
  void onInit() {
    initArgs();
    // Load rating status before fetching other data
    checkUserSongRating();
    fetchApis();
    // Initialize YouTube player - always initialize, autoplay setting just controls playback
    initYoutubeController();
    super.onInit();
  }

  @override
  void onClose() {
    if (playerInitialized.value) {
      youtubeController.dispose();
    }
    super.onClose();
  }

  void initYoutubeController() {
    // Prevent double initialization
    if (playerInitialized.value) return;

    PVModel? pv = song().youtubePV;

    // Extract video ID
    String videoId = (pv != null && pv.url != null)
        ? (YoutubePlayer.convertUrlToId(pv.url!) ?? '')
        : '';

    // Don't initialize player if no valid video ID
    if (videoId.isEmpty) {
      hasValidVideoId(false);
      playerInitialized(true);
      return;
    }

    hasValidVideoId(true);
    youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: (pv != null && pv.url != null) && SharedPreferenceService.autoPlayValue,
      ),
    );
    playerInitialized(true);
  }

  void initArgs() {
    SongDetailArgs args = Get.arguments;

    if (args.song != null) {
      song(args.song);
    } else {
      song(SongModel(id: args.id));
    }
  }

  void fetchApis() {
    String lang = SharedPreferenceService.lang;
    songRepository
        ?.getById(song().id!, lang: lang)
        .then(song.call)
        .then(initialLoadingDone);

    songRepository
        ?.getDerived(song().id!, lang: lang)
        .then((songs) => songs.take(20).toList())
        .then(altSongs.call);

    songRepository
        ?.getRelated(song().id!, lang: lang)
        .then((songs) => songs.take(20).toList())
        .then(relatedSongs.call);

    songRepository
        ?.getComments(song().id!)
        .then((allComments) => allComments.take(5).toList())
        .then(comments.call);
  }

  void checkUserSongRating() {
    int? userId = authService?.currentUser().id;

    if (userId == null) {
      print('User not logged in, cannot check song rating');
      return;
    }

    print('Checking user song rating for song: ${song().id}');
    userRepository
        ?.getCurrentUserRatedSong(song().id!)
        .then((value) {
          print('Rating status fetched: $value');
          final isLiked = (value != 'Nothing');
          liked.value = isLiked;
          print('Song liked state set to: $isLiked');
          // Set up debounce after the initial value is loaded
          debounce(liked, (_) => updateRating(), time: Duration(seconds: 1));
        })
        .catchError((error) {
          print('Error checking rating: $error');
          // Don't set up debounce if there's an error
        });
  }

  Future<List<RatedSongModel>>? updateRating() async {
    print('Updating rating for song: ${song().id}, liked: ${liked.value}');
    
    try {
      // Update rating on server
      await songRepository?.rating(song().id!, (liked.value) ? 'Like' : 'Nothing');
      print('Rating updated: ${liked.value ? "Liked" : "Unliked"}');
      
      // Try to update favorite songs list if the controller exists
      try {
        final controller = Get.find<FavoriteSongController>();
        return await controller.fetchApi();
      } catch (e) {
        print('FavoriteSongController not found (user not on that page), ignoring refresh');
        return <RatedSongModel>[];
      }
    } catch (err) {
      print('Error updating rating on server: $err');
      // Rating update failed on server
      return <RatedSongModel>[];
    }
  }

  bool initialLoadingDone(_) => initialLoading(false);
}
