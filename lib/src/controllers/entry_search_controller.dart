import 'package:get/get.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class EntrySearchController extends SearchPageController<EntryModel> {
  /// Filter parameter
  final entryType = ''.obs;

  /// Filter parameter
  final sort = 'Name'.obs;

  /// Filter parameter
  final tags = <TagModel>[].obs;

  final EntryRepository entryRepository;

  @override
  final enableInitial = false;

  EntrySearchController({required this.entryRepository});

  @override
  void onInit() {
    ever(entryType, (_) => fetchApi());
    ever(sort, (_) => fetchApi());
    ever(tags, (_) => fetchApi());
    super.onInit();
  }

  @override
  Future<List<EntryModel>> fetchApi({int? start}) => entryRepository
      .findEntries(
          query: query.string,
          entryType: entryType.string,
          lang: SharedPreferenceService.lang,
          sort: sort.string,
          tagIds: tags.toList().map((e) => e.id).join(','))
      .catchError((error) {
        super.onError(error);
        return <EntryModel>[];
      });
}
