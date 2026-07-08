import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nekoflow/data/models/anime_interface.dart';
import 'package:nekoflow/screens/main/details/details_screen.dart';

class AnimeCard extends StatelessWidget {
  static const double _cardBorderRadius = 20.0;
  static const double _aspectRatio = 0.75; // 3:4 aspect ratio for posters
  
  final Anime anime;
  final dynamic tag;

  const AnimeCard({
    super.key, 
    required this.anime, 
    required this.tag,
  });

  void _navigateToDetails(BuildContext context, Size screenSize) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          id: anime.id,
          image: _getHighResImage(anime.poster),
          title: anime.name,
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
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.4;
    final cardHeight = cardWidth / _aspectRatio;

    return GestureDetector(
      onTap: () => _navigateToDetails(context, screenSize),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPosterImage(context, cardWidth, cardHeight),
              _buildGradientOverlay(cardWidth),
              _buildTypeChip(),
              _buildTitle(cardWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage(BuildContext context, double width, double height) {
    return Hero(
      transitionOnUserGestures: true,
      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
      tag: 'poster-${anime.id}-$tag',
      child: Image.network(
        _getHighResImage(anime.poster),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildShimmer(context, width, height);
        },
        errorBuilder: (_, __, ___) => const Center(
          child: Text('Image Not Available'),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context, double width, double height) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildGradientOverlay(double width) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              anime.type,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(double width) {
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Text(
        anime.name,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CustomRectTween extends RectTween {
  CustomRectTween({
    required Rect begin, 
    required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final lerped = super.lerp(t);
    if (lerped == null) return begin!;
    return lerped;
  }
}