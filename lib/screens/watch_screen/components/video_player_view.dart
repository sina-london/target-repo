import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shonenx/screens/watch_screen/controls.dart';

/// Main video player component with optimized rendering
class VideoPlayerView extends ConsumerWidget {
  final VideoController controller;
  final AnimationController panelAnimationController;

  const VideoPlayerView({
    super.key,
    required this.controller,
    required this.panelAnimationController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using a more efficient filter quality setting based on platform
    final filterQuality = kDebugMode
        ? FilterQuality.low
        : (kIsWeb ? FilterQuality.medium : FilterQuality.none);

    return Expanded(
      child: Video(
        controller: controller,
        subtitleViewConfiguration:
            const SubtitleViewConfiguration(visible: false),
        filterQuality: filterQuality,
        fit: BoxFit.contain,
        controls: (state) => CustomControls(
          state: state,
          panelAnimationController: panelAnimationController,
        ),
      ),
    );
  }
}
