import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class FavoriteArtistController
    extends SearchPageController<FollowedArtistModel> {
  /// Filter parameter
  final artistType = ''.obs;

  /// Filter parameter
  final tags = <TagModel>[].obs;

  final UserRepository? userRepository;

  final AuthService? authService;

  FavoriteArtistController({this.userRepository, this.authService});

  @override
  void onInit() {
    if (authService?.currentUser().id == null) {
      print('Error user not login yet.');
    }
    ever(artistType, (_) => initialFetch());
    ever(tags, (_) => initialFetch());
    super.onInit();
  }

  @override
  void onShow() {
    print('FavoriteArtistController onShow - page became visible');
    // Force refresh by resetting pagination flag and fetching new data
    noFetchMore.value = false;
    // Fetch fresh data from server
    fetchApi().then((newResults) {
      // Update results list
      results.clear();
      results.addAll(newResults);
      print('FavoriteArtistController refreshed with ${newResults.length} items');
    }).catchError((error) {
      print('Error refreshing favorite artists: $error');
    });
  }

  @override
  void onReady() {
    // Refresh data every time the page becomes visible/ready
    print('FavoriteArtistController onReady - refreshing data');
    // Reset pagination and refresh
    noFetchMore.value = false;
    fetchApi().then((newResults) {
      results.clear();
      results.addAll(newResults);
      print('FavoriteArtistController ready refresh with ${newResults.length} items');
    }).catchError((error) {
      print('Error in onReady: $error');
    });
    super.onReady();
  }

  @override
  Future<List<FollowedArtistModel>> fetchApi({int? start}) => userRepository
      !.getFollowedArtists(authService!.currentUser().id!.toInt(),
          query: query.string,
          start: (start == null) ? 0 : start,
          maxResults: maxResults,
          lang: SharedPreferenceService.lang,
          artistType: artistType.string,
          tagIds: tags.toList().map((e) => e.id).join(','))
      .catchError((error) {
        super.onError(error);
        return <FollowedArtistModel>[];
      });
}
