import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/utils/formatter.dart';
import 'package:shonenx/widgets/ui/shonenx_dropdown.dart';

/// Modern bottom controls with sleek glass-morphic design
class BottomControls extends ConsumerWidget {
  final AnimeProvider animeProvider;
  final WatchState watchState;
  final bool isPlaying;
  final bool isBuffering;
  final VoidCallback onPlayPause;
  final Duration position;
  final Duration duration;
  final VoidCallback onChangeSource;

  const BottomControls({
    required this.animeProvider,
    required this.watchState,
    required this.isPlaying,
    required this.onPlayPause,
    required this.position,
    required this.duration,
    required this.isBuffering,
    required this.onChangeSource,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Padding based on screen size
    final horizontalPadding = isSmallScreen ? 8.0 : 12.0;
    final verticalPadding = isSmallScreen ? 4.0 : 6.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button with modern design
          _buildPlayPauseButton(theme, isSmallScreen),

          SizedBox(width: isSmallScreen ? 10 : 14),

          // Time display with modern style
          _TimeDisplay(
            position: position,
            duration: duration,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: isSmallScreen ? 11 : 12,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(width: isSmallScreen ? 10 : 14),

          // Settings button with glass effect
          _buildSettingsButton(context, theme, isSmallScreen),
        ],
      ),
    );
  }

  /// Build modern play/pause button with glass effect
  Widget _buildPlayPauseButton(ThemeData theme, bool isSmallScreen) {
    final buttonSize = isSmallScreen ? 36.0 : 40.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(buttonSize / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPlayPause,
            borderRadius: BorderRadius.circular(buttonSize / 2),
            child: Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Icon(
                  isPlaying ? Iconsax.pause : Iconsax.play,
                  size: isSmallScreen ? 18 : 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build modern settings button with glass effect
  Widget _buildSettingsButton(
      BuildContext context, ThemeData theme, bool isSmallScreen) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showSettingsPanel(context, position: position),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : 12,
                vertical: isSmallScreen ? 6 : 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.3),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.setting_4,
                    size: isSmallScreen ? 14 : 16,
                    color: theme.colorScheme.primaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _getSettingsLabel(),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Iconsax.arrow_down_1,
                    size: isSmallScreen ? 14 : 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods to avoid repeated calculations
  String _getSourceQuality() {
    if (watchState.sources.isEmpty || watchState.selectedSourceIdx == null) {
      return 'default';
    }
    return watchState.sources[watchState.selectedSourceIdx!].quality ??
        'default';
  }

  String _getSettingsLabel() {
    final server = watchState.selectedServer ?? 'N/A';
    final category = watchState.selectedCategory ?? 'N/A';
    final quality = _getSourceQuality();

    // More compact label format
    return '$server, $category, $quality';
  }

  void _showSettingsPanel(BuildContext context, {required Duration position}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) => _SettingsPanel(
        animeProvider: animeProvider,
        watchState: watchState,
        position: position,
        onClose: () => Navigator.of(modalContext).pop(),
      ),
    ).whenComplete(() => null);
  }
}

class _TimeDisplay extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final TextStyle? style;

  const _TimeDisplay(
      {required this.position, required this.duration, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${formatDuration(position)} / ${formatDuration(duration)}',
      style: style,
    );
  }
}

/// Modern settings panel with glass-morphic design
class _SettingsPanel extends ConsumerWidget {
  final AnimeProvider animeProvider;
  final WatchState watchState;
  final Duration position;
  final VoidCallback onClose;

