import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/screens/settings/source/provider_screen.dart';
import 'package:shonenx/widgets/ui/subtitle_customization_sheet.dart';

/// Ultra- top controls with dynamic glass morphism and micro-interactions
class TopControls extends ConsumerStatefulWidget {
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
  ConsumerState<TopControls> createState() => _TopControlsState();
}

class _TopControlsState extends ConsumerState<TopControls>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 600;

    // Dynamic color scheme based on time or theme
    final isDark = theme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 5 : 10,
            vertical: isCompact ? 5 : 10,
          ),
          child: Row(
            children: [
              _buildBackSection(context, isCompact, isDark),
              const SizedBox(width: 16),
              Expanded(child: _buildTitleSection(context, isCompact, isDark)),
              const SizedBox(width: 16),
              _buildControlsSection(context, isCompact, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackSection(BuildContext context, bool isCompact, bool isDark) {
    return AnimatedScale(
      scale: _pulseAnimation.value,
      duration: const Duration(milliseconds: 100),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 10 : 12),
              child: Icon(
                Iconsax.arrow_left_2,
                size: isCompact ? 20 : 22,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, bool isCompact, bool isDark) {
    final episodeTitle = _getEpisodeTitle();
    final episodeNumber = _getEpisodeNumber();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (episodeNumber != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              episodeNumber,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: isCompact ? 10 : 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        Text(
          episodeTitle,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: isCompact ? 14 : 16,
            letterSpacing: -0.2,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildControlsSection(
      BuildContext context, bool isCompact, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 6 : 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context,
            icon: Iconsax.cloud,
            isEnabled: true,
            onPressed: () =>
                showProviderSettingsBottomSheet(context, (isChanged) async {
              if (isChanged) {
                widget.onPanelToggle();
                await ref.read(watchProvider.notifier).refreshEpisodes();
              }
            }),
            isCompact: isCompact,
            isDark: isDark,
          ),
          SizedBox(width: isCompact ? 8 : 12),
          _buildButton(
            context,
            icon: Iconsax.video,
            isEnabled: widget.watchState.qualityOptions.isNotEmpty,
            onPressed: widget.onQualityTap,
            badgeCount: widget.watchState.qualityOptions.length,
            isCompact: isCompact,
            isDark: isDark,
          ),
          SizedBox(width: isCompact ? 8 : 12),
          _buildButton(
            context,
            icon: Iconsax.subtitle,
            isEnabled: widget.watchState.subtitles.isNotEmpty,
            onPressed: widget.onSubtitleTap,
            onHold: () => SubtitleCustomizationSheet.showAsModalBottomSheet(
                context: context),
            badgeCount: widget.watchState.subtitles.length,
            isCompact: isCompact,
            isDark: isDark,
          ),
          SizedBox(width: isCompact ? 8 : 12),
          _buildButton(
            context,
            icon: Iconsax.maximize_4,
            isEnabled: true,
            onPressed: widget.onFullscreenTap,
            isCompact: isCompact,
            isDark: isDark,
          ),
          SizedBox(width: isCompact ? 8 : 12),
          _buildButton(
            context,
            icon: Iconsax.menu_1,
            isEnabled: true,
            onPressed: widget.onPanelToggle,
            isHighlighted: true,
            isCompact: isCompact,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
    VoidCallback? onHold,
    bool isHighlighted = false,
    int? badgeCount,
    bool isCompact = false,
    bool isDark = true,
  }) {
    final size = isCompact ? 36.0 : 40.0;
    final iconSize = isCompact ? 18.0 : 20.0;

    final buttonColor = isHighlighted
        ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2)
        : Colors.transparent;

    final iconColor = isHighlighted
        ? Theme.of(context).colorScheme.primaryContainer
        : (isDark ? Colors.white : Colors.black87)
            .withOpacity(isEnabled ? 1.0 : 0.4);

    Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onSecondaryTap: isEnabled ? onHold : null,
          onTap: isEnabled ? onPressed : null,
          onLongPress: isEnabled ? onHold : null,
          borderRadius: BorderRadius.circular(12),
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

    if (badgeCount != null && badgeCount > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: -6,
            right: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }

  String _getEpisodeTitle() {
    if (widget.watchState.episodes.isEmpty ||
        widget.watchState.selectedEpisodeIdx == null) {
      return 'Loading...';
    }
    return widget
            .watchState.episodes[widget.watchState.selectedEpisodeIdx!].title ??
        'Untitled Episode';
  }

  String? _getEpisodeNumber() {
    if (widget.watchState.episodes.isEmpty ||
        widget.watchState.selectedEpisodeIdx == null) {
      return null;
    }
    return 'EP ${widget.watchState.selectedEpisodeIdx! + 1}';
  }
}
