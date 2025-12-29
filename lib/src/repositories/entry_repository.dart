import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/repositories/base_repository.dart';

class EntryRepository extends RestApiRepository {
  EntryRepository({required super.httpService});

  /// Find entries
  Future<List<EntryModel>> findEntries(
      {String lang = 'Default',
      String? query,
      String? entryType,
      String? sort,
      String? tagIds,
      String nameMatchMode = 'Auto'}) async {
    final String endpoint = '/api/entries';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (entryType != null && entryType.isNotEmpty) params['entryTypes'] = entryType;
    params['fields'] = 'MainPicture';
    params['languagePreference'] = lang;
    if (tagIds != null && tagIds.isNotEmpty) params['tagId'] = tagIds;
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    params['nameMatchMode'] = nameMatchMode;
    return super
        .getList(endpoint, params)
        .then((items) => EntryModel.jsonToList(items));
  }
}
