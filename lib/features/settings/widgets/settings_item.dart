import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum SettingsItemType {
  normal,
  selectable,
  toggleable,
  slider,
  dropdown,
  segmentedToggle, // New toggle mode for 3-option selections
}

class SettingsItem extends StatelessWidget {
  final Icon icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final double roundness;

  // Selection mode properties
  final SettingsItemType type;
  final bool isSelected;
  final bool isInSelectionMode;

  // Toggle properties
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;

  // Slider properties
  final double? sliderValue;
  final double? sliderMin;
  final double? sliderMax;
  final int? sliderDivisions;
  final String? sliderSuffix;
  final ValueChanged<double>? onSliderChanged;

  // Dropdown properties
  final String? dropdownValue;
  final List<String>? dropdownItems;
  final ValueChanged<String?>? onDropdownChanged;

  // Segmented toggle properties (for 3-option toggle like System/Light/Dark)
  final int? segmentedSelectedIndex;
  final List<Widget>? segmentedOptions;
  final List<String>? segmentedLabels;
  final ValueChanged<int>? onSegmentedChanged;

  // Responsive and compact mode properties
  final bool isCompact;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.onTap,
    this.roundness = 12,
    this.type = SettingsItemType.normal,
    this.isSelected = false,
    this.isInSelectionMode = false,
    this.toggleValue,
    this.onToggleChanged,
    this.sliderValue,
    this.sliderMin,
    this.sliderMax,
    this.sliderDivisions,
    this.sliderSuffix,
    this.onSliderChanged,
    this.dropdownValue,
    this.dropdownItems,
    this.onDropdownChanged,
    this.segmentedSelectedIndex,
    this.segmentedOptions,
    this.segmentedLabels,
    this.onSegmentedChanged,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if this item should be greyed out
    final bool shouldGreyOut =
        type == SettingsItemType.selectable && isInSelectionMode && !isSelected;

    // Get screen width for responsive behavior
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 1200;
    final isLargeScreen = screenWidth >= 1200;

    // Determine effective compact mode
    final effectiveCompact = isCompact || isSmallScreen;

    // Calculate responsive dimensions
    final dimensions =
        _getResponsiveDimensions(effectiveCompact, isSmallScreen);

