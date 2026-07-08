import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart'
    as anilist_media;
import 'package:shonenx/data/hive/models/anime_watch_progress_model.dart';
import 'package:shonenx/helpers/anime_match_popup.dart';

final loadingProvider = StateProvider.family<bool, int>((ref, index) => false);

class ContinueWatchingCard extends ConsumerWidget {
  final AnimeWatchProgressEntry anime;
  final EpisodeProgress episode;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final bool multiSelectMode;

  const ContinueWatchingCard({
    super.key,
    required this.anime,
    required this.episode,
    required this.index,
    this.isSelected = false,
    required this.onTap,
    this.multiSelectMode = false,
  });

  String _formatRemainingTime(int current, int total) {
    final remaining = (total - current).clamp(0, double.infinity) ~/ 60;
    return remaining > 0 ? '$remaining min left' : 'Completed';
  }

  double _calculateProgress() {
    final duration = episode.durationInSeconds ?? 1;
    return (episode.progressInSeconds ?? 0) / duration;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme management
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Progress calculation
    final progress = _calculateProgress().clamp(0.0, 1.0);
    final remainingTime = _formatRemainingTime(
      episode.progressInSeconds ?? 0,
      episode.durationInSeconds ?? 0,
    );

    // Loading state
    final isLoading = ref.watch(loadingProvider(index));

    // Media
    final memoryImage = episode.episodeThumbnail != null
        ? base64Decode(episode.episodeThumbnail!)
        : null;

    return GestureDetector(
      onTap: multiSelectMode ? onTap : () => _handleTap(context, ref),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail
            _buildThumbnail(memoryImage, colorScheme),

            // Gradient overlay
            _buildGradientOverlay(colorScheme),

            // Card content
            _buildCardContent(context, ref, theme, colorScheme, textTheme,
                remainingTime, progress, isLoading),

            // Multi-select overlay
            if (multiSelectMode) _buildMultiSelectOverlay(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(Uint8List? memoryImage, ColorScheme colorScheme) {
    return memoryImage != null
        ? Image.memory(
            memoryImage,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _ImageFallback(colorScheme: colorScheme),
          )
        : CachedNetworkImage(
            imageUrl: anime.animeCover,
            fit: BoxFit.cover,
            memCacheHeight: 150 ~/ 1,
            memCacheWidth: 280 ~/ 1,
            placeholder: (_, __) => _ImagePlaceholder(colorScheme: colorScheme),
            errorWidget: (_, __, ___) =>
                _ImageFallback(colorScheme: colorScheme),
          );
  }

  Widget _buildGradientOverlay(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.8),
          ],
          stops: const [0.4, 0.75, 1.0],
        ),
      ),
    );
  }

  Widget _buildCardContent(
      BuildContext context,
      WidgetRef ref,
      ThemeData theme,
      ColorScheme colorScheme,
      TextTheme textTheme,
      String remainingTime,
      double progress,
      bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Episode info
          Row(
            children: [
              _EpisodeTag(
                episode: episode.episodeNumber,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(width: 8),
              if (episode.episodeTitle.isNotEmpty &&
                  episode.episodeTitle != 'Unknown')
                Expanded(
                  child: Text(
                    episode.episodeTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Anime title
          Text(
            anime.animeTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 16,
              height: 1.2,
              letterSpacing: -0.3,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Progress bar and details row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar with indicator
              Stack(
                children: [
                  // Background bar
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // Progress bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    height: 4,
                    width: progress * (280 - 24), // Full width minus padding
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color:
                              colorScheme.secondaryContainer.withOpacity(0.4),
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Time and action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Format and time remaining
                  Expanded(
                    child: Row(
                      children: [
                        _FormatTag(
                          format: anime.animeFormat,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            remainingTime,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play button
                  if (!multiSelectMode)
                    _ActionButton(
                      isLoading: isLoading,
                      isCompleted: episode.isCompleted,
                      colorScheme: colorScheme,
                      onPressed: () => _handleTap(
                        context,
                        ref,
                        plusEpisode: 0,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectOverlay(ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withOpacity(0.4)
            : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isSelected
          ? Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  Future<void> _handleTap(BuildContext context, WidgetRef ref,
      {int plusEpisode = 0}) async {
    ref.read(loadingProvider(index).notifier).state = true;
    await providerAnimeMatchSearch(
      context: context,
      ref: ref,
      animeMedia: anilist_media.Media(
        id: anime.animeId,
        title: anilist_media.Title(
            english: anime.animeTitle,
            romaji: anime.animeTitle,
            native: anime.animeTitle),
        coverImage: anilist_media.CoverImage(
            large: anime.animeCover, medium: anime.animeCover),
        format: anime.animeFormat,
      ),
    );
    ref.read(loadingProvider(index).notifier).state = false;
  }
}

class _EpisodeTag extends StatelessWidget {
  final int episode;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _EpisodeTag({
    required this.episode,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primaryContainer.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        'EP $episode',
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _FormatTag extends StatelessWidget {
  final String format;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FormatTag({
    required this.format,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        format,
        style: textTheme.labelSmall?.copyWith(
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isLoading;
  final bool isCompleted;
  final ColorScheme colorScheme;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.isLoading,
    required this.isCompleted,
    required this.colorScheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(24),
      elevation: 2,
      shadowColor: colorScheme.primaryContainer.withOpacity(0.5),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: isLoading
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimaryContainer,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompleted ? Iconsax.repeat : Iconsax.play,
                      size: 14,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCompleted ? 'Rewatch' : 'Play',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ImagePlaceholder({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorScheme.primaryContainer,
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ImageFallback({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_rounded,
              size: 28,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
