import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/providers/watch_providers.dart';

class EpisodesPanel extends ConsumerStatefulWidget {
  final String animeId;
  const EpisodesPanel({super.key, required this.animeId});

  @override
  ConsumerState<EpisodesPanel> createState() => _EpisodesPanelState();
}

class _EpisodesPanelState extends ConsumerState<EpisodesPanel>
    with TickerProviderStateMixin {
  int _rangeSize = 50;
  int _currentStart = 1;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, int>> _generateRanges(int totalEpisodes, int rangeSize) {
    final ranges = <Map<String, int>>[];
    for (int start = 1; start <= totalEpisodes; start += rangeSize) {
      final end = (start + rangeSize - 1).clamp(0, totalEpisodes);
      ranges.add({'start': start, 'end': end});
      if (end >= totalEpisodes) break;
    }
    return ranges;
  }

  void _showRangeSizeDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceContainerHigh,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.setting_2,
                      size: 24,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Episode Range Size",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose how many episodes to display at once",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: [10, 25, 50, 100].map((size) {
                      final isSelected = _rangeSize == size;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _rangeSize = size;
                                _currentStart = 1;
                              });
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withOpacity(0.8),
                                        ],
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(20),
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.3),
                                      ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                "$size",
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final watchState = ref.watch(watchProvider);
    final totalEpisodes = watchState.episodes.length;
    final ranges = _generateRanges(totalEpisodes, _rangeSize);

    final filteredEpisodes = watchState.episodes.where((episode) {
      final epNumber = int.tryParse(episode.number.toString()) ?? 0;
      return epNumber >= _currentStart &&
          epNumber <= (_currentStart + _rangeSize - 1);
    }).toList();

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ranges.map((range) {
                            final isSelected = _currentStart == range['start'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _currentStart = range['start'] ?? 1;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${range['start']}-${range['end']}",
                                    style: TextStyle(
                                      color: isSelected
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurfaceVariant,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Iconsax.setting_2, size: 18),
                      onPressed: _showRangeSizeDialog,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Simple episode count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  "${filteredEpisodes.length} of $totalEpisodes episodes",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Compact episodes list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: filteredEpisodes.length,
                  itemBuilder: (context, index) {
                    final episode = filteredEpisodes[index];
                    final actualIndex = watchState.episodes.indexOf(episode);
                    final isSelected =
                        watchState.selectedEpisodeIdx == actualIndex;

                    return CompactEpisodeTile(
                      isFiller: episode.isFiller ?? false,
                      episodeNumber: episode.number.toString(),
                      episodeTitle:
                          episode.title ?? 'Episode ${episode.number}',
                      isSelected: isSelected,
                      onTap: () async {
                        await ref
                            .read(watchProvider.notifier)
                            .changeEpisode(actualIndex, withPlay: true);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompactEpisodeTile extends StatefulWidget {
  final bool isFiller;
  final String episodeNumber;
  final String episodeTitle;
  final bool isSelected;
  final VoidCallback onTap;

  const CompactEpisodeTile({
    super.key,
    this.isFiller = false,
    required this.episodeNumber,
    required this.episodeTitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CompactEpisodeTile> createState() => _CompactEpisodeTileState();
}

class _CompactEpisodeTileState extends State<CompactEpisodeTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.8)
                : _isHovered
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
                    : null,
            borderRadius: BorderRadius.circular(8),
            border: widget.isFiller
                ? Border.all(
                    color: Colors.orange.withOpacity(0.4),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              // Compact episode number
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    widget.episodeNumber,
                    style: TextStyle(
                      color: widget.isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Episode title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.episodeTitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.isFiller) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'FILLER',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Simple play indicator
              if (widget.isSelected)
                Icon(
                  Iconsax.play5,
                  size: 16,
                  color: theme.colorScheme.primary,
                )
              else if (_isHovered)
                Icon(
                  Iconsax.play,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
