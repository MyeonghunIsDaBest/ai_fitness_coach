import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../presentation/screens/main/main_shell.dart';
import '../../presentation/screens/workout/workout_screen.dart';
import '../../presentation/screens/workout/workout_summary_screen.dart';
import '../../presentation/screens/programs/program_detail_screen.dart';
import '../../presentation/screens/history/workout_history_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
// New screens
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/program_editor/custom_program_screen.dart';
import '../../presentation/screens/dashboard/week_dashboard_screen.dart';
import '../../presentation/screens/analytics/analytics_screen.dart';

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
        builder: (context, state) => const WorkoutSummaryScreen(),
      ),

      // Program detail screen
      GoRoute(
        path: '/program/:id',
        name: 'program-detail',
        builder: (context, state) {
          final programId = state.pathParameters['id'];
          return ProgramDetailScreen(programId: programId ?? '');
        },
      ),

      // Workout history screen
      GoRoute(
        path: '/history',
        name: 'workout-history',
        builder: (context, state) => const WorkoutHistoryScreen(),
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
        builder: (context, state) => const SettingsScreen(),
      ),

      // Auth screens
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Program editor
      GoRoute(
        path: '/program-editor',
        name: 'program-editor',
        builder: (context, state) => const CustomProgramScreen(),
      ),

      // Week dashboard
      GoRoute(
        path: '/week-dashboard',
        name: 'week-dashboard',
        builder: (context, state) => const WeekDashboardScreen(),
      ),

      // Analytics
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),

      // Programs list (navigates to MainShell with programs tab selected)
      GoRoute(
        path: '/programs',
        name: 'programs',
        builder: (context, state) => const MainShell(initialTab: 1),
      ),

      // Forgot password screen
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
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

// Placeholder screen - to be implemented
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
