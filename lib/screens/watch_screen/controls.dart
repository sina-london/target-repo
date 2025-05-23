import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:window_manager/window_manager.dart';

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
import 'package:shonenx/widgets/player/subtitle_overlay.dart';
import 'package:shonenx/widgets/player/top_controls.dart';
import 'package:shonenx/widgets/ui/modern_settings_panel.dart';
import 'package:shonenx/widgets/ui/shonenx_dropdown.dart';

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

class _CustomControlsState extends ConsumerState<CustomControls> {
  static const _autoHideDuration = Duration(seconds: 4);
  static const _seekDuration = Duration(seconds: 10);

  bool _controlsVisible = true;
  Timer? _hideControlsTimer;
  bool _isFullscreen = (Platform.isAndroid || Platform.isIOS) ? true : false;
  late GestureHandler _gestureHandler;
  late OverlayManager _overlayManager;

  @override
  void initState() {
    super.initState();

    _overlayManager = OverlayManager();

    _gestureHandler = GestureHandler(
      resetTimer: _resetHideTimer,
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

    developer.log('CustomControls initialized', name: 'CustomControls');

    _initializeState();
  }

  Future<void> _initializeState() async {
    _isFullscreen = (Platform.isAndroid || Platform.isIOS)
        ? true
        : await windowManager.isFullScreen();

    await UIHelper.forceLandscape();
    _gestureHandler.initialize();

    if (mounted) {
      setState(() {
        _controlsVisible = true;
      });
    }

    if (_isFullscreen) {
      _scheduleHideControls();
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _overlayManager.dispose();

    Future.wait([
      widget.state.widget.controller.player.pause(),
      widget.state.widget.controller.player.stop(),
      widget.state.widget.controller.player.remove(0),
      UIHelper.enableAutoRotate(),
      UIHelper.exitImmersiveMode(),
    ]);

    super.dispose();
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();

    if (!_controlsVisible || !_isFullscreen || !mounted) {
      // developer.log(
      //     'Skip hide schedule: visible=$_controlsVisible, fullscreen=$_isFullscreen, mounted=$mounted',
      //     name: 'CustomControls');
      return;
    }

    // developer.log('Scheduling auto-hide', name: 'CustomControls');
    _hideControlsTimer = Timer(_autoHideDuration, () {
      if (mounted && _controlsVisible && _isFullscreen) {
        _hideControls();
      }
    });
  }

  void _showControls() {
    if (!mounted || _controlsVisible) {
      // developer.log(
      //     'Show controls skipped: visible=$_controlsVisible, mounted=$mounted',
      //     name: 'CustomControls');
      return;
    }

    // developer.log('Showing controls', name: 'CustomControls');
    setState(() {
      _controlsVisible = true;
    });
    if (_isFullscreen) {
      _scheduleHideControls();
    }
  }

  void _hideControls() {
    if (!mounted || !_controlsVisible) {
      // developer.log(
      //     'Hide controls skipped: visible=$_controlsVisible, mounted=$mounted',
      //     name: 'CustomControls');
      return;
    }

    // developer.log('Hiding controls', name: 'CustomControls');
    setState(() {
      _controlsVisible = false;
    });
    _hideControlsTimer?.cancel();
  }

  void _resetHideTimer() {
    if (mounted && _controlsVisible && _isFullscreen) {
      // developer.log('Resetting hide timer', name: 'CustomControls');
      _scheduleHideControls();
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerStateProvider);
    final playerNotifier = ref.read(playerStateProvider.notifier);
    final playerSettings = ref.watch(playerSettingsProvider);
    final watchState = ref.watch(watchProvider);
    final theme = Theme.of(context);
    final isDesktop = !Platform.isAndroid && !Platform.isIOS;
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
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_controlsVisible) {
                  _hideControls();
                } else {
                  _showControls();
                }
              },
              child: SafeArea(
                child: Stack(
                  children: [
                    Listener(
                      onPointerDown: (event) {
                      },
                      child: Container(color: Colors.transparent),
                    ),
                    // Subtitle overlay
                    _buildSubtitleOverlay(playerState, playerSettings),
                    // Controls overlay
                    AnimatedOpacity(
                      opacity: _controlsVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: !_controlsVisible,
                        child: _buildControlsOverlay(
                          context,
                          playerState,
                          playerNotifier,
                          watchState,
                          theme,
                          isSmallScreen,
                        ),
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

  Widget _buildSubtitleOverlay(
      PlayerState playerState, PlayerSettings playerSettings) {
    final screenHeight = MediaQuery.of(context).size.height;
    final subtitlePosition = playerSettings.subtitlePosition;
    final height =
        (_controlsVisible ? screenHeight * 0.12 : screenHeight * 0.01);
    return Positioned(
      top: subtitlePosition == 0
          ? height
          : subtitlePosition == 1
              ? 0
              : null,
      bottom: subtitlePosition == 2
          ? height
          : subtitlePosition == 1
              ? 0
              : null,
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

  Widget _buildControlsOverlay(
    BuildContext context,
    PlayerState playerState,
    PlayerStateNotifier playerNotifier,
    WatchState watchState,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    return Stack(
      children: [
        TopControls(
          watchState: watchState,
          onPanelToggle: () => _togglePanel(),
          onQualityTap: () => _showQualitySelector(context, ref, watchState),
          onSubtitleTap: () => _showSubtitleSelector(context, ref, watchState),
          onFullscreenTap: () async => await _handleToggleFullscreen(),
        ),
        Align(
          alignment: Alignment.center,
          child: CenterControls(
            isPlaying: playerState.isPlaying,
            isBuffering: playerState.isBuffering,
            onTap: () => _handlePlayPause(playerNotifier),
            theme: theme,
          ),
        ),
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
    );
  }

  Widget _buildBottomControls(
    PlayerState playerState,
    WatchState watchState,
    PlayerStateNotifier playerNotifier,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    final isNearEnd = playerState.duration.inSeconds > 0 &&
        (playerState.position.inSeconds / playerState.duration.inSeconds) *
                100.0 >=
            85;
    final hasNextEpisode = watchState.episodes.isNotEmpty &&
        watchState.selectedEpisodeIdx != null &&
        (watchState.selectedEpisodeIdx! + 1) < watchState.episodes.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isNearEnd && hasNextEpisode)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.7),
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
            ],
          ),
        Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 8),
            //   child: SeekBar(
            //     position: playerState.position,
            //     duration: playerState.duration,
            //     onSeek: (position) {
            //       _resetHideTimer();
            //       playerNotifier.seek(position);
            //     },
            //     theme: theme,
            //   ),
            // ),
            BottomControls(
              animeProvider: ref
                  .read(animeSourceRegistryProvider.notifier)
                  .getProvider(
                      ref.read(providerSettingsProvider).selectedProviderName)!,
              watchState: watchState,
              onChangeSource: _resetHideTimer,
              isPlaying: playerState.isPlaying,
              onPlayPause: () => _handlePlayPause(playerNotifier),
              position: playerState.position,
              duration: playerState.duration,
              isBuffering: playerState.isBuffering,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handlePlayPause(PlayerStateNotifier playerNotifier) async {
    _resetHideTimer();
    await playerNotifier.playOrPause();
  }

  Future<void> _handleSeek(
      PlayerState playerState, PlayerStateNotifier playerNotifier,
      {required bool forward}) async {
    _resetHideTimer();
    final newPosition = forward
        ? playerState.position + _seekDuration
        : playerState.position - _seekDuration;
    await playerNotifier.seek(newPosition);
  }

  Future<void> _handleToggleFullscreen() async {
    await UIHelper.handleToggleFullscreen(
      isFullscreen: _isFullscreen,
      beforeCallback: _resetHideTimer,
      afterCallback: () {
        if (mounted) {
          setState(() => _isFullscreen = !_isFullscreen);
          if (_isFullscreen && _controlsVisible) {
            _scheduleHideControls();
          }
        }
      },
    );
  }

  Future<void> _togglePanel() async {
    _resetHideTimer();
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
    // _showSelector(
    //   context: context,
    //   title: 'Quality',
    //   items: watchState.qualityOptions,
    //   selectedItemIdx: watchState.selectedQualityIdx,
    //   itemBuilder: (item) => item['quality'],
    //   onTap: (index) async {
    //     await ref.read(watchProvider.notifier).changeQuality(
    //           qualityIdx: index,
    //           lastPosition: ref.read(playerStateProvider).position,
    //         );
    //     _resetHideTimer();
    //   },
    // );
    ModernSettingsPanel.showAsModalBottomSheet(
      context: context,
      title: 'Quality',
      settingsRows: [
        SettingsRowData(
          icon: Iconsax.video,
          label: 'Quality',
          child: ShonenxDropdown(
            icon: Iconsax.video,
            value: watchState.selectedQualityIdx != null
                ? watchState.qualityOptions[watchState.selectedQualityIdx!]
                    ['quality']
                : 'Auto', // Placeholder
            items: watchState.qualityOptions
                .map((option) => option['quality'] as String)
                .toList(),
            onChanged: (value) async {
              final qualityIdx = watchState.qualityOptions
                  .indexWhere((option) => option['quality'] == value);
              await ref.read(watchProvider.notifier).changeQuality(
                    qualityIdx: qualityIdx,
                    lastPosition: ref.read(playerStateProvider).position,
                  );
              _resetHideTimer();
            },
          ),
        ),
      ],
    );
  }

  void _showSubtitleSelector(
      BuildContext context, WidgetRef ref, WatchState watchState) {
    if (watchState.subtitles.isEmpty || !mounted) return;
    ModernSettingsPanel.showAsModalBottomSheet(
      context: context,
      title: 'Subtitles',
      settingsRows: [
        SettingsRowData(
          icon: Iconsax.subtitle,
          label: 'Subtitles',
          child: ShonenxDropdown(
            icon: Iconsax.subtitle,
            value: watchState.selectedSubtitleIdx != null
                ? watchState.subtitles[watchState.selectedSubtitleIdx!].lang ??
                    'Unknown'
                : 'Off',
            items: watchState.subtitles
                .map((subtitle) => subtitle.lang ?? 'Unknown')
                .toList(),
            onChanged: (value) async {
              final subtitleIdx = watchState.subtitles
                  .indexWhere((subtitle) => subtitle.lang == value);
              await ref.read(watchProvider.notifier).updateSubtitleTrack(
                    subtitleIdx: subtitleIdx == -1 ? null : subtitleIdx,
                  );
              setState(() {});
              _resetHideTimer();
            },
          ),
        ),
      ],
    );
  }
}
