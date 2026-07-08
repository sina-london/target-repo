// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nekoflow/data/models/search_result.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/screens/details.dart';
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
  bool? _hasNextPage = false;
  String? error;
  List<Anime>? _searchResults;

  Future<void> _performSearch() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      ResultResponse? result =
          await _animeService.fetchByQuery(query: _searchController.text);
      print(result);
      setState(() {
        _isLoading = false;
        _searchResults = result != null ? result.results : [];
        _hasNextPage = result?.hasNextPage;
      });
    } catch (e) {
      setState(() {
        error = 'Something went wrong';
        _isLoading = false;
      });
    }
  }

  Widget _buildResultRow({required Anime anime, required int index}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Details(id: anime.id, image: anime.image, title: anime.title),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
              child: Image.network(
                anime.image,
                width: MediaQuery.of(context).size.width *
                    0.3, // Adjust width as needed
                height: MediaQuery.of(context).size.width *
                    0.4, // Maintain aspect ratio
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${index + 1}. ${anime.title}",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Wrap(
                    spacing: 4.0, // Space between items in the wrap
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          anime.subOrDub.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                      // You can add more tags or information here in the future
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(child: Text(error!))
            else if (_searchResults == null ||
                (_searchResults != null && _searchResults!.isEmpty))
              const Center(child: Text('No items found'))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _searchResults!.length,
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,

                  physics: BouncingScrollPhysics(),
                  // Enable swiping to dismiss the keyboard
                  itemBuilder: (context, index) => _buildResultRow(
                      anime: _searchResults![index], index: index),
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                ),
              ),
            Text("$_hasNextPage")
          ],
        ),
      ),
    );
  }
}
