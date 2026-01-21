import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';

/// StatDisplay - Molecule component for displaying statistics
///
/// A versatile statistics display component for workout metrics,
/// progress tracking, and performance indicators.
///
/// Example:
/// ```dart
/// StatDisplay(
///   label: 'Total Volume',
///   value: '12,500',
///   unit: 'kg',
///   trend: '+15%',
///   trendPositive: true,
/// )
/// ```
class StatDisplay extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String? trend;
  final bool? trendPositive;
  final IconData? icon;
  final Color? iconColor;
  final StatDisplaySize size;
  final StatDisplayLayout layout;

  const StatDisplay({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.trend,
    this.trendPositive,
    this.icon,
    this.iconColor,
    this.size = StatDisplaySize.medium,
    this.layout = StatDisplayLayout.vertical,
  });

  /// Compact horizontal layout
  const StatDisplay.compact({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.iconColor,
  })  : trend = null,
        trendPositive = null,
        size = StatDisplaySize.small,
        layout = StatDisplayLayout.horizontal;

  /// Large hero stat
  const StatDisplay.hero({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.trend,
    this.trendPositive,
    this.icon,
    this.iconColor,
  })  : size = StatDisplaySize.large,
        layout = StatDisplayLayout.vertical;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (layout == StatDisplayLayout.horizontal) {
      return _buildHorizontal(colorScheme, textTheme);
    }

    return _buildVertical(colorScheme, textTheme);
  }

  Widget _buildVertical(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: _getIconSize(),
                color: iconColor ?? colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: _getLabelStyle(textTheme, colorScheme),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: _getValueStyle(textTheme, colorScheme),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: _getUnitStyle(textTheme, colorScheme),
              ),
            ],
          ],
        ),
        if (trend != null) ...[
          const SizedBox(height: 4),
          _buildTrend(colorScheme, textTheme),
        ],
      ],
    );
  }

  Widget _buildHorizontal(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: _getIconSize(),
              color: iconColor ?? colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: _getLabelStyle(textTheme, colorScheme),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: _getValueStyle(textTheme, colorScheme),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 2),
                  Text(
                    unit!,
                    style: _getUnitStyle(textTheme, colorScheme),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrend(ColorScheme colorScheme, TextTheme textTheme) {
    final isPositive = trendPositive ?? trend!.startsWith('+');
    final color = isPositive ? colorScheme.success : colorScheme.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          trend!,
          style: textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _getIconSize() {
    switch (size) {
      case StatDisplaySize.small:
        return 16;
      case StatDisplaySize.medium:
        return 20;
      case StatDisplaySize.large:
        return 24;
    }
  }

  TextStyle? _getLabelStyle(TextTheme textTheme, ColorScheme colorScheme) {
    switch (size) {
      case StatDisplaySize.small:
        return textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      case StatDisplaySize.medium:
        return textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      case StatDisplaySize.large:
        return textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
    }
  }

  TextStyle? _getValueStyle(TextTheme textTheme, ColorScheme colorScheme) {
    switch (size) {
      case StatDisplaySize.small:
        return textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        );
      case StatDisplaySize.medium:
        return textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        );
      case StatDisplaySize.large:
        return textTheme.headlineLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        );
    }
  }

  TextStyle? _getUnitStyle(TextTheme textTheme, ColorScheme colorScheme) {
    switch (size) {
      case StatDisplaySize.small:
        return textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      case StatDisplaySize.medium:
        return textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      case StatDisplaySize.large:
        return textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
    }
  }
}

enum StatDisplaySize { small, medium, large }
enum StatDisplayLayout { vertical, horizontal }

/// StatGrid - Grid layout for multiple statistics
///
/// Example:
/// ```dart
/// StatGrid(
///   stats: [
///     StatDisplay(label: 'Volume', value: '12,500', unit: 'kg'),
///     StatDisplay(label: 'Sets', value: '42'),
///     StatDisplay(label: 'PRs', value: '3'),
///   ],
/// )
/// ```
class StatGrid extends StatelessWidget {
  final List<StatDisplay> stats;
  final int crossAxisCount;
  final double spacing;
  final double runSpacing;

  const StatGrid({
    super.key,
    required this.stats,
    this.crossAxisCount = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: stats.map((stat) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 32 - spacing * (crossAxisCount - 1)) / crossAxisCount - 32 / crossAxisCount,
            child: stat,
          );
        }).toList(),
      ),
    );
  }
}

/// StatRow - Horizontal row of statistics
///
/// Example:
/// ```dart
/// StatRow(
///   stats: [
///     StatDisplay.compact(label: 'Weight', value: '100', unit: 'kg'),
///     StatDisplay.compact(label: 'Reps', value: '8'),
///     StatDisplay.compact(label: 'RPE', value: '8'),
///   ],
/// )
/// ```
class StatRow extends StatelessWidget {
  final List<StatDisplay> stats;
  final bool showDividers;
  final EdgeInsetsGeometry? padding;

  const StatRow({
    super.key,
    required this.stats,
    this.showDividers = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          stats.length * 2 - 1,
          (index) {
            if (index.isOdd && showDividers) {
              return Container(
                height: 32,
                width: 1,
                color: colorScheme.outlineVariant,
              );
            }
            return Expanded(
              child: Center(child: stats[index ~/ 2]),
            );
          },
        ),
      ),
    );
  }
}

/// RPEDisplay - Specialized display for RPE values
///
/// Example:
/// ```dart
/// RPEDisplay(
///   value: 8.5,
///   target: 8.0,
/// )
/// ```
class RPEDisplay extends StatelessWidget {
  final double value;
  final double? target;
  final bool showLabel;
  final RPEDisplaySize size;

  const RPEDisplay({
    super.key,
    required this.value,
    this.target,
    this.showLabel = true,
    this.size = RPEDisplaySize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rpeColor = colorScheme.getRPEColor(value);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Text(
            'RPE',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 4),
        Container(
          padding: _getPadding(),
          decoration: BoxDecoration(
            color: rpeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            border: Border.all(
              color: rpeColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
            style: _getValueStyle(textTheme, rpeColor),
          ),
        ),
        if (target != null) ...[
          const SizedBox(height: 4),
          Text(
            'Target: ${target!.toStringAsFixed(target! % 1 == 0 ? 0 : 1)}',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case RPEDisplaySize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case RPEDisplaySize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case RPEDisplaySize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case RPEDisplaySize.small:
        return 6;
      case RPEDisplaySize.medium:
        return 8;
      case RPEDisplaySize.large:
        return 10;
    }
  }

  TextStyle? _getValueStyle(TextTheme textTheme, Color color) {
    switch (size) {
      case RPEDisplaySize.small:
        return textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        );
      case RPEDisplaySize.medium:
        return textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        );
      case RPEDisplaySize.large:
        return textTheme.headlineSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        );
    }
  }
}

enum RPEDisplaySize { small, medium, large }
