import 'package:flutter/material.dart';
import 'package:shonenx/data/hive/models/subtitle_style_model.dart';

class SubtitleOverlay extends StatelessWidget {
  final String subtitle;
  final SubtitleStyle subtitleStyle;

  const SubtitleOverlay({
    super.key,
    required this.subtitle,
    required this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (subtitle.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: subtitleStyle.position == 0
          ? Alignment.topCenter
          : subtitleStyle.position == 1
              ? Alignment.center
              : Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.all(subtitleStyle.backgroundOpacity > 0 ? 8 : 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(subtitleStyle.backgroundOpacity),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          subtitleStyle.forceUppercase ? subtitle.toUpperCase() : subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: subtitleStyle.fontSize,
            color: subtitleStyle.textColor,
            fontWeight:
                subtitleStyle.boldText ? FontWeight.bold : FontWeight.normal,
            fontFamily: subtitleStyle.fontFamily != 'Default'
                ? subtitleStyle.fontFamily
                : null,
            shadows: subtitleStyle.hasShadow
                ? [
                    Shadow(
                      color:
                          Colors.black.withOpacity(subtitleStyle.shadowOpacity),
                      offset: const Offset(1, 1),
                      blurRadius: subtitleStyle.shadowBlur,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
