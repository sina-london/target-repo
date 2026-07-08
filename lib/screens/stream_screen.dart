import 'package:flutter/material.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:better_player/better_player.dart';

class StreamScreen extends StatefulWidget {
  final String title;
  final String id;
  const StreamScreen({super.key, required this.title, required this.id});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  late AnimeService _animeService;
  late BetterPlayerController _playerController;

  Future<void> _fetchData() async {

  }

  void initializePlayer() {
    
  }

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
    _fetchData();
  }

  @override
  void dispose() {
    _animeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: [
          Container(color: Colors.red, height: 230,)
        ],
      ),
    );
  }
}
