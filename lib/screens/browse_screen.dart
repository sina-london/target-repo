// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:shonenx/core/anilist/services/anilist_service.dart';
// import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
// import 'package:shonenx/core/utils/app_logger.dart';
// import 'package:shonenx/helpers/navigation.dart';
// import 'package:shonenx/widgets/anime/card/anime_card.dart';
// import 'package:shonenx/widgets/ui/shonenx_grid.dart';

// class BrowseScreen extends StatefulWidget {
//   final String? keyword;
//   const BrowseScreen({super.key, this.keyword});

//   @override
//   State<BrowseScreen> createState() => _BrowseScreenState();
// }

// class _BrowseScreenState extends State<BrowseScreen>
//     with TickerProviderStateMixin {
//   final AnilistService _anilistService = AnilistService();
//   late TextEditingController _searchController;
//   late AnimationController _fadeController;
//   late AnimationController _searchBarController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _searchBarAnimation;

//   List<Media>? _searchResults = [];
//   int _currentPage = 1;
//   bool _isLoading = false;
//   bool _hasMore = true;
//   bool _isSearchFocused = false;
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController(text: widget.keyword);
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);

//     // Initialize animations
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _searchBarController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));

//     _searchBarAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _searchBarController,
//       curve: Curves.elasticOut,
//     ));

//     _searchBarController.forward();

//     if (widget.keyword != null && widget.keyword!.isNotEmpty) {
//       _fetchSearchResults(widget.keyword!, page: _currentPage);
//     }
//   }

