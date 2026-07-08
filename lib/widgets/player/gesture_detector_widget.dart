// lib/widgets/player/gesture/gesture_detector_widget.dart
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shonenx/widgets/player/gesture_overlay.dart';

import 'package:shonenx/providers/watch_providers.dart';

class PlayerGestureDetector extends ConsumerStatefulWidget {
  final PlayerState playerState;
  final PlayerStateNotifier playerNotifier;
  final AnimationController gestureAnimationController;
  final VoidCallback onToggleControls;
  final VoidCallback onResetTimer;
  final Widget child;

  const PlayerGestureDetector({
    super.key,
    required this.playerState,
    required this.playerNotifier,
    required this.gestureAnimationController,
    required this.onToggleControls,
    required this.onResetTimer,
    required this.child,
  });

  @override
  ConsumerState<PlayerGestureDetector> createState() =>
      _PlayerGestureDetectorState();
}

class _PlayerGestureDetectorState extends ConsumerState<PlayerGestureDetector>
    with TickerProviderStateMixin {
  // Gesture state
  bool _isVerticalDrag = false;
  bool _isHorizontalDrag = false;
  bool _isDragging = false;
  double _dragStartX = 0;
  double _dragStartY = 0;
  double _currentDragX = 0;
  double _currentDragY = 0;

  // Volume and brightness
  double _currentVolume = 0.5;
  double _currentBrightness = 0.5;
  double _initialVolume = 0.5;
  double _initialBrightness = 0.5;

  // Seek gesture
  Duration _seekOffset = Duration.zero;
  bool _isSeeking = false;
  Timer? _seekDisplayTimer;

  // Double tap
  DateTime? _lastTapTime;
  Offset? _lastTapPosition;
  static const _doubleTapTimeout = Duration(milliseconds: 300);
  static const _seekDuration = Duration(seconds: 10);

  // Overlay state
  GestureOverlayType _overlayType = GestureOverlayType.none;
  double _overlayValue = 0.0;
  String _overlayText = '';

  @override
  void initState() {
    super.initState();
    _initializeSystem();
  }

  Future<void> _initializeSystem() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _currentVolume = await FlutterVolumeController.getVolume() ?? 1;
        _currentBrightness = await ScreenBrightness().application;
        setState(() {});
      }
    } catch (e) {
      // Handle platform-specific errors
      _currentVolume = 0.5;
      _currentBrightness = 0.5;
    }
  }

  @override
  void dispose() {
    _seekDisplayTimer?.cancel();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    final now = DateTime.now();
    final position = details.globalPosition;

    if (_lastTapTime != null &&
        _lastTapPosition != null &&
        now.difference(_lastTapTime!) < _doubleTapTimeout &&
        (position - _lastTapPosition!).distance < 50) {
      // Double tap detected
      _handleDoubleTap(position);
      _lastTapTime = null;
      _lastTapPosition = null;
    } else {
      _lastTapTime = now;
      _lastTapPosition = position;

      // Schedule single tap action
      Timer(_doubleTapTimeout, () {
        if (_lastTapTime == now && mounted) {
          _handleSingleTap();
        }
      });
    }
  }

  void _handleSingleTap() {
    widget.onToggleControls();
  }

  void _handleDoubleTap(Offset position) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLeftSide = position.dx < screenWidth / 2;

    widget.onResetTimer();
    _performSeek(isLeftSide ? -_seekDuration : _seekDuration);

    // Show seek feedback
    _showSeekOverlay(isLeftSide);
    HapticFeedback.mediumImpact();
  }

  void _handlePanStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
    _dragStartY = details.globalPosition.dy;
    _currentDragX = _dragStartX;
    _currentDragY = _dragStartY;
    _isDragging = false;
    _isVerticalDrag = false;
    _isHorizontalDrag = false;

    _initialVolume = _currentVolume;
    _initialBrightness = _currentBrightness;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _currentDragX = details.globalPosition.dx;
    _currentDragY = details.globalPosition.dy;

    final deltaX = _currentDragX - _dragStartX;
    final deltaY = _currentDragY - _dragStartY;

    // Determine gesture type if not already determined
    if (!_isDragging) {
      if (deltaX.abs() > 20 || deltaY.abs() > 20) {
        _isDragging = true;
        if (deltaY.abs() > deltaX.abs()) {
          _isVerticalDrag = true;
          _handleVerticalDragStart();
        } else {
          _isHorizontalDrag = true;
          _handleHorizontalDragStart();
        }
      }
    }

    if (_isDragging) {
      if (_isVerticalDrag) {
        _handleVerticalDrag(deltaY);
      } else if (_isHorizontalDrag) {
        _handleHorizontalDrag(deltaX);
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_isSeeking) {
      _commitSeek();
    }

    _hideOverlay();
    _isDragging = false;
    _isVerticalDrag = false;
    _isHorizontalDrag = false;
    _isSeeking = false;
    _seekOffset = Duration.zero;
  }

  void _handleVerticalDragStart() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLeftSide = _dragStartX < screenWidth / 2;

    if (isLeftSide) {
      // Left side: brightness control
      _overlayType = GestureOverlayType.brightness;
      _overlayValue = _currentBrightness;
      _overlayText = '${(_currentBrightness * 100).round()}%';
    } else {
      // Right side: volume control
      _overlayType = GestureOverlayType.volume;
      _overlayValue = _currentVolume;
      _overlayText = '${(_currentVolume * 100).round()}%';
    }

    _showOverlay();
  }

  void _handleVerticalDrag(double deltaY) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sensitivity = 2.0 / screenHeight;
    final change = -deltaY * sensitivity;

    if (_overlayType == GestureOverlayType.brightness) {
      _currentBrightness = (_initialBrightness + change).clamp(0.0, 1.0);
      _setBrightness(_currentBrightness);
      _overlayValue = _currentBrightness;
      _overlayText = '${(_currentBrightness * 100).round()}%';
    } else if (_overlayType == GestureOverlayType.volume) {
      _currentVolume = (_initialVolume + change).clamp(0.0, 1.0);
      _setVolume(_currentVolume);
      _overlayValue = _currentVolume;
      _overlayText = '${(_currentVolume * 100).round()}%';
    }
  }

  void _handleHorizontalDragStart() {
    _overlayType = GestureOverlayType.seek;
    _isSeeking = true;
    _seekOffset = Duration.zero;
    _showOverlay();
  }

  void _handleHorizontalDrag(double deltaX) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sensitivity = widget.playerState.duration.inSeconds / screenWidth;
    final seekSeconds = (deltaX * sensitivity).round();

    _seekOffset = Duration(seconds: seekSeconds);
    final newPosition = widget.playerState.position + _seekOffset;
    final clampedPosition = Duration(
      seconds:
          newPosition.inSeconds.clamp(0, widget.playerState.duration.inSeconds),
    );

    _overlayValue =
        clampedPosition.inSeconds / widget.playerState.duration.inSeconds;
    _overlayText = _formatDuration(clampedPosition);
  }

  Future<void> _performSeek(Duration offset) async {
    final newPosition = widget.playerState.position + offset;
    await widget.playerNotifier.seek(newPosition);
  }

  Future<void> _commitSeek() async {
    if (_seekOffset != Duration.zero) {
      await _performSeek(_seekOffset);
    }
  }

  Future<void> _setBrightness(double brightness) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await ScreenBrightness().setApplicationScreenBrightness(brightness);
      }
    } catch (e) {
      // Handle platform-specific errors
    }
  }

  Future<void> _setVolume(double volume) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await FlutterVolumeController.setVolume(volume);
        setState(() {});
      }
    } catch (e) {
      // Handle platform-specific errors
    }
  }

  void _showOverlay() {
    widget.gestureAnimationController.forward();
  }

  void _hideOverlay() {
    widget.gestureAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _overlayType = GestureOverlayType.none;
        });
      }
    });
  }

  void _showSeekOverlay(bool isBackward) {
    setState(() {
      _overlayType = isBackward
          ? GestureOverlayType.seekBackward
          : GestureOverlayType.seekForward;
      _overlayText = '${isBackward ? '-' : '+'}${_seekDuration.inSeconds}s';
    });

    _showOverlay();

    _seekDisplayTimer?.cancel();
    _seekDisplayTimer = Timer(const Duration(milliseconds: 800), () {
      _hideOverlay();
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _handleTapDown,
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: widget.child,
        ),
        GestureOverlay(
          animationController: widget.gestureAnimationController,
          type: _overlayType,
          value: _overlayValue,
          text: _overlayText,
        ),
      ],
    );
  }
}
