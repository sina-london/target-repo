import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shonenx/core/anilist/graphql_client.dart';
import 'package:shonenx/core/anilist/queries.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/core/models/anilist/anilist_favorites.dart';
import 'package:shonenx/core/utils/app_logger.dart';

/// Custom exception for Anilist service errors
class AnilistServiceException implements Exception {
  final String message;
  final dynamic error;

  AnilistServiceException(this.message, [this.error]);

  @override
  String toString() =>
      'AnilistServiceException: $message${error != null ? ' ($error)' : ''}';
}

/// Service class for interacting with the AniList GraphQL API
class AnilistService {
  static const _validStatuses = {
    'CURRENT',
    'COMPLETED',
    'PAUSED',
    'DROPPED',
    'PLANNING',
    'REPEATING',
  };

  /// Executes a GraphQL operation (query or mutation)
  Future<T?> _executeGraphQLOperation<T>({
    required String? accessToken,
    required String query,
    Map<String, dynamic>? variables,
    bool isMutation = false,
    String operationName = '',
  }) async {
    try {
      AppLogger.d('Executing $operationName with variables: $variables');
      final client = AnilistClient.getClient(accessToken: accessToken);
      final options = isMutation
          ? MutationOptions(
              document: gql(query),
              variables: variables ?? {},
              fetchPolicy: FetchPolicy.networkOnly,
            )
          : QueryOptions(
              document: gql(query),
              variables: variables ?? {},
              fetchPolicy: FetchPolicy.cacheAndNetwork,
            );

      final result = isMutation
          ? await client.mutate(options as MutationOptions)
          : await client.query(options as QueryOptions);

      if (result.hasException) {
        AppLogger.e('GraphQL Error in $operationName',
            result.exception, StackTrace.current);
        throw AnilistServiceException(
            'GraphQL operation failed', result.exception);
      }

      AppLogger.d('$operationName completed successfully');
      return result.data as T?;
    } catch (e, stackTrace) {
      AppLogger.e('Operation $operationName failed', e, stackTrace);
      throw AnilistServiceException('Failed to execute $operationName', e);
    }
  }

  /// Converts dynamic media list to typed Media list
  List<Media> _parseMediaList(List<dynamic>? media) =>
      media?.map((json) => Media.fromJson(json)).toList() ?? [];

