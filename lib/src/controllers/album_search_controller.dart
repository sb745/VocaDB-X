import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class AlbumSearchController extends SearchPageController<AlbumModel> {
  /// Filter parameter
  final discType = ''.obs;

  final sort = 'Name'.obs;

  final artists = <ArtistModel>[].obs;

  final tags = <TagModel>[].obs;

  final AlbumRepository albumRepository;

  AlbumSearchController({required this.albumRepository});

  @override
  void onInit() {
    ever(discType, (_) => initialFetch());
    ever(sort, (_) => initialFetch());
    ever(artists, (_) => initialFetch());
    ever(tags, (_) => initialFetch());
    super.onInit();
  }

  @override
  Future<List<AlbumModel>> fetchApi({int? start}) => albumRepository
      .findAlbums(
        start: (start == null) ? 0 : start,
        lang: SharedPreferenceService.lang,
        maxResults: maxResults,
        query: query.string,
        discType: discType.string,
        sort: sort.string,
        artistIds: artists.toList().map((e) => e.id).join(','),
        tagIds: tags.toList().map((e) => e.id).join(','),
      )
      .catchError((error, stackTrace) {
        super.onError(error);
        return <AlbumModel>[];
      });
}
