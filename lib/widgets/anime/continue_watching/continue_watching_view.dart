import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/data/hive/providers/anime_watch_progress_provider.dart';
import 'package:shonenx/widgets/anime/continue_watching/anime_continue_card.dart';

class ContinueWatchingView extends ConsumerWidget {
  const ContinueWatchingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final animeProgressNotifier =
        ref.watch(animeWatchProgressProvider.notifier);
    print(
        "${animeProgressNotifier.getAllEntries()[0].episodesProgress[1]?.episodeTitle}");
    print(
        "${animeProgressNotifier.getMostRecentEpisodeProgressByAnimeId(16498)}");
    final entries =
        animeProgressNotifier.getAllMostRecentWatchedEpisodesWithAnime();
    print("Entries ${entries.length}");

    if (entries.isEmpty) {
      return const Text("No Entries");
      // return const SizedBox.shrink();
    }

    return SizedBox(
      height: 260, // Slightly increased for better spacing
      child: Container(
        height: 260, // Adjusted to match parent
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(), // Smooth scrolling
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ContinueWatchingCard(
                      onTap: () {
                        // Placeholder for multi-select or navigation logic
                        // Example: Toggle selection or navigate
                      },
                      anime: entries[index].anime,
                      episode: entries[index].episode,
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final loadingProvider = StateProvider.family<bool, int>((ref, index) => false);

// Header with Floating Action
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Continue',
            style: GoogleFonts.montserrat(
              fontSize: 22, // Slightly larger for emphasis
              fontWeight: FontWeight.w600, // Bolder for modern look
              color: colorScheme.onSurface,
              letterSpacing: -0.2, // Tighten spacing for polish
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/continue-all'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Iconsax.arrow_right_3,
                    size: 16,
                    color: colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
