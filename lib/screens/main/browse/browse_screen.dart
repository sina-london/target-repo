import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/screens/main/browse/search_result_screen.dart';
import 'package:nekoflow/widgets/search_bar.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  static const List<String> _genres = [
    "Action",
    "Adventure",
    "Cars",
    "Comedy",
    "Dementia",
    "Demons",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Game",
    "Harem",
    "Historical",
    "Horror",
    "Isekai",
    "Josei",
    "Kids",
    "Magic",
    "Martial Arts",
    "Mecha",
    "Military",
    "Music",
    "Mystery",
    "Parody",
    "Police",
    "Psychological",
    "Romance",
    "Samurai",
    "School",
    "Sci-Fi",
    "Seinen",
    "Shoujo",
    "Shoujo Ai",
    "Shounen",
    "Shounen Ai",
    "Slice of Life",
    "Space",
    "Sports",
    "Super Power",
    "Supernatural",
    "Thriller",
    "Vampire"
  ];

  late AnimeService _animeService;
  final TextEditingController _searchController = TextEditingController();
  SearchModel? _searchResult;
  bool _isLoading = false;
  String? _error;

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _error = 'Please enter a search query.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null; // Clear previous error
    });

    try {
      final result = await _animeService.fetchByQuery(
        query: _searchController.text,
        page: 1,
      );
      if (!mounted) return;
      setState(() {
        _searchResult = result;
      });

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => SearchResultScreen(
            searchModel: _searchResult!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error =
            'An error occurred. Please check your connection or try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchGenreAnimes(String genreName) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final genreDetail = await _animeService.fetchGenreAnime(genreName);
      if (!mounted) return;

      if (genreDetail.success) {
        // Map GenreDetailModel's AnimeResult to SearchModel's AnimeResult
        final mappedAnimes = genreDetail.data.animes
            .map((genreAnime) => AnimeResult(
                  id: genreAnime.id,
                  name: genreAnime.name,
                  poster: genreAnime.poster,
                  duration: genreAnime.duration,
                  type: genreAnime.type,
                  rating: genreAnime.rating,
                  episodes: genreAnime.episodes,
                ))
            .toList();

        // Create a SearchModel from the genre results
        final searchResult = SearchModel(
          currentPage: genreDetail.data.currentPage,
          hasNextPage: genreDetail.data.hasNextPage,
          totalPages: genreDetail.data.totalPages,
          searchQuery: genreName, // Use genre name as search query
          searchFilters: {}, // You can add genre as a filter if needed
          animes: mappedAnimes,
          mostPopularAnimes: [], // You can populate this if needed
        );

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SearchResultScreen(
              searchModel: searchResult,
            ),
          ),
        );
      } else {
        setState(() {
          _error = 'Failed to fetch genre anime. Please try again later.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error fetching genre anime. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Searchbar(
              controller: _searchController,
              onSearch: _performSearch,
              isLoading: _isLoading,
            ),
          ),

          // Error Message Display
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                _error!,
                style: themeData.textTheme.bodyMedium?.copyWith(
                  color: themeData.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Genre Selection Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Select Genre',
              style: themeData.textTheme.titleMedium,
            ),
          ),

          // Genres Wrap
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 5.0,
              children: _genres.map((genre) {
                return ChoiceChip(
                  label: Text(genre),
                  selected: false,
                  onSelected: (bool selected) {
                    debugPrint('Selected genre: $genre');
                    _fetchGenreAnimes(
                      genre.toLowerCase().split(' ').join('-'),
                    ); // Fetch animes for the selected genre
                  },
                  selectedColor:
                      themeData.colorScheme.secondary.withOpacity(0.5),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
