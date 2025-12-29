import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/repositories/base_repository.dart';

class AlbumRepository extends RestApiRepository {
  AlbumRepository({required super.httpService});

  /// Find albums
  Future<List<AlbumModel>> findAlbums(
      {String lang = 'Default',
      String? query,
      String? discType,
      String? sort,
      String? artistIds,
      String? tagIds,
      int start = 0,
      int maxResults = 50,
      String nameMatchMode = 'Auto'}) async {
    final String endpoint = '/api/albums';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (discType != null && discType.isNotEmpty) params['discTypes'] = discType;
    params['fields'] = 'MainPicture';
    params['lang'] = lang;
    if (tagIds != null && tagIds.isNotEmpty) params['tagId'] = tagIds;
    if (artistIds != null && artistIds.isNotEmpty) params['artistId'] = artistIds;
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    params['start'] = start.toString();
    params['maxResults'] = maxResults.toString();
    params['nameMatchMode'] = nameMatchMode;
    return super
        .getList(endpoint, params)
        .then((items) => AlbumModel.jsonToList(items));
  }

  /// Gets a album by Id.
  Future<AlbumModel> getById(int id, {String lang = 'Default'}) {
    final Map<String, String> params = {};
    params['fields'] =
        'Tags,MainPicture,Tracks,AdditionalNames,Artists,Description,WebLinks,PVs';
    params['songFields'] = 'MainPicture,PVs,ThumbUrl';
    params['lang'] = lang;
    return super
        .getObject('/api/albums/$id', params)
        .then((i) => AlbumModel.fromJson(i));
  }

  /// Gets list of upcoming or recent albums, same as front page.
  Future<List<AlbumModel>> getNew({String lang = 'Default'}) async {
    final String endpoint = '/api/albums/new';
    final Map<String, String> params = {};
    params['fields'] = 'MainPicture';
    params['languagePreference'] = lang;
    return super
        .getList(endpoint, params)
        .then((items) => AlbumModel.jsonToList(items));
  }

  /// Gets list of top rated albums, same as front page.
  Future<List<AlbumModel>> getTop({String lang = 'Default'}) async {
    final String endpoint = '/api/albums/top';
    final Map<String, String> params = {};
    params['fields'] = 'MainPicture';
    params['languagePreference'] = lang;
    return super
        .getList(endpoint, params)
        .then((items) => AlbumModel.jsonToList(items));
  }

  Future<List<AlbumModel>> getTopAlbumsByTagId(int tagId,
      {String lang = 'Default'}) async {
    return findAlbums(lang: lang, tagIds: tagId.toString(), sort: 'RatingScore');
  }

  Future<List<CommentModel>> getComments(int albumId) async {
    final String endpoint = '/api/albums/$albumId/comments';
    return super
        .getList(endpoint, {})
        .then((items) => CommentModel.jsonToList(items));
  }
}
