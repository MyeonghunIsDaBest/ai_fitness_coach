/// Atomic Design System - Atoms
///
/// This file exports all atomic components (atoms) in the design system.
/// Atoms are the smallest building blocks of the UI.
///
/// Usage:
/// ```dart
/// import 'package:ai_fitness_coach/presentation/widgets/design_system/atoms/atoms.dart';
///
/// // Now you can use any atom component
/// AppButton.primary(text: 'Submit', onPressed: () {})
/// AppTextField.email(label: 'Email')
/// AppCard(child: Text('Content'))
/// ```

// Buttons
export 'app_button.dart';

// Text Inputs
export 'app_text_field.dart';

// Cards
export 'app_card.dart';

// Chips
export 'app_chip.dart';

// Loading Indicators
export 'app_loading.dart';

// Icons
export 'app_icon.dart';

// Badges
export 'app_badge.dart';
