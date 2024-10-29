import 'dart:async';

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
  Duration? _lastPosition;
  int _currentSourceIndex = 0;
  bool _isDraggingProgress = false;
  Timer? _hideControlsTimer;

  Future<void> fetchData() async {
    _toggleFullScreen();
    setState(() {
      _isLoading = true;
      _streamData = null;
      _error = null;
    });

    try {
      final result = await _animeService.fetchStream(id: widget.id);
      if (!mounted) return;
      setState(() {
        _sources = result!.sources;
        _downloadUrl = result.download;
      });
      await _initializePlayer();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to fetch data: ${e.toString()}';
      });
    }
  }

  Future<void> _initializePlayer() async {
    try {
      if (_sources == null || _sources!.isEmpty) {
        throw Exception('No video sources available');
      }

      _playerController?.dispose();
      _playerController = VideoPlayerController.networkUrl(
        Uri.parse(_sources![_currentSourceIndex].url),
      );

      await _playerController!.initialize();

      if (_lastPosition != null) {
        await _playerController!.seekTo(_lastPosition!);
      }

      _playerController!.addListener(_playerListener);
      await _playerController!.play();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to initialize player: ${e.toString()}';
      });
    }
  }

  void _playerListener() {
    if (!mounted) return;
    setState(() {});
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    if (_showControls && !_isDraggingProgress) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _showControls && !_isDraggingProgress) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  void _handleControlsVisibility() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _toggleFullScreen() {
    if (!mounted) return;
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  Future<void> _seekRelative(Duration duration) async {
    final position = await _playerController!.position;
    if (position != null) {
      await _playerController!.seekTo(position + duration);
    }
    _startHideControlsTimer(); // Reset timer after seeking
  }

  Future<void> _changeVideoSource(int index) async {
    if (_currentSourceIndex == index) return;
    setState(() {
      _isLoading = true;
      _currentSourceIndex = index;
    });

    _lastPosition = await _playerController!.position;
    await _initializePlayer();
  }

  Widget _buildPlayerControls() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black45,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlayerButton(
                  icon: const Icon(Icons.replay_10),
                  tooltip: 'Rewind 10 seconds',
                  callback: () => _seekRelative(const Duration(seconds: -10)),
                ),
                _buildPlayerButton(
                  icon: Icon(
                    !_playerController!.value.isPlaying
                        ? Icons.play_arrow
                        : Icons.pause,
                    size: 40,
                  ),
                  tooltip:
                      _playerController!.value.isPlaying ? 'Pause' : 'Play',
                  label: "play",
                  callback: () {
                    setState(() {
                      _playerController!.value.isPlaying
                          ? _playerController!.pause()
                          : _playerController!.play();
                    });
                    _startHideControlsTimer(); // Reset timer after play/pause
                  },
                ),
                _buildPlayerButton(
                  icon: const Icon(Icons.forward_10),
                  tooltip: 'Forward 10 seconds',
                  callback: () => _seekRelative(const Duration(seconds: 10)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ValueListenableBuilder(
      valueListenable: _playerController!,
      builder: (context, VideoPlayerValue value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.grey[600],
                  thumbColor: Colors.red,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 12),
                  trackHeight: 2.0,
                ),
                child: Slider(
                  value: value.position.inMilliseconds.toDouble(),
                  min: 0,
                  max: value.duration.inMilliseconds.toDouble(),
                  onChangeStart: (_) {
                    setState(() => _isDraggingProgress = true);
                    _hideControlsTimer?.cancel(); // Cancel timer while dragging
                  },
                  onChangeEnd: (_) {
                    setState(() => _isDraggingProgress = false);
                    _startHideControlsTimer(); // Restart timer after dragging
                  },
                  onChanged: (double position) {
                    _playerController!
                        .seekTo(Duration(milliseconds: position.toInt()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(value.position),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      _formatDuration(value.duration),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerButton({
    required Icon icon,
    required VoidCallback callback,
    String? label,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GestureDetector(
          onTap: () {
            callback();
            _startHideControlsTimer(); // Reset timer after button press
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: label == 'play' ? Colors.white : Colors.black38,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconTheme(
              data: IconThemeData(
                color: label == 'play' ? Colors.black : Colors.white,
                size: 28.0,
              ),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceSelector() {
    if (_sources == null || _sources!.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: PopupMenuButton<int>(
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _sources![_currentSourceIndex].quality,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Icon(Icons.arrow_drop_down, size: 20, color: Colors.white),
            ],
          ),
        ),
        onSelected: (int index) {
          _changeVideoSource(index);
          _startHideControlsTimer(); // Reset timer after source change
        },
        color: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        itemBuilder: (context) {
          return List.generate(_sources!.length, (index) {
            return PopupMenuItem<int>(
              value: index,
              child: Row(
                children: [
                  if (_currentSourceIndex == index)
                    const Icon(Icons.check, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _sources![index].quality,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: _currentSourceIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          });
        },
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
    _hideControlsTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _playerController?.removeListener(_playerListener);
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: !_showControls
          ? null
          : AppBar(
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.black.withOpacity(0.8),
              elevation: 0,
              actions: [
                _buildSourceSelector(),
                IconButton(
                  onPressed: () {
                    _toggleFullScreen();
                    _startHideControlsTimer(); // Reset timer after fullscreen toggle
                  },
                  icon: Icon(
                    _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.red)
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: fetchData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: _handleControlsVisibility,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: _playerController != null &&
                              _playerController!.value.isInitialized
                          ? [
                              AspectRatio(
                                aspectRatio:
                                    _playerController!.value.aspectRatio,
                                child: VideoPlayer(_playerController!),
                              ),
                              if (_showControls)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Center(
                                      child: _buildPlayerControls(),
                                    ),
                                  ],
                                ),
                            ]
                          : [
                              const Center(
                                child: Text(
                                  'No video sources available',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                    ),
                  ),
      ),
    );
  }
}
