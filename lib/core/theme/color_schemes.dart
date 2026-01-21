import 'package:flutter/material.dart';

/// Color schemes for light and dark themes
/// Preserves existing brand colors: Lime Green (#B4F04D) and Cyan (#00D9FF)
class AppColorSchemes {
  AppColorSchemes._();

  /// Light theme color scheme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // Primary colors - Lime Green
    primary: Color(0xFFB4F04D),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFFD4FF8D),
    onPrimaryContainer: Color(0xFF1A1F00),

    // Secondary colors - Cyan
    secondary: Color(0xFF00D9FF),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF80ECFF),
    onSecondaryContainer: Color(0xFF001F26),

    // Tertiary colors
    tertiary: Color(0xFF7B61FF),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE5DEFF),
    onTertiaryContainer: Color(0xFF1B0067),

    // Error colors
    error: Color(0xFFFF6B6B),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    // Background colors
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF1C1B1F),

    // Surface colors
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),

    // Outline colors
    outline: Color(0xFF79747E),
    outlineVariant: Color(0xFFCAC4D0),

    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFFB4F04D),
  );

  /// Dark theme color scheme (default)
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    // Primary colors - Lime Green
    primary: Color(0xFFB4F04D),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF4E6000),
    onPrimaryContainer: Color(0xFFD4FF8D),

    // Secondary colors - Cyan
    secondary: Color(0xFF00D9FF),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF004D5C),
    onSecondaryContainer: Color(0xFF80ECFF),

    // Tertiary colors
    tertiary: Color(0xFFCABDFF),
    onTertiary: Color(0xFF32009F),
    tertiaryContainer: Color(0xFF4A00E0),
    onTertiaryContainer: Color(0xFFE5DEFF),

    // Error colors
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    // Background colors
    background: Color(0xFF0A0A0A),
    onBackground: Color(0xFFE6E1E5),

    // Surface colors
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF2B2B2B),
    onSurfaceVariant: Color(0xFFCAC4D0),

    // Outline colors
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),

    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF4E6000),
  );
}

/// Extension for custom sport-specific colors
extension SportColors on ColorScheme {
  Color get sportPowerlifting => const Color(0xFFFF6B6B);
  Color get sportBodybuilding => const Color(0xFF4ECDC4);
  Color get sportCrossfit => const Color(0xFFFF9800);
  Color get sportOlympicLifting => const Color(0xFFFFC107);
  Color get sportGeneralFitness => const Color(0xFF9C27B0);
}

/// Extension for RPE (Rate of Perceived Exertion) color mapping
/// Maps RPE values to semantic colors for workout intensity visualization
extension RPEColors on ColorScheme {
  /// Get color based on RPE value (1-10 scale)
  Color getRPEColor(double rpe) {
    if (rpe <= 4) return const Color(0xFF4CAF50); // Green - Very Light to Light
    if (rpe <= 6) return primary; // Lime - Moderate
    if (rpe <= 8) return const Color(0xFFFF9800); // Orange - Hard
    return error; // Red - Very Hard to Max
  }

  /// RPE color variants for specific intensity levels
  Color get rpeVeryLight => const Color(0xFF81C784); // Light green
  Color get rpeLight => const Color(0xFF66BB6A); // Medium green
  Color get rpeModerate => primary; // Lime green (brand color)
  Color get rpeHard => const Color(0xFFFF9800); // Orange
  Color get rpeVeryHard => const Color(0xFFFF6B6B); // Red (error color)
  Color get rpeMaximal => error; // Deep red
}

/// Extension for semantic workout colors
extension WorkoutColors on ColorScheme {
  /// Success state (e.g., workout completed, PR achieved)
  Color get success => const Color(0xFF4ECDC4);

  /// Warning state (e.g., missed workout, approaching failure)
  Color get warning => const Color(0xFFFFE66D);

  /// Info state (e.g., rest day, optional workout)
  Color get info => secondary; // Cyan

  /// Disabled/inactive state
  Color get disabled => onSurfaceVariant.withOpacity(0.38);

  /// Overlay colors for interactions
  Color get hoverOverlay => onSurface.withOpacity(0.08);
  Color get pressOverlay => onSurface.withOpacity(0.12);
  Color get focusOverlay => onSurface.withOpacity(0.12);
}
