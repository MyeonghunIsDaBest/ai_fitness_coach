import 'package:flutter/material.dart';

/// Card elevation variants
enum AppCardElevation {
  /// No elevation, flat card with border
  flat,

  /// Low elevation (2dp)
  low,

  /// Medium elevation (4dp)
  medium,

  /// High elevation (8dp)
  high,
}

/// AppCard - Atomic design system card component
///
/// A unified card component that supports different elevation levels,
/// optional headers, and follows Material 3 design principles.
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('Card content'),
///   elevation: AppCardElevation.low,
/// )
///
/// AppCard.outlined(
///   title: 'Workout Summary',
///   child: WorkoutStats(),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? titleWidget;
  final Widget? subtitle;
  final Widget? trailing;
  final AppCardElevation elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showBorder;

  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.trailing,
    this.elevation = AppCardElevation.low,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.showBorder = false,
  });

  /// Flat card with border, no elevation
  const AppCard.outlined({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.trailing,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
  })  : elevation = AppCardElevation.flat,
        showBorder = true;

  /// Elevated card with medium elevation
  const AppCard.elevated({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.trailing,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
  })  : elevation = AppCardElevation.medium,
        showBorder = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || titleWidget != null) ...[
          _buildHeader(context, colorScheme, textTheme),
          const SizedBox(height: 12),
        ],
        child,
      ],
    );

    final effectivePadding = padding ?? const EdgeInsets.all(16);
    final effectiveMargin = margin ?? const EdgeInsets.all(8);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);

    final cardWidget = Container(
      margin: effectiveMargin,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: effectiveBorderRadius,
        border: showBorder || elevation == AppCardElevation.flat
            ? Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 1,
              )
            : null,
        boxShadow: _getElevationShadow(colorScheme),
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius,
            child: Padding(
              padding: effectivePadding,
              child: cardContent,
            ),
          ),
        ),
      ),
    );

    return cardWidget;
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleWidget != null)
                titleWidget!
              else if (title != null)
                Text(
                  title!,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                DefaultTextStyle(
                  style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ) ??
                      const TextStyle(),
                  child: subtitle!,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }

  List<BoxShadow>? _getElevationShadow(ColorScheme colorScheme) {
    if (elevation == AppCardElevation.flat) return null;

    final shadowColor = colorScheme.shadow.withOpacity(0.1);

    switch (elevation) {
      case AppCardElevation.flat:
        return null;
      case AppCardElevation.low:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case AppCardElevation.medium:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ];
      case AppCardElevation.high:
        return [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ];
    }
  }
}

/// AppCard variant for workout-specific content
/// Note: For full workout cards with exercise lists, use WorkoutCard from organisms
class WorkoutContentCard extends StatelessWidget {
  final Widget child;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const WorkoutContentCard({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard.outlined(
      onTap: onTap,
      padding: padding,
      titleWidget: Row(
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
                color: iconColor ?? colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// AppCard variant for stats/metrics display
class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final String? trend;
  final bool trendPositive;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.trend,
    this.trendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveColor = color ?? colorScheme.primary;

    return AppCard.outlined(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: effectiveColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: textTheme.headlineMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trend != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (trendPositive
                            ? colorScheme.primary
                            : colorScheme.error)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendPositive
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 12,
                        color: trendPositive
                            ? colorScheme.primary
                            : colorScheme.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: textTheme.labelSmall?.copyWith(
                          color: trendPositive
                              ? colorScheme.primary
                              : colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
