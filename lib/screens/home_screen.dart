// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
// import 'package:shonenx/core/models/anilist/anilist_user.dart';
// import 'package:shonenx/core/models/anime/page_model.dart';
// import 'package:shonenx/data/hive/providers/home_page_provider.dart';
// import 'package:shonenx/data/hive/providers/ui_provider.dart';
// import 'package:shonenx/helpers/navigation.dart';
// import 'package:shonenx/providers/anilist/anilist_user_provider.dart';
// import 'package:shonenx/utils/greeting_methods.dart';
// import 'package:shonenx/widgets/anime/anime_section.dart';
// import 'package:shonenx/widgets/anime/spotlight_card/anime_spotlight_card.dart';
// import 'package:shonenx/widgets/anime/continue_watching/continue_watching_view.dart';
// import 'package:shonenx/widgets/ui/slide_indicator.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDesktop = MediaQuery.of(context).size.width > 900;
//     final homepageState = ref.watch(homepageProvider);

    

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       floatingActionButton: isDesktop ? _buildFAB(context) : null,
//       body: SafeArea(
//         child: homepageState.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _HomeContent(
//                 homePage: homepageState.homePage,
//                 isDesktop: isDesktop,
//                 onRefresh: () =>
//                     ref.refresh(homepageProvider.notifier).fetchHomePage(),
//               ),
//         // child: ref.watch(homePageProvider).when(
//         //       data: (homePage) => _HomeContent(
//         //           homePage: homePage,
//         //           isDesktop: isDesktop,
//         //           onRefresh: () => ref.refresh(homePageProvider)),
//         //       error: (error, stackTrace) => const SizedBox(),
//         //       loading: () => const Center(
//         //         child: CircularProgressIndicator(),
//         //       ),
//         //     ),
//       ),
//     );
//   }

//   FloatingActionButton _buildFAB(BuildContext context) {
//     final theme = Theme.of(context);
//     return FloatingActionButton.extended(
//       backgroundColor: theme.colorScheme.primaryContainer,
//       onPressed: null, // Handled by TextField's onSubmitted
//       label: SizedBox(
//         width: 300,
//         child: Row(
//           children: [
//             Icon(Iconsax.search_normal,
//                 color: theme.colorScheme.onPrimaryContainer),
//             const SizedBox(width: 10),
//             Expanded(
//               child: TextField(
//                 keyboardType: TextInputType.text,
//                 onSubmitted: (value) => context.go('/browse?keyword=$value'),
//                 textInputAction: TextInputAction.search,
//                 decoration: InputDecoration(
//                   hintStyle: TextStyle(
//                     color: theme.colorScheme.onPrimaryContainer,
//                   ),
//                   border: InputBorder.none,
//                   hintText: 'Search anime...',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HomeContent extends ConsumerWidget {
//   final HomePage? homePage;
//   final bool isDesktop;
//   final VoidCallback onRefresh;

//   const _HomeContent({
//     required this.homePage,
//     required this.isDesktop,
//     required this.onRefresh,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final uiSettings = ref.watch(uiSettingsProvider);
//     return RefreshIndicator(
//       onRefresh: () async => onRefresh(),
//       child: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(child: _HeaderSection(isDesktop: isDesktop)),
//           SliverToBoxAdapter(child: _SpotlightSection(homePage: homePage)),
//           const SliverToBoxAdapter(child: SizedBox(height: 15)),
//           SliverToBoxAdapter(
//             child: ContinueWatchingView(),
//           ),
//           if (uiSettings.layoutStyle == 'horizontal') ...[
//             HorizontalAnimeSection(
//               title: 'Popular',
//               animes: homePage?.popularAnime,
//               uiSettings: uiSettings,
//             ),
//             HorizontalAnimeSection(
//               title: 'Trending',
//               animes: homePage?.trendingAnime,
//               uiSettings: uiSettings,
//             ),
//             HorizontalAnimeSection(
//               title: 'Most Favorite',
//               animes: homePage?.mostFavoriteAnime,
//               uiSettings: uiSettings,
//             ),
//           ],
//           if (uiSettings.layoutStyle == 'vertical') ...[
//             VerticalAnimeSection(
//               title: 'Popular',
//               animes: homePage?.popularAnime,
//               uiSettings: uiSettings,
//             ),
//             VerticalAnimeSection(
//               title: 'Trending',
//               animes: homePage?.trendingAnime,
//               uiSettings: uiSettings,
//             ),
//             VerticalAnimeSection(
//               title: 'Most Favorite',
//               animes: homePage?.mostFavoriteAnime,
//               uiSettings: uiSettings,
//             ),
//           ],
//           const SliverToBoxAdapter(child: SizedBox(height: 100)),
//         ],
//       ),
//     );
//   }
// }

