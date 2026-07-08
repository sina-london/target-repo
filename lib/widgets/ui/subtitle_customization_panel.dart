import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/data/hive/providers/player_provider.dart';

class ModernSubtitleCustomizationPanel extends ConsumerStatefulWidget {
  const ModernSubtitleCustomizationPanel({super.key});

  @override
  ConsumerState<ModernSubtitleCustomizationPanel> createState() =>
      _ModernSubtitleCustomizationPanelState();

  /// Helper method to show the panel as a modal bottom sheet
  static Future<void> showAsModalBottomSheet({
    required BuildContext context,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.98,
          child: const ModernSubtitleCustomizationPanel()),
    );
  }
}

class _ModernSubtitleCustomizationPanelState
    extends ConsumerState<ModernSubtitleCustomizationPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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

    // Initialize animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
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
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final isWideScreen = screenSize.width > 600;
    final isDark = theme.brightness == Brightness.dark;

    // Adjust height based on orientation
    final panelHeight =
        isLandscape ? screenSize.height * 0.95 : screenSize.height * 0.85;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isLandscape ? 16 : 24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: panelHeight,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(isLandscape ? 16 : 24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, isWideScreen, isDark),

                  // Content
                  Expanded(
                    child: isLandscape
                        ? _buildPortraitLayout(theme, isWideScreen, isDark)
                        : _buildPortraitLayout(theme, isWideScreen, isDark),
                  ),

                  // Action Buttons
                  _buildActionButtons(theme, isWideScreen, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWideScreen, bool isDark) {
    return Container(
      padding: EdgeInsets.all(isWideScreen ? 20 : 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.subtitle,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Subtitle Settings',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Iconsax.close_circle,
                    color: (isDark ? Colors.white : Colors.black87)
                        .withOpacity(0.8),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
      ThemeData theme, bool isWideScreen, bool isDark) {
    return Row(
      children: [
        // Left side - Preview
        // Expanded(
        //   flex: 2,
        //   child: Container(
        //     padding: EdgeInsets.all(isWideScreen ? 20 : 16),
        //     child: _buildLivePreview(theme, isWideScreen, isDark),
        //   ),
        // ),

        // Right side - Controls
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isWideScreen ? 20 : 16),
            child: Column(
              children: [
                _buildCompactTextControls(theme, isWideScreen, isDark),
                const SizedBox(height: 16),
                _buildCompactAppearanceControls(theme, isWideScreen, isDark),
                const SizedBox(height: 16),
                _buildCompactPositionControls(theme, isWideScreen, isDark),
                const SizedBox(height: 16),
                _buildCompactShadowControls(theme, isWideScreen, isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(ThemeData theme, bool isWideScreen, bool isDark) {
    final double padding = isWideScreen ? 20 : 16;
    return Column(
      children: [
        // Live Preview
        Padding(
            padding: EdgeInsets.fromLTRB(padding, padding * 0.8, padding, 0),
            child: _buildLivePreview(theme, isWideScreen, isDark)),
        const SizedBox(height: 5),

        // Controls
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView(
                children: [
                  _buildCompactTextControls(theme, isWideScreen, isDark),
                  const SizedBox(height: 16),
                  _buildCompactAppearanceControls(theme, isWideScreen, isDark),
                  const SizedBox(height: 16),
                  _buildCompactPositionControls(theme, isWideScreen, isDark),
                  const SizedBox(height: 16),
                  _buildCompactShadowControls(theme, isWideScreen, isDark),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLivePreview(ThemeData theme, bool isWideScreen, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Iconsax.eye,
                  color: theme.colorScheme.primaryContainer,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Live Preview',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: isWideScreen ? 120 : 100,
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
              padding: EdgeInsets.all(tempBackgroundOpacity > 0 ? 6 : 0),
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
                            color: Colors.black.withOpacity(tempShadowOpacity),
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextControls(
      ThemeData theme, bool isWideScreen, bool isDark) {
    return _buildCompactSection(
      title: 'Text Style',
      icon: Iconsax.text,
      theme: theme,
      isDark: isDark,
      child: Column(
        children: [
          // Font size slider
          _buildSliderRow(
            icon: Iconsax.text_block,
            label: 'Size',
            value: tempFontSize,
            min: 12.0,
            max: 32.0,
            displayValue: '${tempFontSize.round()}px',
            onChanged: (value) => setState(() => tempFontSize = value),
            theme: theme,
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Font family and color row
          Row(
            children: [
              Expanded(
                child: _buildCompactDropdown(
                  icon: Iconsax.text_italic,
                  label: 'Font',
                  value: tempFontFamily,
                  items: ['Default', 'Roboto', 'OpenSans', 'Montserrat'],
                  onChanged: (value) => setState(() => tempFontFamily = value!),
                  theme: theme,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildColorSelector(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactAppearanceControls(
      ThemeData theme, bool isWideScreen, bool isDark) {
    return _buildCompactSection(
      title: 'Appearance',
      icon: Iconsax.brush_1,
      theme: theme,
      isDark: isDark,
      child: Column(
        children: [
          // Toggle buttons row
          Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  icon: Iconsax.text_bold,
                  label: 'Bold',
                  isActive: tempBoldText,
                  onTap: () => setState(() => tempBoldText = !tempBoldText),
                  theme: theme,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToggleButton(
                  icon: Iconsax.text,
                  label: 'UPPER',
                  isActive: tempForceUppercase,
                  onTap: () =>
                      setState(() => tempForceUppercase = !tempForceUppercase),
                  theme: theme,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Background opacity slider
          _buildSliderRow(
            icon: Iconsax.layer,
            label: 'Background',
            value: tempBackgroundOpacity,
            min: 0.0,
            max: 1.0,
            displayValue: tempBackgroundOpacity == 0
                ? 'None'
                : '${(tempBackgroundOpacity * 100).round()}%',
            onChanged: (value) => setState(() => tempBackgroundOpacity = value),
            theme: theme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPositionControls(
      ThemeData theme, bool isWideScreen, bool isDark) {
    return _buildCompactSection(
      title: 'Position',
      icon: Iconsax.align_vertically,
      theme: theme,
      isDark: isDark,
      child: _buildPositionSelector(theme, isDark),
    );
  }

  Widget _buildCompactShadowControls(
      ThemeData theme, bool isWideScreen, bool isDark) {
    return _buildCompactSection(
      title: 'Shadow',
      icon: Iconsax.ghost,
      theme: theme,
      isDark: isDark,
      child: Column(
        children: [
          _buildToggleButton(
            icon: Iconsax.ghost,
            label: 'Enable Shadow',
            isActive: tempHasShadow,
            onTap: () => setState(() => tempHasShadow = !tempHasShadow),
            theme: theme,
            isDark: isDark,
            fullWidth: true,
          ),
          if (tempHasShadow) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSliderRow(
                    icon: Icons.opacity_rounded,
                    label: 'Opacity',
                    value: tempShadowOpacity,
                    min: 0.0,
                    max: 1.0,
                    displayValue: '${(tempShadowOpacity * 100).round()}%',
                    onChanged: (value) =>
                        setState(() => tempShadowOpacity = value),
                    theme: theme,
                    isDark: isDark,
                    compact: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSliderRow(
                    icon: Iconsax.blur,
                    label: 'Blur',
                    value: tempShadowBlur,
                    min: 1.0,
                    max: 10.0,
                    displayValue: '${tempShadowBlur.toStringAsFixed(1)}px',
                    onChanged: (value) =>
                        setState(() => tempShadowBlur = value),
                    theme: theme,
                    isDark: isDark,
                    compact: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactSection({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black87).withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primaryContainer,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
    required ThemeData theme,
    required bool isDark,
    bool compact = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primaryContainer,
              size: 12,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: compact ? 11 : 12,
              ),
            ),
            const Spacer(),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: compact ? 10 : 11,
                color:
                    (isDark ? Colors.white : Colors.black87).withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: theme.colorScheme.primaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primaryContainer.withOpacity(0.2)
              : (isDark ? Colors.white : Colors.black87).withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primaryContainer
                : (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? theme.colorScheme.primaryContainer
                  : (isDark ? Colors.white : Colors.black87).withOpacity(0.7),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? theme.colorScheme.primaryContainer
                    : (isDark ? Colors.white : Colors.black87).withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDropdown({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primaryContainer,
              size: 12,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black87).withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 11,
            ),
            dropdownColor: theme.colorScheme.surface,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontFamily: item != 'Default' ? item : null,
                    fontSize: 11,
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

  Widget _buildColorSelector() {
    final colorOptions = [
      Colors.white,
      const Color(0xFFFFE066),
      const Color(0xFF64FFDA),
      const Color(0xFFFF5722),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.colorfilter,
              color: Theme.of(context).colorScheme.primaryContainer,
              size: 12,
            ),
            const SizedBox(width: 6),
            Text(
              'Color',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: colorOptions.map((color) {
            final isSelected = tempTextColor.value == color.value;
            return GestureDetector(
              onTap: () => setState(() => tempTextColor = color),
              child: Container(
                width: 28,
                height: 28,
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
                    ? Icon(
                        Icons.check,
                        color:
                            color == Colors.white ? Colors.black : Colors.white,
                        size: 14,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPositionSelector(ThemeData theme, bool isDark) {
    final positions = [
      {'label': 'Top', 'value': 0, 'icon': Icons.align_vertical_top_rounded},
      {'label': 'Center', 'value': 1, 'icon': Iconsax.align_horizontally},
      {'label': 'Bottom', 'value': 2, 'icon': Iconsax.align_bottom},
    ];

    return Row(
      children: positions.map((pos) {
        final isSelected = tempPosition == pos['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => tempPosition = pos['value'] as int),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                    : (isDark ? Colors.white : Colors.black87)
                        .withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : (isDark ? Colors.white : Colors.black87)
                          .withOpacity(0.1),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    pos['icon'] as IconData,
                    color: isSelected
                        ? theme.colorScheme.primaryContainer
                        : (isDark ? Colors.white : Colors.black87)
                            .withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pos['label'] as String,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.primaryContainer
                          : (isDark ? Colors.white : Colors.black87)
                              .withOpacity(0.8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isWideScreen, bool isDark) {
    return Container(
      padding: EdgeInsets.all(isWideScreen ? 20 : 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color:
                      (isDark ? Colors.white : Colors.black87).withOpacity(0.2),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black87)
                            .withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _applySettings,
                  borderRadius: BorderRadius.circular(10),
                  child: const Center(
                    child: Text(
                      'Apply Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
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
