import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shonenx/core/anilist/services/anilist_service.dart';
import 'package:shonenx/core/models/anime/page_model.dart';
import 'package:shonenx/core/repositories/anime_repository.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/data/hive/models/home_page_model.dart';
import 'package:shonenx/shared/providers/anime_repository_provider.dart';

class HomepageState {
  final HomePage? homePage;
  final DateTime lastUpdated;
  final bool isLoading;
  final String? error;

  HomepageState({
    this.homePage,
    required this.lastUpdated,
    this.isLoading = true,
    this.error,
  });

  HomepageState copyWith({
    HomePage? homePage,
    bool? isLoading,
    String? error,
  }) {
    return HomepageState(
      lastUpdated: DateTime.now(),
      homePage: homePage ?? this.homePage,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomepageNotifier extends Notifier<HomepageState> {
  AnimeRepository get _repo => ref.read(animeRepositoryProvider);
  static const _boxName = 'home_page';

  @override
  HomepageState build() {
    final box = Hive.box<HomePageModel>(_boxName);
    final homePage = box.get(0);
    return HomepageState(
      lastUpdated: homePage?.lastUpdated ?? DateTime.now(),
      homePage: homePage?.toHomePage(),
      isLoading: false,
    );
  }

  Future<HomepageState> initialize() {
    if (state.homePage != null &&
        state.homePage!.trendingAnime.isNotEmpty &&
        state.homePage!.popularAnime.isNotEmpty &&
        state.homePage!.mostFavoriteAnime.isNotEmpty &&
        state.lastUpdated.isAfter(
          DateTime.now().subtract(
            const Duration(hours: 6),
          ),
        )) {
      AppLogger.d('Using cached homepage data, last updated: ${state.lastUpdated}');
      return Future.value(state);
    }

    return fetchHomePage();
  }

  Future<HomepageState> fetchHomePage() async {
    try {
      AppLogger.d('Fetching homepage data from AnilistService');
      final trending = await _repo.getTrendingAnime();
      final popular = await _repo.getPopularAnime();
      // final recentlyUpdated = await anilistService.getRecentlyUpdatedAnime();
      // final topRated = await anilistService.getTopRatedAnime();
      final mostFavorite = await _repo.getTopRatedAnime();
      // final mostWatched = await anilistService.getMostWatchedAnime();
      final homePageData = HomePage(
        trendingAnime: trending,
        popularAnime: popular,
        recentlyUpdated: [],
        topRatedAnime: [],
        mostFavoriteAnime: mostFavorite,
        mostWatchedAnime: [],
      );

      AppLogger.d('Successfully fetched homepage data');
      updateHomePage(homePageData);
      return state;
    } catch (err, stackTrace) {
      AppLogger.e('Error fetching homepage data', err, stackTrace);
      return state.copyWith(error: err.toString(), isLoading: false);
    }
  }

  void updateHomePage(HomePage homePage) {
    AppLogger.d('Updating homepage data in Hive');
    state = state.copyWith(homePage: homePage, isLoading: false);
    Hive.box<HomePageModel>(_boxName).put(
      0,
      HomePageModel.fromHomePage(homePage),
    );
  }
}

final homepageProvider = NotifierProvider<HomepageNotifier, HomepageState>(
  HomepageNotifier.new,
);