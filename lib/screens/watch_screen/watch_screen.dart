import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart'
    as anilist_media;
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/helpers/ui.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/screens/watch_screen/components/loading_overlay.dart';
import 'package:shonenx/screens/watch_screen/components/video_player_view.dart';
import 'package:shonenx/screens/watch_screen/episodes_panel.dart';
import 'package:shonenx/services/watch_progress_service.dart';
import 'package:window_manager/window_manager.dart';

/// Optimized watch screen with improved performance and layout
class WatchScreen extends ConsumerStatefulWidget {
  final String animeId;
  final anilist_media.Media animeMedia;
  final String animeName;
  final int? episode;
  final Duration startAt;

  const WatchScreen({
    required this.animeId,
    required this.animeMedia,
    required this.animeName,
    this.startAt = Duration.zero,
    this.episode = 1,
    super.key,
  });

  @override
  ConsumerState<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen>
    with TickerProviderStateMixin {
  // Services
  final WatchProgressService _progressService = WatchProgressService();

  // Timer for progress saving to reduce frequent disk writes
  Timer? _progressSaveTimer;

  // Controllers
  late AnimationController _animationController;
  late final VideoController _controller;

  @override
  void initState() {
    super.initState();
    AppLogger.d('Initializing WatchScreen for anime: ${widget.animeId}');

    // Setup orientation
    _setupOrientation();

    // Initialize animation controller with optimized duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250), // Slightly faster animation
      vsync: this,
      value: ref.read(watchProvider).isExpanded ? 1.0 : 0.0,
    );

    // Get controller from provider
    _controller = ref.read(controllerProvider);

    // Initialize async components and fetch initial data
    _initializeAsync().then((_) => _performInitialFetch(ref));
  }

  /// Set up device orientation for optimal viewing
  Future<void> _setupOrientation() async {
    if (!mounted) return;
    AppLogger.d('Setting up landscape orientation');
    await UIHelper.forceLandscape();
    await UIHelper.enableImmersiveMode();
  }

  /// Initialize async components and set up progress tracking
  Future<void> _initializeAsync() async {
    AppLogger.d('Initializing async components');

    // Set up throttled progress saving (every 10 seconds instead of 5)
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) _saveProgress();
    });
  }

  /// Save watch progress with error handling
  Future<void> _saveProgress() async {
    AppLogger.d('Saving watch progress');
    try {
      await _progressService.saveProgress(
        animeMedia: widget.animeMedia,
        ref: ref,
        onError: (errorMessage) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior:
                    SnackBarBehavior.floating, // Use floating for better UX
                duration: const Duration(seconds: 3), // Shorter duration
              ),
            );
          }
        },
      );
    } catch (e) {
      AppLogger.e('Error saving progress: $e');
    }
  }

  /// Fetch initial episode data
  Future<void> _performInitialFetch(WidgetRef ref) async {
    if (!mounted) return;

    AppLogger.d('Fetching initial episodes for anime: ${widget.animeId}');
    try {
      final notifier = ref.read(watchProvider.notifier);
      await notifier.fetchEpisodes(
        animeId: widget.animeId,
        episodeIdx: (widget.episode ?? 1) - 1,
      );
    } catch (e) {
      AppLogger.e('Error fetching initial episodes: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to load episodes: ${e.toString()}');
      }
    }
  }

  /// Show error message with retry option
  void _showErrorSnackBar(String error) {
    if (!mounted) return;

    // Clear any existing snackbars to prevent stacking
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating, // Use floating for better UX
        margin: const EdgeInsets.all(8), // Add margin for better appearance
        action: SnackBarAction(
          label: 'Retry',
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            ref.read(watchProvider.notifier).clearError();
            _performInitialFetch(ref);
          },
        ),
        duration: const Duration(seconds: 4), // Slightly shorter duration
      ),
    );
  }

  @override
  void dispose() {
    AppLogger.d('Disposing WatchScreen');

    // Cancel progress timer
    _progressSaveTimer?.cancel();

    // Clean up providers
    if (ref.context.mounted) {
      ref.read(watchProvider.notifier).dispose();
    }

    // Dispose animation controller
    _animationController.dispose();

    // Reset UI orientation
    if (mounted) {
      _resetOrientationAndUI();
    }

    super.dispose();
  }

  /// Reset device orientation and UI mode
  Future<void> _resetOrientationAndUI() async {
    if (!mounted) return;

    AppLogger.d('Resetting orientation and UI mode');
    try {
      // Exit fullscreen on desktop platforms
      if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
        await windowManager.setFullScreen(false);
      }

      // Reset orientation and UI mode
      await UIHelper.enableAutoRotate();
      await UIHelper.exitImmersiveMode();
    } catch (e) {
      AppLogger.e('Error resetting orientation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a more efficient Consumer that only rebuilds when necessary
      body: Consumer(
        builder: (context, ref, child) {
          final watchState = ref.watch(watchProvider);

          // Handle loading state changes more efficiently
          if (watchState.episodesLoading || watchState.sourceLoading) {
            // Store context in local variable to avoid BuildContext across async gap
            final currentContext = context;
            // Use addPostFrameCallback instead of microtask for UI updates
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted &&
                  !watchState.episodesLoading &&
                  !watchState.sourceLoading) {
                Navigator.of(currentContext).pop();
              }
            });
          }

          // Handle errors more efficiently
          if (watchState.error != null) {
            // Store error in local variable to avoid capturing changing state
            final currentError = watchState.error!;
            // Use addPostFrameCallback instead of microtask for UI updates
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _showErrorSnackBar(currentError);
            });
          }

          // More efficient layout with better performance
          return Center(
            child: LayoutBuilder(
              builder: (context, constraints) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Video player with optimized rendering
                  VideoPlayerView(
                    controller: _controller,
                    panelAnimationController: _animationController,
                  ),
                  // Episodes panel with optimized animation
                  _buildEpisodesPanel(context, constraints),
                ],
              ),
            ),
          );
        },
      ),
      // Loading overlay with retry functionality
      floatingActionButton: LoadingOverlay(
        onRetry: () => _performInitialFetch(ref),
      ),
    );
  }

  /// Build episodes panel with optimized animation and layout
  Widget _buildEpisodesPanel(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);

    // Calculate optimal panel width based on screen size
    final screenWidth = MediaQuery.sizeOf(context).width;
    final panelWidth =
        screenWidth < 600 ? screenWidth * 0.4 : screenWidth * 0.35;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutQuart, // More natural easing curve
        ),
        axis: Axis.horizontal,
        child: SizedBox(
          width: panelWidth,
          height: constraints.maxHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              // Reduced border radius for more modern look
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              // Add subtle shadow for depth
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: EpisodesPanel(animeId: widget.animeId),
          ),
        ),
      ),
    );
  }
}