// class _HeaderSection extends ConsumerWidget {
//   final bool isDesktop;

//   const _HeaderSection({required this.isDesktop});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider);

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 12, 15, 10),
//       child: Column(
//         children: [
//           SizedBox(height: MediaQuery.of(context).padding.top),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: UserProfileCard(user: user)),
//               const SizedBox(width: 10),
//               ActionPanel(isDesktop: isDesktop),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const DiscoverCard(),
//         ],
//       ),
//     );
//   }
// }

// class UserProfileCard extends StatelessWidget {
//   final User? user;

//   const UserProfileCard({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 0,
//       color: theme.colorScheme.surface,
//       shape: RoundedRectangleBorder(
//         borderRadius:
//             (theme.cardTheme.shape as RoundedRectangleBorder?)?.borderRadius ??
//                 BorderRadius.circular(8),
//         side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             _buildAvatar(context),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     getGreeting(),
//                     style: theme.textTheme.titleSmall?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.7),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user?.name ?? 'Guest',
//                     style: theme.textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatar(BuildContext context) {
//     final theme = Theme.of(context);
//     return user == null
//         ? Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: theme.colorScheme.primaryContainer,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child:
//                 Icon(Iconsax.user, size: 24, color: theme.colorScheme.primary),
//           )
//         : Hero(
//             tag: 'user-avatar',
//             child: Material(
//               elevation: 2,
//               shadowColor: theme.shadowColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(16),
//               child: InkWell(
//                 onTap: () => context.push('/settings/profile'),
//                 borderRadius: BorderRadius.circular(16),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: CachedNetworkImage(
//                     imageUrl: user!.avatar ?? '',
//                     width: 48,
//                     height: 48,
//                     fit: BoxFit.cover,
//                     placeholder: (_, __) => Container(
//                       color: theme.colorScheme.surfaceContainerHighest,
//                       child: Icon(
//                         Icons.person_outline,
//                         color: theme.colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                     errorWidget: (_, __, ___) => Container(
//                       color: theme.colorScheme.errorContainer,
//                       child: Icon(
//                         Icons.error_outline,
//                         color: theme.colorScheme.error,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
// }

// class ActionPanel extends StatelessWidget {
//   final bool isDesktop;

//   const ActionPanel({super.key, required this.isDesktop});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (!isDesktop) ...[
//           _ActionButton(
//             icon: Iconsax.search_normal,
//             onTap: () => showSearchModal(context),
//           ),
//           const SizedBox(width: 10),
//         ],
//         const _ActionButton(icon: Iconsax.setting_2, route: '/settings'),
//       ],
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String? route;
//   final VoidCallback? onTap;

//   const _ActionButton({
//     required this.icon,
//     this.route,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Material(
//       color: theme.colorScheme.secondaryContainer,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onTap ?? (route != null ? () => context.push(route!) : null),
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Icon(icon, color: theme.colorScheme.secondary),
//         ),
//       ),
//     );
//   }
// }

