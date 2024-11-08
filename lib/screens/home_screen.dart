import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nekoflow/data/models/anime_interface.dart';
import 'package:nekoflow/data/models/anime_model.dart';
import 'package:nekoflow/data/models/home_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/anime_card.dart';
import 'package:nekoflow/widgets/snapping_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnimeService _animeService = AnimeService();
  List<TopAiringAnime> _topAiring = [];
  List<LatestCompletedAnime> _completed = [];
  List<MostPopularAnime> _popular = [];
  bool _isLoading = true;
  String? error;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      HomeModel results = await _animeService.fetchHome();

      setState(() {
        _topAiring = results.data.topAiringAnimes;
        _popular = results.data.mostPopularAnimes;
        _completed = results.data.latestCompletedAnimes;
        _isLoading = false;
      });
    } catch (e) {
      print("error fetching: $e");
      if (!mounted) return;
      setState(() {
        error = 'Something went wrong';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
          children: const <Widget>[
            Text(
              "Sup Man, Whats on your mind today?",
              style: TextStyle(
                  fontSize: 35, fontWeight: FontWeight.bold, letterSpacing: 0),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Find your favourite anime and \nwatch it right away",
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
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
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.white!,
      child: SizedBox(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Placeholder count
          itemBuilder: (context, index) {
            return Container(
              height: double.infinity,
              width: screenSize.width * 0.4,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentSection(
      {required String title,
      required List<Anime> animeList,
      required dynamic tag}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title: title),
        SizedBox(height: 10),
        SnappingScroller(
          widthFactor: 0.48,
          children: _isLoading
              ? [
                  _buildShimmerLoading(),
                  _buildShimmerLoading(),
                  _buildShimmerLoading()
                ]
              : animeList
                  .map((anime) => AnimeCard(anime: anime, tag: tag))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle({required String title}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [
              const Color.fromARGB(255, 209, 161, 251),
              Color.fromARGB(255, 221, 105, 251),
            ],
          ).createShader(
            Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              _buildHeaderSection(),
              _buildContentSection(
                  title: "Recommended",
                  animeList: _popular,
                  tag: "recommended"),
              SizedBox(height: 50),
              _buildContentSection(
                  title: "Top Airing", animeList: _topAiring, tag: "topairing"),
              SizedBox(height: 50),
              _buildContentSection(
                  title: "Latest Completed",
                  animeList: _completed,
                  tag: "latestcompleted"),
            ],
          ),
        ),
      ),
    );
  }
}
