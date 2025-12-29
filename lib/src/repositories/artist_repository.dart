import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/repositories/base_repository.dart';

class ArtistRepository extends RestApiRepository {
  ArtistRepository({required super.httpService});

  /// Find artists
  Future<List<ArtistModel>> findArtists(
      {String lang = 'Default',
      String? query,
      String? artistType,
      String? sort,
      String? tagIds,
      int start = 0,
      int maxResults = 50,
      String nameMatchMode = 'Auto'}) async {
    final String endpoint = '/api/artists';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (artistType != null && artistType.isNotEmpty) params['artistTypes'] = artistType;
    params['fields'] = 'MainPicture';
    params['languagePreference'] = lang;
    if (tagIds != null && tagIds.isNotEmpty) params['tagId'] = tagIds;
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    params['start'] = start.toString();
    params['maxResults'] = maxResults.toString();
    params['nameMatchMode'] = nameMatchMode;
    return super
        .getList(endpoint, params)
        .then((items) => ArtistModel.jsonToList(items));
  }

  /// Gets a artist by Id.
  Future<ArtistModel> getById(int id, {String lang = 'Default'}) {
    final Map<String, String> params = {
      'fields':
          'Tags,MainPicture,WebLinks,BaseVoicebank,Description,ArtistLinks,ArtistLinksReverse,AdditionalNames',
      'relations': 'All',
      'lang': lang,
    };
    return super
        .getObject('/api/artists/$id', params)
        .then((i) => ArtistModel.fromJson(i));
  }

  Future<List<ArtistModel>> getTopArtistsByTagId(int tagId,
      {String lang = 'Default'}) async {
    return findArtists(lang: lang, tagIds: tagId.toString(), sort: 'RatingScore');
  }

  Future<List<CommentModel>> getComments(int artistId) async {
    final String endpoint = '/api/artists/$artistId/comments';
    return super
        .getList(endpoint, {})
        .then((items) => CommentModel.jsonToList(items));
  }
}
