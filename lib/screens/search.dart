import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/search_result.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/result_card.dart';
import 'package:nekoflow/widgets/search_bar.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final AnimeService _animeService = AnimeService();
  bool _isLoading = false;
  bool _isMoreLoading = false;
  bool _hasNextPage = false;
  int? _currentPage = 1;

  String? error;
  List<Anime>? _searchResults;

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      error = null;
      _hasNextPage = false;
      _currentPage = 1;
    });

    try {
      ResultResponse result = await _animeService.fetchByQuery(
          query: _searchController.text, page: _currentPage ?? 1);
      setState(() {
        _isLoading = false;
        _searchResults = result.results;
        _hasNextPage = result.hasNextPage;
        _currentPage = result.currentPage;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Something went wrong: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreResults() async {
    if (!_hasNextPage || _isMoreLoading) return;
    setState(() {
      _isMoreLoading = true;
      error = null;
      _hasNextPage = false;
    });
    try {
      ResultResponse result = await _animeService.fetchByQuery(
          query: _searchController.text, page: _currentPage! + 1);
      setState(() {
        _isMoreLoading = false;
        _searchResults!.addAll(result.results);
        _hasNextPage = result.hasNextPage;
        _currentPage = result.currentPage;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Something went wrong: $e';
        _isMoreLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Searchbar(
              controller: _searchController,
              onSearch: _performSearch,
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(child: Text(error!))
            else if (_searchResults == null ||
                (_searchResults != null && _searchResults!.isEmpty))
              const Center(child: Text('No items found'))
            else
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.outOfRange) {
                      _loadMoreResults();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: _searchResults!.length,
                    scrollDirection: Axis.vertical,
                    // shrinkWrap: true,

                    physics: const BouncingScrollPhysics(),
                    // Enable swiping to dismiss the keyboard
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) =>
                        ResultCard(anime: _searchResults![index], index: index),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
