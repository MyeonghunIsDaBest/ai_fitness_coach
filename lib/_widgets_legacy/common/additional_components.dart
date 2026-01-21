import 'package:flutter/material.dart';
import '../../core/theme/color_schemes.dart';

/// ============================================================================
/// PROGRESS BAR - progress.tsx → Flutter
/// ============================================================================

class CustomProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const CustomProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor:
            backgroundColor ?? colorScheme.primary.withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? colorScheme.primary,
        ),
        minHeight: height,
      ),
    );
  }
}

/// ============================================================================
/// SLIDER - slider.tsx → Flutter
/// ============================================================================

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final bool enabled;

  const CustomSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
        ),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        label: label ?? value.toStringAsFixed(1),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

/// ============================================================================
/// SWITCH - switch.tsx → Flutter
/// ============================================================================

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: colorScheme.primary,
      activeTrackColor: colorScheme.primary.withOpacity(0.5),
      inactiveThumbColor: colorScheme.onSurfaceVariant,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
    );
  }
}

/// Switch with label
class LabeledSwitch extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const LabeledSwitch({
    super.key,
    required this.label,
    this.description,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => onChanged?.call(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            CustomSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// TABS - tabs.tsx → Flutter
/// ============================================================================

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController? controller;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        dividerColor: Colors.transparent,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }
}

/// ============================================================================
/// SEPARATOR - separator.tsx → Flutter
/// ============================================================================

class CustomSeparator extends StatelessWidget {
  final Axis direction;
  final double thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const CustomSeparator({
    super.key,
    this.direction = Axis.horizontal,
    this.thickness = 1,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultColor = color ?? colorScheme.outline.withOpacity(0.3);

    if (direction == Axis.horizontal) {
      return Divider(
        thickness: thickness,
        color: defaultColor,
        indent: indent,
        endIndent: endIndent,
      );
    } else {
      return VerticalDivider(
        thickness: thickness,
        color: defaultColor,
        indent: indent,
        endIndent: endIndent,
      );
    }
  }
}

/// ============================================================================
/// SKELETON - skeleton.tsx → Flutter (Loading placeholder)
/// ============================================================================

class Skeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 - _controller.value * 2, 0),
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

/// Pre-built skeleton shapes
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// ============================================================================
/// TOOLTIP - tooltip.tsx → Flutter
/// ============================================================================

class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final TooltipTriggerMode? triggerMode;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.triggerMode,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: message,
      triggerMode: triggerMode,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}

/// ============================================================================
/// TOGGLE BUTTONS - toggle-group.tsx → Flutter
/// ============================================================================

class ToggleButtons extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;
  final List<IconData>? icons;

  const ToggleButtons({
    super.key,
    required this.options,
    required this.selectedIndex,
    this.onChanged,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icons != null && icons!.length > index) ...[
                      Icon(
                        icons![index],
                        size: 16,
                        color: isSelected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      options[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// ============================================================================
/// TABLE - table.tsx → Flutter (DataTable wrapper)
/// ============================================================================

class CustomTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final void Function(int)? onRowTap;

  const CustomTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          dataTextStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ),
          columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
          rows: rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;

            return DataRow(
              cells: row.map((cell) => DataCell(Text(cell))).toList(),
              onSelectChanged:
                  onRowTap != null ? (_) => onRowTap!(index) : null,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// ============================================================================
/// TEXTAREA - textarea.tsx → Flutter (Multi-line TextField)
/// ============================================================================

class CustomTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const CustomTextArea({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.maxLines = 5,
    this.minLines,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
