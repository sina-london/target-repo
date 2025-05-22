import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/core/models/anime/anime_model.dep.dart';
import 'package:shonenx/core/registery/anime_source_registery_provider.dart';
import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/data/hive/providers/anime_watch_progress_provider.dart';
import 'package:shonenx/data/hive/providers/provider_provider.dart';
import 'package:shonenx/helpers/matcher.dart';

/// Searches for an anime match using the provided anime provider and navigates to the watch screen.
Future<void> providerAnimeMatchSearch({
  Function? beforeSearchCallback,
  Function? afterSearchCallback,
  required BuildContext context,
  required WidgetRef ref,
  required Media animeMedia,
  int plusEpisode = 0,
}) async {
  AppLogger.d('Starting anime match search for animeId: ${animeMedia.id}');
  if (beforeSearchCallback != null) beforeSearchCallback();

  try {
    final animeProvider = ref
        .read(animeSourceRegistryProvider.notifier)
        .getProvider(ref.read(providerSettingsProvider).selectedProviderName);
    if (animeProvider == null) {
      throw Exception('No anime provider selected');
    }

    final title = animeMedia.title?.english ??
        animeMedia.title?.romaji ??
        animeMedia.title?.native;
    if (title == null) {
      throw Exception('Anime title is missing');
    }

    // Perform initial search
    final searchTitle = Uri.encodeComponent(title.trim());
    final initialResponse =
        await animeProvider.getSearch(searchTitle, animeMedia.format, 1);
    if (!context.mounted) {
      AppLogger.w('Context unmounted during initial search');
      return;
    }

    if (initialResponse.results.isEmpty) {
      AppLogger.w('No search results for title: $title');
      _showErrorSnackBar(context, 'Anime Not Found',
          'We couldn\'t locate the anime with the selected provider.');
      return;
    }

    // Calculate similarity for results
    final matchedResults = initialResponse.results
        .where((result) => result.name != null && result.id != null)
        .map((result) => (
              result,
              calculateSimilarity(
                  result.name!.toLowerCase(), title.toLowerCase())
            ))
        .where((pair) => pair.$2 > 0)
        .toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    if (!context.mounted) {
      AppLogger.w('Context unmounted after similarity calculation');
      return;
    }

    // Navigate directly for high-confidence matches
    if (matchedResults.isNotEmpty && matchedResults.first.$2 >= 0.8) {
      final bestMatch = matchedResults.first.$1;
      AppLogger.d(
          'High-confidence match found: ${bestMatch.name} (ID: ${bestMatch.id})');
      _navigateToWatch(
        context: context,
        ref: ref,
        animeId: bestMatch.id!,
        animeName: bestMatch.name!,
        animeMedia: animeMedia,
        plusEpisode: plusEpisode,
      );
      return;
    }

    // Show search dialog for manual selection
    AppLogger.d('Showing anime search dialog');
    await showDialog(
      context: context,
      builder: (context) => _AnimeSearchDialog(
        initialResults: matchedResults.isEmpty
            ? initialResponse.results
            : matchedResults.map((r) => r.$1).toList(),
        animeProvider: animeProvider,
        animeMedia: animeMedia,
        plusEpisode: plusEpisode,
        initialQuery: title,
      ),
    );
  } catch (e, stackTrace) {
    AppLogger.e('Anime match search failed', e, stackTrace);
    if (context.mounted) {
      _showErrorSnackBar(
          context, 'Error', 'Failed to load anime details. Please try again.');
    }
  } finally {
    if (afterSearchCallback != null) afterSearchCallback();
  }
}

/// Shows an error snackbar with a title and message.
void _showErrorSnackBar(BuildContext context, String title, String message) {
  AppLogger.d('Showing error snackbar: $title');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: ContentType.failure,
      ),
    ),
  );
}

/// Modern dialog for searching and selecting an anime match.
class _AnimeSearchDialog extends ConsumerStatefulWidget {
  final List<BaseAnimeModel> initialResults;
  final AnimeProvider animeProvider;
  final Media animeMedia;
  final int plusEpisode;
  final String initialQuery;

  const _AnimeSearchDialog({
    required this.initialResults,
    required this.animeProvider,
    required this.animeMedia,
    required this.plusEpisode,
    required this.initialQuery,
  });

  @override
  ConsumerState<_AnimeSearchDialog> createState() => _AnimeSearchDialogState();
}

