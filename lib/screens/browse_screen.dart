// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/genres_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final AnimeService _animeService = AnimeService();
  List<Genre>? _genres = [];
  bool _isLoading = false;
  String? error;

  Future<void> fetchGenres() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      List<Genre>? result = await _animeService.fetchGenres();
      setState(() {
        _genres = result;
        _isLoading = false;
      });
      // response.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        error = 'Failed to fetch _genres';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchGenres,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                "Genres",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Wrap(
                      spacing: 8.0, // Horizontal spacing between items
                      runSpacing: 8.0, // Vertical spacing between items
                      children: _genres != null
                          ? _genres!.map((genre) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.0,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    genre.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList()
                          : [
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
