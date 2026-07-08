import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart'
    as anilist_media;
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/data/hive/models/anime_watch_progress_model.dart';
import 'package:shonenx/data/hive/providers/anime_watch_progress_provider.dart';
import 'package:shonenx/data/hive/providers/player_provider.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/services/thumbnail_service.dart';

/// Service responsible for managing watch progress
class WatchProgressService {
  final ThumbnailService _thumbnailService = ThumbnailService();
  Timer? _saveProgressTimer;
  static const Duration _progressSaveInterval = Duration(seconds: 10);

  /// Start the progress saving timer
  void startProgressTimer(VoidCallback saveCallback) {
    AppLogger.d(
        'Starting progress save timer with interval ${_progressSaveInterval.inSeconds}s');
    _saveProgressTimer?.cancel();
    _saveProgressTimer = Timer.periodic(_progressSaveInterval, (_) {
      saveCallback();
    });
  }

  /// Stop the progress saving timer
  void stopProgressTimer() {
    AppLogger.d('Stopping progress save timer');
    _saveProgressTimer?.cancel();
  }

  /// Check if progress should be saved based on current state
  bool shouldSaveProgress(WatchState watchState, PlayerState playerState) {
    final hasValidEpisode = watchState.selectedEpisodeIdx != null &&
        watchState.episodes.isNotEmpty &&
        watchState.selectedEpisodeIdx! < watchState.episodes.length;
    final hasValidDuration = playerState.duration.inSeconds >= 10;
    final hasValidPosition = playerState.position.inSeconds >= 10;
    final isPositionValid = playerState.position <= playerState.duration;

    AppLogger.d('Should save progress check: '
        'validEpisode=$hasValidEpisode, '
        'validDuration=$hasValidDuration, '
        'validPosition=$hasValidPosition, '
        'positionValid=$isPositionValid');

    return hasValidEpisode &&
        hasValidDuration &&
        hasValidPosition &&
        isPositionValid;
  }

  /// Save the current watch progress
  Future<void> saveProgress({
    required anilist_media.Media animeMedia,
    required WidgetRef ref,
    required Function(String) onError,
  }) async {
    final watchState = ref.read(watchProvider);
    final playerState = ref.read(playerStateProvider);
    final playerSettings = ref.read(playerSettingsProvider);
    if (!shouldSaveProgress(watchState, playerState)) {
      AppLogger.w(
          'Skipping progress save for animeId ${animeMedia.id} - conditions not met');
      return;
    }

    try {
      final episodeIdx = watchState.selectedEpisodeIdx!;
      final episode = watchState.episodes[episodeIdx];
      final progress = playerState.position;
      final duration = playerState.duration;

      if (episode.number == null) {
        AppLogger.w(
            'Episode number is null for animeId ${animeMedia.id}, cannot save progress');
        return;
      }

      final thumbnailBase64 =
          await _thumbnailService.generateThumbnail(ref.read(playerProvider));

      AppLogger.d(
          'Thumbnail generated for animeId ${animeMedia.id}, episode ${episode.number}: '
          'length=${thumbnailBase64.length}, startsWith=${thumbnailBase64.substring(0, 20)}...');

      // Validate thumbnail
      if (thumbnailBase64.isEmpty) {
        AppLogger.w(
            'Thumbnail is empty for animeId ${animeMedia.id}, episode ${episode.number}');
        onError('Thumbnail generation failed, using fallback');
      }

      final isCompleted = progress.inSeconds >=
          (duration.inSeconds * playerSettings.episodeCompletionThreshold);

      AppLogger.d(
          'Saving progress for animeId ${animeMedia.id}, episode ${episode.number}: '
          'Progress: ${progress.inSeconds}s / ${duration.inSeconds}s, '
          'Thumbnail length: ${thumbnailBase64.length}, isCompleted: $isCompleted');

      final animeProgressNotifier =
          ref.read(animeWatchProgressProvider.notifier);

      if (isCompleted) {
        animeProgressNotifier.markEpisodeCompleted(
            animeId: animeMedia.id!, episodeNumber: episode.number!);
      }

      animeProgressNotifier.updateEpisodeProgress(
        animeId: animeMedia.id!,
        episode: EpisodeProgress(
          episodeNumber: episode.number!,
          episodeTitle: episode.title ?? 'Untitled',
          episodeThumbnail: thumbnailBase64,
          progressInSeconds: progress.inSeconds,
          durationInSeconds: duration.inSeconds,
          watchedAt: DateTime.now(),
          isCompleted: isCompleted,
        ),
        animeEntryBase: AnimeWatchProgressEntry(
          animeId: animeMedia.id!,
          animeTitle: animeMedia.title?.english ??
              animeMedia.title?.romaji ??
              animeMedia.title?.native ??
              'Unknown',
          animeFormat: animeMedia.format ?? 'N/A',
          animeCover: animeMedia.coverImage?.medium ??
              animeMedia.coverImage?.large ??
              '',
          totalEpisodes: watchState.episodes.length,
        ),
      );

      AppLogger.d(
          'Progress saved successfully for animeId ${animeMedia.id}, episode ${episode.number}');
    } catch (e, stackTrace) {
      AppLogger.e(
          'Error saving progress for animeId ${animeMedia.id}', e, stackTrace);
      onError('Failed to save progress: $e');
    }
  }

  /// Dispose the service
  void dispose() {
    AppLogger.d('Disposing WatchProgressService');
    stopProgressTimer();
  }
}
