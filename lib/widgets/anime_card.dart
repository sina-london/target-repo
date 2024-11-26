import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/screens/main/details/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeCard extends StatelessWidget {
  final BaseAnimeCard anime;
  final dynamic tag;
  final VoidCallback? onLongPress; // Callback for long press (for multi-select)
  final bool isListLayout; // New parameter to switch between layouts

  const AnimeCard({
    super.key,
    required this.anime,
    required this.tag,
    this.onLongPress,
    this.isListLayout = false, // Default to grid layout
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          id: anime.id,
          image: _getHighResImage(anime.poster),
          name: anime.name,
          tag: tag,
          type: anime.type,
        ),
      ),
    );
  }

  String _getHighResImage(String posterUrl) {
    return posterUrl.replaceAll(RegExp(r'(\d+)x(\d+)'), '600x800');
  }

  @override
  Widget build(BuildContext context) {
    return isListLayout ? _buildListLayout(context) : _buildGridLayout(context);
  }

  Widget _buildGridLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.42;
    final cardHeight = cardWidth * 1.5;

    return SizedBox(
      height: cardHeight,
      width: cardWidth,
      child: _buildCardContent(context, isGrid: true),
    );
  }

  Widget _buildListLayout(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildCardContent(context, isGrid: false),
    );
  }

  Widget _buildCardContent(BuildContext context, {required bool isGrid}) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      onLongPress: onLongPress,
      child: isGrid
          ? _buildGridCardContent(context)
          : _buildListCardContent(context),
    );
  }

  Widget _buildGridCardContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.42;
    final cardHeight = cardWidth * 1.5;

    return Hero(
      tag: 'poster-${anime.id}-$tag',
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          image: DecorationImage(
            image: CachedNetworkImageProvider(_getHighResImage(anime.poster)),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildGradientOverlay(),
              _buildTitle(context),
              if (anime.type != null) _buildTypeChip(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCardContent(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          Hero(
            tag: 'poster-${anime.id}-$tag',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: _getHighResImage(anime.poster),
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    anime.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Type Chip (if available)
                  if (anime.type != null)
                    Chip(
                      label: Text(
                        anime.type!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                    ),

                  const Spacer(),

                  // Additional info can be added here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedInformationSquare,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () => _navigateToDetails(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xCC000000),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          anime.type!,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Text(
        anime.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
