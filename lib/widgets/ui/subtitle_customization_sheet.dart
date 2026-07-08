import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/data/hive/providers/player_provider.dart';

class SubtitleCustomizationSheet extends ConsumerStatefulWidget {
  const SubtitleCustomizationSheet({super.key});

  @override
  ConsumerState<SubtitleCustomizationSheet> createState() =>
      _SubtitleCustomizationSheetState();

  static Future<void> showAsModalBottomSheet({
    required BuildContext context,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: const SubtitleCustomizationSheet()),
    );
  }
}

class _SubtitleCustomizationSheetState
    extends ConsumerState<SubtitleCustomizationSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Temp variables for settings
  late double tempFontSize;
  late Color tempTextColor;
  late double tempBackgroundOpacity;
  late bool tempBoldText;
  late int tempPosition;
  late bool tempHasShadow;
  late double tempShadowOpacity;
  late double tempShadowBlur;
  late String tempFontFamily;
  late bool tempForceUppercase;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize temp settings
    final playerSettings = ref.read(playerSettingsProvider);
    tempFontSize = playerSettings.subtitleFontSize;
    tempTextColor = Color(playerSettings.subtitleTextColor);
    tempBackgroundOpacity = playerSettings.subtitleBackgroundOpacity;
    tempBoldText = playerSettings.subtitleBoldText;
    tempPosition = playerSettings.subtitlePosition;
    tempHasShadow = playerSettings.subtitleHasShadow;
    tempShadowOpacity = playerSettings.subtitleShadowOpacity;
    tempShadowBlur = playerSettings.subtitleShadowBlur;
    tempFontFamily = playerSettings.subtitleFontFamily ?? 'Default';
    tempForceUppercase = playerSettings.subtitleForceUppercase;

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.9),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildCompactHeader(context, theme, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        _buildPreview(theme, isDark),
                        const SizedBox(height: 12),
                        _buildTextSection(theme, isDark),
                        const SizedBox(height: 12),
                        _buildStyleSection(theme, isDark),
                        const SizedBox(height: 12),
                        _buildPositionSection(theme, isDark),
                        const SizedBox(height: 12),
                        _buildShadowSection(theme, isDark),
                      ],
                    ),
                  ),
                ),
                _buildActions(theme, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader(
      BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.subtitle, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          const Text(
            'Subtitle Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            iconSize: 20,
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(ThemeData theme, bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
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
        padding: EdgeInsets.symmetric(
          horizontal: tempBackgroundOpacity > 0 ? 8 : 4,
          vertical: tempBackgroundOpacity > 0 ? 4 : 2,
        ),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tempBackgroundOpacity > 0
              ? Colors.black.withOpacity(tempBackgroundOpacity)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tempForceUppercase ? 'SAMPLE SUBTITLE' : 'Sample Subtitle',
          style: TextStyle(
            fontSize: tempFontSize * 0.8,
            color: tempTextColor,
            fontWeight: tempBoldText ? FontWeight.bold : FontWeight.normal,
            fontFamily: tempFontFamily != 'Default' ? tempFontFamily : null,
            shadows: tempHasShadow
                ? [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: tempShadowBlur,
                      color: Colors.black.withOpacity(tempShadowOpacity),
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection(ThemeData theme, bool isDark) {
    return _buildSection(
      'Text',
      Iconsax.text,
      theme,
      isDark,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildSlider(
                  'Size',
                  tempFontSize,
                  12.0,
                  50.0,
                  '${tempFontSize.round()}px',
                  (v) => setState(() => tempFontSize = v),
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  'Font',
                  tempFontFamily,
                  ['Default', 'Roboto', 'OpenSans', 'Montserrat'],
                  (v) => setState(() => tempFontFamily = v!),
                  theme,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildColorPicker(),
        ],
      ),
    );
  }

  Widget _buildStyleSection(ThemeData theme, bool isDark) {
    return _buildSection(
      'Style',
      Iconsax.brush_1,
      theme,
      isDark,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildToggle(
                  'Bold',
                  Iconsax.text_bold,
                  tempBoldText,
                  () => setState(() => tempBoldText = !tempBoldText),
                  theme,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToggle(
                  'UPPER',
                  Iconsax.text,
                  tempForceUppercase,
                  () =>
                      setState(() => tempForceUppercase = !tempForceUppercase),
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSlider(
            'Background',
            tempBackgroundOpacity,
            0.0,
            1.0,
            tempBackgroundOpacity == 0
                ? 'None'
                : '${(tempBackgroundOpacity * 100).round()}%',
            (v) => setState(() => tempBackgroundOpacity = v),
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildPositionSection(ThemeData theme, bool isDark) {
    return _buildSection(
      'Position',
      Iconsax.align_vertically,
      theme,
      isDark,
      Row(
        children: [
          _buildPositionButton('Top', 0, Icons.align_vertical_top, theme),
          const SizedBox(width: 8),
          _buildPositionButton('Center', 1, Iconsax.align_horizontally, theme),
          const SizedBox(width: 8),
          _buildPositionButton('Bottom', 2, Iconsax.align_bottom, theme),
        ],
      ),
    );
  }

  Widget _buildShadowSection(ThemeData theme, bool isDark) {
    return _buildSection(
      'Shadow',
      Iconsax.ghost,
      theme,
      isDark,
      Column(
        children: [
          _buildToggle(
            'Enable Shadow',
            Iconsax.ghost,
            tempHasShadow,
            () => setState(() => tempHasShadow = !tempHasShadow),
            theme,
            fullWidth: true,
          ),
          if (tempHasShadow) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSlider(
                    'Opacity',
                    tempShadowOpacity,
                    0.0,
                    1.0,
                    '${(tempShadowOpacity * 100).round()}%',
                    (v) => setState(() => tempShadowOpacity = v),
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSlider(
                    'Blur',
                    tempShadowBlur,
                    1.0,
                    10.0,
                    '${tempShadowBlur.toStringAsFixed(1)}px',
                    (v) => setState(() => tempShadowBlur = v),
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, IconData icon, ThemeData theme, bool isDark, Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primaryContainer),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      String display, ValueChanged<double> onChanged, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(display,
                style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.7))),
          ],
        ),
        SizedBox(
          height: 32,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, IconData icon, bool value,
      VoidCallback onTap, ThemeData theme,
      {bool fullWidth = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: value
              ? theme.colorScheme.primaryContainer.withOpacity(0.15)
              : theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.outline.withOpacity(0.3),
            width: value ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 14,
                color: value
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.onSurface.withOpacity(0.7)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: value
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged, ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(6),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 11),
            dropdownColor: theme.colorScheme.surface,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item,
                    style: TextStyle(
                        fontFamily: item != 'Default' ? item : null,
                        fontSize: 11)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.white,
      const Color(0xFFFFE066),
      const Color(0xFF64FFDA),
      const Color(0xFFFF5722)
    ];

    return Row(
      children: [
        const Text('Color',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        ...colors.map((color) {
          final isSelected = tempTextColor.value == color.value;
          return GestureDetector(
            onTap: () => setState(() => tempTextColor = color),
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check,
                      color:
                          color == Colors.white ? Colors.black : Colors.white,
                      size: 12)
                  : null,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPositionButton(
      String label, int value, IconData icon, ThemeData theme) {
    final isSelected = tempPosition == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tempPosition = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withOpacity(0.15)
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.outline.withOpacity(0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 16,
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.onSurface.withOpacity(0.7)),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _applySettings,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  void _applySettings() {
    ref
        .read(playerSettingsProvider.notifier)
        .updateSettings((prev) => prev.copyWith(
              subtitleFontSize: tempFontSize,
              subtitleTextColor: tempTextColor.value,
              subtitleBackgroundOpacity: tempBackgroundOpacity,
              subtitleBoldText: tempBoldText,
              subtitlePosition: tempPosition,
              subtitleHasShadow: tempHasShadow,
              subtitleShadowOpacity: tempShadowOpacity,
              subtitleShadowBlur: tempShadowBlur,
              subtitleFontFamily: tempFontFamily,
              subtitleForceUppercase: tempForceUppercase,
            ));
    Navigator.of(context).pop();
  }
}
