import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shonenx/data/hive/models/anime_watch_progress_model.dart';

final animeWatchProgressProvider = NotifierProvider<AnimeWatchProgressNotifier,
    Map<int, AnimeWatchProgressEntry>>(
  AnimeWatchProgressNotifier.new,
);

// Enum for filter options
enum AnimeFilter {
  all,
  completed,
  inProgress,
  recentlyUpdated,
}

// Enum for view mode
enum ViewMode {
  grouped,
  ungrouped,
}

final animeFilterProvider =
    StateProvider<AnimeFilter>((ref) => AnimeFilter.all);
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.grouped);

class AnimeWatchProgressNotifier
    extends Notifier<Map<int, AnimeWatchProgressEntry>> {
  static const _boxName = 'anime_watch_progress';

  late Box<AnimeWatchProgressEntry> _box;

  @override
  Map<int, AnimeWatchProgressEntry> build() {
    _box = Hive.box<AnimeWatchProgressEntry>(_boxName);

    // Return as a map with animeId as key
    return {
      for (var entry in _box.values) entry.animeId: entry,
    };
  }

  void updateEpisodeProgress({
    required int animeId,
    required EpisodeProgress episode,
    required AnimeWatchProgressEntry animeEntryBase,
  }) {
    final existing = state[animeId];

    final now = DateTime.now();

    final currentWatchedAt = episode.watchedAt ??
        existing?.episodesProgress[episode.episodeNumber]?.watchedAt;

    final updatedEpisode = episode.copyWith(
      watchedAt:
          episode.progressInSeconds != null && episode.progressInSeconds! > 0
              ? now
              : currentWatchedAt,
    );

    final updatedEntry = (existing ?? animeEntryBase).copyWith(
      episodesProgress: {
        ...?existing?.episodesProgress,
        episode.episodeNumber: updatedEpisode,
      },
      lastUpdated: now,
    );

    _box.put(animeId, updatedEntry);
    state = {
      ...state,
      animeId: updatedEntry,
    };
  }

  void markEpisodeCompleted({
    required int animeId,
    required int episodeNumber,
  }) {
    final existing = state[animeId];
    if (existing == null) return;

    final currentEp = existing.episodesProgress[episodeNumber];
    if (currentEp == null) return;

    final updatedEp = currentEp.copyWith(
      isCompleted: true,
      watchedAt: DateTime.now(),
      progressInSeconds: currentEp.durationInSeconds,
    );

    updateEpisodeProgress(
      animeId: animeId,
      episode: updatedEp,
      animeEntryBase: existing,
    );
  }

  void removeAnime(int animeId) {
    _box.delete(animeId);
    final newState = {...state}..remove(animeId);
    state = newState;
  }

  List<({AnimeWatchProgressEntry anime, EpisodeProgress episode})>
      getAllMostRecentWatchedEpisodesWithAnime() {
    final allWatchedEpisodesWithAnime = state.values.expand((entry) {
      return entry.episodesProgress.values
          .where((episode) => episode.watchedAt != null)
          .map((episode) => (anime: entry, episode: episode));
    }).toList();

    allWatchedEpisodesWithAnime.sort(
      (a, b) => b.episode.watchedAt!.compareTo(a.episode.watchedAt!),
    );

    return allWatchedEpisodesWithAnime;
  }

  EpisodeProgress? getMostRecentEpisodeProgressByAnimeId(int animeId) {
    final entry = state[animeId];
    if (entry == null) return null;

    final watchedEpisodes = entry.episodesProgress.values
        .where((episode) => episode.watchedAt != null)
        .toList();

    if (watchedEpisodes.isEmpty) return null;

    watchedEpisodes.sort((a, b) => b.watchedAt!.compareTo(a.watchedAt!));
    return watchedEpisodes.first;
  }

  List<EpisodeProgress> getAllCompletedEpisodes() {
    return state.values
        .expand((entry) => entry.episodesProgress.values)
        .where((episode) => episode.isCompleted)
        .toList();
  }

  List<EpisodeProgress> getAllMostRecentWatchedEpisodes() {
    return state.values
        .expand((entry) => entry.episodesProgress.values)
        .where((episode) => episode.watchedAt != null)
        .toList();
  }

  List<EpisodeProgress> getAllProgressByAnimeId(int animeId) {
    final entry = state[animeId];
    if (entry == null) return [];
    return entry.episodesProgress.values.toList();
  }

  List<AnimeWatchProgressEntry> getAllEntries() => _box.values.toList();

  // Get filtered anime entries
  List<AnimeWatchProgressEntry> getFilteredEntries(AnimeFilter filter) {
    final entries = _box.values.toList();
    switch (filter) {
      case AnimeFilter.all:
        return entries;
      case AnimeFilter.completed:
        return entries
            .where((entry) =>
                entry.episodesProgress.entries.length == entry.totalEpisodes)
            .toList();
      case AnimeFilter.inProgress:
        return entries
            .where((entry) =>
                entry.episodesProgress.entries.length < entry.totalEpisodes)
            .toList();
      case AnimeFilter.recentlyUpdated:
        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        return entries
            .where((entry) =>
                entry.lastUpdated != null &&
                entry.lastUpdated!.isAfter(sevenDaysAgo))
            .toList();
    }
  }

  // New method for ungrouped mode: Get filtered episodes
  List<({AnimeWatchProgressEntry anime, EpisodeProgress episode})>
      getFilteredEpisodes(AnimeFilter filter) {
    final filteredEntries = getFilteredEntries(filter);
    final episodes = filteredEntries.expand((entry) {
      return entry.episodesProgress.entries
          .where((e) => e.value.watchedAt != null)
          .map((e) => (anime: entry, episode: e.value));
    }).toList();

    // Sort by watchedAt (most recent first)
    episodes
        .sort((a, b) => b.episode.watchedAt!.compareTo(a.episode.watchedAt!));
    return episodes;
  }

  void removeEpisodeProgress(int animeId, int episodeNumber) {
    final entry = state[animeId];
    if (entry == null) return;

    final updatedEpisodes = {...entry.episodesProgress}..remove(episodeNumber);
    final updatedEntry = entry.copyWith(
      episodesProgress: updatedEpisodes,
      lastUpdated: DateTime.now(),
    );

    _box.put(animeId, updatedEntry);
    state = {
      ...state,
      animeId: updatedEntry,
    };
  }

  void deleteAnimeProgress(int animeId) {
    _box.delete(animeId);
    final newState = {...state}..remove(animeId);
    state = newState;
  }

  void clearAllProgress() {
    _box.clear();
    state = {};
  }
}
