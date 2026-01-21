import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_theme.dart';
import 'component_themes.dart';

/// Central theme configuration for the app
/// Provides Material 3 themes with custom color schemes
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData light() {
    const colorScheme = AppColorSchemes.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,

      // Component themes
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: AppComponentThemes.textButtonTheme(colorScheme),
      cardTheme: AppComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: AppComponentThemes.inputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: AppComponentThemes.bottomNavigationBarTheme(colorScheme),
      appBarTheme: AppComponentThemes.appBarTheme(colorScheme),

      // Default visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// Dark theme configuration (default)
  static ThemeData dark() {
    const colorScheme = AppColorSchemes.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: AppTextTheme.textTheme,

      // Component themes
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: AppComponentThemes.textButtonTheme(colorScheme),
      cardTheme: AppComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: AppComponentThemes.inputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: AppComponentThemes.bottomNavigationBarTheme(colorScheme),
      appBarTheme: AppComponentThemes.appBarTheme(colorScheme),

      // Default visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
