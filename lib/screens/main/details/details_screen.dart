import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/boxes/watchlist_box.dart';
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/models/info_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/utils/converter.dart';
import 'package:nekoflow/widgets/bottom_player_bar.dart';
import 'package:nekoflow/widgets/episodes_list.dart';
import 'package:nekoflow/widgets/favorite_button.dart';
import 'package:shimmer/shimmer.dart';

class DetailsScreen extends StatefulWidget {
  final String name;
  final String id;
  final String image;
  final dynamic tag;
  final String? type;

  const DetailsScreen({
    super.key,
    required this.name,
    required this.id,
    required this.image,
    required this.tag,
    this.type,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(false);
  final ValueNotifier<List<Episode>> _episodes =
      ValueNotifier<List<Episode>>([]);
  final ValueNotifier<bool> _isLoadingEpisodes = ValueNotifier<bool>(true);
  late final AnimeService _animeService;
  late final WatchlistBox? _watchlistBox;
  final ScrollController _scrollController = ScrollController();
  ContinueWatchingItem? continueWatchingItem;
  String? _nextEpisodeId;
  String? _nextEpisodeTitle;
  AnimeData? info;
  String? error;

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
    _initWatchlistBox();
    _fetchEpisodes();
  }

  Future<void> _fetchEpisodes() async {
    try {
      final episodes = await _animeService.fetchEpisodes(id: widget.id);
      if (episodes.isEmpty) _fetchEpisodes();
      if (!mounted) return;
      _episodes.value = episodes;
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        _isLoadingEpisodes.value = false;
        final Episode? nextEpisode = _getNextEpisode();
        _nextEpisodeId = nextEpisode?.episodeId;
        _nextEpisodeTitle = nextEpisode?.title;
        setState(() {});
      }
    }
  }

  Future<void> _initWatchlistBox() async {
    _watchlistBox = WatchlistBox();
    await _watchlistBox!.init();
    _loadContinueWatching();
  }

  void _loadContinueWatching() {
    continueWatchingItem = _watchlistBox!.getContinueWatchingById(widget.id);
    setState(() {});
  }

  Episode? _getNextEpisode() {
    int continueItemindex = _episodes.value.indexWhere(
        (item) => item.episodeId == continueWatchingItem?.episodeId);
    return _episodes.value[continueItemindex + 1];
  }

  Future<AnimeInfo?> fetchData() async {
    try {
      return await _animeService.fetchAnimeInfoById(id: widget.id);
    } catch (_) {
      setState(() => error = 'Network error occurred');
      return null;
    }
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 85.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.15),
              ],
            ).createShader(rect),
            blendMode: BlendMode.srcATop,
            child: Hero(
              tag: 'poster-${widget.id}-${widget.tag}',
              child: Container(
                margin: EdgeInsets.only(bottom: 60),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: info != null && widget.tag == 'spotlight'
                      ? CachedNetworkImage(
                          imageUrl: getHighResImage(info!.anime!.info!.poster),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width,
                          width: 300,
                          progressIndicatorBuilder:
                              (context, child, loadingProgress) {
                            return Shimmer.fromColors(
                              baseColor: Theme.of(context).colorScheme.primary,
                              highlightColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: Container(
                                height: 400,
                                width: 260,
                                color: Colors.grey[300],
                              ),
                            );
                          },
                          errorWidget: (_, __, ___) => Container(
                            height: 400,
                            color: Colors.grey[300],
                            child: Icon(Icons.error,
                                size: 50, color: Colors.grey[600]),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: getHighResImage(widget.image),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.width,
                          width: 300,
                          progressIndicatorBuilder:
                              (context, child, loadingProgress) {
                            return Shimmer.fromColors(
                              baseColor: Theme.of(context).colorScheme.primary,
                              highlightColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: Container(
                                height: 400,
                                color: Colors.grey[300],
                              ),
                            );
                          },
                          errorWidget: (_, __, ___) => Container(
                            height: 400,
                            color: Colors.grey[300],
                            child: Icon(Icons.error,
                                size: 50, color: Colors.grey[600]),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Hero(
                tag: 'title-${widget.id}-${widget.tag}',
                child: Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String label, String? value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2),
            child: Icon(icon,
                size: 24, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          value == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    width: 50,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
              : Text(
                  value.isEmpty ? 'N/A' : value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection({bool isLoading = false}) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildQuickInfoItem(Icons.timelapse, "Duration",
                isLoading ? null : info?.anime?.moreInfo?.duration),
            _buildQuickInfoItem(Icons.translate, "Japanese",
                isLoading ? null : info?.anime?.moreInfo?.japanese),
          ],
        ),
        const SizedBox(height: 16),
        Text('Details', style: themeData.textTheme.headlineMedium),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          // ValueListenable to handle expanded description
          valueListenable: _isDescriptionExpanded,
          builder: (_, isExpanded, __) {
            return AnimatedCrossFade(
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: themeData.textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: themeData.textTheme.bodyLarge,
              ),
            );
          },
        ),
        TextButton(
          onPressed: () =>
              _isDescriptionExpanded.value = !_isDescriptionExpanded.value,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isDescriptionExpanded,
            builder: (_, isExpanded, __) => Row(
              children: [
                Text(
                  isExpanded ? 'Show Less' : 'Show More',
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 25,
                  color: themeData.colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<Box<WatchlistModel>>(
          valueListenable: _watchlistBox!.listenable(),
          builder: (context, value, child) {
            // Rebuild episodes UI when the box changes
            continueWatchingItem =
                _watchlistBox.getContinueWatchingById(widget.id);
            return EpisodesList(
              anime: AnimeItem(
                name: widget.name,
                poster: info?.anime?.info?.poster ?? widget.image,
                id: widget.id,
                type: info?.anime?.info?.stats?.type,
              ),
              watchedEpisodes: continueWatchingItem?.watchedEpisodes,
              episodes: _episodes, // Pass the ValueNotifier directly
              isLoading: _isLoadingEpisodes, // Pass the ValueNotifier directly
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isDescriptionExpanded.dispose();
    _animeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    ThemeData themeData = Theme.of(context);

    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.horizontal,
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
          extendBody: true,
          backgroundColor: themeData.colorScheme.primary,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.secondary,
                  themeData.colorScheme.tertiary, // End color
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: FutureBuilder<AnimeInfo?>(
              future: fetchData(),
              builder: (context, snapshot) {
                final bool isLoading =
                    snapshot.connectionState == ConnectionState.waiting;
                info = snapshot.data?.data;
        
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: screenHeight * 0.6,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildHeaderSection(),
                      ),
                      actions: [
                        FavoriteButton(
                          animeId: widget.id,
                          title: widget.name,
                          image: widget.image,
                          type: widget.type,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                        ),
                        decoration: BoxDecoration(
                          color: themeData.scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: _buildDetailsSection(isLoading: isLoading),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: ValueListenableBuilder<Box<WatchlistModel>>(
            valueListenable: _watchlistBox!.listenable(),
            builder: (context, box, _) {
              // Get the continue watching item
              continueWatchingItem =
                  _watchlistBox.getContinueWatchingById(widget.id);
        
              if (continueWatchingItem == null || _episodes.value.length < 2) {
                return const SizedBox.shrink();
              }
        
              return BottomPlayerBar(
                episodes: _episodes.value,
                item: continueWatchingItem!,
                title: continueWatchingItem!.title,
                id: widget.id,
                image: widget.image,
                type: widget.type,
                nextEpisodeId: _nextEpisodeId,
                nextEpisodeTitle: _nextEpisodeTitle,
              );
            },
          ),
        ),
      ),
    );
  }
}
