import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shonenx/core/models/anime/episode_model.dart';
import 'package:shonenx/core/models/anime/source_model.dart';
import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/utils/extractors.dart' as extractor;

/// Represents the state of the video player and episode selection.
@immutable
class WatchState {
  final String animeId;
  final bool isExpanded;
  final String? selectedCategory;
  final String? selectedSource;
  final String? selectedServer;
  final List<Map<String, dynamic>> qualityOptions;
  final List<EpisodeDataModel> episodes;
  final List<Source> sources;
  final List<Subtitle> subtitles;
  final int? selectedQualityIdx;
  final int? selectedSubtitleIdx;
  final int? selectedSourceIdx;
  final int? selectedEpisodeIdx;
  final String? error;
  final bool episodesLoading;
  final bool sourceLoading;
  final String? loadingMessage;
  final Map<String, int>? intro;
  final Map<String, int>? outro;

  const WatchState({
    required this.animeId,
    this.isExpanded = false,
    this.selectedCategory = 'sub',
    this.selectedSource,
    this.selectedServer,
    this.qualityOptions = const [],
    this.episodes = const [],
    this.sources = const [],
    this.subtitles = const [],
    this.selectedQualityIdx,
    this.selectedSubtitleIdx,
    this.selectedSourceIdx,
    this.selectedEpisodeIdx,
    this.error,
    this.episodesLoading = false,
    this.sourceLoading = false,
    this.loadingMessage,
    this.intro,
    this.outro,
  });

  WatchState copyWith({
    String? animeId,
    bool? isExpanded,
    String? selectedCategory,
    String? selectedSource,
    String? selectedServer,
    List<Map<String, dynamic>>? qualityOptions,
    List<EpisodeDataModel>? episodes,
    List<Source>? sources,
    List<Subtitle>? subtitles,
    int? selectedQualityIdx,
    int? selectedSubtitleIdx,
    int? selectedSourceIdx,
    int? selectedEpisodeIdx,
    String? error,
    bool? episodesLoading,
    bool? sourceLoading,
    String? loadingMessage,
    Map<String, int>? intro,
    Map<String, int>? outro,
  }) {
    return WatchState(
      animeId: animeId ?? this.animeId,
      isExpanded: isExpanded ?? this.isExpanded,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSource: selectedSource ?? this.selectedSource,
      selectedServer: selectedServer ?? this.selectedServer,
      qualityOptions: qualityOptions ?? this.qualityOptions,
      episodes: episodes ?? this.episodes,
      sources: sources ?? this.sources,
      subtitles: subtitles ?? this.subtitles,
      selectedQualityIdx: selectedQualityIdx ?? this.selectedQualityIdx,
      selectedSubtitleIdx: selectedSubtitleIdx ?? this.selectedSubtitleIdx,
      selectedSourceIdx: selectedSourceIdx ?? this.selectedSourceIdx,
      selectedEpisodeIdx: selectedEpisodeIdx ?? this.selectedEpisodeIdx,
      error: error,
      episodesLoading: episodesLoading ?? this.episodesLoading,
      sourceLoading: sourceLoading ?? this.sourceLoading,
      loadingMessage: loadingMessage,
      intro: intro ?? this.intro,
      outro: outro ?? this.outro,
    );
  }
}

/// Manages the watch state, including episode selection, streaming, and player control.
class WatchStateNotifier extends StateNotifier<WatchState> {
  final Player? player;
  final VideoController? controller;
  final AnimeProvider animeProvider;
  StreamSubscription<Duration>? _positionSubscription;

  WatchStateNotifier({
    required this.player,
    required this.controller,
    required this.animeProvider,
  }) : super(const WatchState(animeId: ''));

  // --- State Management ---

  /// Clears any existing error message.
  void clearError() {
    AppLogger.d('Clearing error message');
    state = state.copyWith(error: null);
  }

  /// Resets the watch state to its initial state.
  void resetState() {
    AppLogger.d('Resetting watch state');
    _positionSubscription?.cancel();
    state = const WatchState(animeId: '');
  }

  /// Updates the selected category (e.g., sub/dub).
  void updateCategory(String? category) {
    if (category == null) return;
    AppLogger.d('Updating category to $category');
    state = state.copyWith(selectedCategory: category, error: null);
    fetchStreamData(episodeIdx: state.selectedEpisodeIdx ?? 0);
  }

