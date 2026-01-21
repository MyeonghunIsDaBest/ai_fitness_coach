# Atomic Design System - Atoms

This directory contains all atomic components (atoms) for the AI Fitness Coach app. Atoms are the smallest, most fundamental building blocks of the UI.

## Overview

All atoms follow Material 3 design principles and integrate seamlessly with the app's theme system. They are fully accessible, responsive, and optimized for the fitness coaching domain.

## Available Atoms

### 1. AppButton ([app_button.dart](app_button.dart))
Unified button component with multiple variants.

**Variants:**
- `AppButton.primary()` - High emphasis filled button
- `AppButton.secondary()` - Medium emphasis outlined button
- `AppButton.text()` - Low emphasis text button
- `AppButton.icon()` - Icon-only button

**Features:**
- Loading states
- Size variants (small, medium, large)
- Full-width option
- Leading/trailing widgets
- Fully theme-aware

**Example:**
```dart
AppButton.primary(
  text: 'Start Workout',
  onPressed: () => startWorkout(),
  isLoading: isLoading,
)

AppButton.icon(
  icon: Icons.add,
  onPressed: () => addExercise(),
)
```

### 2. AppTextField ([app_text_field.dart](app_text_field.dart))
Unified text input component with validation.

**Types:**
- `AppTextField.email()` - Email input
- `AppTextField.password()` - Password with visibility toggle
- `AppTextField.number()` - Numeric input
- `AppTextField.multiline()` - Text area

**Features:**
- Built-in validation
- Helper text support
- Error states
- Prefix/suffix icons and text
- Character limits
- Input formatters

**Example:**
```dart
AppTextField.email(
  label: 'Email Address',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  onChanged: (value) => setState(() => email = value),
)

AppTextField.number(
  label: 'Weight (lbs)',
  suffixText: 'lbs',
  maxLength: 4,
)
```

### 3. AppCard ([app_card.dart](app_card.dart))
Unified card component for content containers.

**Variants:**
- `AppCard.outlined()` - Flat card with border
- `AppCard.elevated()` - Card with shadow elevation
- `WorkoutCard()` - Specialized for workout content
- `StatsCard()` - Specialized for metrics display

**Features:**
- Optional header with title/subtitle
- Trailing widgets
- Tap handling
- Elevation levels
- Custom padding/margin

**Example:**
```dart
WorkoutCard(
  title: 'Upper Body',
  subtitle: '45 min',
  icon: Icons.fitness_center,
  onTap: () => startWorkout(),
  child: WorkoutSummary(),
)

StatsCard(
  label: 'Total Volume',
  value: '12,450 lbs',
  icon: Icons.trending_up,
  trend: '+12%',
  trendPositive: true,
)
```

### 4. AppChip ([app_chip.dart](app_chip.dart))
Unified chip component for filters, tags, and selections.

**Variants:**
- `AppChip.filter()` - Selectable filter chip
- `AppChip.input()` - Input chip with delete
- `AppChip.choice()` - Single selection chip
- `AppChipGroup()` - Multiple chip management

**Features:**
- Selected states
- Icons
- Delete actions
- Outlined/filled variants

**Example:**
```dart
AppChip.filter(
  label: 'Powerlifting',
  selected: isSelected,
  onSelected: (selected) => toggleFilter(selected),
  icon: Icons.fitness_center,
)

AppChipGroup(
  labels: ['Beginner', 'Intermediate', 'Advanced'],
  selectedLabels: selectedLevels,
  onSelectionChanged: (label, selected) => updateSelection(label, selected),
)
```

### 5. AppLoading ([app_loading.dart](app_loading.dart))
Unified loading indicators with consistent styling.

**Types:**
- `AppLoading.circular()` - Circular spinner
- `AppLinearLoading()` - Progress bar
- `AppSkeleton()` - Shimmer placeholder
- `AppLoadingOverlay()` - Full-screen overlay

**Features:**
- Size variants
- Custom colors
- Skeleton shapes (rect, circle, line)
- Animated shimmer effect

**Example:**
```dart
// Circular loader
AppLoading.circular()

// Progress bar
AppLinearLoading(value: 0.65)

// Skeleton placeholders
AppSkeleton.line(width: 200, height: 16)
AppSkeleton.circle(size: 48)
SkeletonText(lines: 3)
SkeletonCard()

// Loading overlay
AppLoadingOverlay(
  isLoading: isLoading,
  message: 'Loading workout...',
  child: YourContent(),
)
```

### 6. AppIcon ([app_icon.dart](app_icon.dart))
Unified icon component with semantic coloring.

**Semantic Types:**
- `AppIcon.success()` - Green, completed states
- `AppIcon.error()` - Red, failed states
- `AppIcon.warning()` - Yellow, caution states
- `AppIcon.info()` - Blue, informational
- `AppIcon.primary()` - Brand lime color
- `AppIcon.disabled()` - Grayed out

