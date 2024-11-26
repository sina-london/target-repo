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
  // Add a state variable to track the current layout
  bool _isGridLayout = true;

  // Toggle layout method
  void _toggleLayout() {
    setState(() {
      _isGridLayout = !_isGridLayout;
    });
  }

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
        actions: [
          // Layout toggle button
          IconButton(
            icon: Icon(_isGridLayout ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleLayout,
            tooltip: _isGridLayout ? 'Switch to List View' : 'Switch to Grid View',
          ),
        ],
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

            // Conditional rendering based on layout
            Expanded(
              child: _isGridLayout 
                ? _buildGridView(themeData)
                : _buildListView(themeData),
            ),
          ],
        ),
      ),
    );
  }

  // Grid View Builder
  Widget _buildGridView(ThemeData themeData) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.searchModel.animes.length,
      itemBuilder: (context, index) {
        final anime = widget.searchModel.animes[index];
        return AnimeCard(anime: anime, tag: 'search_grid_$index');
      },
    );
  }

  // List View Builder
  Widget _buildListView(ThemeData themeData) {
    return ListView.separated(
      itemCount: widget.searchModel.animes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10,),
      itemBuilder: (context, index) {
        final anime = widget.searchModel.animes[index];
        return AnimeCard(
          anime: anime, 
          tag: 'search_list_$index',
          isListLayout: true,
        );
      },
    );
  }
}