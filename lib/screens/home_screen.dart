import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/featured_item.dart';
import 'package:nekoflow/widgets/popular_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnimeService _animeService = AnimeService();
  List<AnimeResult>? _topAiring;
  List<AnimeResult>? _favourite;
  List<AnimeResult>? _popular;
  bool _isLoading = true;
  String? error;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      List<SearchResponseModel?> results = await Future.wait([
        _animeService.fetchTopAiring(),
        _animeService.fetchPopular(),
        _animeService.fetchFavourite(),
      ]);

      setState(() {
        _topAiring = results[0]?.results;
        _popular = results[1]?.results;
        _favourite = results[2]?.results;
        _isLoading = false;
      });

      print(results);
    } catch (e) {
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

  Widget _buildContentSection({required String title}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
                Rect.fromLTWH(0.0, 0.0, 200.0,
                    70.0), // Adjust the rect size based on your needs
              ),
          ),
        ),
      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              _buildHeaderSection(),
              _buildContentSection(title: "Recommended")
            ],
          ),
        ),
      ),
    );
  }
}
