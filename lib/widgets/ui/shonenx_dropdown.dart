import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ShonenxDropdown extends StatefulWidget {
  final IconData icon;
  final String value;
  final List<String> items;
  final Widget Function(String)? itemBuilder;
  final void Function(String) onChanged;
  final String? hint;
  final bool enabled;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const ShonenxDropdown({
    super.key,
    required this.icon,
    required this.value,
    required this.items,
    this.itemBuilder,
    required this.onChanged,
    this.hint,
    this.enabled = true,
    this.width,
    this.padding,
  });

  @override
  State<ShonenxDropdown> createState() => _ShonenxDropdownState();
}

class _ShonenxDropdownState extends State<ShonenxDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uniqueItems = widget.items.toSet().toList();
    final validValue = uniqueItems.contains(widget.value)
        ? widget.value
        : (uniqueItems.isNotEmpty ? uniqueItems.first : '');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (widget.enabled) {
                _animationController.forward();
              }
            },
            onTapUp: (_) {
              if (widget.enabled) {
                _animationController.reverse();
                _showDropdownMenu(context, uniqueItems, validValue);
              }
            },
            onTapCancel: () {
              if (widget.enabled) {
                _animationController.reverse();
              }
            },
            child: Container(
              width: widget.width,
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.enabled
                      ? [
                          theme.colorScheme.surface,
                          theme.colorScheme.surfaceContainerHighest,
                        ]
                      : [
                          theme.colorScheme.surfaceContainerLow,
                          theme.colorScheme.surfaceContainerLow,
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isOpen
                      ? theme.colorScheme.primary.withOpacity(0.5)
                      : theme.colorScheme.outlineVariant,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  if (_isOpen)
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 18,
                      color: widget.enabled
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: widget.itemBuilder?.call(validValue) ??
                        Text(
                          validValue.isEmpty
                              ? (widget.hint ?? 'Select an option')
                              : validValue.toUpperCase(),
                          style: TextStyle(
                            color: validValue.isEmpty
                                ? theme.colorScheme.onSurface.withOpacity(0.6)
                                : (widget.enabled
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.5)),
                            fontSize: 15,
                            fontWeight: validValue.isEmpty
                                ? FontWeight.w400
                                : FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Iconsax.arrow_down_1,
                        size: 16,
                        color: widget.enabled
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDropdownMenu(
      BuildContext context, List<String> uniqueItems, String currentValue) {
    if (!widget.enabled || uniqueItems.isEmpty) return;

    setState(() => _isOpen = true);

    final RenderBox box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final theme = Theme.of(context);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + box.size.height + 4,
        position.dx + box.size.width,
        0,
      ),
      items: uniqueItems
          .map((item) => PopupMenuItem<String>(
                value: item,
                height: 48,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: item == currentValue
                        ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (item == currentValue) ...[
                        Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: widget.itemBuilder?.call(item) ??
                            Text(
                              item.toUpperCase(),
                              style: TextStyle(
                                color: item == currentValue
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: item == currentValue
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: 1,
        ),
      ),
      color: theme.colorScheme.surface,
      constraints: BoxConstraints(
        minWidth: box.size.width,
        maxWidth: box.size.width,
        maxHeight: 300,
      ),
    ).then((selected) {
      setState(() => _isOpen = false);
      if (selected != null && selected != currentValue) {
        widget.onChanged(selected);
      }
    });
  }
}
