import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:shonenx/providers/watch_providers.dart';
import 'package:shonenx/utils/formatter.dart';
import 'package:shonenx/widgets/player/seek_bar.dart';
import 'package:shonenx/widgets/ui/modern_settings_panel.dart';
import 'package:shonenx/widgets/ui/shonenx_dropdown.dart';

/// Ultra-modern bottom controls with dynamic glass morphism and micro-interactions
class BottomControls extends ConsumerStatefulWidget {
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
  ConsumerState<BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends ConsumerState<BottomControls>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _playButtonController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
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
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 600;

    // Dynamic color scheme based on theme
    final isDark = theme.brightness == Brightness.dark;
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 14 : 20,
            vertical: isCompact ? 12 : 16,
          ),
          child: Row(
            children: [
              // _buildPlayPauseSection(context, isCompact, isDark),
              // const SizedBox(width: 20),
              Expanded(child: _buildTimeSection(context, isCompact, isDark)),
              const SizedBox(width: 20),
              _buildSettingsSection(context, isCompact, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(BuildContext context, bool isCompact, bool isDark) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Consumer(
          builder: (context, ref, child) {
            return Text(
              formatDuration(widget.position),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Consumer(builder: (context, ref, child) {
            return SeekBar(
              position: widget.position,
              duration: widget.duration,
              onSeek: (value) async {
                widget.onChangeSource();
                await ref.read(playerProvider).seek(value);
              },
              theme: theme,
            );
          }),
        ),
        const SizedBox(width: 10),
        Consumer(
          builder: (context, ref, child) {
            return Text(
              formatDuration(widget.duration),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildSettingsSection(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showSettingsPanel(context, position: widget.position),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 12 : 16,
              vertical: isCompact ? 10 : 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.setting_4,
                    size: isCompact ? 14 : 16,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _getSettingsLabel(),
                    style: TextStyle(
                      fontSize: isCompact ? 11 : 12,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Iconsax.arrow_up_2,
                  size: isCompact ? 14 : 16,
                  color:
                      (isDark ? Colors.white : Colors.black87).withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSourceQuality() {
    if (widget.watchState.sources.isEmpty ||
        widget.watchState.selectedSourceIdx == null) {
      return 'Auto';
    }
    return widget
            .watchState.sources[widget.watchState.selectedSourceIdx!].quality ??
        'Auto';
  }

  String _getSettingsLabel() {
    final server = widget.watchState.selectedServer ?? 'Default';
    final category = widget.watchState.selectedCategory ?? 'Sub';
    final quality = _getSourceQuality();

    return '$server • $category • $quality';
  }

  void _showSettingsPanel(BuildContext context, {required Duration position}) {
    // Create settings rows based on available options
    final List<SettingsRowData> settingsRows = [];

    // Add category selector if supported
    if (widget.animeProvider.getDubSubParamSupport()) {
      settingsRows.add(
        SettingsRowData(
          icon: Iconsax.language_circle,
          label: 'Category',
          child: ShonenxDropdown(
            icon: Iconsax.language_circle,
            value: widget.watchState.selectedCategory ?? 'sub',
            items: const ['dub', 'sub'],
            onChanged: (value) =>
                ref.read(watchProvider.notifier).updateCategory(value),
          ),
        ),
      );
    }

    // Add server selector if multiple servers available
    if (widget.animeProvider.getSupportedServers().isNotEmpty &&
        widget.animeProvider.getSupportedServers().length > 1) {
      settingsRows.add(
        SettingsRowData(
          icon: Iconsax.devices,
          label: 'Servers',
          child: ShonenxDropdown(
            icon: Iconsax.devices,
            value: widget.watchState.selectedServer ?? 'Default',
            items: widget.animeProvider.getSupportedServers(),
            onChanged: (value) =>
                ref.read(watchProvider.notifier).changeServer(value),
          ),
        ),
      );
    }

    // Add source selector if multiple sources available
    if (widget.watchState.sources.isNotEmpty &&
        widget.watchState.sources.length > 1) {
      settingsRows.add(
        SettingsRowData(
          icon: Iconsax.cloud,
          label: 'Sources',
          child: ShonenxDropdown(
            icon: Iconsax.cloud,
            value: widget
                    .watchState
                    .sources[widget.watchState.selectedSourceIdx ?? 0]
                    .quality ??
                'Default',
            items: widget.watchState.sources
                .map((source) => source.quality ?? 'Default')
                .toList(),
            onChanged: (value) => _handleQualityChange(value, ref, position),
          ),
        ),
      );
    }

    // Get episode info for subtitle
    String subtitle = '';
    if (widget.watchState.episodes.isNotEmpty &&
        widget.watchState.selectedEpisodeIdx != null) {
      final episode =
          widget.watchState.episodes[widget.watchState.selectedEpisodeIdx!];
      subtitle = 'Episode ${episode.number}: ${episode.title ?? 'Untitled'}';
    }

    // Show the settings panel using the reusable component
    ModernSettingsPanel.showAsModalBottomSheet(
      context: context,
      title: 'Video Settings',
      titleIcon: Iconsax.setting_4,
      settingsRows: settingsRows,
      subtitle: subtitle,
    );
  }

  void _handleQualityChange(String? value, WidgetRef ref, Duration position) {
    if (value == null) return;
    final index = widget.watchState.sources
        .indexWhere((source) => source.quality == value);
    if (index != -1) {
      ref.read(watchProvider.notifier).changeSource(
            sourceIdx: index,
            lastPosition: position,
          );
    }
  }
}
