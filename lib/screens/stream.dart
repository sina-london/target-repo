import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nekoflow/data/models/watch_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:video_player/video_player.dart';

class Stream extends StatefulWidget {
  final String id;
  final String title;
  const Stream({super.key, required this.id, required this.title});

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  WatchResponse? _streamData;
  AnimeService _animeService = AnimeService();
  VideoPlayerController? _playerController;
  bool _isLoading = true;
  List<WatchSource>? _sources;
  String? _downloadUrl;
  String? _error;
  bool _isFullScreen = false;
  bool _showControls = false;

  Future<void> fetchData() async {
    _toggleFullScren();
    setState(() {
      _isLoading = true;
      _streamData = null;
    });

    try {
      final result = await _animeService.fetchStream(id: widget.id);
      setState(() {
        _sources = result?.sources;
        _downloadUrl = result?.download;
      });
      await _initializePlayer();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch data';
      });
    }
  }

  Future<void> _initializePlayer() async {
    try {
      if (_sources == null || _sources!.isEmpty) {
        throw Exception('No video sources available');
      }

      _playerController =
          VideoPlayerController.networkUrl(Uri.parse(_sources![0].url));
      await _playerController!.initialize();
      setState(() {
        _isLoading = false;
      });
      _playerController!.play();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to initialize player: ${e.toString()}';
      });
    }
  }

  void _toggleFullScren() {
    if (!mounted) return;
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  Future<void> _seekRelative(Duration duration) async {
    final position = await _playerController!.position;
    if (position != null) {
      await _playerController!.seekTo(position + duration);
    }
  }

  Widget _buildPlayerControls() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayerButton(
              icon: const Icon(Icons.replay_10),
              callback: () => _seekRelative(const Duration(seconds: -10))),
          _buildPlayerButton(
              icon: Icon(
                !_playerController!.value.isPlaying
                    ? Icons.play_arrow
                    : Icons.pause,
                size: 40,
              ),
              label: "play",
              callback: () {
                _playerController!.value.isPlaying
                    ? _playerController!.pause()
                    : _playerController!.play();
                setState(() {});
              }),
          _buildPlayerButton(
              icon: const Icon(Icons.forward_10),
              callback: () => _seekRelative(const Duration(seconds: 10)))
        ],
      ),
    );
  }

  Widget _buildPlayerButton({
    String? label,
    required Icon icon,
    required VoidCallback callback,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: GestureDetector(
        onTap: callback,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: label == 'play' ? Colors.white : Colors.black,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: label == 'play' ? Colors.black : Colors.white,
                  size: 28.0,
                ),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? "$hours:$minutes:$seconds"
        : "$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (_playerController != null) {
      _playerController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: !_isFullScreen
      //     ? null
      //     : AppBar(
      //         title: Text(widget.title),
      //         centerTitle: true,
      //       ),
      body: Container(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _error != null
                  ? Center(
                      child: Text(_error!),
                    )
                  : GestureDetector(
                      onTap: () =>
                          setState(() => _showControls = !_showControls),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Video Player
                          _playerController != null &&
                                  _playerController!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _playerController!.value.aspectRatio,
                                  child: VideoPlayer(_playerController!),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_showControls) ...[
                                  VideoProgressIndicator(
                                    _playerController!,
                                    allowScrubbing: true,
                                    colors: const VideoProgressColors(
                                      playedColor: Colors.red,
                                      bufferedColor: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ValueListenableBuilder(
                                            valueListenable: _playerController!,
                                            builder: (context, value, child) {
                                              return Text(
                                                '${_formatDuration(value.duration)}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              );
                                            }),
                                        _buildPlayerControls(),
                                        ValueListenableBuilder(
                                            valueListenable: _playerController!,
                                            builder: (context, value, child) {
                                              return Text(
                                                '${_formatDuration(value.position)}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