//   @override
//   void didUpdateWidget(covariant BrowseScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.keyword != oldWidget.keyword) {
//       _searchController.text = widget.keyword ?? '';
//       _onSearch();
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (widget.keyword != null && widget.keyword!.isNotEmpty) {
//       _fetchSearchResults(widget.keyword!, page: _currentPage);
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     _fadeController.dispose();
//     _searchBarController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchSearchResults(String keyword, {required int page}) async {
//     if (_isLoading || !_hasMore) return;

//     setState(() {
//       _isLoading = true;
//     });

//     if (page == 1) {
//       _fadeController.reset();
//     }

//     AppLogger.d("Fetching search results for '$keyword' (page $page)");

//     try {
//       final results =
//           await _anilistService.searchAnime(keyword, page: page, perPage: 20);

//       setState(() {
//         if (page == 1) {
//           _searchResults = results;
//           _fadeController.forward();
//         } else {
//           _searchResults = [...?_searchResults, ...results];
//         }
//         _hasMore = results.isNotEmpty;
//         _isLoading = false;
//       });
//     } catch (e, stackTrace) {
//       AppLogger.e("Error fetching search results", e, stackTrace);
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200 &&
//         !_isLoading &&
//         _hasMore) {
//       _currentPage++;
//       _fetchSearchResults(_searchController.text, page: _currentPage);
//     }
//   }

//   Future<void> _onSearch() async {
//     if (_searchController.text.isEmpty) return;

//     setState(() {
//       _currentPage = 1;
//       _searchResults = [];
//       _hasMore = true;
//     });

//     await _fetchSearchResults(_searchController.text, page: _currentPage);
//   }

//   void _onSearchFocusChange(bool focused) {
//     setState(() {
//       _isSearchFocused = focused;
//     });
//   }

//   Widget _buildHeader() {
//     return Container(
//       decoration: BoxDecoration(),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Title with Animation
//               AnimatedBuilder(
//                 animation: _searchBarAnimation,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, 30 * (1 - _searchBarAnimation.value)),
//                     child: Opacity(
//                       opacity: _searchBarAnimation.value,
//                       child: Text(
//                         'Discover Anime',
//                         style: Theme.of(context)
//                             .textTheme
//                             .headlineLarge
//                             ?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).colorScheme.onSurface,
//                             ),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 8),

//               AnimatedBuilder(
//                 animation: _searchBarAnimation,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, 20 * (1 - _searchBarAnimation.value)),
//                     child: Opacity(
//                       opacity: _searchBarAnimation.value * 0.7,
//                       child: Text(
//                         'Find your next favorite series',
//                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .onSurface
//                                   .withOpacity(0.7),
//                             ),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 24),

//               // Modern Search Bar
//               AnimatedBuilder(
//                 animation: _searchBarAnimation,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: 0.8 + (0.2 * _searchBarAnimation.value),
//                     child: Opacity(
//                       opacity: _searchBarAnimation.value,
//                       child: _buildModernSearchBar(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: _isSearchFocused
//                 ? Theme.of(context).colorScheme.primaryContainer
//                 : Theme.of(context).colorScheme.outline.withOpacity(0.2),
//             width: _isSearchFocused ? 2 : 1,
//           ),
//         ),
//         child: Focus(
//           onFocusChange: _onSearchFocusChange,
//           child: TextField(
//             controller: _searchController,
//             onSubmitted: (_) => _onSearch(),
//             decoration: InputDecoration(
//               hintText: 'Search anime titles...',
//               hintStyle: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
//               ),
//               prefixIcon: AnimatedRotation(
//                 turns: _isSearchFocused ? 0.5 : 0,
//                 duration: const Duration(milliseconds: 300),
//                 child: Icon(
//                   Iconsax.search_normal,
//                   color: _isSearchFocused
//                       ? Theme.of(context).colorScheme.primaryContainer
//                       : Theme.of(context)
//                           .colorScheme
//                           .onSurface
//                           .withOpacity(0.5),
//                 ),
//               ),
//               suffixIcon: _searchController.text.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(Icons.clear_rounded),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           _searchResults = [];
//                         });
//                       },
//                     )
//                   : AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.tune_rounded,
//                           color: Theme.of(context)
//                               .colorScheme
//                               .onSurface
//                               .withOpacity(0.5),
//                         ),
//                         onPressed: () {
//                           // Add filter functionality
//                         },
//                       ),
//                     ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 16,
//               ),
//             ),
//             style: Theme.of(context).textTheme.bodyLarge,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildResultsSection() {
//     if (_searchResults?.isEmpty == true && !_isLoading) {
//       return _buildEmptyState();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Results Header
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AnimatedBuilder(
//                 animation: _fadeAnimation,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: _fadeAnimation.value,
//                     child: Text(
//                       _searchResults?.isNotEmpty == true
//                           ? '${_searchResults!.length} Results'
//                           : 'Results',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.w600,
//                           ),
//                     ),
//                   );
//                 },
//               ),
//               // View Toggle (Grid/List)
//               // AnimatedBuilder(
//               //   animation: _fadeAnimation,
//               //   builder: (context, child) {
//               //     return Opacity(
//               //       opacity: _fadeAnimation.value,
//               //       child: Container(
//               //         decoration: BoxDecoration(
//               //           borderRadius: BorderRadius.circular(12),
//               //           color: Theme.of(context).colorScheme.surface,
//               //           border: Border.all(
//               //             color: Theme.of(context)
//               //                 .colorScheme
//               //                 .outline
//               //                 .withOpacity(0.2),
//               //           ),
//               //         ),
//               //         child: Row(
//               //           mainAxisSize: MainAxisSize.min,
//               //           children: [
//               //             IconButton(
//               //               icon: const Icon(Icons.grid_view_rounded),
//               //               onPressed: () {},
//               //               color:
//               //                   Theme.of(context).colorScheme.primaryContainer,
//               //             ),
//               //             IconButton(
//               //               icon: const Icon(Icons.view_list_rounded),
//               //               onPressed: () {},
//               //               color: Theme.of(context)
//               //                   .colorScheme
//               //                   .onSurface
//               //                   .withOpacity(0.5),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     );
//               //   },
//               // ),
//             ],
//           ),
//         ),

//         // Results Grid
//         Expanded(
//           child: AnimatedBuilder(
//             animation: _fadeAnimation,
//             builder: (context, child) {
//               return AnimatedOpacity(
//                 opacity: _fadeAnimation.value,
//                 duration: const Duration(milliseconds: 400),
//                 child: ShonenXGridView(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   childAspectRatio: 0.75,
//                   crossAxisCount: _getOptimalColumnCount(),
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   items: [
//                     ...?_searchResults?.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final anime = entry.value;
//                       return AnimatedContainer(
//                         duration: Duration(milliseconds: 300 + (index * 50)),
//                         curve: Curves.easeOutBack,
//                         child: AnimatedAnimeCard(
//                           onTap: () => navigateToDetail(
//                               context, anime, anime.id.toString()),
//                           anime: anime,
//                           mode: 'Card',
//                           tag: anime.id.toString(),
//                         ),
//                       );
//                     }),
//                     if (_isLoading) _buildLoadingIndicator(),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Theme.of(context)
//                     .colorScheme
//                     .primaryContainer
//                     .withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.search_off_rounded,
//                 size: 64,
//                 color: Theme.of(context).colorScheme.primaryContainer,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Start Your Search',
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Enter an anime title to discover amazing series',
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.7),
//                   ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: 32,
//                   height: 32,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 3,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).colorScheme.primaryContainer,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Loading more...',
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Theme.of(context)
//                             .colorScheme
//                             .onSurface
//                             .withOpacity(0.7),
//                       ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   int _getOptimalColumnCount() {
//     final width = MediaQuery.sizeOf(context).width;
//     if (width >= 1400) return 6;
//     if (width >= 1100) return 5;
//     if (width >= 800) return 4;
//     if (width >= 500) return 3;
//     return 2;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: _buildResultsSection(),
//           ),
//         ],
//       ),
//     );
//   }
// }
