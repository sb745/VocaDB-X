import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class FavoriteAlbumController extends SearchPageController<AlbumUserModel> {
  /// Filter parameter
  final purchaseStatuses = ''.obs;

  /// Filter parameter
  final discType = ''.obs;

  /// Filter parameter
  final sort = 'Name'.obs;

  /// Filter parameter
  final tags = <TagModel>[].obs;

  /// Filter parameter
  final artists = <ArtistModel>[].obs;

  /// If set to [True], no fetch more data from server. Default is [False].
  @override
  final noFetchMore = false.obs;

  final UserRepository? userRepository;

  final AuthService? authService;

  FavoriteAlbumController({required this.userRepository, this.authService});

  @override
  void onInit() {
    if (authService?.currentUser().id == null) {
      print('Error user not login yet.');
    }
    ever(purchaseStatuses, (_) => initialFetch());
    ever(discType, (_) => initialFetch());
    ever(sort, (_) => initialFetch());
    ever(tags, (_) => initialFetch());
    ever(artists, (_) => initialFetch());
    super.onInit();
  }

  @override
  void onShow() {
    print('FavoriteAlbumController onShow - page became visible');
    // Force refresh by resetting pagination flag and fetching new data
    noFetchMore.value = false;
    // Fetch fresh data from server
    fetchApi().then((newResults) {
      // Update results list
      results.clear();
      results.addAll(newResults);
      print('FavoriteAlbumController refreshed with ${newResults.length} items');
    }).catchError((error) {
      print('Error refreshing favorite albums: $error');
    });
  }

  @override
  void onReady() {
    // Refresh data every time the page becomes visible/ready
    print('FavoriteAlbumController onReady - refreshing data');
    // Reset pagination and refresh
    noFetchMore.value = false;
    fetchApi().then((newResults) {
      results.clear();
      results.addAll(newResults);
      print('FavoriteAlbumController ready refresh with ${newResults.length} items');
    }).catchError((error) {
      print('Error in onReady: $error');
    });
    super.onReady();
  }

  @override
  Future<List<AlbumUserModel>> fetchApi({int? start}) => userRepository!
      .getAlbums(authService!.currentUser().id!.toInt(),
          query: query.string,
          start: (start == null) ? 0 : start,
          maxResults: maxResults,
          discType: discType.string,
          purchaseStatuses: purchaseStatuses.string,
          sort: sort.string,
          lang: SharedPreferenceService.lang,
          artistIds: artists.toList().map((e) => e.id).join(','),
          tagIds: tags.toList().map((e) => e.id).join(','))
      .catchError((error) {
        super.onError(error);
        return <AlbumUserModel>[];
      });
}