  /// Search for anime by title
  Future<List<Media>> searchAnime(String title) async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.searchAnimeQuery,
      variables: {'search': title},
      operationName: 'SearchAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch user profile data
  Future<Map<String, dynamic>> getUserProfile(String accessToken) async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: AnilistQueries.userProfileQuery,
      operationName: 'GetUserProfile',
    );
    return data?['Viewer'] ?? {};
  }

  /// Fetch user anime list by status
  Future<MediaListCollection> getUserAnimeList({
    required String accessToken,
    required String userId,
    required String type,
    required String status,
  }) async {
    if (accessToken.isEmpty) {
      AppLogger.w('Empty accessToken for GetUserAnimeList');
      return MediaListCollection(lists: []);
    }

    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: AnilistQueries.userAnimeListQuery,
      variables: {'userId': userId, 'status': status, 'type': type},
      operationName: 'GetUserAnimeList',
    );

    return data != null
        ? MediaListCollection.fromJson(data)
        : MediaListCollection(lists: []);
  }

  /// Fetch trending anime
  Future<List<Media>> getTrendingAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.trendingAnimeQuery,
      operationName: 'GetTrendingAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch popular anime
  Future<List<Media>> getPopularAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.popularAnimeQuery,
      operationName: 'GetPopularAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch recently updated anime
  Future<List<Media>> getRecentlyUpdatedAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.recentlyUpdatedAnimeQuery,
      operationName: 'GetRecentlyUpdatedAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch top-rated anime
  Future<List<Media>> getTopRatedAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.topRatedAnimeQuery,
      operationName: 'GetTopRatedAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch most favorited anime
  Future<List<Media>> getMostFavoriteAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.mostFavoritedAnimeQuery,
      operationName: 'GetMostFavoriteAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch most watched anime
  Future<List<Media>> getMostWatchedAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.mostWatchedAnimeQuery,
      operationName: 'GetMostWatchedAnime',
    );
    return _parseMediaList(data?['Page']?['media']);
  }

  /// Fetch upcoming anime
  Future<List<Map<String, dynamic>>> getUpcomingAnime() async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.upcomingAnimeQuery,
      operationName: 'GetUpcomingAnime',
    );
    return (data?['Page']?['media'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];
  }

  /// Fetch detailed anime information
  Future<Media> getAnimeDetails(int animeId) async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: null,
      query: AnilistQueries.animeDetailsQuery,
      variables: {'id': animeId},
      operationName: 'GetAnimeDetails',
    );
    return data?['Media'] != null ? Media.fromJson(data!['Media']) : Media();
  }

  /// Fetch user's favorite anime
  Future<AnilistFavorites?> getFavorites({
    required int? userId,
    required String? accessToken,
  }) async {
    if (userId == null || accessToken == null || accessToken.isEmpty) {
      AppLogger.w('Invalid input: userId or accessToken is null/empty for GetFavorites');
      return null;
    }

    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: AnilistQueries.userFavoritesQuery,
      variables: {'userId': userId},
      operationName: 'GetFavorites',
    );

    return data != null
        ? AnilistFavorites(
            anime: _parseMediaList(
                data['User']?['favourites']?['anime']?['nodes']),
          )
        : null;
  }

  /// Toggle anime as favorite
  Future<List<Media>> toggleFavorite({
    required int animeId,
    required String? accessToken,
  }) async {
    if (accessToken == null || accessToken.isEmpty) {
      AppLogger.w('Invalid accessToken for ToggleFavorite');
      return [];
    }

    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: AnilistQueries.toggleFavoriteQuery,
      variables: {'animeId': animeId},
      isMutation: true,
      operationName: 'ToggleFavorite',
    );

    return _parseMediaList(data?['ToggleFavourite']?['anime']?['nodes']);
  }

  /// Save media progress
  Future<void> saveMediaProgress({
    required int mediaId,
    required String accessToken,
    required int episodeNumber,
  }) async {
    await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: AnilistQueries.saveMediaProgressQuery,
      variables: {'mediaId': mediaId, 'progress': episodeNumber},
      isMutation: true,
      operationName: 'SaveMediaProgress',
    );
  }

  /// Check if an anime is favorited
  Future<bool> isAnimeFavorite({
    required int animeId,
    required String accessToken,
  }) async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: AnilistQueries.isAnimeFavoriteQuery,
      variables: {'animeId': animeId},
      operationName: 'IsAnimeFavorite',
    );
    return data?['Media']?['isFavourite'] as bool? ?? false;
  }

  /// Update the status of an anime in the user's list
  Future<void> updateAnimeStatus({
    required int mediaId,
    required String accessToken,
    required String newStatus,
  }) async {
    final validatedStatus = validateMediaListStatus(newStatus);
    if (validatedStatus == 'INVALID') {
      AppLogger.w('Invalid MediaListStatus: $newStatus for UpdateAnimeStatus');
      throw AnilistServiceException('Invalid MediaListStatus: $newStatus');
    }

    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: '''
        mutation UpdateAnimeStatus(\$mediaId: Int!, \$status: MediaListStatus!) {
          SaveMediaListEntry(mediaId: \$mediaId, status: \$status, progress: 0) {
            id
            mediaId
            status
            progress
            score
          }
        }
      ''',
      variables: {'mediaId': mediaId, 'status': validatedStatus},
      isMutation: true,
      operationName: 'UpdateAnimeStatus',
    );

    if (data?['SaveMediaListEntry'] == null) {
      AppLogger.e('Failed to update anime status for mediaId: $mediaId');
      throw AnilistServiceException('Failed to update anime status');
    }
  }

  /// Remove an anime from the user's list
  Future<void> deleteAnimeEntry({
    required int entryId,
    required String accessToken,
  }) async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: '''
        mutation DeleteMediaListEntry(\$id: Int!) {
          DeleteMediaListEntry(id: \$id) {
            deleted
          }
        }
      ''',
      variables: {'id': entryId},
      isMutation: true,
      operationName: 'DeleteAnimeEntry',
    );

    if (data?['DeleteMediaListEntry']?['deleted'] != true) {
      AppLogger.e('Failed to delete anime entry with id: $entryId');
      throw AnilistServiceException('Failed to delete anime entry');
    }
  }

  /// Fetch the current status of an anime for a user
  Future<Map<String, dynamic>?> getAnimeStatus({
    required String accessToken,
    required int userId,
    required int animeId,
  }) async {
    final data = await _executeGraphQLOperation<Map<String, dynamic>>(
      accessToken: accessToken,
      query: '''
        query GetAnimeStatus(\$userId: Int!, \$animeId: Int!) {
          MediaList(userId: \$userId, mediaId: \$animeId) {
            id
            status
          }
        }
      ''',
      variables: {'userId': userId, 'animeId': animeId},
      operationName: 'GetAnimeStatus',
    );
    return data?['MediaList'] as Map<String, dynamic>?;
  }

  /// Validate and convert status to a valid MediaListStatus value
  String validateMediaListStatus(String status) {
    final upperStatus = status.toUpperCase();
    if (!_validStatuses.contains(upperStatus)) {
      AppLogger.w('Invalid MediaListStatus: $status. Valid values: $_validStatuses');
      return 'INVALID';
    }
    return upperStatus;
  }
}