// lib/widgets/player/gesture/gesture_overlay.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum GestureOverlayType {
  none,
  volume,
  brightness,
  seek,
  seekForward,
  seekBackward,
}

class GestureOverlay extends StatelessWidget {
  final AnimationController animationController;
  final GestureOverlayType type;
  final double value;
  final String text;

  const GestureOverlay({
    super.key,
    required this.animationController,
    required this.type,
    required this.value,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (type == GestureOverlayType.none) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Center(
          child: _buildOverlayContent(context),
        );
      },
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case GestureOverlayType.volume:
        return _buildVolumeOverlay(theme);
      case GestureOverlayType.brightness:
        return _buildBrightnessOverlay(theme);
      case GestureOverlayType.seek:
        return _buildSeekOverlay(theme);
      case GestureOverlayType.seekForward:
      case GestureOverlayType.seekBackward:
        return _buildSeekFeedbackOverlay(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildVolumeOverlay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getVolumeIcon(),
            size: 32,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(theme),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrightnessOverlay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getBrightnessIcon(),
            size: 32,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(theme),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeekOverlay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.play,
            size: 20,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeekFeedbackOverlay(ThemeData theme) {
    final isForward = type == GestureOverlayType.seekForward;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isForward ? Iconsax.forward : Iconsax.backward,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    return SizedBox(
      width: 120,
      height: 4,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: theme.colorScheme.outline.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  IconData _getVolumeIcon() {
    if (value == 0) {
      return Iconsax.volume_cross;
    } else if (value < 0.3) {
      return Iconsax.volume_low;
    } else if (value < 0.7) {
      return Iconsax.volume;
    } else {
      return Iconsax.volume_high;
    }
  }

  IconData _getBrightnessIcon() {
    if (value < 0.3) {
      return Icons.brightness_1;
    } else if (value < 0.7) {
      return Icons.brightness_3;
    } else {
      return Iconsax.sun_1;
    }
  }
}
