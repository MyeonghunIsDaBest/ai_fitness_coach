/// FitCoach AI Design System
///
/// A comprehensive design system built on Atomic Design principles
/// with full Material 3 theme integration.
///
/// ## Usage
/// ```dart
/// import 'package:ai_fitness_coach/presentation/widgets/design_system/design_system.dart';
/// ```
///
/// ## Structure
/// - **Atoms**: Basic building blocks (buttons, inputs, cards, badges, etc.)
/// - **Molecules**: Combinations of atoms (form groups, search bars, exercise items)
/// - **Organisms**: Complex UI sections (workout cards, exercise sections, headers)
/// - **Templates**: Page-level layouts (main layout, detail layout, workout layout)
///
/// ## Example
/// ```dart
/// // Using atoms
/// AppButton.primary(text: 'Start Workout', onPressed: () {});
/// AppTextField.email(label: 'Email');
///
/// // Using molecules
/// FormGroup(label: 'Weight', child: AppTextField.number());
/// ExerciseListItem(name: 'Squat', sets: 4, reps: 8);
///
/// // Using organisms
/// WorkoutCard(title: 'Push Day', focus: 'Chest, Shoulders');
/// ExerciseSection(title: 'Main Lifts', exercises: [...]);
///
/// // Using templates
/// MainLayout(body: content, currentIndex: 0, onNavigationChanged: ...);
/// DetailLayout(title: 'Exercise', body: content);
/// ```
library;

// Atoms - Basic building blocks
export 'atoms/atoms.dart';

// Molecules - Combinations of atoms
export 'molecules/molecules.dart';

// Organisms - Complex UI sections
export 'organisms/organisms.dart';

// Templates - Page-level layouts
export 'templates/templates.dart';
