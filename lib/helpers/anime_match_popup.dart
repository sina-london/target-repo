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

/// Dialog for searching and selecting an anime match.
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

class _AnimeSearchDialogState extends ConsumerState<_AnimeSearchDialog> {
  late final TextEditingController _searchController;
  List<BaseAnimeModel> _results = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    AppLogger.d('Initializing AnimeSearchDialog');
    _searchController = TextEditingController(text: widget.initialQuery);
    _results = widget.initialResults;
  }

  @override
  void dispose() {
    AppLogger.d('Disposing AnimeSearchDialog');
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Searches for anime based on the provided query.
  Future<void> _searchAnime(String query) async {
    AppLogger.d('Searching anime with query: $query');
    if (query.isEmpty) {
      setState(() => _results = widget.initialResults);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final encodedQuery = Uri.encodeComponent(query.trim());
      final response = await widget.animeProvider
          .getSearch(encodedQuery, widget.animeMedia.format, 1);
      setState(() =>
          _results = response.results.where((r) => r.id != null).toList());
      AppLogger.d('Search returned ${response.results.length} results');
    } catch (e, stackTrace) {
      AppLogger.e('Anime search failed', e, stackTrace);
      if (mounted) {
        _showErrorSnackBar(
            context, 'Search Error', 'Failed to fetch search results.');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Debounces search input to prevent excessive API calls.
  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _searchAnime(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme),
            const Divider(height: 1),
            _buildResults(theme),
            const Divider(height: 1),
            _buildCancelButton(theme),
          ],
        ),
      ),
    );
  }

  /// Builds the dialog header with search bar.
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Anime',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle, size: 24),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search anime...',
              prefixIcon: const Icon(Iconsax.search_normal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerLowest,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            ),
            onChanged: _onSearchChanged,
          ),
        ],
      ),
    );
  }

  /// Builds the results list or loading/empty state.
  Widget _buildResults(ThemeData theme) {
    return Flexible(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(
                  child:
                      Text('No results found', style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return _AnimeTile(
                      anime: result,
                      onTap: () {
                        AppLogger.d(
                            'Selected anime: ${result.name} (ID: ${result.id})');
                        Navigator.of(context).pop();
                        _navigateToWatch(
                          context: context,
                          ref: ref,
                          animeId: result.id!,
                          animeName: result.name ?? '',
                          animeMedia: widget.animeMedia,
                          plusEpisode: widget.plusEpisode,
                        );
                      },
                    );
                  },
                ),
    );
  }

  /// Builds the cancel button.
  Widget _buildCancelButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          AppLogger.d('Canceling anime search dialog');
          Navigator.of(context).pop();
        },
        child: Text(
          'Cancel',
          style: TextStyle(fontSize: 16, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

/// Displays an anime tile with thumbnail, title, and details.
class _AnimeTile extends StatelessWidget {
  final BaseAnimeModel anime;
  final VoidCallback onTap;

  const _AnimeTile({required this.anime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Thumbnail
            _buildThumbnail(theme),
            const SizedBox(width: 12),
            // Title and Details
            _buildDetails(theme),
            const Icon(Iconsax.arrow_right_3, size: 20),
          ],
        ),
      ),
    );
  }

  /// Builds the anime thumbnail or placeholder.
  Widget _buildThumbnail(ThemeData theme) {
    if (anime.poster == null) {
      return Container(
        width: 50,
        height: 70,
        color: theme.colorScheme.surfaceContainerHighest,
        child: const Icon(Iconsax.image, size: 20),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: anime.poster!,
        width: 50,
        height: 70,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 50,
          height: 70,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          width: 50,
          height: 70,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Icon(Iconsax.image, size: 20),
        ),
      ),
    );
  }

  /// Builds the anime title and details.
  Widget _buildDetails(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            anime.name ?? 'Unknown',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (anime.releaseDate != null || anime.type != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                [anime.releaseDate, anime.type]
                    .where((e) => e != null)
                    .join(' • '),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
        ],
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
