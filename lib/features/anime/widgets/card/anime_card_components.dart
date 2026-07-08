import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';

// I've made your _EpisodesInfo a public, reusable widget.
class EpisodesInfo extends StatelessWidget {
  final Media? anime;
  final bool compact;

  const EpisodesInfo({
    super.key,
    required this.anime,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (anime?.episodes == null || anime!.episodes == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          Iconsax.play_circle,
          size: 14,
          color: Colors.white.withOpacity(0.9),
        ),
        const SizedBox(width: 4),
        Text(
          compact ? '${anime!.episodes}ep' : '${anime!.episodes} episodes',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}