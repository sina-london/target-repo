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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
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
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context)
                                              .colorScheme
                                              .primary
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
                                              .primary
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
                                      ? Theme.of(context).colorScheme.onPrimary
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
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainer.withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with range selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.surfaceContainerHigh,
                        theme.colorScheme.surfaceContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ranges.asMap().entries.map((entry) {
                              final index = entry.key;
                              final range = entry.value;
                              final isSelected =
                                  _currentStart == range['start'];

                              return AnimatedContainer(
                                duration:
                                    Duration(milliseconds: 300 + (index * 50)),
                                curve: Curves.easeOutBack,
                                margin: const EdgeInsets.only(right: 8.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _currentStart = range['start'] ?? 1;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(25),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? LinearGradient(
                                                colors: [
                                                  theme.colorScheme.primary,
                                                  theme.colorScheme.primary
                                                      .withOpacity(0.8),
                                                ],
                                              )
                                            : null,
                                        color: isSelected
                                            ? null
                                            : theme.colorScheme
                                                .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: theme
                                                      .colorScheme.primary
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        "${range['start']}-${range['end']}",
                                        style: TextStyle(
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.setting_2,
                            size: 20,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          onPressed: _showRangeSizeDialog,
                          tooltip: "Adjust Range Size",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Episodes count indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Showing ${filteredEpisodes.length} of $totalEpisodes episodes",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Episodes list
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredEpisodes.length,
                    itemBuilder: (context, index) {
                      final episode = filteredEpisodes[index];
                      final actualIndex = watchState.episodes.indexOf(episode);
                      final isSelected =
                          watchState.selectedEpisodeIdx == actualIndex;

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200 + (index * 30)),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: EpisodeTile(
                          isFiller: episode.isFiller ?? false,
                          episodeNumber: episode.number.toString(),
                          episodeTitle:
                              episode.title ?? 'Episode ${episode.number}',
                          isSelected: isSelected,
                          index: index,
                          onTap: () async {
                            await ref
                                .read(watchProvider.notifier)
                                .changeEpisode(actualIndex, withPlay: true);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EpisodeTile extends StatefulWidget {
  final bool isFiller;
  final String episodeNumber;
  final String episodeTitle;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const EpisodeTile({
    super.key,
    this.isFiller = false,
    required this.episodeNumber,
    required this.episodeTitle,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  State<EpisodeTile> createState() => _EpisodeTileState();
}

class _EpisodeTileState extends State<EpisodeTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  // late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    // _scaleAnimation = Tween<double>(
    //   begin: 1.0,
    //   end: 1.02,
    // ).animate(CurvedAnimation(
    //   parent: _hoverController,
    //   curve: Curves.easeOut,
    // ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surfaceContainerHigh,
                        theme.colorScheme.surfaceContainer,
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: widget.isFiller
                  ? Border.all(
                      color: Colors.orange.withOpacity(0.5),
                      width: 1.5,
                    )
                  : null,
              boxShadow: [
                // if (widget.isSelected || _isHovered)
                //   BoxShadow(
                //     color: widget.isSelected
                //         ? theme.colorScheme.primary.withOpacity(0.3)
                //         : Colors.black.withOpacity(0.1),
                //     blurRadius: widget.isSelected ? 12 : 8,
                //     offset: const Offset(0, 4),
                //   ),
              ],
            ),
            child: Row(
              children: [
                // Episode number circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: widget.isSelected
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.onPrimary,
                              theme.colorScheme.onPrimary.withOpacity(0.9),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.8),
                            ],
                          ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary)
                            .withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.episodeNumber,
                      style: TextStyle(
                        color: widget.isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Episode title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.episodeTitle,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: widget.isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.isFiller) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FILLER',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Play indicator
                if (widget.isSelected)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onPrimary.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Iconsax.play5,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  )
                else if (_isHovered)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.play,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
