import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';

/// Badge variant types
enum AppBadgeVariant {
  /// Standard badge with primary color
  primary,

  /// Success/completed state
  success,

  /// Error/alert state
  error,

  /// Warning/caution state
  warning,

  /// Info/neutral state
  info,

  /// Neutral/subtle badge
  neutral,
}

/// Badge size options
enum AppBadgeSize {
  small,
  medium,
  large,
}

/// AppBadge - Atomic design system badge component
///
/// Provides consistent badges for counts, notifications, and status indicators.
///
/// Example:
/// ```dart
/// AppBadge(text: '5')
/// AppBadge.dot()
/// AppBadge.success(text: 'New')
/// Badge(child: Icon(Icons.notifications), badge: AppBadge(text: '3'))
/// ```
class AppBadge extends StatelessWidget {
  final String? text;
  final int? count;
  final AppBadgeVariant variant;
  final AppBadgeSize size;
  final bool isDot;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBadge({
    super.key,
    this.text,
    this.count,
    this.variant = AppBadgeVariant.primary,
    this.size = AppBadgeSize.medium,
    this.isDot = false,
    this.backgroundColor,
    this.textColor,
  }) : assert(
          text != null || count != null || isDot == true,
          'Either text, count, or isDot must be provided',
        );

  /// Dot badge (no text)
  const AppBadge.dot({
    super.key,
    this.variant = AppBadgeVariant.error,
    this.backgroundColor,
  })  : text = null,
        count = null,
        size = AppBadgeSize.small,
        isDot = true,
        textColor = null;

  /// Count badge
  const AppBadge.count({
    super.key,
    required this.count,
    this.variant = AppBadgeVariant.primary,
    this.size = AppBadgeSize.medium,
    this.backgroundColor,
    this.textColor,
  })  : text = null,
        isDot = false;

  /// Success badge
  const AppBadge.success({
    super.key,
    this.text,
    this.count,
    this.size = AppBadgeSize.medium,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppBadgeVariant.success,
        isDot = false;

  /// Error/alert badge
  const AppBadge.error({
    super.key,
    this.text,
    this.count,
    this.size = AppBadgeSize.medium,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppBadgeVariant.error,
        isDot = false;

  /// Warning badge
  const AppBadge.warning({
    super.key,
    this.text,
    this.count,
    this.size = AppBadgeSize.medium,
    this.backgroundColor,
    this.textColor,
  })  : variant = AppBadgeVariant.warning,
        isDot = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveBackgroundColor =
        backgroundColor ?? _getVariantColor(colorScheme);
    final effectiveTextColor =
        textColor ?? _getContrastColor(effectiveBackgroundColor);

    if (isDot) {
      return Container(
        width: _getDotSize(),
        height: _getDotSize(),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          shape: BoxShape.circle,
        ),
      );
    }

    final displayText = count != null
        ? (count! > 99 ? '99+' : count.toString())
        : text!;

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      constraints: BoxConstraints(
        minWidth: _getMinWidth(),
        minHeight: _getMinHeight(),
      ),
      child: Center(
        child: Text(
          displayText,
          style: _getTextStyle(textTheme, effectiveTextColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getVariantColor(ColorScheme colorScheme) {
    switch (variant) {
      case AppBadgeVariant.primary:
        return colorScheme.primary;
      case AppBadgeVariant.success:
        return colorScheme.success;
      case AppBadgeVariant.error:
        return colorScheme.error;
      case AppBadgeVariant.warning:
        return colorScheme.warning;
      case AppBadgeVariant.info:
        return colorScheme.info;
      case AppBadgeVariant.neutral:
        return colorScheme.surfaceContainerHighest;
    }
  }

  Color _getContrastColor(Color background) {
    if (variant == AppBadgeVariant.neutral) {
      return Colors.black;
    }
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  double _getDotSize() {
    switch (size) {
      case AppBadgeSize.small:
        return 8;
      case AppBadgeSize.medium:
        return 10;
      case AppBadgeSize.large:
        return 12;
    }
  }

  double _getMinWidth() {
    switch (size) {
      case AppBadgeSize.small:
        return 16;
      case AppBadgeSize.medium:
        return 20;
      case AppBadgeSize.large:
        return 24;
    }
  }

  double _getMinHeight() {
    switch (size) {
      case AppBadgeSize.small:
        return 16;
      case AppBadgeSize.medium:
        return 20;
      case AppBadgeSize.large:
        return 24;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppBadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
      case AppBadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 3);
      case AppBadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    }
  }

  TextStyle _getTextStyle(TextTheme textTheme, Color textColor) {
    final baseStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
    );

    switch (size) {
      case AppBadgeSize.small:
        return textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ) ??
            baseStyle;
      case AppBadgeSize.medium:
        return textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ) ??
            baseStyle;
      case AppBadgeSize.large:
        return textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ) ??
            baseStyle;
    }
  }
}

/// Badge positioned on a child widget
class BadgedWidget extends StatelessWidget {
  final Widget child;
  final AppBadge badge;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry offset;

  const BadgedWidget({
    super.key,
    required this.child,
    required this.badge,
    this.alignment = Alignment.topRight,
    this.offset = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: alignment == Alignment.topRight || alignment == Alignment.topLeft
              ? offset.vertical
              : null,
          right: alignment == Alignment.topRight ||
                  alignment == Alignment.bottomRight
              ? offset.horizontal
              : null,
          bottom: alignment == Alignment.bottomRight ||
                  alignment == Alignment.bottomLeft
              ? offset.vertical
              : null,
          left: alignment == Alignment.topLeft ||
                  alignment == Alignment.bottomLeft
              ? offset.horizontal
              : null,
          child: badge,
        ),
      ],
    );
  }
}

/// Status badge for workout states
class WorkoutStatusBadge extends StatelessWidget {
  final String status;
  final AppBadgeSize size;

  const WorkoutStatusBadge({
    super.key,
    required this.status,
    this.size = AppBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final variant = _getVariantForStatus(status);
    return AppBadge(
      text: status,
      variant: variant,
      size: size,
    );
  }

  AppBadgeVariant _getVariantForStatus(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('complete') || lowerStatus.contains('done')) {
      return AppBadgeVariant.success;
    }
    if (lowerStatus.contains('skip') || lowerStatus.contains('miss')) {
      return AppBadgeVariant.error;
    }
    if (lowerStatus.contains('progress') || lowerStatus.contains('active')) {
      return AppBadgeVariant.info;
    }
    if (lowerStatus.contains('rest')) {
      return AppBadgeVariant.neutral;
    }
    return AppBadgeVariant.primary;
  }
}
