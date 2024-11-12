import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nekoflow/data/models/anime_interface.dart';
import 'package:nekoflow/data/models/anime_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/anime_card.dart';
import 'package:nekoflow/widgets/snapping_scroll.dart';

class HomeScreen extends StatefulWidget {
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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _animeService.fetchHome();
      if (mounted) {
        setState(() {
          _topAiring = results.data.topAiringAnimes;
          _popular = results.data.mostPopularAnimes;
          _completed = results.data.latestCompletedAnimes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Something went wrong';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animeService.dispose();
    super.dispose();
  }

  Widget _buildHeaderSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello ${widget.userName}, What's on your mind today?",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Find your favourite anime and \nwatch it right away",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    final screenSize = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      child: SizedBox(
        height: screenSize.height * 0.25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Container(
            height: double.infinity,
            width: screenSize.width * 0.4,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection({
    required String title,
    required List<Anime> animeList,
    required String tag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 10),
        _isLoading
            ? _buildShimmerLoading()
            : SnappingScroller(
                widthFactor: 0.48,
                children: animeList
                    .map((anime) => AnimeCard(anime: anime, tag: tag))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              _buildHeaderSection(),
              _buildContentSection(
                title: "Recommended",
                animeList: _popular,
                tag: "recommended",
              ),
              const SizedBox(height: 50),
              _buildContentSection(
                title: "Top Airing",
                animeList: _topAiring,
                tag: "topairing",
              ),
              const SizedBox(height: 50),
              _buildContentSection(
                title: "Latest Completed",
                animeList: _completed,
                tag: "latestcompleted",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
