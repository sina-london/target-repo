import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/providers/watch_providers.dart';

/// Modern top controls with sleek glass-morphic design
class TopControls extends ConsumerWidget {
  final WatchState watchState;
  final VoidCallback onPanelToggle;
  final VoidCallback onQualityTap;
  final VoidCallback onSubtitleTap;
  final Future<void> Function() onFullscreenTap;

  const TopControls({
    super.key,
    required this.watchState,
    required this.onPanelToggle,
    required this.onQualityTap,
    required this.onSubtitleTap,
    required this.onFullscreenTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Get screen dimensions for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    // Modern glass-morphic colors
    final glassColor = Colors.black.withOpacity(0.2);
    final accentColor = theme.colorScheme.primaryContainer;
    final textColor = Colors.white;

    // Get episode info
    final String episodeTitle = _getEpisodeTitle();
    final String? episodeNumber = _getEpisodeNumber();

    return Padding(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 8 : 12,
        right: isSmallScreen ? 8 : 12,
        top: 8,
        bottom: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and title with glass effect
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 0.5,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      _buildIconButton(
                        icon: Iconsax.arrow_left_1,
                        tooltip: 'Back',
                        onPressed: () => context.pop(),
                        isSmallScreen: isSmallScreen,
                      ),

                      SizedBox(width: isSmallScreen ? 8 : 12),

                      // Episode info
                      Flexible(
                        child: Row(
                          children: [
                            // Episode number badge
                            if (episodeNumber != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  episodeNumber,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                ),
                              ),

                            // Episode title
                            Expanded(
                              child: Text(
                                episodeTitle,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isSmallScreen ? 13 : 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: isSmallScreen ? 8 : 12),

          // Control buttons with glass effect
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: glassColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 6 : 8,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quality button
                    _buildControlButton(
                      context,
                      icon: Iconsax.video,
                      tooltip: 'Quality',
                      isEnabled: watchState.qualityOptions.isNotEmpty,
                      onPressed: onQualityTap,
                      badgeCount: watchState.qualityOptions.length,
                      isSmallScreen: isSmallScreen,
                    ),

                    SizedBox(width: isSmallScreen ? 4 : 6),

                    // Subtitles button
                    _buildControlButton(
                      context,
                      icon: Iconsax.subtitle,
                      tooltip: 'Subtitles',
                      isEnabled: watchState.subtitles.isNotEmpty,
                      onPressed: onSubtitleTap,
                      badgeCount: watchState.subtitles.length,
                      isSmallScreen: isSmallScreen,
                    ),

                    SizedBox(width: isSmallScreen ? 4 : 6),

                    // Fullscreen button
                    _buildControlButton(
                      context,
                      icon: Iconsax.maximize_4,
                      tooltip: 'Fullscreen',
                      isEnabled: true,
                      onPressed: onFullscreenTap,
                      isSmallScreen: isSmallScreen,
                    ),

                    SizedBox(width: isSmallScreen ? 4 : 6),

                    // Episodes button
                    _buildControlButton(
                      context,
                      icon: Iconsax.menu_1,
                      tooltip: 'Episodes',
                      isEnabled: true,
                      onPressed: onPanelToggle,
                      isHighlighted: true,
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a modern icon button
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isSmallScreen = false,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: isSmallScreen ? 18 : 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Helper methods to avoid repeated calculations
  String _getEpisodeTitle() {
    if (watchState.episodes.isEmpty || watchState.selectedEpisodeIdx == null) {
      return 'Loading...';
    }
    return watchState.episodes[watchState.selectedEpisodeIdx!].title ??
        'No Title';
  }

  String? _getEpisodeNumber() {
    if (watchState.episodes.isEmpty || watchState.selectedEpisodeIdx == null) {
      return null;
    }
    return 'EP ${watchState.selectedEpisodeIdx! + 1}';
  }

  /// Modern control button with glass effect
  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required bool isEnabled,
    required VoidCallback? onPressed,
    bool isHighlighted = false,
    int? badgeCount,
    bool isSmallScreen = false,
  }) {
    // Get theme colors from the build context
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primaryContainer;

    // Button size based on screen size
    final buttonSize = isSmallScreen ? 32.0 : 36.0;
    final iconSize = isSmallScreen ? 16.0 : 18.0;

    // Button colors
    final buttonColor =
        isHighlighted ? accentColor.withOpacity(0.3) : Colors.transparent;
    final iconColor = isHighlighted
        ? Colors.white
        : Colors.white.withOpacity(isEnabled ? 1.0 : 0.5);

    // Skip badge rendering if not needed
    if (badgeCount == null || badgeCount <= 0) {
      return Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ),
        ),
      );
    }

    // Use Stack for badge
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Button
        Material(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: buttonSize,
              height: buttonSize,
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),

        // Badge
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Center(
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
