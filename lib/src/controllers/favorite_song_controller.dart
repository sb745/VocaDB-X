import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class FavoriteSongController extends SearchPageController<RatedSongModel> {
  /// List of results from search
  @override
  final results = <RatedSongModel>[].obs;

  /// Filter parameter
  final sort = 'RatingDate'.obs;

  /// Filter parameter
  final rating = ''.obs;

  /// Filter parameter
  final groupByRating = false.obs;

  /// Filter parameter
  final artists = <ArtistModel>[].obs;

  /// Filter parameter
  final tags = <TagModel>[].obs;

  final UserRepository? userRepository;

  final AuthService authService;

  FavoriteSongController({this.userRepository, required this.authService});

  @override
  void onInit() {
    if (authService.currentUser().id == null) {
      print('Error user not login yet.');
    }

    initialFetch();
    ever(rating, (_) => initialFetch());
    ever(groupByRating, (_) => initialFetch());
    ever(sort, (_) => initialFetch());
    ever(artists, (_) => initialFetch());
    ever(tags, (_) => initialFetch());
    super.onInit();
  }

  @override
  void onShow() {
    print('FavoriteSongController onShow - page became visible');
    // Force refresh by resetting pagination flag and fetching new data
    noFetchMore.value = false;
    // Fetch fresh data from server
    fetchApi().then((newResults) {
      // Update results list
      results.clear();
      results.addAll(newResults);
      print('FavoriteSongController refreshed with ${newResults.length} items');
    }).catchError((error) {
      print('Error refreshing favorite songs: $error');
    });
  }

  @override
  void onReady() {
    // Refresh data every time the page becomes visible/ready
    print('FavoriteSongController onReady - refreshing data');
    // Reset pagination and refresh
    noFetchMore.value = false;
    fetchApi().then((newResults) {
      results.clear();
      results.addAll(newResults);
      print('FavoriteSongController ready refresh with ${newResults.length} items');
    }).catchError((error) {
      print('Error in onReady: $error');
    });
    super.onReady();
  }

  @override
  Future<List<RatedSongModel>> fetchApi({int? start}) => userRepository
      !.getRatedSongs(authService.currentUser().id!.toInt(),
          start: (start == null) ? 0 : start,
          maxResults: maxResults,
          lang: SharedPreferenceService.lang,
          query: query.string,
          rating: rating.string,
          groupByRating: groupByRating.value,
          sort: sort.string,
          artistIds: artists.toList().map((e) => e.id).join(','),
          tagIds: tags.toList().map((e) => e.id).join(','))
      .catchError((error) {
        super.onError(error);
        return <RatedSongModel>[];
      });
}
