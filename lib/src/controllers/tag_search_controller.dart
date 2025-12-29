import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class TagSearchController extends SearchPageController<TagModel> {
  final category = ''.obs;

  final TagRepository tagRepository;

  TagSearchController({required this.tagRepository});

  @override
  void onInit() {
    initArgs();
    super.onInit();
  }

  void initArgs() {
    final TagSearchArgs args = Get.arguments;
    category(args.category);
  }

  @override
  Future<List<TagModel>> fetchApi({int? start}) => tagRepository
      .findTags(
          start: (start == null) ? 0 : start,
          lang: SharedPreferenceService.lang,
          maxResults: maxResults,
          query: query.string,
          categoryName: category.string)
      .catchError((error) {
        super.onError(error);
        return <TagModel>[];
      });
}
