import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/boxes/watchlist_box.dart';
import 'package:nekoflow/data/models/info_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/screens/main/stream/stream_screen.dart';
import 'package:nekoflow/utils/converter.dart';
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
  late final AnimeService _animeService = AnimeService();
  late final WatchlistBox _watchlistBox;
  final ScrollController _scrollController = ScrollController();
  ContinueWatchingItem? continueWatchingItem;
  AnimeData? info;
  String? error;

  @override
  void initState() {
    super.initState();
    _initWatchlistBox();
  }

  Future<void> _initWatchlistBox() async {
    _watchlistBox = WatchlistBox();
    await _watchlistBox.init();
    _loadContinueWatching();
  }

  void _loadContinueWatching() {
    continueWatchingItem = _watchlistBox.getContinueWatchingById(widget.id);
    debugPrint("DETAIL : $continueWatchingItem");
    setState(() {});
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
              child: Text(
                widget.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String label, String? value) {
    ThemeData themeData = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, style: themeData.textTheme.labelMedium),
          const SizedBox(height: 2),
          value == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[600]!,
                  child: Container(
                    margin: EdgeInsets.only(top: 3),
                    width: 50,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
              : Text(
                  value.isEmpty ? 'N/A' : value,
                  style: themeData.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                Text(isExpanded ? 'Show Less' : 'Show More',
                    style: themeData.textTheme.bodyMedium),
                Icon(
                  Icons.arrow_drop_down,
                  size: 25,
                  color: themeData.iconTheme.color,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        EpisodesList(
          id: widget.id,
          name: widget.name,
          poster: info?.anime?.info?.poster ?? widget.image,
          type: info?.anime?.info?.stats?.type ?? 'N/A',
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

    return Scaffold(
      extendBody: true,
      backgroundColor: themeData.colorScheme.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeData.colorScheme.surface,
              themeData.colorScheme.primary,
              themeData.colorScheme.secondary, // End color
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
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.navigate_before,
                      size: 40,
                    ),
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
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
        valueListenable: _watchlistBox.listenToContinueWatching(),
        builder: (context, box, _) {
          // Get the continue watching item
          continueWatchingItem =
              _watchlistBox.getContinueWatchingById(widget.id);

          if (continueWatchingItem == null) {
            return const SizedBox.shrink();
          }

          return BottomAppBar(
            height: 100,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: themeData.colorScheme.tertiary.withOpacity(0.2),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      title: Text(
                        "Episode : ${continueWatchingItem!.episode}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        continueWatchingItem!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StreamScreen(
                                name: continueWatchingItem!.name,
                                title: widget.name,
                                id: widget.id,
                                episodeId: continueWatchingItem!.episodeId,
                                poster: widget.image,
                                episode: continueWatchingItem!.episode,
                                type: widget.type),
                          ),
                        ),
                        icon: TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            "${continueWatchingItem!.timestamp.split(':')[0]}:${continueWatchingItem!.timestamp.split(':')[1]}",
                            style: themeData.textTheme.labelMedium,
                          ),
                          icon: Icon(Icons.play_circle),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
