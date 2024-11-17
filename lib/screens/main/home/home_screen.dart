import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/screens/main/details/details_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nekoflow/data/models/anime_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/anime_card.dart';
import 'package:nekoflow/widgets/snapping_scroll.dart';

class HomeScreen extends StatefulWidget {
  static const double _horizontalPadding = 20.0;
  static const double _sectionSpacing = 50.0;

  final String userName;

  const HomeScreen({super.key, this.userName = 'Guest'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnimeService _animeService = AnimeService();

  List<TopAiringAnime> _topAiring = [];
  List<LatestCompletedAnime> _completed = [];
  List<MostPopularAnime> _popular = [];
  List<SpotlightAnime> _spotlight = [];
  bool _isLoading = true;
  // String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      // _error = null;
    });

    try {
      final results = await _animeService.fetchHome();
      if (!mounted) return;

      setState(() {
        _spotlight = results.data.spotlightAnimes;
        _topAiring = results.data.topAiringAnimes;
        _popular = results.data.mostPopularAnimes;
        _completed = results.data.latestCompletedAnimes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        // _error = 'Something went wrong';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animeService.dispose();
    super.dispose();
  }

  Widget _buildHeaderSection(ThemeData theme) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hello ${widget.userName}, What's on your mind today?",
            style: theme.textTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Find your favourite anime and \nwatch it right away",
            style: TextStyle(color: theme.colorScheme.secondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(ThemeData theme, double factor) {
    final screenSize = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.primary.withOpacity(0.5),
      highlightColor: theme.colorScheme.secondary,
      child: SizedBox(
        height: screenSize.width * 0.6,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          padding: EdgeInsets.zero,
          itemBuilder: (_, __) => Container(
            height: double.infinity,
            width: screenSize.width * factor,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSpotlightSection({
    required String title,
    required List<SpotlightAnime> animeList,
    required String tag,
    required ThemeData theme,
  }) {
    if (animeList.isEmpty && !_isLoading) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
        ],
        _isLoading
            ? _buildShimmerLoading(theme, 0.9)
            : SnappingScroller(
                widthFactor: 1,
                children: animeList
                    .map((anime) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                  name: anime.name,
                                  id: anime.id,
                                  image: anime.poster,
                                  tag: tag),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(anime.poster),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.surface,
                                    Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(0.1),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    anime.name,
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    anime.description,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
      ],
    );
  }

  Widget? _buildContentSection({
    required String title,
    required List<BaseAnimeCard> animeList,
    required String tag,
    required ThemeData theme,
  }) {
    if (animeList.isEmpty && !_isLoading) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        _isLoading
            ? _buildShimmerLoading(theme, 0.4)
            : SnappingScroller(
                widthFactor: 0.48,
                children: animeList
                    .map((anime) => AnimeCard(anime: anime, tag: tag))
                    .toList(),
              ),
      ],
    );
  }

  List<Widget> _buildContentSections(ThemeData theme) {
    final sections = <Widget>[];
    Widget? section;

    // Spotlight Section
    section = _buildSpotlightSection(
      title: "",
      animeList: _spotlight,
      tag: "spotlight",
      theme: theme,
    );
    if (section != null) {
      sections.add(section);
      sections.add(const SizedBox(height: HomeScreen._sectionSpacing));
    }

    // Popular Section
    section = _buildContentSection(
      title: "Popular",
      animeList: _popular,
      tag: "popular",
      theme: theme,
    );
    if (section != null) {
      sections.add(section);
      sections.add(const SizedBox(height: HomeScreen._sectionSpacing));
    }

    // Top Airing Section
    section = _buildContentSection(
      title: "Top Airing",
      animeList: _topAiring,
      tag: "topairing",
      theme: theme,
    );
    if (section != null) {
      sections.add(section);
      sections.add(const SizedBox(height: HomeScreen._sectionSpacing));
    }

    // Latest Completed Section
    section = _buildContentSection(
      title: "Latest Completed",
      animeList: _completed,
      tag: "latestcompleted",
      theme: theme,
    );
    if (section != null) {
      sections.add(section);
    }

    // Remove last spacing if it exists
    if (sections.isNotEmpty && sections.last is SizedBox) {
      sections.removeLast();
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: HomeScreen._horizontalPadding),
          child: ListView(
            children: [
              _buildHeaderSection(theme),
              ..._buildContentSections(theme),
            ],
          ),
        ),
      ),
    );
  }
}
