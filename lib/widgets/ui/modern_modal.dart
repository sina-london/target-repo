import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

/// A modern, highly reusable modal with glass morphism effects
/// Supports multiple layout types and customization options
class ModernModal extends ConsumerStatefulWidget {
  /// Title displayed at the top of the modal
  final String title;

  /// Icon displayed next to the title
  final IconData? titleIcon;

  /// Optional subtitle or description
  final String? subtitle;

  /// Main content of the modal
  final Widget content;

  /// Modal size configuration
  final ModalSize size;

  /// Modal type for different layouts
  final ModalType type;

  /// Primary action button
  final ModalAction? primaryAction;

  /// Secondary action button
  final ModalAction? secondaryAction;

  /// Additional actions (displayed as icon buttons in header)
  final List<ModalHeaderAction>? headerActions;

  /// Whether the modal can be dismissed by tapping outside or back button
  final bool isDismissible;

  /// Whether to show close button in header
  final bool showCloseButton;

  /// Custom header widget (overrides title/subtitle)
  final Widget? customHeader;

  /// Custom footer widget (overrides action buttons)
  final Widget? customFooter;

  /// Background blur intensity (0.0 to 30.0)
  final double blurIntensity;

  /// Whether to use compact layout
  final bool? isCompact;

  /// Callback when modal is dismissed
  final VoidCallback? onDismissed;

  const ModernModal({
    super.key,
    required this.title,
    this.titleIcon,
    this.subtitle,
    required this.content,
    this.size = ModalSize.medium,
    this.type = ModalType.bottomSheet,
    this.primaryAction,
    this.secondaryAction,
    this.headerActions,
    this.isDismissible = true,
    this.showCloseButton = true,
    this.customHeader,
    this.customFooter,
    this.blurIntensity = 20.0,
    this.isCompact,
    this.onDismissed,
  });

  @override
  ConsumerState<ModernModal> createState() => _ModernModalState();

