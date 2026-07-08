import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/core/anilist/services/anilist_service.dart';
import 'package:shonenx/data/hive/models/home_page_model.dart';

// Provider for AnilistService to enable dependency injection
final anilistServiceProvider =
    Provider<AnilistService>((ref) => AnilistService());

final homePageProvider = FutureProvider.autoDispose<HomePage>((ref) async {
  dev.log('Fetching home page data...', name: 'homePageProvider');
  final anilistService = ref.watch(anilistServiceProvider);

  Future<T> fetchWithRetry<T>(Future<T> Function() fetchFn,
      {int retries = 1}) async {
    int attempt = 0;
    while (true) {
      try {
        return await fetchFn();
      } catch (e) {
        if (attempt >= retries) rethrow;
        attempt++;
        dev.log('Retrying fetch: $e', name: 'homePageProvider');
      }
    }
  }

  try {
    final trending =
        await fetchWithRetry(() => anilistService.getTrendingAnime());
    final popular =
        await fetchWithRetry(() => anilistService.getPopularAnime());
    // final recentlyUpdated = await fetchWithRetry(() => anilistService.getRecentlyUpdatedAnime());
    // final topRated =
    //     await fetchWithRetry(() => anilistService.getTopRatedAnime());
    final mostFavorite =
        await fetchWithRetry(() => anilistService.getMostFavoriteAnime());
    // final mostWatched =
    //     await fetchWithRetry(() => anilistService.getMostWatchedAnime());

    final homePageData = HomePage(
      trendingAnime: trending,
      popularAnime: popular,
      recentlyUpdated: [],
      topRatedAnime: [],
      mostFavoriteAnime: mostFavorite,
      mostWatchedAnime: [],
      spotlight: [],
      featured: [],
    );

    dev.log('Home page data fetched successfully', name: 'homePageProvider');
    return homePageData;
  } catch (e, stackTrace) {
    dev.log('Failed to fetch home page data: $e',
        name: 'homePageProvider', error: e, stackTrace: stackTrace);
    throw Exception('Failed to load home page data: $e');
  }
});
