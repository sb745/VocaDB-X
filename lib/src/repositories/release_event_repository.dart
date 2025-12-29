import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/repositories/base_repository.dart';

class ReleaseEventRepository extends RestApiRepository {
  ReleaseEventRepository({required super.httpService});

  Future<List<ReleaseEventModel>> findReleaseEvents(
      {String lang = 'Default',
      String? query,
      String? sort,
      String? category,
      String? afterDate,
      String? beforeDate,
      String? artistIds,
      String? tagIds,
      int start = 0,
      int maxResults = 50,
      String nameMatchMode = 'Auto'}) async {
    final String endpoint = '/api/releaseEvents';
    final Map<String, String> params = {};
    params['fields'] = 'MainPicture,Series';
    params['lang'] = lang;
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (tagIds != null && tagIds.isNotEmpty) params['tagId'] = tagIds;
    if (artistIds != null && artistIds.isNotEmpty) params['artistId'] = artistIds;
    if (afterDate != null && afterDate.isNotEmpty) params['afterDate'] = afterDate;
    if (beforeDate != null && beforeDate.isNotEmpty) params['beforeDate'] = beforeDate;
    params['start'] = start.toString();
    params['maxResults'] = maxResults.toString();
    params['nameMatchMode'] = nameMatchMode;
    return super
        .getList(endpoint, params)
        .then((items) => ReleaseEventModel.jsonToList(items));
  }

  /// Gets list of top rated albums, same as front page.
  Future<List<ReleaseEventModel>> getRecently({String lang = 'Default'}) async {
    return findReleaseEvents(
        lang: lang,
        sort: 'Date',
        afterDate: DateTime.now().subtract(Duration(days: 3)).toString(),
        beforeDate: DateTime.now().add(Duration(days: 12)).toString());
  }

  /// Gets an event by Id.
  Future<ReleaseEventModel> getById(int id, {String lang = 'Default'}) {
    final Map<String, String> params = {
      'fields':
          'Artists,MainPicture,AdditionalNames,Description,WebLinks,Series,Tags',
      'lang': lang,
    };
    return super
        .getObject('/api/releaseEvents/$id', params)
        .then((i) => ReleaseEventModel.fromJson(i));
  }

  /// Gets a list of albums for a specific event
  Future<List<AlbumModel>> getAlbums(int id, {String lang = 'Default'}) async {
    final Map<String, String> params = {};
    params['fields'] = ' MainPicture';
    params['lang'] = lang;
    return super
        .getList('/api/releaseEvents/$id/albums', params)
        .then((items) => AlbumModel.jsonToList(items));
  }

  /// Gets a list of songs for a specific event
  Future<List<SongModel>> getPublishedSongs(int id,
      {String lang = 'Default'}) async {
    final Map<String, String> params = {};
    params['fields'] = ' MainPicture,PVs,ThumbUrl';
    params['lang'] = lang;
    return super
        .getList('/api/releaseEvents/$id/published-songs', params)
        .then((items) => SongModel.jsonToList(items));
  }
}
