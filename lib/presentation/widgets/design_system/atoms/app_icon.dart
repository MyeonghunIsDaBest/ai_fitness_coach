import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';

/// Icon size variants
enum AppIconSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Icon semantic types for workout app
enum AppIconType {
  /// Default icon
  normal,

  /// Success/completed state
  success,

  /// Error/failed state
  error,

  /// Warning/caution state
  warning,

  /// Info/neutral state
  info,

  /// Primary accent
  primary,

  /// Disabled/inactive
  disabled,
}

/// AppIcon - Atomic design system icon component
///
/// Provides consistent icon sizing and semantic coloring across the app.
///
/// Example:
/// ```dart
/// AppIcon(Icons.fitness_center)
/// AppIcon.success(Icons.check_circle)
/// AppIcon.primary(Icons.add, size: AppIconSize.large)
/// ```
class AppIcon extends StatelessWidget {
  final IconData icon;
  final AppIconSize size;
  final AppIconType type;
  final Color? color;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.type = AppIconType.normal,
    this.color,
  });

  /// Success icon (completed, achieved)
  const AppIcon.success(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
  }) : type = AppIconType.success;

  /// Error icon (failed, invalid)
  const AppIcon.error(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
  }) : type = AppIconType.error;

  /// Warning icon (caution, attention needed)
  const AppIcon.warning(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
  }) : type = AppIconType.warning;

  /// Info icon (neutral information)
  const AppIcon.info(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
  }) : type = AppIconType.info;

  /// Primary accent icon
  const AppIcon.primary(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
  }) : type = AppIconType.primary;

  /// Disabled/inactive icon
  const AppIcon.disabled(
    this.icon, {
    super.key,
    this.size = AppIconSize.medium,
    this.color,
  }) : type = AppIconType.disabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Icon(
      icon,
      size: _getIconSize(),
      color: color ?? _getSemanticColor(colorScheme),
    );
  }

  double _getIconSize() {
    switch (size) {
      case AppIconSize.small:
        return 16;
      case AppIconSize.medium:
        return 24;
      case AppIconSize.large:
        return 32;
      case AppIconSize.extraLarge:
        return 48;
    }
  }

  Color _getSemanticColor(ColorScheme colorScheme) {
    switch (type) {
      case AppIconType.success:
        return colorScheme.success;
      case AppIconType.error:
        return colorScheme.error;
      case AppIconType.warning:
        return colorScheme.warning;
      case AppIconType.info:
        return colorScheme.info;
      case AppIconType.primary:
        return colorScheme.primary;
      case AppIconType.disabled:
        return colorScheme.disabled;
      case AppIconType.normal:
        return colorScheme.onSurface;
    }
  }
}

/// Icon with circular background container
class AppIconContainer extends StatelessWidget {
  final IconData icon;
  final AppIconSize size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? containerSize;

  const AppIconContainer({
    super.key,
    required this.icon,
    this.size = AppIconSize.medium,
    this.iconColor,
    this.backgroundColor,
    this.containerSize,
  });

  /// Primary colored icon container
  const AppIconContainer.primary({
    super.key,
    required this.icon,
    this.size = AppIconSize.medium,
    this.containerSize,
  })  : iconColor = null,
        backgroundColor = null;

  /// Success colored icon container
  const AppIconContainer.success({
    super.key,
    required this.icon,
    this.size = AppIconSize.medium,
    this.containerSize,
  })  : iconColor = null,
        backgroundColor = null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final effectiveBackgroundColor =
        backgroundColor ?? effectiveIconColor.withOpacity(0.1);
    final effectiveContainerSize = containerSize ?? _getContainerSize();

    return Container(
      width: effectiveContainerSize,
      height: effectiveContainerSize,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(effectiveContainerSize / 2),
      ),
      child: Center(
        child: AppIcon(
          icon,
          size: size,
          color: effectiveIconColor,
        ),
      ),
    );
  }

  double _getContainerSize() {
    switch (size) {
      case AppIconSize.small:
        return 32;
      case AppIconSize.medium:
        return 40;
      case AppIconSize.large:
        return 56;
      case AppIconSize.extraLarge:
        return 72;
    }
  }
}

/// Workout-specific icon helpers
class WorkoutIcons {
  WorkoutIcons._();

  /// Sport-specific icons
  static const IconData powerlifting = Icons.fitness_center;
  static const IconData bodybuilding = Icons.self_improvement;
  static const IconData crossfit = Icons.sports_gymnastics;
  static const IconData running = Icons.directions_run;
  static const IconData cycling = Icons.directions_bike;

  /// Exercise type icons
  static const IconData barbell = Icons.fitness_center;
  static const IconData dumbbell = Icons.fitness_center;
  static const IconData bodyweight = Icons.accessibility_new;
  static const IconData cardio = Icons.favorite;
  static const IconData stretching = Icons.self_improvement;

  /// Action icons
  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.check;
  static const IconData cancel = Icons.close;

  /// Status icons
  static const IconData completed = Icons.check_circle;
  static const IconData inProgress = Icons.pending;
  static const IconData skipped = Icons.cancel;
  static const IconData rest = Icons.hotel;

  /// Metrics icons
  static const IconData weight = Icons.monitor_weight;
  static const IconData reps = Icons.repeat;
  static const IconData sets = Icons.format_list_numbered;
  static const IconData time = Icons.timer;
  static const IconData calories = Icons.local_fire_department;

  /// Navigation icons
  static const IconData home = Icons.home;
  static const IconData workouts = Icons.fitness_center;
  static const IconData programs = Icons.calendar_today;
  static const IconData history = Icons.history;
  static const IconData analytics = Icons.analytics;
  static const IconData settings = Icons.settings;
  static const IconData profile = Icons.person;
}

/// RPE (Rate of Perceived Exertion) icon helper
class RPEIcon extends StatelessWidget {
  final double rpe;
  final AppIconSize size;

  const RPEIcon({
    super.key,
    required this.rpe,
    this.size = AppIconSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppIcon(
      _getIconForRPE(rpe),
      size: size,
      color: colorScheme.getRPEColor(rpe),
    );
  }

  IconData _getIconForRPE(double rpe) {
    if (rpe <= 4) return Icons.sentiment_very_satisfied;
    if (rpe <= 6) return Icons.sentiment_satisfied;
    if (rpe <= 8) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }
}
