import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/data/hive/models/settings/player_model.dart';
import 'package:shonenx/data/hive/providers/player_provider.dart';
import 'package:shonenx/data/hive/providers/provider_provider.dart';
import 'package:shonenx/helpers/player/gesture_handler.dart';
import 'package:shonenx/helpers/player/overlay_manager.dart';
import 'package:shonenx/helpers/ui.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/widgets/player/bottom_controls.dart';
import 'package:shonenx/widgets/player/center_controls.dart';
import 'package:shonenx/widgets/player/seek_bar.dart';
import 'package:shonenx/widgets/player/selector_tile.dart';
import 'package:shonenx/widgets/player/subtitle_overlay.dart';
import 'package:shonenx/widgets/player/top_controls.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

// Intents for keyboard shortcuts
class PlayPauseIntent extends Intent {
  const PlayPauseIntent();
}

class SeekForwardIntent extends Intent {
  const SeekForwardIntent();
}

class SeekBackwardIntent extends Intent {
  const SeekBackwardIntent();
}

class ToggleFullscreenIntent extends Intent {
  const ToggleFullscreenIntent();
}

/// Modern video player controls with sleek design
class CustomControls extends ConsumerStatefulWidget {
  final media_kit_video.VideoState state;
  final AnimationController panelAnimationController;

  const CustomControls({
    super.key,
    required this.state,
    required this.panelAnimationController,
  });

  @override
  ConsumerState<CustomControls> createState() => _CustomControlsState();
}

