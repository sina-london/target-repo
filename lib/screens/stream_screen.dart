import 'dart:async';

import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/models/watch_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';

class StreamScreen extends StatefulWidget {
  final String id;
  final String title;
  final List<Episode> episodes;
  const StreamScreen({
    super.key,
    required this.id,
    required this.episodes,
    required this.title,
  });

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen>
    with WidgetsBindingObserver {
  BetterPlayerController? _playerController;
  late final AnimeService _animeService;
  WatchResponseModel? _watchData;
  bool _isLoading = true;

  Future<void> _fetchData() async {
    if (!mounted) return;

    try {
      final result = await _animeService.fetchWatchById(id: widget.id);
      if (!mounted) return;

      setState(() {
        _watchData = result;
      });
      await _initializePlayer();
    } catch (e) {
      print("Fetch error: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _initializePlayer() async {
    if (!mounted || _watchData == null) return;

    try {
      // Create data source outside setState
      final dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, _watchData!.sources[0].url,
          subtitles: _watchData!.subtitles
              .map((subtitle) => BetterPlayerSubtitlesSource(
                  type: BetterPlayerSubtitlesSourceType.network,
                  name: subtitle.lang,
                  urls: [subtitle.url]))
              .toList());

      // Create configuration outside setState
      final configuration = BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        handleLifecycle: true, // Handle app lifecycle events
        allowedScreenSleep: false, // Prevent screen from sleeping
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableProgressBar: true,
          enablePlayPause: true,
          enableSkips: true,
          enableFullscreen: true,
          enableMute: true,
          enableAudioTracks: true,
          enableOverflowMenu: true,
          controlBarColor: Colors.black26,
          controlBarHeight: 40,
          loadingColor: Theme.of(context).primaryColor,
          progressBarPlayedColor: Theme.of(context).primaryColor,
          progressBarHandleColor: Theme.of(context).primaryColor,
          progressBarBufferedColor: Colors.white70,
          progressBarBackgroundColor: Colors.white30,
          backwardSkipTimeInMilliseconds: 10000,
          forwardSkipTimeInMilliseconds: 10000,
        ),
      );

      final controller = BetterPlayerController(configuration);
      await controller.setupDataSource(dataSource);

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _playerController = controller;
        _isLoading = false;
      });
    } catch (e) {
      print("Player initialization error: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animeService = AnimeService();
    _fetchData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _playerController?.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerController?.dispose();
    _animeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_playerController == null) {
      return const Center(
        child: Text(
          'Failed to load video',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _playerController!.getAspectRatio()!,
        child: BetterPlayer(
          controller: _playerController!,
        ),
      ),
    );
  }
}