class _AnimeSearchDialogState extends ConsumerState<_AnimeSearchDialog>
    with TickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final AnimationController _searchAnimationController;
  late final AnimationController _resultsAnimationController;
  late final Animation<double> _searchFadeAnimation;
  late final Animation<double> _resultsFadeAnimation;

  List<BaseAnimeModel> _results = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    AppLogger.d('Initializing Enhanced AnimeSearchDialog');

    _searchController = TextEditingController(text: widget.initialQuery);
    _results = widget.initialResults;

    // Initialize animations
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _resultsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _searchFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _searchAnimationController, curve: Curves.easeOutQuart),
    );
    _resultsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _resultsAnimationController, curve: Curves.easeOutCubic),
    );

    // Start animations
    _searchAnimationController.forward();
    _resultsAnimationController.forward();

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    AppLogger.d('Disposing Enhanced AnimeSearchDialog');
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchAnimationController.dispose();
    _resultsAnimationController.dispose();
    super.dispose();
  }

  /// Searches for anime with improved error handling and loading states.
  Future<void> _searchAnime(String query) async {
    AppLogger.d('Searching anime with query: $query');

    if (query.isEmpty) {
      setState(() => _results = widget.initialResults);
      return;
    }

    if (query.length < 2) return; // Minimum query length

    setState(() => _isLoading = true);

    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final response = await widget.animeProvider
          .getSearch(encodedQuery, widget.animeMedia.format, 1);

      if (mounted) {
        setState(() {
          _results = response.results.where((r) => r.id != null).toList();
        });
        AppLogger.d('Search returned ${response.results.length} results');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Anime search failed', e, stackTrace);
      if (mounted) {
        _showErrorSnackBar(
          context,
          'Search Error',
          'Unable to fetch results. Please try again.',
        );
        setState(() => _results = []);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Enhanced debounced search with minimum query validation.
  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        _searchAnime(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 700),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildModernHeader(theme),
            _buildSearchStats(theme),
            Expanded(child: _buildEnhancedResults(theme)),
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  /// Modern header with glassmorphism effect and better typography.
  Widget _buildModernHeader(ThemeData theme) {
    return FadeTransition(
      opacity: _searchFadeAnimation,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 16, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.search_favorite,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Your Anime',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Search and select the correct match',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Iconsax.close_circle, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Type anime title...',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Iconsax.search_normal_1,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Iconsax.close_circle, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _results = widget.initialResults);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              style: theme.textTheme.bodyLarge,
              onChanged: _onSearchChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// Search statistics and status indicator.
  Widget _buildSearchStats(ThemeData theme) {
    if (_isLoading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Icon(
            Iconsax.info_circle,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '${_results.length} result${_results.length != 1 ? 's' : ''} found',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced results with better loading states and animations.
  Widget _buildEnhancedResults(ThemeData theme) {
    return FadeTransition(
      opacity: _resultsFadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildResultsContent(theme),
        ),
      ),
    );
  }

  Widget _buildResultsContent(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Searching anime...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.search_status,
                size: 32,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No anime found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try different search terms',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _results.length,
      separatorBuilder: (context, index) => Divider(
        color: theme.colorScheme.outlineVariant.withOpacity(0.3),
        height: 1,
      ),
      itemBuilder: (context, index) {
        return _EnhancedAnimeTile(
          anime: _results[index],
          index: index,
          onTap: () => _selectAnime(_results[index]),
        );
      },
    );
  }

  /// Action buttons with improved layout.
  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                AppLogger.d('Canceling anime search dialog');
                Navigator.of(context).pop();
              },
              icon: const Icon(Iconsax.close_circle, size: 18),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAnime(BaseAnimeModel anime) {
    AppLogger.d('Selected anime: ${anime.name} (ID: ${anime.id})');
    Navigator.of(context).pop();
    _navigateToWatch(
      context: context,
      ref: ref,
      animeId: anime.id!,
      animeName: anime.name ?? '',
      animeMedia: widget.animeMedia,
      plusEpisode: widget.plusEpisode,
    );
  }
}

/// Enhanced anime tile with better visual design and hover effects.
class _EnhancedAnimeTile extends StatefulWidget {
  final BaseAnimeModel anime;
  final int index;
  final VoidCallback onTap;

  const _EnhancedAnimeTile({
    required this.anime,
    required this.index,
    required this.onTap,
  });

  @override
  State<_EnhancedAnimeTile> createState() => _EnhancedAnimeTileState();
}

class _EnhancedAnimeTileState extends State<_EnhancedAnimeTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
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
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? theme.colorScheme.surfaceContainerHigh
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildEnhancedThumbnail(theme),
                      const SizedBox(width: 16),
                      Expanded(child: _buildEnhancedDetails(theme)),
                      _buildActionIcon(theme),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Enhanced thumbnail with better placeholders and loading states.
  Widget _buildEnhancedThumbnail(ThemeData theme) {
    return Container(
      width: 56,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: widget.anime.poster != null
            ? CachedNetworkImage(
                imageUrl: widget.anime.poster!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholder(theme),
              )
            : _buildPlaceholder(theme),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.image,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            'No\nImage',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Enhanced details with better typography and metadata display.
  Widget _buildEnhancedDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.anime.name ?? 'Unknown Title',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        if (widget.anime.releaseDate != null || widget.anime.type != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              [widget.anime.releaseDate, widget.anime.type]
                  .where((e) => e != null && e.toString().trim().isNotEmpty)
                  .join(' • '),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  /// Action icon with animation.
  Widget _buildActionIcon(ThemeData theme) {
    return AnimatedRotation(
      turns: _isHovered ? 0.1 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isHovered
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Iconsax.arrow_right_3,
          size: 16,
          color: _isHovered
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Navigates to the watch screen with the selected anime and episode.
void _navigateToWatch({
  required BuildContext context,
  required WidgetRef ref,
  required String animeId,
  required String animeName,
  required Media animeMedia,
  required int plusEpisode,
}) {
  final continueWatchingEntry = ref
      .read(animeWatchProgressProvider.notifier)
      .getMostRecentEpisodeProgressByAnimeId(animeMedia.id!);
  final encodedAnimeName = Uri.encodeComponent(animeName);
  final route = continueWatchingEntry != null
      ? '/watch/$animeId?animeName=$encodedAnimeName&episode=${continueWatchingEntry.episodeNumber + plusEpisode}&startAt=${continueWatchingEntry.progressInSeconds}'
      : '/watch/$animeId?animeName=$encodedAnimeName&episode=${1 + plusEpisode}';
  AppLogger.d('Navigating to watch screen: $route');
  context.push(route, extra: animeMedia);
}
