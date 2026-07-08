import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/data/hive/models/anime_watch_progress_model.dart';
import 'package:shonenx/data/hive/providers/anime_watch_progress_provider.dart';
import 'package:shonenx/widgets/anime/continue_watching/anime_continue_card.dart';
import 'package:shonenx/widgets/ui/shonenx_accordion.dart';
import 'package:shonenx/widgets/ui/shonenx_grid.dart';

class ContinueWatchingScreen extends StatelessWidget {
  const ContinueWatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Continue Watching",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.setting_4),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.sort),
            tooltip: 'Sort',
          ),
        ],
      ),
      body: _ContinueWatchingContent(),
    );
  }
}

class _ContinueWatchingContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entries =
        ref.watch(animeWatchProgressProvider.notifier).getAllEntries();

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.video_slash,
                size: 64,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Watch History',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Start watching anime episodes and they\'ll appear here for easy access',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/explore'),
              icon: const Icon(Iconsax.discover),
              label: const Text('Explore Anime'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic here
        await Future.delayed(const Duration(seconds: 1));
      },
      color: colorScheme.primary,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          // Stats section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _WatchStats(entries: entries),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 4, 12),
              child: Text(
                'Your Anime Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Main content
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = entries[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _AnimeSeriesCard(entry: entry),
                );
              },
              childCount: entries.length,
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom),
          ),
        ],
      ),
    );
  }
}

class _WatchStats extends StatelessWidget {
  final List<AnimeWatchProgressEntry> entries;

  const _WatchStats({required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate stats
    final totalSeries = entries.length;
    int totalEpisodes = 0;
    int watchedEpisodes = 0;

    for (var entry in entries) {
      totalEpisodes += entry.totalEpisodes;
      watchedEpisodes += entry.episodesProgress.entries.length;
    }

    final completionPercentage = totalEpisodes > 0
        ? (watchedEpisodes / totalEpisodes * 100).toStringAsFixed(1)
        : '0';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.chart_success,
                color: colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Watch Progress',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Iconsax.video_play,
                value: totalSeries.toString(),
                label: 'Anime',
                color: colorScheme.onPrimaryContainer,
              ),
              _StatItem(
                icon: Iconsax.video_tick,
                value: watchedEpisodes.toString(),
                label: 'Episodes',
                color: colorScheme.onPrimaryContainer,
              ),
              _StatItem(
                icon: Iconsax.percentage_circle,
                value: '$completionPercentage%',
                label: 'Complete',
                color: colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _AnimeSeriesCard extends StatelessWidget {
  final dynamic entry;

  const _AnimeSeriesCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ShonenXAccordion(
      title: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: entry.animeCover,
                  height: 70,
                  width: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: colorScheme.errorContainer,
                    child: Icon(
                      Iconsax.image,
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ),
              if (entry.episodesProgress.entries.length == entry.totalEpisodes)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.tick_circle,
                      color: colorScheme.onPrimary,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.animeTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _ProgressIndicator(
                      current: entry.episodesProgress.entries.length,
                      total: entry.totalEpisodes,
                      width: 80,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.episodesProgress.entries.length}/${entry.totalEpisodes}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      content: ShonenXGridView(
        items: entry.episodesProgress.entries.map<Widget>((episode) {
          return ContinueWatchingCard(
            anime: entry,
            episode: episode.value,
            index: episode.key,
            onTap: () {
              context.push(
                  '/watch/${entry.animeId}/${episode.value.episodeNumber}');
            },
          );
        }).toList(),
        crossAxisExtent: 320,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.8,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      ),
      isExpanded: false,
      headerColor: colorScheme.surface,
      contentColor: colorScheme.surfaceVariant.withOpacity(0.3),
      border: Border.all(
        color: colorScheme.outlineVariant,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(16.0),
      expandIcon: Iconsax.arrow_down_1,
      headerPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      contentPadding: const EdgeInsets.all(8.0),
      onExpansionChanged: (isExpanded) {
        // Handle expansion change if needed
      },
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int current;
  final int total;
  final double width;

  const _ProgressIndicator({
    required this.current,
    required this.total,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = total > 0 ? current / total : 0.0;

    return SizedBox(
      width: width,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
    );
  }
}
