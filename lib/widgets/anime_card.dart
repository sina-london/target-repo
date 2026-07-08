import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nekoflow/data/models/anime_interface.dart';
import 'package:nekoflow/screens/main/details/details_screen.dart';

class AnimeCard extends StatelessWidget {
  // Constants moved to static final for better performance
  static final BorderRadius _borderRadius = BorderRadius.circular(20.0);
  static const double _aspectRatio = 0.75;
  static const EdgeInsets _cardMargin = EdgeInsets.only(right: 12);
  static const EdgeInsets _chipPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const TextStyle _titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle _typeStyle = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  final Anime anime;
  final dynamic tag;

  const AnimeCard({
    super.key, 
    required this.anime, 
    required this.tag,
  });

  void _navigateToDetails(BuildContext context) {
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
    // Using cached computed value if available
    return posterUrl.replaceAll(RegExp(r'(\d+)x(\d+)'), '600x800');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4;
    final cardHeight = cardWidth / _aspectRatio;

    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: _cardMargin,
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000), // Optimized opacity
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPosterImage(context, cardWidth, cardHeight),
              _buildGradientOverlay(),
              _buildTypeChip(context),
              _buildTitle(),
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
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.primary,
      highlightColor: theme.colorScheme.secondary,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xCC000000), // Optimized opacity
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: _chipPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
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
              style: _typeStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          anime.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _titleStyle,
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
    return lerped ?? begin!;
  }
}