    return Opacity(
      opacity: shouldGreyOut ? 0.5 : 1.0,
      child: Card(
        elevation: effectiveCompact ? 1 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundness),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(roundness),
          child: InkWell(
            onTap: _shouldDisableOnTap() ? null : onTap,
            borderRadius: BorderRadius.circular(roundness),
            child: Padding(
              padding: dimensions.padding,
              child: _buildLayout(
                context,
                effectiveCompact,
                isSmallScreen,
                isMediumScreen,
                isLargeScreen,
                dimensions,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldDisableOnTap() {
    return type == SettingsItemType.toggleable ||
        type == SettingsItemType.slider ||
        type == SettingsItemType.dropdown ||
        type == SettingsItemType.segmentedToggle;
  }

  Widget _buildLayout(
    BuildContext context,
    bool effectiveCompact,
    bool isSmallScreen,
    bool isMediumScreen,
    bool isLargeScreen,
    ResponsiveDimensions dimensions,
  ) {
    // For very small screens and complex controls, use vertical layout
    if (isSmallScreen && _shouldUseVerticalLayout()) {
      return _buildVerticalLayout(context, effectiveCompact, dimensions);
    }

    return _buildHorizontalLayout(context, effectiveCompact, dimensions);
  }

  bool _shouldUseVerticalLayout() {
    return type == SettingsItemType.dropdown ||
        type == SettingsItemType.slider ||
        type == SettingsItemType.segmentedToggle;
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    bool effectiveCompact,
    ResponsiveDimensions dimensions,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIconContainer(effectiveCompact, dimensions),
            SizedBox(width: dimensions.spacing),
            _buildTitleAndDescription(effectiveCompact, dimensions),
            SizedBox(width: dimensions.spacing / 2),
            if (_shouldShowTrailing()) _buildTrailingWidget(effectiveCompact),
          ],
        ),
        if (type == SettingsItemType.dropdown) ...[
          SizedBox(height: effectiveCompact ? 8 : 12),
          _buildDropdown(context, effectiveCompact),
        ],
        if (type == SettingsItemType.slider) ...[
          SizedBox(height: effectiveCompact ? 8 : 12),
          _buildSlider(context, effectiveCompact),
        ],
        if (type == SettingsItemType.segmentedToggle) ...[
          SizedBox(height: effectiveCompact ? 8 : 12),
          _buildSegmentedToggle(context, effectiveCompact),
        ],
      ],
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    bool effectiveCompact,
    ResponsiveDimensions dimensions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildIconContainer(effectiveCompact, dimensions),
            SizedBox(width: dimensions.spacing),
            _buildTitleAndDescription(effectiveCompact, dimensions,
                isVertical: true),
          ],
        ),
        if (type == SettingsItemType.dropdown) ...[
          SizedBox(height: effectiveCompact ? 8 : 12),
          _buildDropdown(context, effectiveCompact),
        ] else if (type == SettingsItemType.slider) ...[
          SizedBox(height: effectiveCompact ? 8 : 12),
          _buildSlider(context, effectiveCompact),
        ] else if (type == SettingsItemType.segmentedToggle) ...[
          SizedBox(height: effectiveCompact ? 8 : 12),
          _buildSegmentedToggle(context, effectiveCompact),
        ],
      ],
    );
  }

  Widget _buildIconContainer(
      bool effectiveCompact, ResponsiveDimensions dimensions) {
    return Container(
      width: dimensions.iconContainerSize,
      height: dimensions.iconContainerSize,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(effectiveCompact ? 6 : 8),
      ),
      child: Center(
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: dimensions.iconSize,
          ),
          child: icon,
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription(
    bool effectiveCompact,
    ResponsiveDimensions dimensions, {
    bool isVertical = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: dimensions.titleFontSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: (effectiveCompact || isVertical) ? 1 : 2,
          ),
          if (description.isNotEmpty &&
              (!effectiveCompact || description.isNotEmpty)) ...[
            SizedBox(height: effectiveCompact ? 1 : 2),
            Text(
              description,
              style: TextStyle(
                fontSize: dimensions.descriptionFontSize,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: (effectiveCompact || isVertical) ? 1 : 2,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmentedToggle(BuildContext context, bool effectiveCompact) {
    if (segmentedOptions == null ||
        segmentedLabels == null ||
        segmentedOptions!.length != 3) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(effectiveCompact ? 10 : 12),
      ),
      child: Row(
        children: List.generate(3, (index) {
          final isSelected = segmentedSelectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSegmentedChanged?.call(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(2),
                padding: EdgeInsets.symmetric(
                  vertical: effectiveCompact ? 8 : 10,
                  horizontal: effectiveCompact ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? iconColor : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(effectiveCompact ? 8 : 10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: iconColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        color: isSelected ? Colors.white : iconColor,
                        size: effectiveCompact ? 16 : 18,
                      ),
                      child: segmentedOptions![index],
                    ),
                    if (!effectiveCompact) ...[
                      const SizedBox(width: 6),
                      Text(
                        segmentedLabels![index],
                        style: TextStyle(
                          fontSize: effectiveCompact ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : iconColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, bool effectiveCompact) {
    return Container(
      padding: EdgeInsets.all(effectiveCompact ? 0.5 : 1),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(effectiveCompact ? 8 : 10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: EdgeInsets.symmetric(horizontal: effectiveCompact ? 6 : 8),
          value: dropdownValue,
          focusColor: Colors.transparent,
          elevation: 0,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: iconColor,
            size: effectiveCompact ? 18 : 20,
          ),
          style: TextStyle(
            fontSize: effectiveCompact ? 13 : 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          borderRadius: BorderRadius.circular(effectiveCompact ? 6 : 8),
          items: dropdownItems?.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onDropdownChanged,
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, bool effectiveCompact) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: iconColor,
              inactiveTrackColor: iconColor.withOpacity(0.3),
              thumbColor: iconColor,
              overlayColor: iconColor.withOpacity(0.2),
              trackHeight: effectiveCompact ? 2 : 3,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: effectiveCompact ? 6 : 8,
              ),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: effectiveCompact ? 12 : 16,
              ),
            ),
            child: Slider(
              value: sliderValue ?? 0,
              min: sliderMin ?? 0,
              max: sliderMax ?? 100,
              divisions: sliderDivisions,
              onChanged: onSliderChanged,
            ),
          ),
        ),
        SizedBox(width: effectiveCompact ? 6 : 8),
        Text(
          '${(sliderValue ?? 0).toStringAsFixed(sliderDivisions != null ? 0 : 1)}${sliderSuffix ?? ''}',
          style: TextStyle(
            fontSize: effectiveCompact ? 13 : 14,
            fontWeight: FontWeight.w500,
            color: iconColor,
          ),
        ),
      ],
    );
  }

  bool _shouldShowTrailing() {
    return type != SettingsItemType.slider &&
        type != SettingsItemType.dropdown &&
        type != SettingsItemType.segmentedToggle;
  }

  Widget _buildTrailingWidget(bool effectiveCompact) {
    switch (type) {
      case SettingsItemType.selectable:
        if (isSelected) {
          return Container(
            width: effectiveCompact ? 20 : 24,
            height: effectiveCompact ? 20 : 24,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(effectiveCompact ? 10 : 12),
            ),
            child: Icon(
              Icons.check,
              size: effectiveCompact ? 14 : 16,
              color: Colors.white,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }

      case SettingsItemType.toggleable:
        return Transform.scale(
          scale: effectiveCompact ? 0.8 : 1.0,
          child: Switch(
            value: toggleValue ?? false,
            onChanged: onToggleChanged,
            activeColor: iconColor,
          ),
        );

      case SettingsItemType.normal:
      default:
        return Icon(
          Iconsax.arrow_right_3,
          size: effectiveCompact ? 16 : 20,
          color: Colors.grey[400],
        );
    }
  }

  ResponsiveDimensions _getResponsiveDimensions(
      bool effectiveCompact, bool isSmallScreen) {
    return ResponsiveDimensions(
      iconSize: effectiveCompact ? 20 : (isSmallScreen ? 22 : 24),
      iconContainerSize: effectiveCompact ? 40 : (isSmallScreen ? 44 : 48),
      titleFontSize: effectiveCompact ? 14 : (isSmallScreen ? 15 : 16),
      descriptionFontSize: effectiveCompact ? 11 : (isSmallScreen ? 11.5 : 12),
      padding: effectiveCompact
          ? const EdgeInsets.all(12.0)
          : (isSmallScreen
              ? const EdgeInsets.all(14.0)
              : const EdgeInsets.all(16.0)),
      spacing: effectiveCompact ? 12 : (isSmallScreen ? 14 : 16),
    );
  }
}

class ResponsiveDimensions {
  final double iconSize;
  final double iconContainerSize;
  final double titleFontSize;
  final double descriptionFontSize;
  final EdgeInsets padding;
  final double spacing;

  const ResponsiveDimensions({
    required this.iconSize,
    required this.iconContainerSize,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.padding,
    required this.spacing,
  });
}
