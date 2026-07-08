import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nekoflow/data/models/anime_interface.dart';
import 'package:nekoflow/data/models/anime_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/anime_card.dart';
import 'package:nekoflow/widgets/snapping_scroll.dart';

class HomeScreen extends StatefulWidget {
  static const double _horizontalPadding = 20.0;
  static const double _sectionSpacing = 50.0;
  
  final String userName;
  
  const HomeScreen({
    super.key, 
    this.userName = 'Guest'
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnimeService _animeService = AnimeService();
  
  List<TopAiringAnime> _topAiring = [];
  List<LatestCompletedAnime> _completed = [];
  List<MostPopularAnime> _popular = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _animeService.fetchHome();
      if (!mounted) return;
      
      setState(() {
        _topAiring = results.data.topAiringAnimes;
        _popular = results.data.mostPopularAnimes;
        _completed = results.data.latestCompletedAnimes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = 'Something went wrong';
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
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold
            ),
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

  Widget _buildShimmerLoading(ThemeData theme) {
    final screenSize = MediaQuery.of(context).size;
    
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.primary,
      highlightColor: theme.colorScheme.secondary,
      child: SizedBox(
        height: screenSize.height * 0.25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          padding: EdgeInsets.zero,
          itemBuilder: (_, __) => Container(
            height: double.infinity,
            width: screenSize.width * 0.4,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildContentSection({
    required String title,
    required List<Anime> animeList,
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
            ? _buildShimmerLoading(theme)
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
            horizontal: HomeScreen._horizontalPadding
          ),
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