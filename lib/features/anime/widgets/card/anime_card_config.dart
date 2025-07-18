import 'package:flutter/material.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/features/anime/widgets/card/modes/default_card.dart';

import 'package:shonenx/widgets/anime/card/modes/anime_cinematic_card.dart';
import 'package:shonenx/widgets/anime/card/modes/anime_compact_card.dart';
import 'package:shonenx/widgets/anime/card/modes/anime_glass_card.dart';
import 'package:shonenx/widgets/anime/card/modes/anime_minimal_card.dart';
import 'package:shonenx/widgets/anime/card/modes/anime_neon_card.dart';
import 'package:shonenx/widgets/anime/card/modes/anime_poster_card.dart';

enum AnimeCardMode {
  defaults,
  compact,
  poster,
  glass,
  neon,
  minimal,
  cinematic,
}


typedef ResponsiveSize = ({double small, double large});

// The definition of the expected function signature
typedef AnimeCardBuilder = Widget Function({
  required Media? anime,
  required String tag,
  required bool isHovered,
});

class AnimeCardConfig {
  final ResponsiveSize responsiveWidth;
  final ResponsiveSize responsiveHeight;
  final double radius;
  final AnimeCardBuilder builder;

  const AnimeCardConfig({
    required this.responsiveWidth,
    required this.responsiveHeight,
    required this.radius,
    required this.builder,
  });
}

final Map<AnimeCardMode, AnimeCardConfig> cardConfigs = {
  AnimeCardMode.defaults: AnimeCardConfig(
    responsiveWidth: (small: 140.0, large: 160.0),
    responsiveHeight: (small: 200.0, large: 240.0),
    radius: 15.0,
    builder: ({required anime, required tag, required isHovered}) =>
        DefaultCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
  AnimeCardMode.compact: AnimeCardConfig(
    responsiveWidth: (small: 100.0, large: 120.0),
    responsiveHeight: (small: 150.0, large: 180.0),
    radius: 12.0,
    builder: ({required anime, required tag, required isHovered}) =>
        CompactCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
  AnimeCardMode.poster: AnimeCardConfig(
    responsiveWidth: (small: 160.0, large: 180.0),
    responsiveHeight: (small: 260.0, large: 300.0),
    radius: 18.0,
    builder: ({required anime, required tag, required isHovered}) =>
        PosterCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
  AnimeCardMode.glass: AnimeCardConfig(
    responsiveWidth: (small: 150.0, large: 170.0),
    responsiveHeight: (small: 220.0, large: 260.0),
    radius: 20.0,
    builder: ({required anime, required tag, required isHovered}) =>
        GlassCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
  AnimeCardMode.neon: AnimeCardConfig(
    responsiveWidth: (small: 140.0, large: 160.0),
    responsiveHeight: (small: 200.0, large: 240.0),
    radius: 16.0,
    builder: ({required anime, required tag, required isHovered}) =>
        NeonCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
  AnimeCardMode.minimal: AnimeCardConfig(
    responsiveWidth: (small: 130.0, large: 150.0),
    responsiveHeight: (small: 180.0, large: 220.0),
    radius: 10.0,
    builder: ({required anime, required tag, required isHovered}) =>
        MinimalCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
  AnimeCardMode.cinematic: AnimeCardConfig(
    responsiveWidth: (small: 200.0, large: 240.0),
    responsiveHeight: (small: 140.0, large: 160.0),
    radius: 14.0,
    builder: ({required anime, required tag, required isHovered}) =>
        CinematicCard(anime: anime, tag: tag, isHovered: isHovered),
  ),
};