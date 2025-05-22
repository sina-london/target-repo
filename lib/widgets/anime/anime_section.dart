import 'package:flutter/material.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/data/hive/models/settings/ui_model.dart';
import 'package:shonenx/helpers/navigation.dart';
import 'package:shonenx/widgets/anime/card/anime_card.dart';
import 'package:uuid/uuid.dart';

class HorizontalAnimeSection extends StatelessWidget {
  final String title;
  final List<Media>? animes;
  final UiSettings uiSettings;

  const HorizontalAnimeSection({
    super.key,
    required this.title,
    required this.animes,
    required this.uiSettings,
  });

  double _getCardWidth(BuildContext context, String mode) {
    final screenWidth = MediaQuery.of(context).size.width;
    return switch (mode) {
      'Card' => screenWidth < 600 ? 140.0 : 160.0,
      'Compact' => screenWidth < 600 ? 100.0 : 120.0,
      'Poster' => screenWidth < 600 ? 160.0 : 180.0,
      'Glass' => screenWidth < 600 ? 150.0 : 170.0,
      'Neon' => screenWidth < 600 ? 140.0 : 160.0,
      'Minimal' => screenWidth < 600 ? 130.0 : 150.0,
      'Cinematic' => screenWidth < 600 ? 200.0 : 350,
      _ => screenWidth < 600 ? 140.0 : 160.0,
    };
  }

  double _getCardHeight(BuildContext context, String mode) {
    final screenWidth = MediaQuery.of(context).size.width;
    return switch (mode) {
      'Card' => screenWidth < 600 ? 200.0 : 240.0,
      'Compact' => screenWidth < 600 ? 150.0 : 180.0,
      'Poster' => screenWidth < 600 ? 260.0 : 300.0,
      'Glass' => screenWidth < 600 ? 220.0 : 260.0,
      'Neon' => screenWidth < 600 ? 200.0 : 240.0,
      'Minimal' => screenWidth < 600 ? 180.0 : 220.0,
      'Cinematic' => screenWidth < 600 ? 100.0 : 120.0,
      _ => screenWidth < 600 ? 200.0 : 240.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardWidth = _getCardWidth(context, uiSettings.cardStyle);
    final cardHeight = _getCardHeight(context, uiSettings.cardStyle);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 32, 15, 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              physics: const ClampingScrollPhysics(),
              itemCount: animes?.length ?? 10,
              itemBuilder: (context, index) {
                final anime = animes?[index];
                final tag = const Uuid().v4();
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: cardWidth,
                    child: AnimatedAnimeCard(
                      anime: anime,
                      tag: tag,
                      mode: uiSettings.cardStyle,
                      onTap: () => anime != null
                          ? navigateToDetail(context, anime, tag)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalAnimeSection extends StatelessWidget {
  final String title;
  final List<Media>? animes;
  final UiSettings uiSettings;
  final int crossAxisCount;
  final double aspectRatio;

  const VerticalAnimeSection({
    super.key,
    required this.title,
    required this.animes,
    required this.uiSettings,
    this.crossAxisCount = 2,
    this.aspectRatio = 0.7,
  });

  double _getCardWidth(BuildContext context, String mode) {
    final screenWidth = MediaQuery.of(context).size.width;
    return switch (mode) {
      'Card' => screenWidth < 600 ? 140.0 : 160.0,
      'Compact' => screenWidth < 600 ? 100.0 : 120.0,
      'Poster' => screenWidth < 600 ? 160.0 : 180.0,
      'Glass' => screenWidth < 600 ? 150.0 : 170.0,
      'Neon' => screenWidth < 600 ? 140.0 : 160.0,
      'Minimal' => screenWidth < 600 ? 130.0 : 150.0,
      'Cinematic' => screenWidth < 600 ? 200.0 : 350,
      _ => screenWidth < 600 ? 140.0 : 160.0,
    };
  }

  double _getCardHeight(BuildContext context, String mode) {
    final screenWidth = MediaQuery.of(context).size.width;
    return switch (mode) {
      'Card' => screenWidth < 600 ? 200.0 : 240.0,
      'Compact' => screenWidth < 600 ? 150.0 : 180.0,
      'Poster' => screenWidth < 600 ? 260.0 : 300.0,
      'Glass' => screenWidth < 600 ? 220.0 : 260.0,
      'Neon' => screenWidth < 600 ? 200.0 : 240.0,
      'Minimal' => screenWidth < 600 ? 180.0 : 220.0,
      'Cinematic' => screenWidth < 600 ? 100.0 : 120.0,
      _ => screenWidth < 600 ? 200.0 : 240.0,
    };
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid layout based on screen width
    if (screenWidth < 400) return 2;
    if (screenWidth < 700) return 3;
    if (screenWidth < 1000) return 4;
    return 8;
  }

  double _getCardAspectRatio(String mode) {
    return switch (mode) {
      'Card' => 0.7,
      'Compact' => 0.65,
      'Poster' => 0.6,
      'Glass' => 0.75,
      'Neon' => 0.7,
      'Minimal' => 0.72,
      'Cinematic' => 1.8, // Wider cards for cinematic style
      _ => 0.7,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final actualCrossAxisCount = _getCrossAxisCount(context);
    final actualAspectRatio = _getCardAspectRatio(uiSettings.cardStyle);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 32, 15, 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: _getCardWidth(context, uiSettings.cardStyle),
              childAspectRatio: actualAspectRatio,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: animes?.length ?? 10,
            itemBuilder: (context, index) {
              final anime = animes?[index];
              final tag = const Uuid().v4();
              return AnimatedAnimeCard(
                anime: anime,
                tag: tag,
                mode: uiSettings.cardStyle,
                onTap: () => anime != null
                    ? navigateToDetail(context, anime, tag)
                    : null,
              );
            },
          ),
          const SizedBox(height: 16), // Bottom padding
        ],
      ),
    );
  }
}
