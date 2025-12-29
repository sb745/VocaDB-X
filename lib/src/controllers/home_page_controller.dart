import 'package:get/get.dart';

import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class HomePageController extends GetxController {
  final highlighted = <SongModel>[].obs;
  final randomAlbums = <AlbumModel>[].obs;
  final recentAlbums = <AlbumModel>[].obs;
  final recentReleaseEvents = <ReleaseEventModel>[].obs;

  final SongRepository songRepository;
  final AlbumRepository albumRepository;
  final ReleaseEventRepository releaseEventRepository;
  
  bool _initialDataFetched = false;

  HomePageController(
      {required this.songRepository, required this.albumRepository, required this.releaseEventRepository});

  @override
  void onInit() {
    // Defer initial fetch to avoid blocking tab switch - only fetch once
    Future.delayed(Duration.zero, () {
      if (!_initialDataFetched) {
        _initialDataFetched = true;
        fetchApi();
      }
    });
    super.onInit();
  }

  void fetchApi() {
    String lang = SharedPreferenceService.lang;
    songRepository
        .getHighlighted(lang: lang)
        .then(highlighted.call)
        .catchError((err) {
          onError(err);
          highlighted.value = [];
          return <SongModel>[];
        });
    albumRepository.getTop(lang: lang).then(randomAlbums.call).catchError((err) {
      onError(err);
      randomAlbums.value = [];
      return <AlbumModel>[];
    });
    albumRepository.getNew(lang: lang).then(recentAlbums.call).catchError((err) {
      onError(err);
      recentAlbums.value = [];
      return <AlbumModel>[];
    });
    releaseEventRepository
        .getRecently(lang: lang)
        .then((result) => result.reversed.toList())
        .then(recentReleaseEvents.call)
        .catchError((err) {
          onError(err);
          recentReleaseEvents.value = [];
          return <ReleaseEventModel>[];
        });
  }

  void onError(err) {
    print('Error: $err');
  }
}
