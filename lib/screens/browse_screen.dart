import 'package:flutter/material.dart';
import 'package:shonenx/core/anilist/services/anilist_service.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/widgets/anime/card/anime_card.dart';
import 'package:shonenx/widgets/ui/search_bar.dart';
import 'package:shonenx/widgets/ui/shonenx_grid.dart';

class BrowseScreen extends StatefulWidget {
  final String? keyword;
  const BrowseScreen({super.key, this.keyword});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final AnilistService _anilistService = AnilistService();
  late TextEditingController _searchController;
  List<Media>? _searchResults = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.keyword);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    if (widget.keyword != null && widget.keyword!.isNotEmpty) {
      _fetchSearchResults(widget.keyword!, page: _currentPage);
    }
  }

  @override
  void didUpdateWidget(covariant BrowseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.keyword != oldWidget.keyword) {
      _searchController.text = widget.keyword ?? '';
      _onSearch();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.keyword != null && widget.keyword!.isNotEmpty) {
      _fetchSearchResults(widget.keyword!, page: _currentPage);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults(String keyword, {required int page}) async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });
    AppLogger.d("Fetching search results for '$keyword' (page $page)");
    try {
      final results =
          await _anilistService.searchAnime(keyword, page: page, perPage: 20);
      setState(() {
        if (page == 1) {
          _searchResults = results;
        } else {
          _searchResults = [...?_searchResults, ...results];
        }
        _hasMore = results.isNotEmpty; // Assume no more results if empty
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      AppLogger.e("Error fetching search results", e, stackTrace);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _currentPage++;
      _fetchSearchResults(_searchController.text, page: _currentPage);
    }
  }

  Future<void> _onSearch() async {
    if (_searchController.text.isEmpty) return;
    setState(() {
      _currentPage = 1;
      _searchResults = [];
      _hasMore = true;
    });
    await _fetchSearchResults(_searchController.text, page: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Searchbar(
              controller: _searchController,
              onSearch: _onSearch,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ShonenXGridView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
              crossAxisCount: MediaQuery.sizeOf(context).width >= 1400
                  ? 6
                  : MediaQuery.sizeOf(context).width >= 1100
                      ? 5
                      : MediaQuery.sizeOf(context).width >= 800
                          ? 4
                          : MediaQuery.sizeOf(context).width >= 500
                              ? 3
                              : 2,
              physics: const AlwaysScrollableScrollPhysics(),
              items: [
                ...?_searchResults?.map((anime) => AnimatedAnimeCard(
                      anime: anime,
                      mode: 'Card',
                      tag: anime.id.toString(),
                    )),
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
