import 'package:get/get.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/src/arguments/comments_args.dart';

class CommentsController extends GetxController {
  final allComments = <CommentModel>[].obs;
  final displayedComments = <CommentModel>[].obs;
  final isLoading = false.obs;
  final hasMore = true.obs;

  late String entityType;
  late int entityId;
  late String entityName;

  static const int ITEMS_PER_PAGE = 25;
  int currentPage = 0;

  final SongRepository? songRepository;

  final AlbumRepository? albumRepository;

  final ArtistRepository? artistRepository;

  CommentsController(
      {this.songRepository, this.albumRepository, this.artistRepository});

  @override
  void onInit() {
    CommentsArgs args = Get.arguments;
    entityType = args.entityType;
    entityId = args.entityId;
    entityName = args.entityName;
    
    fetchAllComments();
    super.onInit();
  }

  Future<void> fetchAllComments() async {
    isLoading(true);
    try {
      List<CommentModel> fetchedComments = [];
      
      if (entityType == 'song') {
        fetchedComments = await songRepository?.getComments(entityId) ?? [];
      } else if (entityType == 'album') {
        fetchedComments = await albumRepository?.getComments(entityId) ?? [];
      } else if (entityType == 'artist') {
        fetchedComments = await artistRepository?.getComments(entityId) ?? [];
      }
      
      // Sort comments by date, most recent first
      fetchedComments.sort((a, b) {
        // Parse the date strings if they're ISO 8601 format
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
      
      allComments.assignAll(fetchedComments);
      currentPage = 0;
      loadMoreComments();
    } catch (e) {
      print('Error loading comments: $e');
    } finally {
      isLoading(false);
    }
  }

  void loadMoreComments() {
    if (!hasMore.value) return;

    int startIndex = currentPage * ITEMS_PER_PAGE;
    int endIndex = startIndex + ITEMS_PER_PAGE;

    if (startIndex >= allComments.length) {
      hasMore(false);
      return;
    }

    if (endIndex > allComments.length) {
      endIndex = allComments.length;
      hasMore(false);
    } else {
      hasMore(true);
    }

    List<CommentModel> newBatch = allComments.sublist(startIndex, endIndex);
    displayedComments.addAll(newBatch);
    currentPage++;
  }

  void onReachEndScroll() {
    if (hasMore.value && !isLoading.value) {
      loadMoreComments();
    }
  }
}
