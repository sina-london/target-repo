// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
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
              "Sup Man, Whats on\nyour mind today?",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 0),
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

  Widget _buildContentSection(
      {required String title, required List<Anime> animeList}) {
    return !_isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(title: title),
              SizedBox(height: 10),
              SnappingScroller(
                widthFactor: 0.48,
                children: animeList.map((anime) => AnimeCard(anime: anime)).toList(),
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildSectionTitle({required String title}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [
              Color.fromARGB(255, 94, 96, 206),
              Color.fromARGB(255, 83, 144, 217),
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
              _buildContentSection(title: "Recommended", animeList: _popular),
              SizedBox(height: 50),
              _buildContentSection(title: "Top Airing", animeList: _topAiring),
              SizedBox(height: 50),
              _buildContentSection(title: "Latest Completed", animeList: _completed),
            ],
          ),
        ),
      ),
    );
  }
}
