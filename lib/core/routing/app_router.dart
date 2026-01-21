import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/screens/main/main_shell.dart';
import '../../presentation/screens/workout/workout_screen.dart';

part 'app_router.g.dart';

/// Router provider for GoRouter configuration
@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Main shell with bottom navigation
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainShell(),
      ),

      // Workout execution screen
      GoRoute(
        path: '/workout',
        name: 'workout',
        builder: (context, state) => const WorkoutScreen(),
      ),

      // Workout summary screen
      GoRoute(
        path: '/workout/summary',
        name: 'workout-summary',
        builder: (context, state) => const _WorkoutSummaryPlaceholder(),
      ),

      // Program detail screen
      GoRoute(
        path: '/program/:id',
        name: 'program-detail',
        builder: (context, state) {
          final programId = state.pathParameters['id'];
          return _ProgramDetailPlaceholder(programId: programId);
        },
      ),

      // Exercise detail screen
      GoRoute(
        path: '/exercise/:id',
        name: 'exercise-detail',
        builder: (context, state) {
          final exerciseId = state.pathParameters['id'];
          return _ExerciseDetailPlaceholder(exerciseId: exerciseId);
        },
      ),

      // Settings screens
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const _SettingsPlaceholder(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'settings-profile',
            builder: (context, state) => const _ProfileEditPlaceholder(),
          ),
          GoRoute(
            path: 'training',
            name: 'settings-training',
            builder: (context, state) => const _TrainingPrefsPlaceholder(),
          ),
        ],
      ),
    ],

    // Error handling
    errorBuilder: (context, state) {
      final colorScheme = Theme.of(context).colorScheme;
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Placeholder screens - to be implemented
class _WorkoutSummaryPlaceholder extends StatelessWidget {
  const _WorkoutSummaryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Summary')),
      body: const Center(child: Text('Workout Summary - Coming Soon')),
    );
  }
}

class _ProgramDetailPlaceholder extends StatelessWidget {
  final String? programId;

  const _ProgramDetailPlaceholder({this.programId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program Details')),
      body: Center(child: Text('Program: $programId')),
    );
  }
}

class _ExerciseDetailPlaceholder extends StatelessWidget {
  final String? exerciseId;

  const _ExerciseDetailPlaceholder({this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Details')),
      body: Center(child: Text('Exercise: $exerciseId')),
    );
  }
}

class _SettingsPlaceholder extends StatelessWidget {
  const _SettingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings - Coming Soon')),
    );
  }
}

class _ProfileEditPlaceholder extends StatelessWidget {
  const _ProfileEditPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile - Coming Soon')),
    );
  }
}

class _TrainingPrefsPlaceholder extends StatelessWidget {
  const _TrainingPrefsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training Preferences')),
      body: const Center(child: Text('Training Preferences - Coming Soon')),
    );
  }
}
