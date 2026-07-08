import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shonenx/widgets/ui/shonenx_grid.dart';

class ShonenXAccordion extends StatefulWidget {
  /// The title widget displayed in the accordion header
  final Widget title;
  
  /// The content widget displayed when the accordion is expanded
  final Widget content;
  
  /// Whether the accordion is expanded by default
  final bool isExpanded;
  
  /// The background color for the header or null to use theme surfaces
  final Color? headerColor;
  
  /// The background color for the content area or null to use theme surfaces
  final Color? contentColor;
  
  /// Icon to use for the expand/collapse indicator
  final IconData? expandIcon;
  
  /// Optional widget to display at the start of the header
  final Widget? leading;
  
  /// Additional padding for the header
  final EdgeInsets? headerPadding;
  
  /// Additional padding for the content
  final EdgeInsets? contentPadding;
  
  /// Border radius for the entire accordion
  final BorderRadius? borderRadius;
  
  /// Optional border for the accordion
  final Border? border;
  
  /// Optional elevation for the accordion
  final double elevation;
  
  /// Callback when expansion state changes
  final ValueChanged<bool>? onExpansionChanged;
  
  /// Duration for the expansion/collapse animation
  final Duration animationDuration;
  
  /// Whether to show a divider between header and content
  final bool showDivider;
  
  /// Optional custom divider widget
  final Widget? customDivider;
  
  /// Whether to allow the accordion to be toggled
  final bool toggleable;
  
  /// Whether the transition should maintain the content size or collapse it
  final bool maintainState;

  const ShonenXAccordion({
    super.key,
    required this.title,
    required this.content,
    this.isExpanded = false,
    this.headerColor,
    this.contentColor,
    this.expandIcon,
    this.leading,
    this.headerPadding,
    this.contentPadding,
    this.borderRadius,
    this.border,
    this.elevation = 0,
    this.onExpansionChanged,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showDivider = true,
    this.customDivider,
    this.toggleable = true,
    this.maintainState = false,
  });

  @override
  ShonenXAccordionState createState() => ShonenXAccordionState();
}

