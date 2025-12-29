import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/repositories/base_repository.dart';

class TagRepository extends RestApiRepository {
  TagRepository({required super.httpService});

  /// Find tags
  Future<List<TagModel>> findTags(
      {String lang = 'Default',
      String? query,
      String? categoryName,
      int start = 0,
      int maxResults = 50,
      String nameMatchMode = 'Auto'}) async {
    final String endpoint = '/api/tags';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    params['fields'] = 'MainPicture';
    if (categoryName != null && categoryName.isNotEmpty) params['categoryName'] = categoryName;
    params['lang'] = lang;
    params['start'] = start.toString();
    params['maxResults'] = maxResults.toString();
    params['nameMatchMode'] = nameMatchMode;
    return super
        .getList(endpoint, params)
        .then((items) => TagModel.jsonToList(items));
  }

  /// Gets a tag by Id.
  Future<TagModel> getById(int id, {String lang = 'Default'}) {
    final Map<String, String> params = {};
    params['fields'] =
        'MainPicture,AdditionalNames,Description,Parent,RelatedTags,WebLinks';
    params['lang'] = lang;
    return super
        .getObject('/api/tags/$id', params)
        .then((i) => TagModel.fromJson(i));
  }
}
