import 'package:flutter/material.dart';

/// Color schemes for light and dark themes
/// Semi-dark theme inspired by modern web fitness app design
class AppColorSchemes {
  AppColorSchemes._();

  /// Light theme color scheme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // Primary colors - Blue (matching web design)
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDBEAFE),
    onPrimaryContainer: Color(0xFF1E3A8A),

    // Secondary colors - Lime Green accent
    secondary: Color(0xFFB4F04D),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFFD4FF8D),
    onSecondaryContainer: Color(0xFF1A1F00),

    // Tertiary colors - Cyan
    tertiary: Color(0xFF00D9FF),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF80ECFF),
    onTertiaryContainer: Color(0xFF001F26),

    // Error colors
    error: Color(0xFFFF6B6B),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    // Background colors
    background: Color(0xFFF8FAFC),
    onBackground: Color(0xFF1C1B1F),

    // Surface colors
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFF1F5F9),
    onSurfaceVariant: Color(0xFF49454F),

    // Outline colors
    outline: Color(0xFFCBD5E1),
    outlineVariant: Color(0xFFE2E8F0),

    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFF3B82F6),
  );

  /// Semi-dark theme color scheme (default) - Modern fitness app design
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    // Primary colors - Blue (matching web design gradient)
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF2563EB),
    onPrimaryContainer: Color(0xFFDBEAFE),

    // Secondary colors - Lime Green accent
    secondary: Color(0xFFB4F04D),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF4E6000),
    onSecondaryContainer: Color(0xFFD4FF8D),

    // Tertiary colors - Cyan
    tertiary: Color(0xFF00D9FF),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF004D5C),
    onTertiaryContainer: Color(0xFF80ECFF),

    // Error colors
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    // Background colors - Semi-dark (slightly lighter than pure black)
    background: Color(0xFF0F172A),
    onBackground: Color(0xFFE2E8F0),

    // Surface colors - Card backgrounds
    surface: Color(0xFF1E293B),
    onSurface: Color(0xFFE2E8F0),
    surfaceVariant: Color(0xFF334155),
    onSurfaceVariant: Color(0xFFCBD5E1),

    // Outline colors
    outline: Color(0xFF475569),
    outlineVariant: Color(0xFF334155),

    // Other colors
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE2E8F0),
    onInverseSurface: Color(0xFF1E293B),
    inversePrimary: Color(0xFF2563EB),
  );
}

/// Extension for custom sport-specific colors (matching web design gradients)
extension SportColors on ColorScheme {
  Color get sportPowerlifting => const Color(0xFFEF4444);
  Color get sportPowerliftingEnd => const Color(0xFFF97316);
  Color get sportBodybuilding => const Color(0xFF3B82F6);
  Color get sportBodybuildingEnd => const Color(0xFF8B5CF6);
  Color get sportCrossfit => const Color(0xFF10B981);
  Color get sportCrossfitEnd => const Color(0xFF14B8A6);
  Color get sportOlympicLifting => const Color(0xFFF59E0B);
  Color get sportOlympicLiftingEnd => const Color(0xFFF97316);
  Color get sportGeneralFitness => const Color(0xFF06B6D4);
  Color get sportGeneralFitnessEnd => const Color(0xFF3B82F6);
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
