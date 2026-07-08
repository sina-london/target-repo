import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

/// A modern, reusable settings panel with glass morphism effects
/// Can be used across different screens in the app
class ModernSettingsPanel extends ConsumerStatefulWidget {
  /// Title displayed at the top of the panel
  final String title;

  /// Icon displayed next to the title
  final IconData titleIcon;

  /// Callback when the panel is closed
  final VoidCallback onClose;

  /// Settings rows to display in the panel
  final List<SettingsRowData> settingsRows;

  /// Optional subtitle or description
  final String? subtitle;

  /// Optional custom header widget
  final Widget? customHeader;

  /// Optional custom footer widget
  final Widget? customFooter;

  /// Whether to use a compact layout
  final bool? isCompact;

  const ModernSettingsPanel({
    super.key,
    required this.title,
    this.titleIcon = Iconsax.setting_4,
    required this.onClose,
    required this.settingsRows,
    this.subtitle,
    this.customHeader,
    this.customFooter,
    this.isCompact,
  });

  @override
  ConsumerState<ModernSettingsPanel> createState() =>
      _ModernSettingsPanelState();

  /// Helper method to show the panel as a modal bottom sheet
  static Future<void> showAsModalBottomSheet({
    required BuildContext context,
    required String title,
    IconData titleIcon = Iconsax.setting_4,
    required List<SettingsRowData> settingsRows,
    String? subtitle,
    Widget? customHeader,
    Widget? customFooter,
    bool? isCompact,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => ModernSettingsPanel(
        title: title,
        titleIcon: titleIcon,
        onClose: () => Navigator.of(modalContext).pop(),
        settingsRows: settingsRows,
        subtitle: subtitle,
        customHeader: customHeader,
        customFooter: customFooter,
        isCompact: isCompact,
      ),
    );
  }
}

class _ModernSettingsPanelState extends ConsumerState<ModernSettingsPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    final isCompact = widget.isCompact ?? screenSize.width < 600;
    final isDark = theme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header section
                  widget.customHeader ??
                      _buildHeader(context, isCompact, isDark),

                  // Subtitle if provided
                  if (widget.subtitle != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 20 : 24,
                        vertical: 12,
                      ),
                      child: Text(
                        widget.subtitle!,
                        style: TextStyle(
                          color: (isDark ? Colors.white : Colors.black87)
                              .withOpacity(0.7),
                          fontSize: isCompact ? 14 : 15,
                        ),
                      ),
                    ),

                  // Settings rows
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isCompact ? 20 : 24),
                      child: _buildSettingsOptions(theme, isCompact, isDark),
                    ),
                  ),

                  // Footer if provided
                  if (widget.customFooter != null) widget.customFooter!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isCompact, bool isDark) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 20 : 24),
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
              widget.titleIcon,
              color: Colors.white,
              size: isCompact ? 18 : 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: isCompact ? 18 : 20,
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
                onTap: widget.onClose,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Iconsax.close_circle,
                    color: (isDark ? Colors.white : Colors.black87)
                        .withOpacity(0.8),
                    size: isCompact ? 20 : 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(ThemeData theme, bool isCompact, bool isDark) {
    if (widget.settingsRows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No settings available',
            style: TextStyle(
              color: (isDark ? Colors.white : Colors.black87).withOpacity(0.6),
              fontSize: isCompact ? 14 : 15,
            ),
          ),
        ),
      );
    }

    return Column(
      children: widget.settingsRows
          .map((rowData) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSettingsRow(
                  icon: rowData.icon,
                  label: rowData.label,
                  child: rowData.child,
                  theme: theme,
                  isCompact: isCompact,
                  isDark: isDark,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required Widget child,
    required ThemeData theme,
    required bool isCompact,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 16 : 18),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primaryContainer,
              size: isCompact ? 18 : 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: isCompact ? 14 : 15,
                letterSpacing: -0.1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Data class for settings row
class SettingsRowData {
  final IconData icon;
  final String label;
  final Widget child;

  SettingsRowData({
    required this.icon,
    required this.label,
    required this.child,
  });
}
