# Material 3 Theme System

This directory contains the Material 3 theme configuration for the AI Fitness Coach app.

## Overview

The app uses **Material 3 (Material You)** design system with custom brand colors:
- **Primary**: Lime Green (#B4F04D)
- **Secondary**: Cyan (#00D9FF)

## Architecture

### Files Structure

```
lib/core/theme/
├── app_theme.dart          # Central theme configuration
├── color_schemes.dart      # Color schemes + extensions
├── text_theme.dart         # Typography configuration
├── component_themes.dart   # Component-specific themes
└── README.md              # This file
```

## Usage Guidelines

### ✅ DO: Use Theme Colors

Always access colors through the theme system:

```dart
// Get the color scheme from context
final colorScheme = Theme.of(context).colorScheme;

// Use semantic colors
Container(
  color: colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(color: colorScheme.onSurface),
  ),
);
```

### ❌ DON'T: Hard-code Colors

**NEVER** use hard-coded color values:

```dart
// ❌ WRONG
Container(color: Color(0xFFB4F04D))
Container(color: Color(0xFF1E1E1E))
Text('Hello', style: TextStyle(color: Colors.white))

// ✅ CORRECT
Container(color: colorScheme.primary)
Container(color: colorScheme.surface)
Text('Hello', style: TextStyle(color: colorScheme.onSurface))
```

## Available Color Schemes

### Material 3 Standard Colors

All widgets have access to the standard Material 3 ColorScheme:

```dart
colorScheme.primary              // Lime Green (#B4F04D)
colorScheme.onPrimary           // Text/icons on primary
colorScheme.primaryContainer    // Lighter primary variant
colorScheme.onPrimaryContainer  // Text on primary container

colorScheme.secondary           // Cyan (#00D9FF)
colorScheme.onSecondary
colorScheme.secondaryContainer
colorScheme.onSecondaryContainer

colorScheme.tertiary            // Purple accent
colorScheme.error               // Error red (#FF6B6B)
colorScheme.surface             // Card/sheet backgrounds
colorScheme.onSurface          // Text on surfaces
colorScheme.outline            // Borders/dividers
```

### Custom Extensions

#### 1. Sport Colors (`SportColors`)

Use for sport-specific UI elements:

```dart
final colorScheme = Theme.of(context).colorScheme;

colorScheme.sportPowerlifting     // Red (#FF6B6B)
colorScheme.sportBodybuilding     // Teal (#4ECDC4)
colorScheme.sportCrossfit         // Orange (#FF9800)
colorScheme.sportOlympicLifting   // Yellow (#FFC107)
colorScheme.sportGeneralFitness   // Purple (#9C27B0)
```

**Example:**
```dart
Color _getProgramColor(Sport sport) {
  final colorScheme = Theme.of(context).colorScheme;
  switch (sport) {
    case Sport.powerlifting:
      return colorScheme.sportPowerlifting;
    case Sport.bodybuilding:
      return colorScheme.sportBodybuilding;
    // ...
  }
}
```

#### 2. RPE Colors (`RPEColors`)

Use for workout intensity visualization:

```dart
final colorScheme = Theme.of(context).colorScheme;

// Dynamic color based on RPE value
Color color = colorScheme.getRPEColor(7.5);

// Or use specific intensity colors
colorScheme.rpeVeryLight   // Light green
colorScheme.rpeLight       // Green
colorScheme.rpeModerate    // Lime (brand primary)
colorScheme.rpeHard        // Orange
colorScheme.rpeVeryHard    // Red
colorScheme.rpeMaximal     // Deep red
```

**Example:**
```dart
Container(
  decoration: BoxDecoration(
    color: colorScheme.getRPEColor(rpeValue),
    borderRadius: BorderRadius.circular(8),
  ),
)
```

#### 3. Workout Colors (`WorkoutColors`)

Semantic colors for workout states:

```dart
final colorScheme = Theme.of(context).colorScheme;

colorScheme.success        // Workout completed, PR achieved
colorScheme.warning        // Missed workout, caution
colorScheme.info          // Rest day, optional info
colorScheme.disabled      // Inactive elements

// Interaction overlays
colorScheme.hoverOverlay
colorScheme.pressOverlay
colorScheme.focusOverlay
```

## Component Themes

### Buttons

All button themes automatically use the color scheme:

```dart
// Elevated button - automatically uses primary color
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
)

// Outlined button - automatically uses primary for border
OutlinedButton(
  onPressed: () {},
  child: Text('Cancel'),
)

// Text button - automatically uses primary
TextButton(
  onPressed: () {},
  child: Text('Learn More'),
)
```

### Cards

```dart
Card(
  // Automatically uses surface color with outline
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
```

### Input Fields

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Weight',
    // Automatically styled with theme colors
    // Focus border: primary
    // Error border: error
    // Fill: surfaceContainerHighest
  ),
)
```

## Typography

Access text styles through the theme:

```dart
final textTheme = Theme.of(context).textTheme;

