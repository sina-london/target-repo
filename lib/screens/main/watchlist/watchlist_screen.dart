import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/widgets/anime_card.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlistBox = Hive.box<WatchlistModel>("user_watchlist");

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Watchlist",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: watchlistBox.listenable(),
        builder: (context, Box<WatchlistModel> box, _) {
          final recentlyWatched = box.get('recentlyWatched')?.recentlyWatched ?? [];
          final favorites = box.get('favorites')?.favorites ?? [];
          final continueWatching = box.get('continueWatching')?.continueWatching ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              // Optional: Refresh logic if needed.
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildSection(
                    context,
                    title: "Recently Watched",
                    items: recentlyWatched,
                    emptyMessage: "No recently watched anime",
                    tag: "recent",
                  ),
                  _buildSection(
                    context,
                    title: "Continue Watching",
                    items: continueWatching,
                    emptyMessage: "No Anime to continue",
                    tag: "continue",
                  ),
                  _buildSection(
                    context,
                    title: "Favorites",
                    items: favorites,
                    emptyMessage: "No favorites anime",
                    tag: "favorite",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<BaseAnimeCard> items,
    required String emptyMessage,
    required String tag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title),
        const SizedBox(height: 8),
        items.isEmpty
            ? Center(child: Text(emptyMessage))
            : _buildAnimeList(items, tag),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.navigate_next, size: 35),
        ),
      ],
    );
  }

  Widget _buildAnimeList(List<BaseAnimeCard> items, String tag) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final anime = items[index];
          return AnimeCard(anime: anime, tag: tag);
        },
      ),
    );
  }
}
