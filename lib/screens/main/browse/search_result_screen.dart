import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/widgets/anime_card.dart';

class SearchResultScreen extends StatefulWidget {
  final SearchModel searchModel;
  const SearchResultScreen({super.key, required this.searchModel});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.navigate_before,
            size: 30,
          ),
        ),
        title: Text(
          "Search Results for \"${widget.searchModel.searchQuery}\"",
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // centerTitle: true,
        titleSpacing: 0,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total results and pagination info
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Total Results: ${widget.searchModel.animes.length} | Page ${widget.searchModel.currentPage} of ${widget.searchModel.totalPages}',
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),

            // Anime Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: widget.searchModel.animes.length,
                itemBuilder: (context, index) {
                  final anime = widget.searchModel.animes[index];
                  return AnimeCard(anime: anime, tag: 'search');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

