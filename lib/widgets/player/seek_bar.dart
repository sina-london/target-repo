import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:shonenx/utils/formatter.dart';

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final void Function(Duration) onSeek;
  final ThemeData theme;

  const SeekBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.theme,
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  late double _currentPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = _validatePosition(widget.position.inSeconds.toDouble());
  }

  @override
  void didUpdateWidget(SeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update position if not dragging and position has changed
    if (!_isDragging && oldWidget.position != widget.position) {
      setState(() {
        _currentPosition =
            _validatePosition(widget.position.inSeconds.toDouble());
      });
    }
  }

  // Validate position to ensure it's within bounds
  double _validatePosition(double position) {
    final maxDuration = _getValidDuration();
    return position.clamp(0.0, maxDuration);
  }

  // Get valid duration with minimum value
  double _getValidDuration() {
    return widget.duration.inSeconds > 0
        ? widget.duration.inSeconds.toDouble()
        : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final maxDuration = _getValidDuration();

    // Ensure position doesn't exceed duration
    if (_currentPosition > maxDuration) {
      _currentPosition = maxDuration;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final sliderHeight =
            isLandscape ? screenHeight * 0.1 : screenHeight * 0.05;
        final handlerHeight = sliderHeight * 0.4;
        final handlerWidth = constraints.maxWidth * 0.007;

        return FlutterSlider(
          values: [_currentPosition],
          min: 0,
          max: maxDuration,
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const SizedBox.shrink(),
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBar: BoxDecoration(
              color: widget.theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: widget.theme.colorScheme.onPrimaryContainer
                    .withOpacity(0.8),
              ),
            ),
            inactiveTrackBar: BoxDecoration(
              color:
                  widget.theme.colorScheme.onPrimaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: widget.theme.colorScheme.onPrimaryContainer
                    .withOpacity(0.3),
              ),
            ),
            activeTrackBarHeight: 8,
            inactiveTrackBarHeight: 8,
          ),
          tooltip: FlutterSliderTooltip(
            boxStyle: FlutterSliderTooltipBox(
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textStyle: TextStyle(
              color: widget.theme.colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            custom: (value) => Text(
              formatDuration(Duration(seconds: value.toInt())),
              style: TextStyle(
                color: widget.theme.colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          handlerHeight: handlerHeight,
          handlerWidth: handlerWidth,
          touchSize: handlerHeight * 1.5, // Increase touch target size
          onDragging: (handlerIndex, lowerValue, upperValue) {
            setState(() {
              _isDragging = true;
              _currentPosition = lowerValue as double;
            });
          },
          onDragCompleted: (handlerIndex, lowerValue, upperValue) {
            final newPosition = Duration(seconds: lowerValue.toInt());
            widget.onSeek(newPosition);
            setState(() {
              _isDragging = false;
              _currentPosition = _validatePosition(lowerValue.toDouble());
            });
          },
          // Add error handling for invalid values
          onDragStarted: (handlerIndex, lowerValue, upperValue) {
            setState(() {
              _isDragging = true;
            });
          },
          // Prevent slider from jumping when disabled
          disabled: maxDuration <= 1.0,
        );
      },
    );
  }
}