Text('Display Large', style: textTheme.displayLarge)
Text('Headline Medium', style: textTheme.headlineMedium)
Text('Body Large', style: textTheme.bodyLarge)
Text('Label Small', style: textTheme.labelSmall)
```

## Migration Guide

### Migrating Old Code

**Before:**
```dart
Container(
  color: Color(0xFF1E1E1E),
  child: Text(
    'Hello',
    style: TextStyle(color: Color(0xFFB4F04D)),
  ),
)
```

**After:**
```dart
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.primary,
    ),
  ),
)
```

### Common Replacements

| Old (Hard-coded) | New (Theme-aware) |
|-----------------|-------------------|
| `Color(0xFFB4F04D)` | `colorScheme.primary` |
| `Color(0xFF00D9FF)` | `colorScheme.secondary` |
| `Color(0xFF1E1E1E)` | `colorScheme.surface` |
| `Color(0xFF0A0A0A)` | `colorScheme.background` |
| `Colors.grey.shade800` | `colorScheme.onSurfaceVariant` |
| `Colors.white.withOpacity(0.1)` | `colorScheme.outline.withOpacity(0.2)` |
| `RPEThresholds.getRPEColor(rpe)` | `colorScheme.getRPEColor(rpe)` |

## Light vs Dark Mode

The theme system automatically handles light and dark modes:

```dart
// In app.dart
MaterialApp(
  theme: AppTheme.light(),      // Light mode theme
  darkTheme: AppTheme.dark(),   // Dark mode theme
  themeMode: ThemeMode.system,  // Follows system preference
)
```

Both themes use the same color values but with different backgrounds and surface colors optimized for their respective modes.

## Best Practices

### 1. Always Use Theme Context

```dart
// ✅ CORRECT
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(color: colorScheme.surface);
}

// ❌ WRONG - Can't access theme without context
final primaryColor = Color(0xFFB4F04D);
```

### 2. Use Semantic Color Names

```dart
// ✅ CORRECT - Semantic meaning is clear
color: colorScheme.error        // For errors
color: colorScheme.success      // For success
color: colorScheme.surface      // For backgrounds

// ❌ WRONG - Hard to understand intent
color: Color(0xFFFF6B6B)
color: Color(0xFF4ECDC4)
```

### 3. Leverage Extensions for Domain Logic

```dart
// ✅ CORRECT - Use extensions for app-specific colors
color: colorScheme.getRPEColor(workout.rpe)
color: colorScheme.sportPowerlifting

// ❌ WRONG - Don't recreate logic
Color getRPEColor(double rpe) {
  if (rpe <= 4) return Colors.green;
  // ...
}
```

### 4. Don't Mix Material Colors with Theme

```dart
// ❌ WRONG - Mixing Material defaults with theme
color: Colors.grey.shade800

// ✅ CORRECT - Use theme consistently
color: colorScheme.onSurfaceVariant
```

## Testing Theme Changes

To test theme changes:

1. **Hot reload** - Changes to theme files require hot restart
2. **Test both modes** - Always check light and dark themes
3. **Check contrast** - Ensure text is readable on all backgrounds

## Common Issues

### Issue: Colors not updating after theme change

**Solution:** Ensure you're using `Theme.of(context)` inside the build method, not storing colors in class fields.

```dart
// ❌ WRONG
class MyWidget extends StatelessWidget {
  final color = Color(0xFFB4F04D); // Static, won't update

// ✅ CORRECT
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary; // Dynamic
```

### Issue: Can't access theme extensions

**Solution:** Import the color_schemes.dart file:

```dart
import '../../core/theme/color_schemes.dart';
```

## Contributing

When adding new colors:

1. Add to appropriate extension in `color_schemes.dart`
2. Document the use case
3. Update this README with examples
4. Ensure it works in both light and dark themes

---

**Questions?** Check the Material 3 guidelines: https://m3.material.io/