// // Show a modal SearchBar for smaller screens
// void showSearchModal(BuildContext context) {
//   final theme = Theme.of(context);
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       backgroundColor: Colors.transparent,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         constraints: const BoxConstraints(maxWidth: 400),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SearchBar(
//               padding: WidgetStatePropertyAll(
//                   EdgeInsets.symmetric(horizontal: 15, vertical: 5)),
//               leading: Icon(Iconsax.search_normal,
//                   color: theme.colorScheme.onSurface),
//               trailing: [
//                 IconButton(
//                   icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//               shape: WidgetStatePropertyAll(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                   side: BorderSide(
//                     color: theme.colorScheme.primaryContainer,
//                     width: 2,
//                   ),
//                 ),
//               ),
//               hintText: 'Search anime...',
//               hintStyle: WidgetStatePropertyAll(
//                 TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
//               ),
//               textStyle: WidgetStatePropertyAll(
//                 TextStyle(color: theme.colorScheme.onSurface),
//               ),
//               backgroundColor: WidgetStatePropertyAll(
//                 theme.colorScheme.surfaceContainer,
//               ),
//               elevation: const WidgetStatePropertyAll(0),
//               autoFocus: true,
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.search,
//               onSubmitted: (value) {
//                 Navigator.of(context).pop(); // Close the dialog
//                 context.go('/browse?keyword=$value');
//               },
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// class DiscoverCard extends StatelessWidget {
//   const DiscoverCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return GestureDetector(
//       onTap: () => context.go('/browse'),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               theme.colorScheme.primaryContainer.withOpacity(0.15),
//               theme.colorScheme.primaryContainer.withOpacity(0.05),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: (theme.cardTheme.shape as RoundedRectangleBorder?)
//                   ?.borderRadius ??
//               BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.primaryContainer.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Icon(
//                 Icons.explore,
//                 color: theme.colorScheme.primaryContainer,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Discover Anime',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.primaryContainer,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Find your next favorite series',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.7),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               color: theme.colorScheme.primary,
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SpotlightSection extends StatelessWidget {
//   final HomePage? homePage;

//   const _SpotlightSection({required this.homePage});

//   @override
//   Widget build(BuildContext context) {
//     final trendingAnimes =
//         homePage?.trendingAnime ?? List<Media?>.filled(9, null);
//     final carouselHeight =
//         MediaQuery.of(context).size.width > 900 ? 500.0 : 240.0;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SpotlightHeader(homePage: homePage),
//         FlutterCarousel(
//           options: FlutterCarouselOptions(
//             height: carouselHeight,
//             showIndicator: true,
//             autoPlay: true,
//             autoPlayInterval: const Duration(seconds: 5),
//             enableInfiniteScroll: true,
//             floatingIndicator: false,
//             enlargeCenterPage: true,
//             enlargeStrategy: CenterPageEnlargeStrategy.height,
//             slideIndicator: CustomSlideIndicator(context),
//             viewportFraction:
//                 MediaQuery.of(context).size.width > 900 ? 0.95 : 0.9,
//             pageSnapping: true,
//           ),
//           items: trendingAnimes
//               .map((anime) => Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
//                     child: AnimeSpotlightCard(
//                       onTap: (media) => anime?.id != null
//                           ? navigateToDetail(
//                               context, media, anime?.id.toString() ?? '')
//                           : null,
//                       anime: anime,
//                       heroTag: anime?.id.toString() ?? 'loading',
//                     ),
//                   ))
//               .toList(),
//         ),
//       ],
//     );
//   }
// }

// class _SpotlightHeader extends StatelessWidget {
//   final HomePage? homePage;

//   const _SpotlightHeader({required this.homePage});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.tertiaryContainer,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Iconsax.star5, size: 18, color: theme.colorScheme.tertiary),
//             const SizedBox(width: 8),
//             Text(
//               'Trending ${homePage?.trendingAnime.length ?? 0}',
//               style: theme.textTheme.labelLarge?.copyWith(
//                 color: theme.colorScheme.tertiary,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
