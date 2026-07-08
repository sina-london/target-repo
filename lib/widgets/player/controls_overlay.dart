// lib/widgets/player/overlay/controls_overlay.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;

import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/data/hive/providers/provider_provider.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/widgets/player/bottom_controls.dart';
import 'package:shonenx/widgets/player/center_controls.dart';
import 'package:shonenx/widgets/player/top_controls.dart';
import 'package:shonenx/widgets/ui/settings_sheet.dart';
import 'package:shonenx/widgets/ui/shonenx_dropdown.dart';

class ControlsOverlay extends ConsumerWidget {
  final media_kit_video.VideoState state;
  final AnimationController panelAnimationController;
  final AnimationController animationController;
  final bool controlsVisible;
  final bool isFullscreen;
  final VoidCallback onToggleFullscreen;
  final VoidCallback onResetTimer;
  final VoidCallback onTogglePanel;

  const ControlsOverlay({
    super.key,
    required this.state,
    required this.panelAnimationController,
    required this.animationController,
    required this.controlsVisible,
    required this.isFullscreen,
    required this.onToggleFullscreen,
    required this.onResetTimer,
    required this.onTogglePanel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerStateProvider);
    final playerNotifier = ref.read(playerStateProvider.notifier);
    final watchState = ref.watch(watchProvider);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return AnimatedBuilder(
      animation: animationController,
      child: _buildControlsContent(
        context,
        ref,
        playerState,
        playerNotifier,
        watchState,
        theme,
        isSmallScreen,
      ),
      builder: (context, child) {
        return Opacity(
          opacity: animationController.value,
          child: IgnorePointer(
            ignoring: !controlsVisible,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildControlsContent(
    BuildContext context,
    WidgetRef ref,
    PlayerState playerState,
    PlayerStateNotifier playerNotifier,
    WatchState watchState,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    return Stack(
      children: [
        // Top controls
        TopControls(
          watchState: watchState,
          onPanelToggle: onTogglePanel,
          onQualityTap: () => _showQualitySelector(context, ref, watchState),
          onSubtitleTap: () => _showSubtitleSelector(context, ref, watchState),
          onFullscreenTap: () async => onToggleFullscreen,
        ),

        // Center controls
        Align(
          alignment: Alignment.center,
          child: CenterControls(
            isPlaying: playerState.isPlaying,
            isBuffering: playerState.isBuffering,
            onTap: () => _handlePlayPause(ref, playerNotifier),
            theme: theme,
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomControls(
            context,
            ref,
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
    BuildContext context,
    WidgetRef ref,
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
        // Next episode button
        if (isNearEnd && hasNextEpisode)
          _buildNextEpisodeButton(
            context,
            ref,
            watchState,
            theme,
            isSmallScreen,
          ),
        const SizedBox(height: 8),

        // Main bottom controls
        BottomControls(
          animeProvider: ref
              .read(animeSourceRegistryProvider.notifier)
              .getProvider(
                  ref.read(providerSettingsProvider).selectedProviderName)!,
          watchState: watchState,
          onChangeSource: onResetTimer,
          isPlaying: playerState.isPlaying,
          onPlayPause: () => _handlePlayPause(ref, playerNotifier),
          position: playerState.position,
          duration: playerState.duration,
          isBuffering: playerState.isBuffering,
        ),
      ],
    );
  }

  Widget _buildNextEpisodeButton(
    BuildContext context,
    WidgetRef ref,
    WatchState watchState,
    ThemeData theme,
    bool isSmallScreen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: watchState.selectedEpisodeIdx != null &&
                  (watchState.selectedEpisodeIdx! + 1) <
                      watchState.episodes.length
              ? () async {
                  final nextIndex = watchState.selectedEpisodeIdx! + 1;
                  await ref
                      .read(watchProvider.notifier)
                      .changeEpisode(nextIndex);
                  onResetTimer();
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12.0 : 16.0,
              vertical: isSmallScreen ? 6.0 : 8.0,
            ),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.skip_next,
                  size: isSmallScreen ? 16 : 18,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    watchState.selectedEpisodeIdx != null &&
                            (watchState.selectedEpisodeIdx! + 1) <
                                watchState.episodes.length
                        ? 'Next: EP ${watchState.episodes[watchState.selectedEpisodeIdx! + 1].number}'
                        : 'Next: --',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePlayPause(
      WidgetRef ref, PlayerStateNotifier playerNotifier) async {
    onResetTimer();
    await playerNotifier.playOrPause();
  }

  void _showQualitySelector(
      BuildContext context, WidgetRef ref, WatchState watchState) {
    if (watchState.qualityOptions.isEmpty) return;

    SettingsSheet.showAsModalBottomSheet(
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
                : 'Auto',
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
              onResetTimer();
            },
          ),
        ),
      ],
    );
  }

  void _showSubtitleSelector(
      BuildContext context, WidgetRef ref, WatchState watchState) {
    if (watchState.subtitles.isEmpty) return;

    SettingsSheet.showAsModalBottomSheet(
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
              onResetTimer();
            },
          ),
        ),
      ],
    );
  }
}