  /// Updates the selected server.
  void updateServer(String? server) {
    if (server == null) return;
    AppLogger.d('Updating server to $server');
    state = state.copyWith(selectedServer: server, error: null);
    fetchStreamData(episodeIdx: state.selectedEpisodeIdx ?? 0);
  }

  // --- Episode and Stream Management ---

  /// Changes the current episode and fetches stream data.
  Future<void> changeEpisode(int episodeIdx, {bool withPlay = true}) async {
    if (!_isValidEpisodeIndex(episodeIdx)) {
      _handleError('Invalid episode index: $episodeIdx');
      return;
    }
    AppLogger.d('Changing to episode index $episodeIdx, withPlay: $withPlay');
    try {
      await fetchStreamData(episodeIdx: episodeIdx, withPlay: withPlay);
      state = state.copyWith(error: null);
    } catch (e, stackTrace) {
      _handleError('Failed to change episode: $e', stackTrace);
    }
  }

  Future<void> refreshEpisodes() async {
    await fetchEpisodes(
      animeId: state.animeId,
      episodeIdx: state.selectedEpisodeIdx ?? 0,
      withPlay: true,
    );
  }

  /// Fetches episode data for the given anime ID.
  Future<void> fetchEpisodes({
    required dynamic animeId,
    int episodeIdx = 0,
    Duration startAt = Duration.zero,
    bool withPlay = true,
  }) async {
    try {
      state = state.copyWith(
        animeId: animeId.toString(),
        episodesLoading: true,
        error: null,
        loadingMessage: 'Loading episodes...',
      );
      final episodes =
          (await animeProvider.getEpisodes(animeId.toString())).episodes ?? [];
      state = state.copyWith(
        episodesLoading: false,
        episodes: episodes,
        selectedServer: animeProvider.getSupportedServers().firstOrNull,
        error: null,
        loadingMessage: null,
      );
      if (episodes.isNotEmpty) {
        await fetchStreamData(
            episodeIdx: episodeIdx, withPlay: withPlay, startAt: startAt);
      } else {
        _handleError('No episodes found for animeId: $animeId');
      }
    } catch (e, stackTrace) {
      _handleError('Failed to fetch episodes: $e', stackTrace);
      state = state.copyWith(episodesLoading: false, loadingMessage: null);
    }
  }

  /// Fetches stream data for the selected episode.
  Future<void> fetchStreamData({
    required int episodeIdx,
    bool withPlay = true,
    Duration startAt = Duration.zero,
  }) async {
    if (!_isValidEpisodeIndex(episodeIdx)) {
      _handleError('Invalid episode index: $episodeIdx');
      return;
    }
    AppLogger.d('Fetching stream data for episode index $episodeIdx');
    try {
      state = state.copyWith(
        selectedEpisodeIdx: episodeIdx,
        sourceLoading: true,
        error: null,
        loadingMessage: 'Loading sources...',
      );
      final episode = state.episodes[episodeIdx];
      final data = await animeProvider.getSources(
        state.animeId,
        episode.id ?? '',
        state.selectedServer ?? '',
        state.selectedCategory ?? 'sub',
      );

      state = state.copyWith(
        sourceLoading: false,
        loadingMessage: null,
        selectedSource: data.sources.isNotEmpty ? data.sources.first.url : null,
        sources: data.sources,
        subtitles: data.tracks,
        intro: data.intro != null
            ? {'start': data.intro!.start ?? 0, 'end': data.intro!.end ?? 0}
            : null,
        outro: data.outro != null
            ? {'start': data.outro!.start ?? 0, 'end': data.outro!.end ?? 0}
            : null,
        error: null,
      );

      await _extractQualities();
      final qualityUrl = state.qualityOptions.isNotEmpty
          ? state.qualityOptions[0]['url']
          : data.sources.isNotEmpty
              ? data.sources.first.url
              : null;

      if (qualityUrl != null) {
        await updateVideoSource(
            sourceUrl: qualityUrl, startAt: startAt, withPlay: withPlay);
      } else {
        _handleError('No playable sources found for episode: ${episode.id}');
      }
    } catch (e, stackTrace) {
      _handleError('Failed to fetch stream data: $e', stackTrace);
      state = state.copyWith(sourceLoading: false, loadingMessage: null);
    }
  }

