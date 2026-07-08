import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/watch_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class Stream extends StatefulWidget {
  final String id;
  final String title;
  const Stream({super.key, required this.id, required this.title});

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  VideoPlayerController? _controller;
  WatchResponse? _streamData;
  bool _isLoading = true;
  bool _hasError = false;
  String _selectedQuality = '720p';
  bool _isControlsVisible = true;
  final AnimeService _animeService = AnimeService();
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _loadStream();
  }

  Future<void> _loadStream() async {
    setState(() => _isLoading = true);
    try {
      final streamData = await _animeService.fetchStream(id: widget.id);
      if (streamData != null) {
        setState(() {
          _streamData = streamData;
          _selectedQuality = streamData.sources
              .firstWhere(
                (source) => source.quality == '720p',
                orElse: () => streamData.sources.first,
              )
              .quality;
        });
        await _initializePlayer();
      } else {
        setState(() => _hasError = true);
      }
    } catch (e) {
      setState(() => _hasError = true);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _initializePlayer() async {
    final selectedSource = _streamData?.sources.firstWhere(
      (source) => source.quality == _selectedQuality,
      orElse: () => _streamData!.sources.first,
    );

    if (selectedSource != null) {
      _controller?.dispose();
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(selectedSource.url),
        httpHeaders: {
          'Referer': 'https://s3taku.com',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      try {
        await _controller?.initialize();
        await _controller?.play();
        setState(() {});

        // Add listener for auto-hiding controls
        _controller?.addListener(_videoListener);
      } catch (e) {
        print('Error initializing player: $e');
        setState(() => _hasError = true);
      }
    }
  }

  void _videoListener() {
    // Auto-hide controls after 3 seconds of inactivity
    if (_isControlsVisible && !_isDragging) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isControlsVisible && !_isDragging) {
          setState(() => _isControlsVisible = false);
        }
      });
    }
  }

  void _toggleControls() {
    setState(() => _isControlsVisible = !_isControlsVisible);
  }

  Future<void> _changeQuality(String quality) async {
    if (quality == _selectedQuality) return;

    final currentPosition = _controller?.value.position ?? Duration.zero;
    final wasPlaying = _controller?.value.isPlaying ?? false;

    setState(() {
      _selectedQuality = quality;
      _isLoading = true;
    });

    await _initializePlayer();

    // Restore previous position and play state
    await _controller?.seekTo(currentPosition);
    if (wasPlaying) {
      await _controller?.play();
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Widget _buildControls() {
    return AnimatedOpacity(
      opacity: _isControlsVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
            stops: const [0.0, 0.2, 0.8, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTopBar(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildIconButton(
                Icons.arrow_back,
                () => Navigator.pop(context),
                tooltip: 'Back',
              ),
              const SizedBox(width: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          _buildQualitySelector(),
        ],
      ),
    );
  }

  Widget _buildQualitySelector() {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_selectedQuality, style: const TextStyle(color: Colors.white)),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
      onSelected: _changeQuality,
      itemBuilder: (context) =>
          _streamData?.sources
              .map((source) => PopupMenuItem(
                    value: source.quality,
                    child: Row(
                      children: [
                        if (source.quality == _selectedQuality)
                          const Icon(Icons.check, size: 18, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(source.quality),
                      ],
                    ),
                  ))
              .toList() ??
          [],
    );
  }

  Widget _buildBottomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProgressBar(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              _buildPlayPauseButton(),
              const SizedBox(width: 12),
              _buildTimeDisplay(),
              const Spacer(),
              _buildIconButton(
                Icons.replay_10,
                () => _controller?.seekTo((_controller!.value.position -
                    const Duration(seconds: 10))),
                tooltip: 'Rewind 10 seconds',
              ),
              const SizedBox(width: 12),
              _buildIconButton(
                Icons.forward_10,
                () => _controller?.seekTo((_controller!.value.position +
                    const Duration(seconds: 10))),
                tooltip: 'Forward 10 seconds',
              ),
              const SizedBox(width: 12),
              _buildIconButton(
                Icons.fullscreen,
                () {}, // Implement fullscreen toggle if needed
                tooltip: 'Toggle fullscreen',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final position = _controller?.value.position ?? Duration.zero;
    final duration = _controller?.value.duration ?? Duration.zero;
    final progress = position.inMilliseconds / duration.inMilliseconds;

    return GestureDetector(
      onHorizontalDragStart: (details) => setState(() => _isDragging = true),
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final width = box.size.width;
        final position = details.localPosition.dx.clamp(0, width);
        final relativePosition = position / width;
        final newPosition = duration * relativePosition;
        _controller?.seekTo(newPosition);
      },
      onHorizontalDragEnd: (details) => setState(() => _isDragging = false),
      child: Stack(
        children: [
          Container(
            height: 5,
            color: Colors.white12,
          ),
          FractionallySizedBox(
            widthFactor: progress.isNaN || progress.isInfinite ? 0.0 : progress,
            child: Container(
              height: 5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton(
      icon: Icon(
        _controller?.value.isPlaying ?? false ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          if (_controller?.value.isPlaying ?? false) {
            _controller?.pause();
          } else {
            _controller?.play();
          }
        });
      },
    );
  }

  Widget _buildTimeDisplay() {
    final position = _controller?.value.position ?? Duration.zero;
    final duration = _controller?.value.duration ?? Duration.zero;
    final positionText = _formatDuration(position);
    final durationText = _formatDuration(duration);

    return Text(
      '$positionText / $durationText',
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed,
      {String? tooltip}) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.blue)
            : _hasError
                ? const Text(
                    'Failed to load stream',
                    style: TextStyle(color: Colors.white),
                  )
                : GestureDetector(
                    onTap: _toggleControls,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller?.value.aspectRatio ?? 16 / 9,
                          child: VideoPlayer(_controller!),
                        ),
                        _buildControls(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
