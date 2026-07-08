import 'package:flutter/material.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/featured_item.dart';
import 'package:nekoflow/widgets/popular_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AnimeService _animeService = AnimeService();
  List<dynamic>? topAiring;
  List<dynamic>? movies;
  List<dynamic>? popular;
  bool _isLoading = true;
  String? error;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      final results = await Future.wait([
        _animeService.fetchTopAiring(),
        _animeService.fetchPopular(),
        _animeService.fetchMovies(),
      ]);

      setState(() {
        topAiring = results[0];
        popular = results[1];
        movies = results[2];
        _isLoading = false;
      });
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

  Widget _buildSection(
      {required String title,
      required List<dynamic>? items,
      required Widget Function(Map<String, dynamic>) itemBuilder,
      bool featured = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != "")
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 10.0),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (error != null)
          Center(child: Text(error!))
        else if (items == null || items.isEmpty)
          const Center(child: Text('No items found'))
        else
          featured
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items.map((item) => itemBuilder(item)).toList(),
                  ),
                )
              : GridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          MediaQuery.of(context).size.width * 0.5,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 2 / 4),
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: items.map((anime) => itemBuilder(anime)).toList(),
                )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              _buildSection(
                  title: '',
                  items: topAiring,
                  itemBuilder: (anime) => FeaturedItem(anime: anime),
                  featured: true),
              _buildSection(
                title: 'Popular',
                items: popular,
                itemBuilder: (anime) => PopularItem(anime: anime),
              ),
              _buildSection(
                  title: 'Movies',
                  items: movies,
                  itemBuilder: (anime) => PopularItem(anime: anime))
            ],
          ),
        ),
      ),
    );
  }
}