  // --- Player Control ---

  /// Toggles the control panel visibility.
  Future<void> togglePanel(AnimationController controller) async {
    AppLogger.d('Toggling panel, current isExpanded: ${state.isExpanded}');
    try {
      state = state.copyWith(isExpanded: !state.isExpanded);
      await (state.isExpanded ? controller.forward() : controller.reverse());
      state = state.copyWith(error: null);
    } catch (e, stackTrace) {
      _handleError('Failed to toggle panel: $e', stackTrace);
    }
  }

  /// Updates the video source and optionally plays it.
  Future<void> updateVideoSource({
    required String? sourceUrl,
    bool withPlay = true,
    Duration startAt = Duration.zero,
  }) async {
    if (sourceUrl == null) {
      _handleError('No video source provided');
      return;
    }
    AppLogger.d('Updating video source to $sourceUrl, startAt: $startAt');
    try {
      state = state.copyWith(selectedSource: sourceUrl, error: null);
      if (withPlay && player != null) {
        await player?.open(Media(sourceUrl), play: false);
        await player?.stream.duration.firstWhere((d) => d > Duration.zero);
        await player?.seek(startAt);
        await player?.play();
        AppLogger.d('Video source updated and playing: $sourceUrl');
      }
    } catch (e, stackTrace) {
      _handleError('Failed to update video source: $e', stackTrace);
    }
  }

  /// Changes the video quality and resumes at the last position.
  Future<void> changeQuality({
    required int qualityIdx,
    required Duration lastPosition,
  }) async {
    if (state.qualityOptions.isEmpty) {
      _handleError('No quality options available');
      return;
    }
    if (qualityIdx < 0 || qualityIdx >= state.qualityOptions.length) {
      _handleError('Invalid quality index: $qualityIdx');
      return;
    }
    AppLogger.d('Changing quality to index $qualityIdx');
    try {
      state = state.copyWith(selectedQualityIdx: qualityIdx, error: null);
      final quality = state.qualityOptions[qualityIdx];
      await updateVideoSource(sourceUrl: quality['url'], startAt: lastPosition);
    } catch (e, stackTrace) {
      _handleError('Failed to change quality: $e', stackTrace);
    }
  }

  /// Changes the source and resumes at the last position.
  Future<void> changeSource({
    required int sourceIdx,
    required Duration lastPosition,
  }) async {
    if (state.sources.isEmpty) {
      _handleError('No sources available');
      return;
    }
    if (sourceIdx < 0 || sourceIdx >= state.sources.length) {
      _handleError('Invalid source index: $sourceIdx');
      return;
    }
    AppLogger.d('Changing source to index $sourceIdx');
    try {
      state = state.copyWith(selectedSourceIdx: sourceIdx, error: null);
      await updateVideoSource(
          sourceUrl: state.sources[sourceIdx].url, startAt: lastPosition);
    } catch (e, stackTrace) {
      _handleError('Failed to change source: $e', stackTrace);
    }
  }

  /// Changes the server and refetches stream data.
  Future<void> changeServer(String? server) async {
    if (server == null) return;
    AppLogger.d('Changing server to $server');
    try {
      state = state.copyWith(selectedServer: server, error: null);
      await fetchStreamData(episodeIdx: state.selectedEpisodeIdx ?? 0);
    } catch (e, stackTrace) {
      _handleError('Failed to change server: $e', stackTrace);
    }
  }

  /// Updates the subtitle track.
  Future<void> updateSubtitleTrack({required int? subtitleIdx}) async {
    if (player == null) {
      _handleError('Player not initialized');
      return;
    }
    AppLogger.d('Updating subtitle track to index $subtitleIdx');
    try {
      if (subtitleIdx == null) {
        await player?.setSubtitleTrack(SubtitleTrack.no());
        state = state.copyWith(selectedSubtitleIdx: null, error: null);
      } else if (subtitleIdx >= 0 && subtitleIdx < state.subtitles.length) {
        final subtitle = state.subtitles[subtitleIdx];
        if (subtitle.url == null) {
          _handleError('Subtitle URL is null');
          return;
        }
        await player?.setSubtitleTrack(SubtitleTrack.uri(
          subtitle.url!,
          title: subtitle.lang,
          language: subtitle.lang,
        ));
        state = state.copyWith(selectedSubtitleIdx: subtitleIdx, error: null);
      } else {
        _handleError('Invalid subtitle index: $subtitleIdx');
      }
    } catch (e, stackTrace) {
      _handleError('Failed to update subtitle track: $e', stackTrace);
    }
  }

