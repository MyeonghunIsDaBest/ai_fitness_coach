import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/daily_workout.dart';
import '../../widgets/design_system/atoms/atoms.dart';
import '../../widgets/design_system/molecules/molecules.dart';
import '../../widgets/design_system/organisms/organisms.dart';

/// HomeScreen - Main dashboard screen
///
/// Displays today's workout, quick stats, and recent activity.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch providers
    final profileAsync = ref.watch(currentAthleteProfileProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final todayWorkoutAsync = ref.watch(workoutForDayProvider(DateTime.now().weekday));
    final totalWorkoutsAsync = ref.watch(totalWorkoutsProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final workoutHistoryAsync = ref.watch(workoutHistoryProvider(5));

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentAthleteProfileProvider);
          ref.invalidate(activeProgramProvider);
          ref.invalidate(totalWorkoutsProvider);
          ref.invalidate(workoutHistoryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting header with user name
              _buildGreetingHeader(colorScheme, textTheme, profileAsync),
              const SizedBox(height: 24),

              // Today's workout card
              _buildTodaysWorkout(
                context,
                colorScheme,
                textTheme,
                todayWorkoutAsync,
                activeProgramAsync,
                ref,
              ),
              const SizedBox(height: 24),

              // Quick stats
              _buildQuickStats(
                colorScheme,
                textTheme,
                totalWorkoutsAsync,
                currentStreakAsync,
              ),
              const SizedBox(height: 24),

              // Recent workouts
              _buildRecentWorkouts(
                context,
                colorScheme,
                textTheme,
                workoutHistoryAsync,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<dynamic> profileAsync,
  ) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    final userName = profileAsync.whenOrNull(
      data: (profile) => profile?.name,
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName != null ? '$greeting, $userName' : greeting,
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ready to crush your workout?',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        BadgedWidget(
          badge: const AppBadge.dot(),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysWorkout(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<DailyWorkout?> todayWorkoutAsync,
    AsyncValue<dynamic> activeProgramAsync,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Today's Workout",
          action: TextButton(
            onPressed: () {
              // Navigate to week view
            },
            child: const Text('View Week'),
          ),
        ),
        const SizedBox(height: 8),
        todayWorkoutAsync.when(
          data: (workout) {
            if (workout == null) {
              // Check if we have an active program
              return activeProgramAsync.when(
                data: (program) {
                  if (program == null) {
                    // No program selected
                    return _buildNoProgram(context, colorScheme);
                  }
                  // Rest day
                  return WorkoutCard.restDay(
                    onTap: () {},
                  );
                },
                loading: () => _buildLoadingCard(colorScheme),
                error: (_, __) => _buildNoProgram(context, colorScheme),
              );
            }

            // Build workout card from actual data
            return WorkoutCard(
              title: workout.name,
              focus: workout.focus,
              exerciseCount: workout.exercises.length,
              estimatedDuration: workout.estimatedDurationMinutes,
              isActive: true,
              exercises: workout.exercises.take(3).map((e) {
                return WorkoutExercisePreview(
                  name: e.name,
                  sets: e.sets,
                  reps: e.reps,
                  isMain: e.isMain,
                );
              }).toList(),
              onStart: () {
                // Start workout
                _startWorkout(context, ref, workout);
              },
              onTap: () => context.push('/workout'),
            );
          },
          loading: () => _buildLoadingCard(colorScheme),
          error: (error, _) => _buildErrorCard(colorScheme, error.toString()),
        ),
      ],
    );
  }

  Widget _buildNoProgram(BuildContext context, ColorScheme colorScheme) {
    return AppCard.outlined(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Program Selected',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a training program to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton.primary(
            text: 'Browse Programs',
            onPressed: () {
              // Navigate to programs
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(ColorScheme colorScheme) {
    return AppCard.outlined(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildErrorCard(ColorScheme colorScheme, String error) {
    return AppCard.outlined(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading workout',
            style: TextStyle(color: colorScheme.error),
          ),
        ],
      ),
    );
  }

  void _startWorkout(BuildContext context, WidgetRef ref, DailyWorkout workout) async {
    final program = await ref.read(activeProgramProvider.future);
    if (program == null) return;

    final weekNumber = ref.read(currentWeekProvider);

    try {
      final startSession = ref.read(startWorkoutSessionProvider);
      await startSession(
        programId: program.id,
        weekNumber: weekNumber,
        dayNumber: workout.dayNumber,
        workoutName: workout.name,
      );

      if (context.mounted) {
        context.push('/workout');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting workout: $e')),
        );
      }
    }
  }

  Widget _buildQuickStats(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<int> totalWorkoutsAsync,
    AsyncValue<int> currentStreakAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Your Stats',
          action: TextButton(
            onPressed: () {},
            child: const Text('Details'),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: StatDisplay(
                  label: 'Total Workouts',
                  value: totalWorkoutsAsync.when(
                    data: (count) => count.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.fitness_center,
                  size: StatDisplaySize.small,
                  layout: StatDisplayLayout.vertical,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: StatDisplay(
                  label: 'Current Streak',
                  value: currentStreakAsync.when(
                    data: (streak) => streak.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  unit: 'days',
                  icon: Icons.local_fire_department,
                  iconColor: colorScheme.primary,
                  size: StatDisplaySize.small,
                  layout: StatDisplayLayout.vertical,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<List<dynamic>> workoutHistoryAsync,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Workouts',
          action: TextButton(
            onPressed: () => context.push('/history'),
            child: const Text('See All'),
          ),
        ),
        const SizedBox(height: 8),
        workoutHistoryAsync.when(
          data: (sessions) {
            if (sessions.isEmpty) {
              return AppCard.outlined(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 32,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No workouts yet',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Complete your first workout to see it here',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: sessions.take(3).map((session) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: WorkoutCard.compact(
                    title: session.workoutName,
                    focus: '${session.sets.length} sets',
                    exerciseCount: session.exercisesPerformed.length,
                    estimatedDuration: session.duration?.inMinutes ?? 0,
                    isCompleted: session.isCompleted,
                    onTap: () {
                      // Navigate to workout detail
                    },
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
