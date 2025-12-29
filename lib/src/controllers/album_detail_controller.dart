import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class AlbumDetailController extends GetxController {
  final collected = false.obs;

  final initialLoading = true.obs;

  final album = AlbumModel().obs;

  final comments = <CommentModel>[].obs;

  final AlbumRepository albumRepository;

  final UserRepository? userRepository;

  final AuthService? authService;

  AlbumDetailController(
      {required this.albumRepository, this.authService, this.userRepository});

  @override
  void onInit() {
    initArgs();
    fetchApis();
    checkAlbumCollectionStatus();
    super.onInit();
  }

  void initArgs() {
    AlbumDetailArgs args = Get.arguments;

    if (args.album != null) {
      album(args.album);
    } else {
      album(AlbumModel(id: args.id));
    }
  }

  Future<dynamic> fetchApis() async {
    await albumRepository
        .getById(album().id!, lang: SharedPreferenceService.lang)
        .then(album.call)
        .then(initialLoadingDone);
    
    // Fetch comments after album data loads
    albumRepository
        .getComments(album().id!)
        .then((allComments) {
          // Sort by date, most recent first
          allComments.sort((a, b) {
            DateTime dateA = DateTime.now();
            DateTime dateB = DateTime.now();
            
            try {
              if (a.created != null) {
                dateA = a.created is DateTime ? a.created as DateTime : DateTime.parse(a.created.toString());
              }
            } catch (e) {
              dateA = DateTime.now();
            }
            
            try {
              if (b.created != null) {
                dateB = b.created is DateTime ? b.created as DateTime : DateTime.parse(b.created.toString());
              }
            } catch (e) {
              dateB = DateTime.now();
            }
            
            return dateB.compareTo(dateA);
          });
          
          return allComments.take(5).toList();
        })
        .then(comments.call);
  }

  void checkAlbumCollectionStatus() {
    int? userId = authService?.currentUser().id;

    if (userId == null) {
      print('User not logged in, cannot check album collection status');
      return;
    }

    userRepository!
        .getAlbumCollectionStatus(album().id!)
        .then((albumUser) {
          // Album is in collection if purchaseStatus is not "Nothing"
          collected.value = albumUser.purchaseStatus != 'Nothing' && albumUser.purchaseStatus != null;
          print('Album collection status: ${albumUser.purchaseStatus}');
        })
        .catchError((error) {
          print('Error checking album collection status: $error');
          // If error (e.g., 404), it means album is not in collection
          collected(false);
        });
  }

  Future<void> updateAlbumCollection() async {
    int? userId = authService?.currentUser().id;

    if (userId == null) {
      print('Cannot update album collection: user not logged in');
      return;
    }

    try {
      final newStatus = collected.value ? 'Nothing' : 'Owned';
      await userRepository!.updateAlbumCollection(
        album().id!,
        collectionStatus: newStatus,
      );
      
      print('Album collection status updated to: $newStatus');
      collected(!collected.value);
      
      // Trigger refresh of favorite albums if controller exists
      try {
        final favoriteController = Get.find<FavoriteAlbumController>();
        await favoriteController.fetchApi();
      } catch (e) {
        print('FavoriteAlbumController not found, skipping refresh');
      }
    } catch (err) {
      print('Error updating album collection: $err');
      // Revert the UI change on error
      collected(!collected.value);
    }
  }

  bool initialLoadingDone(_) => initialLoading(false);
}