  // --- Helper Methods ---

  /// Extracts quality options from the selected source.
  Future<void> _extractQualities() async {
    if (state.selectedSource == null) {
      _handleError('No source selected for quality extraction');
      return;
    }
    AppLogger.d('Extracting qualities for source: ${state.selectedSource}');
    try {
      final qualities =
          await extractor.extractQualities(state.selectedSource!, {});
      state = state.copyWith(
        qualityOptions: qualities,
        selectedQualityIdx: qualities.isNotEmpty ? 0 : null,
        error: null,
      );
    } catch (e, stackTrace) {
      _handleError('Failed to extract qualities: $e', stackTrace);
    }
  }

  /// Validates the episode index.
  bool _isValidEpisodeIndex(int index) {
    return index >= 0 && index < state.episodes.length;
  }

  /// Handles errors by logging and updating state.
  void _handleError(String message, [StackTrace? stackTrace]) {
    AppLogger.e(message, null, stackTrace);
    state = state.copyWith(error: message);
  }

  @override
  void dispose() {
    AppLogger.d('Disposing WatchStateNotifier');
    _positionSubscription?.cancel();
    super.dispose();
  }
}

/// Represents the state of the media player.
@immutable
class PlayerState {
  final bool isPlaying;
  final bool isBuffering;
  final Duration position;
  final Duration duration;
  final double volume;
  final bool isCompleted;
  final List<String> subtitle;

  const PlayerState({
    this.isPlaying = false,
    this.isBuffering = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 100.0,
    this.isCompleted = false,
    this.subtitle = const [],
  });

  PlayerState copyWith({
    bool? isPlaying,
    bool? isBuffering,
    Duration? position,
    Duration? duration,
    double? volume,
    bool? isCompleted,
    List<String>? subtitle,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      isCompleted: isCompleted ?? this.isCompleted,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

/// Manages the media player state.
class PlayerStateNotifier extends StateNotifier<PlayerState> {
  final Player player;
  late final List<StreamSubscription> _subscriptions;

  PlayerStateNotifier(this.player) : super(const PlayerState()) {
    _subscriptions = [
      player.stream.playing
          .listen((playing) => state = state.copyWith(isPlaying: playing)),
      player.stream.buffering.listen(
          (buffering) => state = state.copyWith(isBuffering: buffering)),
      player.stream.position
          .listen((position) => state = state.copyWith(position: position)),
      player.stream.duration
          .listen((duration) => state = state.copyWith(duration: duration)),
      player.stream.volume
          .listen((volume) => state = state.copyWith(volume: volume)),
      player.stream.completed.listen(
          (completed) => state = state.copyWith(isCompleted: completed)),
      player.stream.subtitle
          .listen((subtitle) => state = state.copyWith(subtitle: subtitle)),
    ];
  }

  Future<void> playOrPause() => player.playOrPause();
  Future<void> seek(Duration position) => player.seek(position);
  Future<void> setVolume(double volume) => player.setVolume(volume);

  @override
  void dispose() {
    AppLogger.d('Disposing PlayerStateNotifier');
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}

/// Riverpod providers for watch and player management.
final watchProvider =
    StateNotifierProvider<WatchStateNotifier, WatchState>((ref) {
  final animeProvider = ref.watch(currentAnimeProviderProvider);

  if (animeProvider == null) {
    AppLogger.w('No anime provider available');
    throw Exception(
        'No anime provider available. Ensure registry is initialized.');
  }

  return WatchStateNotifier(
    player: ref.watch(playerProvider),
    controller: ref.watch(controllerProvider),
    animeProvider: animeProvider,
  );
});

final playerProvider = Provider<Player>((ref) {
  final player = Player();
  ref.onDispose(() {
    AppLogger.d('Disposing player');
    player.dispose();
  });
  return player;
});

final controllerProvider = Provider<VideoController>((ref) {
  final controller = VideoController(ref.watch(playerProvider));
  return controller;
});

final playerStateProvider =
    StateNotifierProvider<PlayerStateNotifier, PlayerState>((ref) {
  return PlayerStateNotifier(ref.watch(playerProvider));
});
