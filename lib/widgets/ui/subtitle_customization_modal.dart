import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/data/hive/providers/player_provider.dart';

void setSubtitleAppearance(BuildContext context, WidgetRef ref) async {
  final playerSettings = ref.read(playerSettingsProvider);
  double tempFontSize = playerSettings.subtitleFontSize;
  Color tempTextColor = Color(playerSettings.subtitleTextColor);
  double tempBackgroundOpacity = playerSettings.subtitleBackgroundOpacity;
  bool tempBoldText = playerSettings.subtitleBoldText;
  int tempPosition = playerSettings.subtitlePosition;
  bool tempHasShadow = playerSettings.subtitleHasShadow;
  double tempShadowOpacity = playerSettings.subtitleShadowOpacity;
  double tempShadowBlur = playerSettings.subtitleShadowBlur;
  String tempFontFamily = playerSettings.subtitleFontFamily ?? 'Default';
  bool tempForceUppercase = playerSettings.subtitleForceUppercase;

  final colorScheme = Theme.of(context).colorScheme;

  final List<Map<String, dynamic>> colorOptions = [
    {'color': Colors.white, 'name': 'White'},
    {'color': const Color(0xFFFFE066), 'name': 'Yellow'},
    {'color': const Color(0xFF64FFDA), 'name': 'Cyan'},
    {'color': const Color(0xFFFF5722), 'name': 'Red'},
  ];

  final fontFamilies = ['Default', 'Roboto', 'OpenSans', 'Montserrat'];

  final updated = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // Header
                Text(
                  'Subtitle Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Live Preview
                Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        'https://static1.cbrimages.com/wordpress/wp-content/uploads/2025/04/mixcollage-16-apr-2025-08-53-pm-2639.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: tempPosition == 0
                      ? Alignment.topCenter
                      : tempPosition == 1
                          ? Alignment.center
                          : Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(tempBackgroundOpacity > 0 ? 8 : 0),
                    color: tempBackgroundOpacity > 0
                        ? Colors.black.withOpacity(tempBackgroundOpacity)
                        : null,
                    child: Text(
                      tempForceUppercase
                          ? 'SAMPLE SUBTITLE'
                          : 'Sample Subtitle',
                      style: TextStyle(
                        fontSize: tempFontSize,
                        color: tempTextColor,
                        fontWeight:
                            tempBoldText ? FontWeight.bold : FontWeight.normal,
                        fontFamily:
                            tempFontFamily != 'Default' ? tempFontFamily : null,
                        shadows: tempHasShadow
                            ? [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: tempShadowBlur,
                                  color: Colors.black
                                      .withOpacity(tempShadowOpacity),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Settings
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Font Size Slider
                        _buildSlider(
                          context,
                          'Font Size',
                          tempFontSize,
                          12.0,
                          32.0,
                          '${tempFontSize.round()}px',
                          (value) => setDialogState(() => tempFontSize = value),
                        ),
                        const SizedBox(height: 16),

                        // Font Family Dropdown
                        _buildDropdown(
                          context,
                          'Font Family',
                          tempFontFamily,
                          fontFamilies,
                          (value) =>
                              setDialogState(() => tempFontFamily = value!),
                        ),
                        const SizedBox(height: 16),

                        // Color Selector
                        _buildColorSelector(
                          colorOptions,
                          tempTextColor,
                          (color) =>
                              setDialogState(() => tempTextColor = color),
                        ),
                        const SizedBox(height: 16),

                        // Position Selector
                        _buildPositionSelector(
                          context,
                          tempPosition,
                          (pos) => setDialogState(() => tempPosition = pos),
                        ),
                        const SizedBox(height: 16),

                        // Bold Toggle
                        _buildToggle(
                          context,
                          'Bold Text',
                          tempBoldText,
                          (value) => setDialogState(() => tempBoldText = value),
                        ),
                        const SizedBox(height: 16),

                        // Uppercase Toggle
                        _buildToggle(
                          context,
                          'Uppercase',
                          tempForceUppercase,
                          (value) =>
                              setDialogState(() => tempForceUppercase = value),
                        ),
                        const SizedBox(height: 16),

                        // Text Shadow Toggle
                        _buildToggle(
                          context,
                          'Text Shadow',
                          tempHasShadow,
                          (value) =>
                              setDialogState(() => tempHasShadow = value),
                        ),
                        if (tempHasShadow) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildSlider(
                                  context,
                                  'Shadow Opacity',
                                  tempShadowOpacity,
                                  0.0,
                                  1.0,
                                  '${(tempShadowOpacity * 100).round()}%',
                                  (value) => setDialogState(
                                      () => tempShadowOpacity = value),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildSlider(
                                  context,
                                  'Shadow Blur',
                                  tempShadowBlur,
                                  1.0,
                                  10.0,
                                  '${tempShadowBlur.toStringAsFixed(1)}px',
                                  (value) => setDialogState(
                                      () => tempShadowBlur = value),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),

                        // Background Opacity Slider
                        _buildSlider(
                          context,
                          'Background Opacity',
                          tempBackgroundOpacity,
                          0.0,
                          1.0,
                          tempBackgroundOpacity == 0
                              ? 'None'
                              : '${(tempBackgroundOpacity * 100).round()}%',
                          (value) => setDialogState(
                              () => tempBackgroundOpacity = value),
                        ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(playerSettingsProvider.notifier)
                              .updateSettings((prev) => prev.copyWith(
                                    subtitleFontSize: tempFontSize,
                                    subtitleTextColor: tempTextColor.value,
                                    subtitleBackgroundOpacity:
                                        tempBackgroundOpacity,
                                    subtitleBoldText: tempBoldText,
                                    subtitlePosition: tempPosition,
                                    subtitleHasShadow: tempHasShadow,
                                    subtitleShadowOpacity: tempShadowOpacity,
                                    subtitleShadowBlur: tempShadowBlur,
                                    subtitleFontFamily: tempFontFamily,
                                    subtitleForceUppercase: tempForceUppercase,
                                  ));
                          Navigator.pop(context, true);
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (updated == true) {
    // Handle settings save if needed
  }
}

Widget _buildSlider(
  BuildContext context,
  String label,
  double value,
  double min,
  double max,
  String displayValue,
  ValueChanged<double> onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(displayValue),
        ],
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primaryContainer,
        inactiveColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    ],
  );
}

Widget _buildColorSelector(
  List<Map<String, dynamic>> colors,
  Color selectedColor,
  ValueChanged<Color> onColorSelected,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Color'),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: colors.map((colorData) {
          final color = colorData['color'] as Color;
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedColor == color
                      ? Colors.black
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildPositionSelector(
  BuildContext context,
  int selectedPosition,
  ValueChanged<int> onPositionChanged,
) {
  final theme = Theme.of(context);
  final positions = [
    {'label': 'Top', 'value': 0},
    {'label': 'Center', 'value': 1},
    {'label': 'Bottom', 'value': 2},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Position'),
      const SizedBox(height: 8),
      Row(
        children: positions.map((pos) {
          final isSelected = selectedPosition == pos['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onPositionChanged(pos['value'] as int),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primaryContainer : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pos['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildToggle(
  BuildContext context,
  String label,
  bool value,
  ValueChanged<bool> onChanged,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label),
      Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
        activeColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    ],
  );
}

Widget _buildDropdown(
  BuildContext context,
  String label,
  String value,
  List<String> options,
  ValueChanged<String?> onChanged,
) {
  final theme = Theme.of(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: option != 'Default' ? option : null,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
