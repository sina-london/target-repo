import 'package:flutter/material.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Watchlist", style: TextStyle(fontSize: 30),),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle("Recently Watched"),
            const SizedBox(height: 8),
            _buildHorizontalList([
              "Anime A",
              "Anime B",
              "Anime C",
            ]),
            const SizedBox(height: 24),
            
            _buildSectionTitle("Continue Watching"),
            const SizedBox(height: 8),
            _buildHorizontalList([
              "Anime D",
              "Anime E",
              "Anime F",
            ]),
            const SizedBox(height: 24),

            _buildSectionTitle("Favorites"),
            const SizedBox(height: 8),
            _buildHorizontalList([
              "Anime G",
              "Anime H",
              "Anime I",
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHorizontalList(List<String> items) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie,
                  size: 50,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 8),
                Text(
                  items[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}