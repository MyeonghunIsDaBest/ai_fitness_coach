/// Atomic Design System - Molecules
///
/// This file exports all molecule components (molecules) in the design system.
/// Molecules are combinations of atoms that form more complex UI components.
///
/// Usage:
/// ```dart
/// import 'package:ai_fitness_coach/presentation/widgets/design_system/molecules/molecules.dart';
///
/// // Now you can use any molecule component
/// FormGroup(label: 'Email', child: AppTextField.email())
/// AppSearchBar(hint: 'Search exercises...')
/// ActionCard(title: 'Start Workout', primaryAction: ...)
/// ExerciseListItem(name: 'Bench Press', sets: 4, reps: 8)
/// ```

// Form Components
export 'form_group.dart';

// Search Components
export 'search_bar.dart';

// Card Components
export 'action_card.dart';

// Exercise Components
export 'exercise_list_item.dart';

// Statistics Components
export 'stat_display.dart';

// Navigation Components
export 'navigation_item.dart';