class _CustomControlsState extends ConsumerState<CustomControls>
    with SingleTickerProviderStateMixin {
  // Longer auto-hide duration for better UX
  static const _autoHideDuration = Duration(seconds: 4);
  static const _seekDuration = Duration(seconds: 10);

  // State variables
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;
  bool _isFullscreen = (Platform.isAndroid && Platform.isIOS ? true : false);
  late GestureHandler _gestureHandler;
  late OverlayManager _overlayManager;

  // Animation controller for fade effects
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize overlay manager
    _overlayManager = OverlayManager();

    // Initialize gesture handler
    _gestureHandler = GestureHandler(
      resetTimer: _resetTimer,
      showOverlay: (context, {required bool isBrightness}) {
        if (!mounted) return;
        _overlayManager.showAdjustmentOverlay(
          context,
          isBrightness: isBrightness,
          value: isBrightness
              ? _gestureHandler.brightnessValue
              : _gestureHandler.volumeValue,
        );
      },
    );

    // Initialize fade animation controller
    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    );

    // Initialize player state
    _initializeState();
  }

  Future<void> _initializeState() async {
    // Check fullscreen state
    _isFullscreen = (!Platform.isAndroid && !Platform.isIOS)
        ? await windowManager.isFullScreen()
        : false;

    // Force landscape orientation
    await UIHelper.forceLandscape();

    // Initialize gesture handler
    _gestureHandler.initialize();

    // Show controls initially
    _controlsVisible = true;
    _fadeAnimationController.value = 1.0;

    // Schedule hide if in fullscreen
    if (_isFullscreen) {
      _scheduleHideControls();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No need to save ancestor references here unless accessing specific inherited widgets
  }

  @override
  void dispose() {
    // Cancel timers
    _hideControlsTimer?.cancel();

    // Dispose animation controller
    _fadeAnimationController.dispose();

    // Dispose overlay manager
    _overlayManager.dispose();

    // Clean up player and UI
    Future.wait([
      widget.state.widget.controller.player.pause(),
      widget.state.widget.controller.player.stop(),
      widget.state.widget.controller.player.remove(0),
      UIHelper.enableAutoRotate(),
      UIHelper.exitImmersiveMode()
    ]);

    // Avoid disposing widget.state here; let the parent widget handle it
    super.dispose();
  }

  /// Schedule hiding controls with animation
  void _scheduleHideControls() {
    // Cancel any existing timer
    _hideControlsTimer?.cancel();

    // Don't schedule if controls are already hidden or not in fullscreen
    if (!_controlsVisible || !mounted || !_isFullscreen) return;

    // Set timer to hide controls
    _hideControlsTimer = Timer(_autoHideDuration, () {
      if (mounted) {
        // Animate controls out
        _fadeAnimationController.reverse().then((_) {
          if (mounted) {
            setState(() => _controlsVisible = false);
          }
        });
        developer.log('Controls auto-hidden', name: 'CustomControls');
      }
    });
  }

  /// Toggle controls visibility with animation
  void _toggleControls() {
    if (!mounted) return;

    if (_controlsVisible) {
      // Hide controls with animation
      _fadeAnimationController.reverse().then((_) {
        if (mounted) {
          setState(() => _controlsVisible = false);
        }
      });
      _hideControlsTimer?.cancel();
    } else {
      // Show controls with animation
      setState(() => _controlsVisible = true);
      _fadeAnimationController.forward();
      _scheduleHideControls();
    }
  }

  /// Show controls with animation
  void _showControls() {
    if (!mounted || _controlsVisible) return;

    // Show controls immediately
    setState(() => _controlsVisible = true);

    // Animate in
    _fadeAnimationController.forward();

    // Schedule hide
    _scheduleHideControls();
  }

  /// Reset the auto-hide timer
  void _resetTimer() {
    if (mounted && _controlsVisible) {
      _scheduleHideControls();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get state from providers
    final playerState = ref.watch(playerStateProvider);
    final playerNotifier = ref.read(playerStateProvider.notifier);
    final playerSettings = ref.watch(playerSettingsProvider);
    final watchState = ref.watch(watchProvider);
    final theme = Theme.of(context);
    final isDesktop = !Platform.isAndroid && !Platform.isIOS;

    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.space): PlayPauseIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): SeekForwardIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft): SeekBackwardIntent(),
        SingleActivator(LogicalKeyboardKey.keyF): ToggleFullscreenIntent(),
        SingleActivator(LogicalKeyboardKey.escape): ToggleFullscreenIntent(),
      },
      child: Actions(
        actions: {
          PlayPauseIntent: CallbackAction<PlayPauseIntent>(
            onInvoke: (_) => _handlePlayPause(playerNotifier),
          ),
          SeekForwardIntent: CallbackAction<SeekForwardIntent>(
            onInvoke: (_) =>
                _handleSeek(playerState, playerNotifier, forward: true),
          ),
          SeekBackwardIntent: CallbackAction<SeekBackwardIntent>(
            onInvoke: (_) =>
                _handleSeek(playerState, playerNotifier, forward: false),
          ),
          ToggleFullscreenIntent: CallbackAction<ToggleFullscreenIntent>(
            onInvoke: (_) => _handleToggleFullscreen(),
          ),
        },
        child: Focus(
          autofocus: isDesktop,
          child: MouseRegion(
            onHover: (_) => isDesktop ? _showControls() : null,
            cursor: isDesktop && _isFullscreen && !_controlsVisible
                ? SystemMouseCursors.none
                : MouseCursor.defer,
            child: GestureDetector(
              onTap: _toggleControls,
              // Double tap to seek forward/backward
              onDoubleTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                final tapPosition = details.globalPosition.dx;

                // If tap is on the right side of the screen, seek forward
                if (tapPosition > screenWidth / 2) {
                  _handleSeek(playerState, playerNotifier, forward: true);
                } else {
                  // Otherwise, seek backward
                  _handleSeek(playerState, playerNotifier, forward: false);
                }
              },
              child: SafeArea(
                child: Stack(
                  children: [
                    // Subtitle overlay
                    _buildSubtitleOverlay(playerState, playerSettings),

                    // Controls overlay with fade animation
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: IgnorePointer(
                            ignoring: !_controlsVisible,
                            child: child!,
                          ),
                        );
                      },
                      child: _buildControlsOverlay(
                        context,
                        playerState,
                        playerNotifier,
                        watchState,
                        theme,
                        isSmallScreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build modern subtitle overlay with improved visibility
  Widget _buildSubtitleOverlay(
      PlayerState playerState, PlayerSettings playerSettings) {
    // Get screen dimensions for responsive positioning
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      // Position subtitles higher when controls are visible
      bottom: _controlsVisible
          ? screenHeight * 0.2 // 20% from bottom when controls visible
          : screenHeight * 0.1, // 10% from bottom when controls hidden
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: playerState.subtitle.isNotEmpty ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: SubtitleOverlay(
            subtitleStyle: playerSettings.toSubtitleStyle(),
            subtitle: playerState.subtitle.firstOrNull ?? '',
          ),
        ),
      ),
    );
  }

  /// Build the main controls overlay with modern glass-morphic design
  Widget _buildControlsOverlay(
    BuildContext context,
    PlayerState playerState,
    PlayerStateNotifier playerNotifier,
    WatchState watchState,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    return Container(
      decoration: BoxDecoration(
        // Modern gradient overlay for better visibility
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7), // Stronger at bottom
            Colors.black.withOpacity(0.4), // Medium in middle
            Colors.black.withOpacity(0.7), // Stronger at top
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      // Full screen container
      child: ClipRect(
        child: BackdropFilter(
          // Apply subtle blur for glass effect
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 8 : 12, 0, isSmallScreen ? 8 : 12, 0),
            child: Stack(
              children: [
                // Top controls with modern design
                TopControls(
                  watchState: watchState,
                  onPanelToggle: () => _togglePanel(),
                  onQualityTap: () =>
                      _showQualitySelector(context, ref, watchState),
                  onSubtitleTap: () =>
                      _showSubtitleSelector(context, ref, watchState),
                  onFullscreenTap: () async => await _handleToggleFullscreen(),
                ),

                // Center play/pause controls
                Align(
                  alignment: Alignment.center,
                  child: CenterControls(
                    isPlaying: playerState.isPlaying,
                    isBuffering: playerState.isBuffering,
                    onTap: () => _handlePlayPause(playerNotifier),
                    theme: theme,
                  ),
                ),

                // Bottom controls with seek bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomControls(
                    playerState,
                    watchState,
                    playerNotifier,
                    theme,
                    isSmallScreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build bottom controls with modern design
  Widget _buildBottomControls(
    PlayerState playerState,
    WatchState watchState,
    PlayerStateNotifier playerNotifier,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    // Calculate if we're near the end of the episode
    final isNearEnd = playerState.duration.inSeconds > 0 &&
        (playerState.position.inSeconds / playerState.duration.inSeconds) *
                100.0 >=
            85;

    // Get next episode number if available
    final hasNextEpisode = watchState.episodes.isNotEmpty &&
        watchState.selectedEpisodeIdx != null &&
        (watchState.selectedEpisodeIdx! + 1) < watchState.episodes.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Next episode button (only show when near the end)
        if (isNearEnd && hasNextEpisode)
          Container(
            margin: EdgeInsets.only(
              right: isSmallScreen ? 8 : 16,
              bottom: isSmallScreen ? 4 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Modern next episode button with glass effect
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primaryContainer.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.next5,
                            size: isSmallScreen ? 16 : 18,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Next: EP ${watchState.episodes[(watchState.selectedEpisodeIdx ?? 0) + 1].number}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Main controls container with glass effect
        Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    // Modern seek bar
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SeekBar(
                        position: playerState.position,
                        duration: playerState.duration,
                        onSeek: (position) {
                          _resetTimer();
                          playerNotifier.seek(position);
                        },
                        theme: theme,
                      ),
                    ),

                    // Bottom controls
                    BottomControls(
                      animeProvider: ref
                          .read(animeSourceRegistryProvider.notifier)
                          .getProvider(ref
                              .read(providerSettingsProvider)
                              .selectedProviderName)!,
                      watchState: watchState,
                      onChangeSource: _resetTimer,
                      isPlaying: playerState.isPlaying,
                      onPlayPause: () => _handlePlayPause(playerNotifier),
                      position: playerState.position,
                      duration: playerState.duration,
                      isBuffering: playerState.isBuffering,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePlayPause(PlayerStateNotifier playerNotifier) async {
    _resetTimer();
    await playerNotifier.playOrPause();
  }

  Future<void> _handleSeek(
      PlayerState playerState, PlayerStateNotifier playerNotifier,
      {required bool forward}) async {
    _resetTimer();
    final newPosition = forward
        ? playerState.position + _seekDuration
        : playerState.position - _seekDuration;
    await playerNotifier.seek(newPosition);
  }

  Future<void> _handleToggleFullscreen() async {
    await UIHelper.handleToggleFullscreen(
        isFullscreen: _isFullscreen,
        beforeCallback: _resetTimer,
        afterCallback: () {
          if (mounted) setState(() => _isFullscreen = !_isFullscreen);
        });
  }

  Future<void> _togglePanel() async {
    _resetTimer();
    if (_isFullscreen) {
      await widget.state.exitFullscreen();
      if (mounted) setState(() => _isFullscreen = false);
    }
    await ref
        .read(watchProvider.notifier)
        .togglePanel(widget.panelAnimationController);
  }

  void _showQualitySelector(
      BuildContext context, WidgetRef ref, WatchState watchState) {
    if (watchState.qualityOptions.isEmpty || !mounted) return;
    _showSelector(
      context: context,
      title: 'Quality',
      items: watchState.qualityOptions,
      selectedItemIdx: watchState.selectedQualityIdx,
      itemBuilder: (item) => item['quality'],
      onTap: (index) async {
        await ref.read(watchProvider.notifier).changeQuality(
              qualityIdx: index,
              lastPosition: ref.read(playerStateProvider).position,
            );
        _resetTimer();
      },
    );
  }

  void _showSubtitleSelector(
      BuildContext context, WidgetRef ref, WatchState watchState) {
    if (watchState.subtitles.isEmpty || !mounted) return;
    _showSelector(
      context: context,
      title: 'Subtitles',
      items: watchState.subtitles,
      selectedItemIdx: watchState.selectedSubtitleIdx,
      showDisableOption: true,
      itemBuilder: (item) => item.lang ?? 'Unknown',
      onTap: (index) async {
        await ref.read(watchProvider.notifier).updateSubtitleTrack(
              subtitleIdx: index == -1 ? null : index,
            );
        _resetTimer();
      },
    );
  }

  void _showSelector<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required int? selectedItemIdx,
    required String Function(T) itemBuilder,
    required Future<void> Function(int) onTap,
    bool showDisableOption = false,
  }) {
    if (!mounted) return;

    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: true,
      builder: (modalContext) => _buildSelectorModal(
        modalContext,
        theme,
        title,
        items,
        selectedItemIdx,
        itemBuilder,
        onTap,
        showDisableOption,
      ),
    ).whenComplete(() => _resetTimer());
  }

  Widget _buildSelectorModal<T>(
    BuildContext modalContext,
    ThemeData theme,
    String title,
    List<T> items,
    int? selectedItemIdx,
    String Function(T) itemBuilder,
    Future<void> Function(int) onTap,
    bool showDisableOption,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(modalContext).pop(),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    foregroundColor: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (showDisableOption)
                    SelectorTile(
                      selected: selectedItemIdx == null,
                      title: "OFF",
                      onTap: () async {
                        await onTap(-1);
                        if (modalContext.mounted) {
                          Navigator.of(modalContext).pop();
                        }
                      },
                      theme: theme,
                    ),
                  ...items.asMap().entries.map((entry) => SelectorTile(
                        selected: selectedItemIdx == entry.key,
                        title: itemBuilder(entry.value),
                        onTap: () async {
                          await onTap(entry.key);
                          if (modalContext.mounted) {
                            Navigator.of(modalContext).pop();
                          }
                        },
                        theme: theme,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
