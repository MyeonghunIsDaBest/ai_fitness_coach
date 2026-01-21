import 'package:flutter/material.dart';

/// Chip variant types
enum AppChipVariant {
  /// Standard chip with subtle background
  filled,

  /// Outlined chip with border
  outlined,

  /// Elevated chip with shadow
  elevated,
}

/// AppChip - Atomic design system chip component
///
/// A unified chip component for filters, tags, and selections.
/// Follows Material 3 design principles with full theme integration.
///
/// Example:
/// ```dart
/// AppChip(
///   label: 'Beginner',
///   onTap: () => print('Selected'),
/// )
///
/// AppChip.filter(
///   label: 'Powerlifting',
///   selected: true,
///   onSelected: (selected) => print('Toggle: $selected'),
/// )
/// ```
class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final AppChipVariant variant;
  final bool selected;
  final Color? backgroundColor;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDelete,
    this.variant = AppChipVariant.filled,
    this.selected = false,
    this.backgroundColor,
    this.selectedColor,
    this.padding,
  });

  /// Filter chip with selection state
  const AppChip.filter({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    required void Function(bool) onSelected,
    this.selectedColor,
  })  : variant = AppChipVariant.outlined,
        onTap = null,
        onDelete = null,
        backgroundColor = null,
        padding = null;

  /// Input chip with delete action
  const AppChip.input({
    super.key,
    required this.label,
    this.icon,
    required this.onDelete,
  })  : variant = AppChipVariant.filled,
        onTap = null,
        selected = false,
        backgroundColor = null,
        selectedColor = null,
        padding = null;

  /// Choice chip for single selection
  const AppChip.choice({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  })  : variant = AppChipVariant.filled,
        onDelete = null,
        backgroundColor = null,
        padding = null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveBackgroundColor = selected
        ? (selectedColor ?? colorScheme.primary)
        : (backgroundColor ?? colorScheme.surfaceContainerHighest);

    final effectiveTextColor = selected
        ? (selectedColor != null
            ? _getContrastColor(selectedColor!)
            : colorScheme.onPrimary)
        : colorScheme.onSurface;

    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: onDelete != null ? 12 : 16,
          vertical: 8,
        );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: variant != AppChipVariant.outlined
                ? effectiveBackgroundColor
                : Colors.transparent,
            border: variant == AppChipVariant.outlined
                ? Border.all(
                    color: selected
                        ? (selectedColor ?? colorScheme.primary)
                        : colorScheme.outline,
                    width: selected ? 2 : 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: variant == AppChipVariant.elevated
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: effectiveTextColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: effectiveTextColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 6),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: effectiveTextColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    // Simple contrast calculation
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Chip group for multiple chip selection
class AppChipGroup extends StatelessWidget {
  final List<String> labels;
  final List<String> selectedLabels;
  final void Function(String label, bool selected)? onSelectionChanged;
  final bool multiSelect;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;

  const AppChipGroup({
    super.key,
    required this.labels,
    this.selectedLabels = const [],
    this.onSelectionChanged,
    this.multiSelect = true,
    this.alignment = WrapAlignment.start,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      children: labels.map((label) {
        final isSelected = selectedLabels.contains(label);
        return AppChip.choice(
          label: label,
          selected: isSelected,
          onTap: () {
            onSelectionChanged?.call(label, !isSelected);
          },
        );
      }).toList(),
    );
  }
}