class ShonenXAccordionState extends State<ShonenXAccordion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  late Animation<double> _headerColorAnimation;
  late Animation<double> _contentOpacity;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _headerColorAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _contentOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ShonenXAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      _handleExpansionDirective();
    }
  }

  void _handleExpansionDirective() {
    setState(() {
      _isExpanded = widget.isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (!widget.toggleable) return;
    
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call(_isExpanded);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Apply theme defaults for colors if not provided
    final headerBackgroundColor = widget.headerColor ?? 
        colorScheme.surfaceContainerLow;
    final contentBackgroundColor = widget.contentColor ?? 
        colorScheme.surfaceContainerLowest;
    final headerActiveColor = Color.lerp(
      headerBackgroundColor,
      colorScheme.primary.withOpacity(0.1),
      _headerColorAnimation.value,
    );
    
    final borderRadius = widget.borderRadius ?? 
        BorderRadius.circular(16);
    final headerPadding = widget.headerPadding ?? 
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    final contentPadding = widget.contentPadding ?? 
        const EdgeInsets.all(16);
    
    final expandIcon = widget.expandIcon ?? Iconsax.arrow_down_1;
    final iconSize = 20.0;
    final iconColor = _isExpanded ? colorScheme.primary : colorScheme.onSurface;
    
    // Create the default divider if requested
    final divider = widget.showDivider
        ? widget.customDivider ??
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withOpacity(0.5),
            )
        : const SizedBox.shrink();

    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: widget.border ?? 
            Border.all(color: colorScheme.outlineVariant, width: 1),
        boxShadow: widget.elevation > 0 
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1 * widget.elevation),
                  blurRadius: 4.0 * widget.elevation,
                  spreadRadius: 0.5 * widget.elevation,
                  offset: Offset(0, 1 * widget.elevation),
                ),
              ] 
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Material(
              color: headerActiveColor,
              child: InkWell(
                onTap: _toggleExpand,
                splashColor: colorScheme.primary.withOpacity(0.1),
                highlightColor: colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.topLeft,
                  topRight: borderRadius.topRight,
                  bottomLeft: _isExpanded ? Radius.zero : borderRadius.bottomLeft,
                  bottomRight: _isExpanded ? Radius.zero : borderRadius.bottomRight,
                ),
                child: Padding(
                  padding: headerPadding,
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(child: widget.title),
                      RotationTransition(
                        turns: _iconRotation,
                        child: AnimatedContainer(
                          duration: widget.animationDuration,
                          child: Icon(
                            expandIcon,
                            size: iconSize,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Conditional divider
            if (_isExpanded) divider,
            
            // Content
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _heightFactor.value,
                    child: FadeTransition(
                      opacity: _contentOpacity,
                      child: child,
                    ),
                  ),
                );
              },
              child: Container(
                color: contentBackgroundColor,
                child: Offstage(
                  offstage: !_isExpanded && !widget.maintainState,
                  child: Padding(
                    padding: contentPadding,
                    child: widget.content,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example Screen showing multiple accordion use cases
class AccordionShowcaseScreen extends StatefulWidget {
  const AccordionShowcaseScreen({super.key});

  @override
  State<AccordionShowcaseScreen> createState() => _AccordionShowcaseScreenState();
}

class _AccordionShowcaseScreenState extends State<AccordionShowcaseScreen> {
  bool _isFirstExpanded = true;
  bool _isSecondExpanded = false;
  bool _isThirdExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sample grid items
    final gridItems = List.generate(
      8,
      (index) => Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.gallery,
                size: 32,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Item ${index + 1}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accordion Showcase',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple accordion with controlled state
            ShonenXAccordion(
              isExpanded: _isFirstExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isFirstExpanded = expanded;
                });
              },
              leading: Icon(
                Iconsax.gallery,
                color: colorScheme.primary,
              ),
              title: Text(
                'Gallery Section',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: ShonenXGridView (
                items: gridItems,
                crossAxisExtent: 150,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              elevation: 1,
              headerColor: colorScheme.secondaryContainer,
              contentColor: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            
            const SizedBox(height: 16),
            
            // Custom styled accordion
            ShonenXAccordion(
              isExpanded: _isSecondExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isSecondExpanded = expanded;
                });
              },
              leading: CircleAvatar(
                backgroundColor: colorScheme.tertiaryContainer,
                radius: 16,
                child: Icon(
                  Iconsax.activity,
                  size: 16,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See your last 7 days',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              content: Column(
                children: List.generate(
                  3,
                  (index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                        colorScheme.tertiaryContainer,
                      ][index],
                      child: Icon(
                        [
                          Iconsax.play_circle,
                          Iconsax.heart,
                          Iconsax.bookmark,
                        ][index],
                        color: [
                          colorScheme.primary,
                          colorScheme.secondary,
                          colorScheme.tertiary,
                        ][index],
                      ),
                    ),
                    title: Text(
                      [
                        'Watched Episode 12',
                        'Favorited Naruto',
                        'Bookmarked One Piece',
                      ][index],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      [
                        '2 hours ago',
                        'Yesterday',
                        '3 days ago',
                      ][index],
                      style: theme.textTheme.bodySmall,
                    ),
                    trailing: Icon(
                      Iconsax.arrow_right_3,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              elevation: 1,
              headerColor: colorScheme.surfaceVariant.withOpacity(0.5),
              customDivider: const Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Stylized accordion with custom content
            ShonenXAccordion(
              isExpanded: _isThirdExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isThirdExpanded = expanded;
                });
              },
              title: Row(
                children: [
                  Icon(
                    Iconsax.chart,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Statistics',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        icon: Iconsax.play_circle,
                        value: '87',
                        label: 'Episodes Watched',
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        icon: Iconsax.clock,
                        value: '142h',
                        label: 'Watch Time',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        icon: Iconsax.strongbox,
                        value: '23',
                        label: 'Animes Completed',
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        context,
                        icon: Iconsax.heart,
                        value: '15',
                        label: 'Favorites',
                      ),
                    ],
                  ),
                ],
              ),
              expandIcon: Iconsax.arrow_circle_down,
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant),
              headerColor: colorScheme.primaryContainer,
              contentColor: colorScheme.surfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}