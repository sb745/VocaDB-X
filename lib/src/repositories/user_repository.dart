import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/src/repositories/base_repository.dart';

class UserRepository extends RestApiRepository {
  UserRepository({required super.httpService});

  /// Get a list of songs rated by user.
  Future<List<RatedSongModel>> getRatedSongs(int userId,
      {String lang = 'Default',
      String? query,
      String? rating,
      String? sort,
      String? artistIds,
      String? tagIds,
      bool groupByRating = false,
      String nameMatchMode = 'Auto',
      int start = 0,
      int maxResults = 50}) async {
    final String endpoint = '/api/users/$userId/ratedSongs';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    params['fields'] = 'ThumbUrl,PVs,MainPicture';
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (rating != null && rating.isNotEmpty) params['rating'] = rating;
    params['groupByRating'] = groupByRating.toString();
    if (artistIds != null && artistIds.isNotEmpty) params['artistId'] = artistIds;
    if (tagIds != null && tagIds.isNotEmpty) params['tagId'] = tagIds;
    params['nameMatchMode'] = nameMatchMode;
    params['lang'] = lang;
    params['start'] = start.toString();
    params['maxResults'] = maxResults.toString();
    return super
        .getList(endpoint, params)
        .then((items) => RatedSongModel.jsonToList(items));
  }

  /// Gets a list of artists followed by a user
  Future<List<FollowedArtistModel>> getFollowedArtists(int userId,
      {String lang = 'Default',
      String? query,
      String? artistType,
      String? tagIds,
      String nameMatchMode = 'Auto',
      int start = 0,
      int maxResults = 50}) async {
    final String endpoint = '/api/users/$userId/followedArtists';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (artistType != null && artistType.isNotEmpty) params['artistType'] = artistType;
    params['fields'] = 'MainPicture';
    params['lang'] = lang;
    if (tagIds != null && tagIds.isNotEmpty) params['tagId'] = tagIds;
    params['start'] = start.toString();
    params['maxResults'] = maxResults.toString();
    params['nameMatchMode'] = nameMatchMode;
    return super
        .getList(endpoint, params)
        .then((items) => FollowedArtistModel.jsonToList(items));
  }

  /// Gets a list of albums in a user's collection.
  Future<List<AlbumUserModel>> getAlbums(int userId,
      {String lang = 'Default',
      String? query,
      String? discType,
      String? sort,
      String? purchaseStatuses,
      String? artistIds,
      String? tagIds,
      String nameMatchMode = 'Auto',
      int start = 0,
      int maxResults = 50}) async {
    final String endpoint = '/api/users/$userId/albums';
    final Map<String, String> params = {};
    if (query != null && query.isNotEmpty) params['query'] = query;
    if (discType != null && discType.isNotEmpty) params['albumTypes'] = discType;
    if (purchaseStatuses != null && purchaseStatuses.isNotEmpty) params['purchaseStatuses'] = purchaseStatuses;
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
        .then((items) => AlbumUserModel.jsonToList(items));
  }

  /// Gets currently logged in user's rating for a song
  Future<String> getCurrentUserRatedSong(int songId) {
    return httpService
        .get('/api/users/current/ratedSongs/$songId', {})
        .then((v) => v as String);
  }

  /// Gets a user's album collection status for a specific album
  Future<AlbumUserModel> getAlbumCollectionStatus(int albumId) {
    return httpService
        .get('/api/users/current/album-collection-statuses/$albumId', {})
        .then((obj) => AlbumUserModel.fromJson(obj));
  }

  /// Updates/adds an album to the user's collection
  /// collectionStatus: "Nothing" (remove), "Wishlisted", "Ordered", or "Owned" (default)
  Future<void> updateAlbumCollection(int albumId,
      {String collectionStatus = 'Owned', String? mediaType, int? rating}) {
    final Map<String, String> params = {};
    params['collectionStatus'] = collectionStatus;
    if (mediaType != null && mediaType.isNotEmpty) {
      params['mediaType'] = mediaType;
    }
    if (rating != null) {
      params['rating'] = rating.toString();
    }
    return httpService.post('/api/users/current/albums/$albumId', params);
  }

  /// Gets currently logged in user's follow status for an artist
  Future<FollowedArtistModel?> getCurrentUserFollowedArtist(int artistId) async {
    try {
      return await httpService
          .get('/api/users/current/followedArtists/$artistId', {})
          .then((obj) => FollowedArtistModel.fromJson(obj));
    } catch (e) {
      // If artist is not followed, the API might return an error
      // In this case, we return null to indicate not followed
      print('Artist not followed or error fetching follow status: $e');
      return null;
    }
  }

  /// Add an artist to the user's followed artists list
  Future<void> addArtistForUser(int artistId) {
    return httpService.post('/User/AddArtistForUser', {'artistId': artistId.toString()});
  }

  /// Update artist subscription settings
  /// emailNotifications: whether to receive email notifications
  /// siteNotifications: whether to receive site notifications
  Future<void> updateArtistSubscription(int artistId,
      {bool emailNotifications = false, bool siteNotifications = true}) {
    final Map<String, String> params = {};
    params['artistId'] = artistId.toString();
    params['emailNotifications'] = emailNotifications.toString();
    params['siteNotifications'] = siteNotifications.toString();
    return httpService.post('/User/UpdateArtistSubscription', params);
  }

  /// Remove an artist from the user's followed artists list
  Future<void> removeArtistFromUser(int artistId) {
    return httpService.post('/User/RemoveArtistFromUser', {'artistId': artistId.toString()});
  }
}
