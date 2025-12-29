import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class ArtistDetailController extends GetxController {
  final liked = false.obs;

  final initialLoading = true.obs;

  final artist = ArtistModel().obs;

  final comments = <CommentModel>[].obs;

  final ArtistRepository artistRepository;

  final UserRepository? userRepository;

  final AuthService? authService;

  ArtistDetailController(
      {required this.artistRepository, this.authService, this.userRepository});

  @override
  void onInit() {
    initArgs();
    // Load follow status before fetching other data
    checkFollowArtistStatus();
    fetchApis();
    super.onInit();
  }

  void initArgs() {
    ArtistDetailArgs args = Get.arguments;

    if (args.artist != null) {
      artist(args.artist);
    } else {
      artist(ArtistModel(id: args.id));
    }
  }

  Future<dynamic> fetchApis() async {
    await artistRepository
        .getById(artist().id!, lang: SharedPreferenceService.lang)
        .then(artist.call)
        .then(initialLoadingDone);
    
    // Fetch comments after artist data loads
    artistRepository
        .getComments(artist().id!)
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

  void checkFollowArtistStatus() {
    int? userId = authService?.currentUser().id;

    if (userId == null) {
      print('User not logged in, cannot check artist follow status');
      // Reset liked state when not logged in to clear any previous local toggles
      liked.value = false;
      return;
    }

    print('Checking user artist follow status for artist: ${artist().id}');
    userRepository
        ?.getCurrentUserFollowedArtist(artist().id!)
        .then((value) {
          print('Follow status fetched: $value');
          final isFollowed = (value != null);
          liked.value = isFollowed;
          print('Artist liked state set to: $isFollowed');
          // Set up debounce after the initial value is loaded
          debounce(liked, (_) => updateFollowArtist(), time: Duration(seconds: 1));
        })
        .catchError((error) {
          print('Error checking follow status: $error');
          // Reset to false on error to ensure clean state
          liked.value = false;
          // Don't set up debounce if there's an error
        });
  }

  Future<void> updateFollowArtist() async {
    print('Updating follow status for artist: ${artist().id}, liked: ${liked.value}');
    
    try {
      if (liked.value) {
        // Like the artist - call both endpoints
        await userRepository?.addArtistForUser(artist().id!);
        print('Artist added for user');
        await userRepository?.updateArtistSubscription(artist().id!);
        print('Artist subscription updated');
      } else {
        // Unlike the artist
        await userRepository?.removeArtistFromUser(artist().id!);
        print('Artist removed from user');
      }
      
      // Try to update favorite artists list if the controller exists
      try {
        final controller = Get.find<FavoriteArtistController>();
        await controller.fetchApi();
        print('FavoriteArtistController refreshed');
      } catch (e) {
        print('FavoriteArtistController not found (user not on that page), ignoring refresh');
      }
    } catch (err) {
      print('Error updating follow status on server: $err');
      // Revert the state if the API call failed
      liked.toggle();
    }
  }

  bool initialLoadingDone(_) => initialLoading(false);
}
