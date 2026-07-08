import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nekoflow/data/models/info_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/episodes_list.dart';
import 'package:nekoflow/widgets/favorite_button.dart';
import 'package:shimmer/shimmer.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String id;
  final String image;
  final String type;
  final dynamic tag;

  const DetailsScreen({
    super.key,
    required this.title,
    required this.id,
    required this.image,
    required this.tag,
    this.type = 'N/A'
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(false);
  late final AnimeService _animeService = AnimeService();
  late final Box<WatchlistModel> _watchlistBox;
  final ScrollController _scrollController = ScrollController();
  AnimeData? info;
  String? error;

  Future<AnimeInfo?> fetchData() async {
    try {
      return await _animeService.fetchAnimeInfoById(id: widget.id);
    } catch (_) {
      setState(() {
        error = 'Network error occurred';
      });
      return null;
    }
  }

  Future<void> _toggleFavorite() async {
    final watchlist = _watchlistBox.get('favorites') ??
        WatchlistModel(
          recentlyWatched: [],
          continueWatching: [],
          favorites: [],
        );

    final newItem = AnimeItem(
      name: widget.title,
      poster: widget.image,
      id: widget.id,
      type: info?.anime?.info?.stats?.type ?? 'N/A',
    );

    var favourites = watchlist.favorites ?? [];

    // If the item is already in the favorites list, remove it
    if (favourites.any((item) => item.id == newItem.id)) {
      favourites.removeWhere((item) => item.id == newItem.id);
    } else {
      // If the item is not in the list, add it
      favourites = [
        newItem,
        ...favourites
            .where((item) => item.id != newItem.id), // Avoid duplicates
      ].take(10).toList();
    }

    // Update the favorites list in the watchlist
    watchlist.favorites = favourites;

    // Save the updated watchlist
    await _watchlistBox.put('favorites', watchlist);

    // Trigger UI update
    setState(() {});
  }

  bool _checkFavourites() {
    final watchlist = _watchlistBox.get('favorites') ??
        WatchlistModel(
          recentlyWatched: [],
          continueWatching: [],
          favorites: [],
        );

    var favourites = watchlist.favorites ?? [];

    bool exists = favourites.any((anime) => anime.id == widget.id);
    return exists;
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 85.0),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color.fromARGB(255, 44, 41, 41),
                Colors.black.withOpacity(0.2),
                const Color.fromARGB(0, 178, 30, 30),
              ],
            ).createShader(rect),
            blendMode: BlendMode.srcATop,
            child: Hero(
              tag: 'poster-${widget.id}-${widget.tag}',
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 400,
                      color: Colors.grey[300],
                      child:
                          Icon(Icons.error, size: 50, color: Colors.grey[600]),
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
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                  ),
                ],
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
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 2),
          value == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[600]!,
                  child: Container(
                    width: 50,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
              : Text(
                  value.isEmpty ? 'N/A' : value,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection({bool isLoading = false}) {
    ThemeData _themeContext = Theme.of(context);
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildQuickInfoItem(Icons.timelapse, "Duration", null),
              _buildQuickInfoItem(Icons.translate, "Translate", null),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Details',
            style: _themeContext.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 16,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 16,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildQuickInfoItem(
              Icons.timelapse,
              "Duration",
              info?.anime?.moreInfo?.duration,
            ),
            _buildQuickInfoItem(
              Icons.translate,
              "Translate",
              info?.anime?.moreInfo?.japanese,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Details',
          style: _themeContext.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: _isDescriptionExpanded,
          builder: (context, isExpanded, child) {
            return AnimatedCrossFade(
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: _themeContext.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: _themeContext.textTheme.bodyMedium,
              ),
            );
          },
        ),
        TextButton(
          onPressed: () =>
              _isDescriptionExpanded.value = !_isDescriptionExpanded.value,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isDescriptionExpanded,
            builder: (context, isExpanded, child) {
              return Text(isExpanded ? 'Show Less' : 'Show More', style: _themeContext.textTheme.labelMedium,);
            },
          ),
        ),
        const SizedBox(height: 10),
        EpisodesList(
          id: widget.id,
          title: widget.title,
          poster: widget.image,
          type: info?.anime?.info?.stats?.type ?? 'N/A',
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _watchlistBox = Hive.box<WatchlistModel>('user_watchlist');
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
    return Scaffold(
      extendBody: true,
      body: FutureBuilder<AnimeInfo?>(
        future: fetchData(),
        builder: (context, snapshot) {
          final bool isLoading =
              snapshot.connectionState == ConnectionState.waiting;
          info = snapshot.data?.data;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: screenHeight * 0.6,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.navigate_before,
                    size: 40,
                  ),
                ),
                stretch: true,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeaderSection(),
                ),
                actions: [
                  FavoriteButton(
                    animeId: widget.id,
                    title: widget.title,
                    image: widget.image,
                    type: widget.type,
                  ),
                  SizedBox(width: 10)
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Theme.of(context).cardColor,
                  child: _buildDetailsSection(isLoading: isLoading),
                ),
              ),
            ],
          );
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   height: 100,
      //   color: Colors.transparent,
      //   child: ClipRect(
      //     child: BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(
      //               0.2), // Semi-transparent color for frosted effect
      //           borderRadius:
      //               BorderRadius.circular(15), // Optional: rounded corners
      //         ),
      //         padding: const EdgeInsets.symmetric(
      //             horizontal: 15.0), // Adjust padding as needed
      //         child: Center(
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text(
      //                       widget.title,
      //                       style: TextStyle(
      //                           fontSize: 18, overflow: TextOverflow.ellipsis),
      //                     ),
      //                     Text('Episode 1')
      //                   ],
      //                 ),
      //               ),
      //               Container(
      //                 child: Icon(
      //                   Icons.play_circle_sharp,
      //                   size: 35,
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
