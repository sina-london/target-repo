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
      ]);

      setState(() {
        topAiring = results[0];
        popular = results[1];
        _isLoading = false;
      });
    } catch (e) {
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

  Widget _buildSection(
      {required String title,
      required List<dynamic>? items,
      required Widget Function(Map<String, dynamic>) itemBuilder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20.0),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (error != null)
          Center(child: Text(error!))
        else if (items == null || items.isEmpty)
          const Center(child: Text('No items found'))
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => itemBuilder(item)).toList(),
            ),
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
                title: 'Featured',
                items: topAiring,
                itemBuilder: (anime) => FeaturedItem(anime: anime),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              _buildSection(
                title: 'Popular',
                items: popular,
                itemBuilder: (anime) => PopularItem(anime: anime),
              ),
              const Text(
                "Continue Watching",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "UNDER CONSTRUCTION",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