  /// Show as bottom sheet modal
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required String title,
    IconData? titleIcon,
    String? subtitle,
    required Widget content,
    ModalSize size = ModalSize.medium,
    ModalAction? primaryAction,
    ModalAction? secondaryAction,
    List<ModalHeaderAction>? headerActions,
    bool isDismissible = true,
    bool showCloseButton = true,
    Widget? customHeader,
    Widget? customFooter,
    double blurIntensity = 20.0,
    bool? isCompact,
    VoidCallback? onDismissed,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) => ModernModal(
        title: title,
        titleIcon: titleIcon,
        subtitle: subtitle,
        content: content,
        size: size,
        type: ModalType.bottomSheet,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
        headerActions: headerActions,
        isDismissible: isDismissible,
        showCloseButton: showCloseButton,
        customHeader: customHeader,
        customFooter: customFooter,
        blurIntensity: blurIntensity,
        isCompact: isCompact,
        onDismissed: onDismissed,
      ),
    );
  }

  /// Show as dialog modal
  static Future<T?> showDialog<T>({
    required BuildContext context,
    required String title,
    IconData? titleIcon,
    String? subtitle,
    required Widget content,
    ModalSize size = ModalSize.medium,
    ModalAction? primaryAction,
    ModalAction? secondaryAction,
    List<ModalHeaderAction>? headerActions,
    bool isDismissible = true,
    bool showCloseButton = true,
    Widget? customHeader,
    Widget? customFooter,
    double blurIntensity = 20.0,
    bool? isCompact,
    VoidCallback? onDismissed,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => ModernModal(
        title: title,
        titleIcon: titleIcon,
        subtitle: subtitle,
        content: content,
        size: size,
        type: ModalType.dialog,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
        headerActions: headerActions,
        isDismissible: isDismissible,
        showCloseButton: showCloseButton,
        customHeader: customHeader,
        customFooter: customFooter,
        blurIntensity: blurIntensity,
        isCompact: isCompact,
        onDismissed: onDismissed,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Show as full screen modal
  static Future<T?> showFullScreen<T>({
    required BuildContext context,
    required String title,
    IconData? titleIcon,
    String? subtitle,
    required Widget content,
    ModalAction? primaryAction,
    ModalAction? secondaryAction,
    List<ModalHeaderAction>? headerActions,
    bool isDismissible = true,
    bool showCloseButton = true,
    Widget? customHeader,
    Widget? customFooter,
    double blurIntensity = 20.0,
    bool? isCompact,
    VoidCallback? onDismissed,
  }) {
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        fullscreenDialog: true,
        pageBuilder: (context, animation, secondaryAnimation) => ModernModal(
          title: title,
          titleIcon: titleIcon,
          subtitle: subtitle,
          content: content,
          size: ModalSize.large,
          type: ModalType.fullScreen,
          primaryAction: primaryAction,
          secondaryAction: secondaryAction,
          headerActions: headerActions,
          isDismissible: isDismissible,
          showCloseButton: showCloseButton,
          customHeader: customHeader,
          customFooter: customFooter,
          blurIntensity: blurIntensity,
          isCompact: isCompact,
          onDismissed: onDismissed,
        ),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }
}

class _ModernModalState extends ConsumerState<ModernModal>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _slideController.forward();
    _fadeController.forward();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.type == ModalType.bottomSheet
          ? const Offset(0, 1)
          : const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    if (widget.onDismissed != null) {
      widget.onDismissed!();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isCompact = widget.isCompact ?? screenSize.width < 600;
    final isDark = theme.brightness == Brightness.dark;

    Widget modalContent =
        _buildModalContent(theme, screenSize, isCompact, isDark);

    if (widget.type == ModalType.dialog) {
      return Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: modalContent,
          ),
        ),
      );
    }

    if (widget.type == ModalType.fullScreen) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: modalContent,
      );
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: modalContent,
      ),
    );
  }

  Widget _buildModalContent(
    ThemeData theme,
    Size screenSize,
    bool isCompact,
    bool isDark,
  ) {
    final modalHeight = _getModalHeight(screenSize);
    final modalWidth = _getModalWidth(screenSize);

    return Container(
      width: widget.type == ModalType.dialog ? modalWidth : null,
      height: widget.type == ModalType.bottomSheet ? modalHeight : null,
      constraints: widget.type == ModalType.dialog
          ? BoxConstraints(
              maxWidth: modalWidth,
              maxHeight: screenSize.height * 0.85,
            )
          : null,
      child: ClipRRect(
        borderRadius: _getBorderRadius(),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: widget.blurIntensity,
            sigmaY: widget.blurIntensity,
          ),
          child: Container(
            decoration: BoxDecoration(
              color:
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.95),
              borderRadius: _getBorderRadius(),
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
                  offset: widget.type == ModalType.bottomSheet
                      ? const Offset(0, -10)
                      : const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: widget.type == ModalType.dialog
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              children: [
                // Drag handle for bottom sheet
                if (widget.type == ModalType.bottomSheet &&
                    widget.isDismissible)
                  _buildDragHandle(isDark),

                // Header
                widget.customHeader ?? _buildHeader(theme, isCompact, isDark),

                // Subtitle
                if (widget.subtitle != null && widget.customHeader == null)
                  _buildSubtitle(isCompact, isDark),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 20 : 24,
                      vertical: 16,
                    ),
                    child: widget.content,
                  ),
                ),

                // Footer
                widget.customFooter ?? _buildFooter(theme, isCompact, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isCompact, bool isDark) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 16 : 20),
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
          // Title icon
          if (widget.titleIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.titleIcon!,
                color: theme.colorScheme.onPrimaryContainer,
                size: isCompact ? 18 : 20,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Title
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

          // Header actions
          if (widget.headerActions != null)
            ...widget.headerActions!.map((action) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildHeaderActionButton(action, isCompact, isDark),
                )),

          // Close button
          if (widget.showCloseButton) _buildCloseButton(isCompact, isDark),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton(
    ModalHeaderAction action,
    bool isCompact,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              action.icon,
              color: (isDark ? Colors.white : Colors.black87).withOpacity(0.8),
              size: isCompact ? 18 : 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(bool isCompact, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleDismiss,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Iconsax.close_circle,
              color: (isDark ? Colors.white : Colors.black87).withOpacity(0.8),
              size: isCompact ? 18 : 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(bool isCompact, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 24,
        vertical: 12,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.subtitle!,
          style: TextStyle(
            color: (isDark ? Colors.white : Colors.black87).withOpacity(0.7),
            fontSize: isCompact ? 14 : 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, bool isCompact, bool isDark) {
    if (widget.primaryAction == null && widget.secondaryAction == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black87).withOpacity(0.02),
        border: Border(
          top: BorderSide(
            color: (isDark ? Colors.white : Colors.black87).withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.secondaryAction != null) ...[
            Expanded(
              child: _buildActionButton(
                widget.secondaryAction!,
                true,
                theme,
                isCompact,
              ),
            ),
            if (widget.primaryAction != null) const SizedBox(width: 12),
          ],
          if (widget.primaryAction != null)
            Expanded(
              child: _buildActionButton(
                widget.primaryAction!,
                false,
                theme,
                isCompact,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    ModalAction action,
    bool isSecondary,
    ThemeData theme,
    bool isCompact,
  ) {
    if (isSecondary) {
      return OutlinedButton.icon(
        onPressed: action.onPressed,
        icon:
            action.icon != null ? Icon(action.icon!) : const SizedBox.shrink(),
        label: Text(action.label),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: isCompact ? 14 : 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: action.onPressed,
      icon: action.icon != null ? Icon(action.icon!) : const SizedBox.shrink(),
      label: Text(action.label),
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: isCompact ? 14 : 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    switch (widget.type) {
      case ModalType.bottomSheet:
        return const BorderRadius.vertical(top: Radius.circular(24));
      case ModalType.dialog:
        return BorderRadius.circular(20);
      case ModalType.fullScreen:
        return BorderRadius.zero;
    }
  }

  double _getModalHeight(Size screenSize) {
    switch (widget.size) {
      case ModalSize.small:
        return screenSize.height * 0.4;
      case ModalSize.medium:
        return screenSize.height * 0.6;
      case ModalSize.large:
        return screenSize.height * 0.85;
      case ModalSize.auto:
        return screenSize.height * 0.6; // Default fallback
    }
  }

  double _getModalWidth(Size screenSize) {
    switch (widget.size) {
      case ModalSize.small:
        return screenSize.width * 0.8;
      case ModalSize.medium:
        return screenSize.width * 0.9;
      case ModalSize.large:
        return screenSize.width * 0.95;
      case ModalSize.auto:
        return screenSize.width * 0.9; // Default fallback
    }
  }
}

/// Modal size options
enum ModalSize { small, medium, large, auto }

/// Modal type options
enum ModalType { bottomSheet, dialog, fullScreen }

/// Action button configuration
class ModalAction {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  ModalAction({
    required this.label,
    required this.onPressed,
    this.icon,
  });
}

/// Header action button configuration
class ModalHeaderAction {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  ModalHeaderAction({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });
}
