/// Atomic Design System - Templates
///
/// This file exports all template components in the design system.
/// Templates are page-level layouts that define the structure of screens.
///
/// Usage:
/// ```dart
/// import 'package:ai_fitness_coach/presentation/widgets/design_system/templates/templates.dart';
///
/// // Now you can use any template component
/// MainLayout(body: content, currentIndex: 0, onNavigationChanged: ...)
/// DetailLayout(title: 'Details', body: content)
/// WorkoutLayout(title: 'Push Day', body: content, ...)
/// ```

// Main app layouts
export 'main_layout.dart';

// Detail/sub-screen layouts
export 'detail_layout.dart';

// Workout-specific layouts
export 'workout_layout.dart';
