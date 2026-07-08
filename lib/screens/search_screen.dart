import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/result_card.dart';
import 'package:nekoflow/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late AnimeService _animeService;
  SearchModel? _searchResult;
  bool _isLoading = false;

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      SearchModel? result = await _animeService.fetchByQuery(
          query: _searchController.text, page: 1);
      setState(() {
        _searchResult = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildResultSection() {
    if (_isLoading) {
      return [
        Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ];
    } else if (_searchResult == null) {
      return [
        SizedBox(
          height: 100,
          child: Center(child: Text("Search it up")),
        )
      ];
    }
    return [
      SizedBox(
        height: 15,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: _searchResult!.animes.length,
          itemBuilder: (context, index) =>
              ResultCard(anime: _searchResult!.animes[index]),
        ),
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animeService = AnimeService();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Searchbar(controller: _searchController, onSearch: _performSearch),
            ..._buildResultSection()
          ],
        ),
      ),
    );
  }
}