  const _SettingsPanel({
    required this.animeProvider,
    required this.watchState,
    required this.position,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Extract episode information
    final String episodeTitle = _getEpisodeTitle();
    final String episodeNumber = _getEpisodeNumber();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Modern header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Video Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16 : 18,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: onClose,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Iconsax.close_circle,
                          color: Colors.white.withOpacity(0.8),
                          size: isSmallScreen ? 20 : 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Episode info with modern design
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Episode badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primaryContainer.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        episodeNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // Episode title
                    Expanded(
                      child: Text(
                        episodeTitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Settings options with modern design
              _buildSettingsOptions(ref, theme, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to avoid repeated calculations
  String _getEpisodeTitle() {
    final episodeIdx = watchState.selectedEpisodeIdx ?? 0;
    if (watchState.episodes.isEmpty) {
      return 'Loading...';
    }
    return watchState.episodes[episodeIdx].title ?? 'Untitled';
  }

  String _getEpisodeNumber() {
    final episodeIdx = watchState.selectedEpisodeIdx ?? 0;
    if (watchState.episodes.isEmpty) {
      return 'EP N/A';
    }
    return 'EP ${watchState.episodes[episodeIdx].number}';
  }

  /// Build modern settings options container
  Widget _buildSettingsOptions(
      WidgetRef ref, ThemeData theme, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: _buildSettingsRows(ref, theme, isSmallScreen),
      ),
    );
  }

  /// Build settings rows with modern design
  List<Widget> _buildSettingsRows(
      WidgetRef ref, ThemeData theme, bool isSmallScreen) {
    final List<Widget> rows = [];
    final divider = Divider(color: Colors.white.withOpacity(0.1), height: 24);

    // Add category selector if supported
    if (animeProvider.getDubSubParamSupport()) {
      rows.add(
        _buildSettingsRow(
          icon: Iconsax.language_circle,
          label: 'Category',
          child: ShonenxDropdown(
            icon: Iconsax.language_circle,
            value: watchState.selectedCategory ?? 'sub',
            items: const ['dub', 'sub'],
            onChanged: (value) =>
                ref.read(watchProvider.notifier).updateCategory(value),
          ),
          theme: theme,
          isSmallScreen: isSmallScreen,
        ),
      );

      if (animeProvider.getSupportedServers().isNotEmpty &&
              animeProvider.getSupportedServers().length > 1 ||
          watchState.sources.isNotEmpty && watchState.sources.length > 1) {
        rows.add(divider);
      }
    }

    // Add server selector if multiple servers available
    if (animeProvider.getSupportedServers().isNotEmpty &&
        animeProvider.getSupportedServers().length > 1) {
      rows.add(
        _buildSettingsRow(
          icon: Iconsax.devices,
          label: 'Servers',
          child: ShonenxDropdown(
            icon: Iconsax.devices,
            value: watchState.selectedServer ?? 'Default',
            items: animeProvider.getSupportedServers(),
            onChanged: (value) =>
                ref.read(watchProvider.notifier).changeServer(value),
          ),
          theme: theme,
          isSmallScreen: isSmallScreen,
        ),
      );

      if (watchState.sources.isNotEmpty && watchState.sources.length > 1) {
        rows.add(divider);
      }
    }

    // Add source selector if multiple sources available
    if (watchState.sources.isNotEmpty && watchState.sources.length > 1) {
      rows.add(
        _buildSettingsRow(
          icon: Iconsax.cloud,
          label: 'Sources',
          child: ShonenxDropdown(
            icon: Iconsax.cloud,
            value:
                watchState.sources[watchState.selectedSourceIdx ?? 0].quality ??
                    'Default',
            items: watchState.sources
                .map((source) => source.quality ?? 'Default')
                .toList(),
            onChanged: (value) => _handleQualityChange(value, ref),
          ),
          theme: theme,
          isSmallScreen: isSmallScreen,
        ),
      );
    }

    return rows;
  }

  /// Build a single settings row with modern design
  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required Widget child,
    required ThemeData theme,
    required bool isSmallScreen,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon with accent color
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primaryContainer,
            size: isSmallScreen ? 16 : 18,
          ),
        ),
        const SizedBox(width: 12),
        // Label
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: isSmallScreen ? 13 : 14,
            ),
          ),
        ),
        // Dropdown or other control
        Expanded(child: child),
      ],
    );
  }

  void _handleQualityChange(String? value, WidgetRef ref) {
    if (value == null) return;
    final index =
        watchState.sources.indexWhere((source) => source.quality == value);
    if (index != -1) {
      ref
          .read(watchProvider.notifier)
          .changeSource(sourceIdx: index, lastPosition: position);
    }
  }
}