**Features:**
- Size variants (small, medium, large, extraLarge)
- Semantic coloring
- Icon containers with backgrounds
- Workout-specific icon constants
- RPE icon helper

**Example:**
```dart
AppIcon.success(Icons.check_circle)
AppIcon.primary(Icons.fitness_center, size: AppIconSize.large)

AppIconContainer.primary(
  icon: WorkoutIcons.powerlifting,
  size: AppIconSize.medium,
)

RPEIcon(rpe: 8.5) // Auto-colored based on intensity
```

**Workout Icons:**
```dart
WorkoutIcons.powerlifting
WorkoutIcons.bodybuilding
WorkoutIcons.weight
WorkoutIcons.reps
WorkoutIcons.sets
WorkoutIcons.completed
// ... and many more
```

### 7. AppBadge ([app_badge.dart](app_badge.dart))
Unified badge component for counts and status indicators.

**Variants:**
- `AppBadge.dot()` - Small dot indicator
- `AppBadge.count()` - Numeric badge
- `AppBadge.success/error/warning()` - Semantic badges
- `BadgedWidget()` - Badge positioned on widget
- `WorkoutStatusBadge()` - Workout-specific status

**Features:**
- Size variants
- Count display (with 99+ overflow)
- Semantic colors
- Dot mode
- Positioned badges

**Example:**
```dart
// Count badge
AppBadge.count(count: 5)

// Dot indicator
AppBadge.dot()

// Status badge
AppBadge.success(text: 'Completed')

// Badge on widget
BadgedWidget(
  badge: AppBadge.count(count: 3),
  child: Icon(Icons.notifications),
)

// Workout status
WorkoutStatusBadge(status: 'Completed')
```

## Usage Guidelines

### Importing Atoms

**Option 1: Import all atoms**
```dart
import 'package:ai_fitness_coach/presentation/widgets/design_system/atoms/atoms.dart';
```

**Option 2: Import specific atoms**
```dart
import 'package:ai_fitness_coach/presentation/widgets/design_system/atoms/app_button.dart';
import 'package:ai_fitness_coach/presentation/widgets/design_system/atoms/app_card.dart';
```

### Theme Integration

All atoms automatically use the app's theme colors:

```dart
// ✅ Good - Atoms handle theming automatically
AppButton.primary(text: 'Submit')

// ❌ Bad - Don't override colors unless absolutely necessary
AppButton.primary(
  text: 'Submit',
  // Avoid custom colors; use semantic variants instead
)
```

### Composition

Atoms can be composed together:

```dart
AppCard.outlined(
  title: 'Workout Summary',
  child: Column(
    children: [
      StatsCard(label: 'Sets', value: '12'),
      AppButton.primary(
        text: 'View Details',
        onPressed: () {},
      ),
    ],
  ),
)
```

## Accessibility

All atoms include:
- ✅ Proper semantic labels
- ✅ Minimum touch target sizes (48x48)
- ✅ High contrast color schemes
- ✅ Screen reader support
- ✅ Keyboard navigation support

## Best Practices

### 1. Use Semantic Variants

```dart
// ✅ Good - Clear intent
AppButton.primary(text: 'Save')
AppButton.secondary(text: 'Cancel')

// ❌ Bad - Generic variant
AppButton(text: 'Save', variant: AppButtonVariant.primary)
```

### 2. Leverage Named Constructors

```dart
// ✅ Good - Type-safe and clear
AppTextField.email(label: 'Email')

// ❌ Bad - Requires manual type specification
AppTextField(
  label: 'Email',
  type: AppTextFieldType.email,
)
```

### 3. Let Theme Handle Colors

```dart
// ✅ Good - Theme-aware
AppIcon.success(Icons.check)

// ❌ Bad - Hard-coded color
Icon(Icons.check, color: Colors.green)
```

### 4. Use Loading States

```dart
// ✅ Good - Built-in loading
AppButton.primary(
  text: 'Save',
  isLoading: isLoading,
  onPressed: () async {
    setState(() => isLoading = true);
    await save();
    setState(() => isLoading = false);
  },
)
```

## Testing

All atoms should be tested for:
- Different states (enabled, disabled, loading)
- Theme variations (light/dark mode)
- Accessibility compliance
- Various screen sizes

## Contributing

When adding new atoms:

1. **Follow naming conventions**: `App[ComponentName]`
2. **Include semantic variants**: Named constructors for common use cases
3. **Support theming**: Use `Theme.of(context).colorScheme`
4. **Add accessibility**: Proper semantics and touch targets
5. **Document usage**: Clear examples and use cases
6. **Export in atoms.dart**: Make it available to the app

## Related Documentation

- [Material 3 Theme System](../../../core/theme/README.md)
- [Color Schemes](../../../core/theme/color_schemes.dart)
- Phase 2.1 Completion Summary

---

**Phase:** 2.2 - Atomic Design - Atoms
**Status:** Complete ✅
**Components:** 7 atoms, 15+ variants
