import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/daily_workout.dart';
import '../../../domain/models/logged_set.dart';
import '../../widgets/design_system/atoms/atoms.dart';
import '../../widgets/design_system/molecules/molecules.dart';
import '../../widgets/design_system/organisms/organisms.dart';

/// WorkoutScreen - Active workout execution screen
///
/// Displays the current exercise, sets, and provides controls
/// for logging workout progress.
class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isResting = false;
  int _restSeconds = 0;
  Timer? _restTimer;
  DateTime? _workoutStartTime;
  Timer? _elapsedTimer;
  Duration _elapsedTime = Duration.zero;

  // Tracked weights/reps (user can modify)
  double? _currentWeight;
  int? _currentReps;
  double? _currentRPE;

  @override
  void initState() {
    super.initState();
    _workoutStartTime = DateTime.now();
    _startElapsedTimer();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _elapsedTimer?.cancel();
    super.dispose();
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = DateTime.now().difference(_workoutStartTime!);
        });
      }
    });
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _restSeconds > 0) {
        setState(() {
          _restSeconds--;
          if (_restSeconds <= 0) {
            _isResting = false;
            _restTimer?.cancel();
          }
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch active session and today's workout
    final sessionAsync = ref.watch(activeWorkoutSessionProvider);
    final todayWorkoutAsync = ref.watch(workoutForDayProvider(DateTime.now().weekday));
    final loggedSets = ref.watch(loggedSetsProvider);

    return todayWorkoutAsync.when(
      data: (workout) {
        if (workout == null) {
          return _buildNoWorkout(context, colorScheme);
        }

        final exercises = workout.exercises;
        if (exercises.isEmpty) {
          return _buildNoWorkout(context, colorScheme);
        }

        final currentExercise = exercises[_currentExerciseIndex];

        // Initialize current values if not set
        _currentWeight ??= currentExercise.suggestedWeight ?? 0.0;
        _currentReps ??= currentExercise.reps;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: _buildAppBar(colorScheme, textTheme, workout),
          body: _isResting
              ? _buildRestTimer(colorScheme, textTheme)
              : _buildExerciseContent(
                  colorScheme, textTheme, currentExercise, exercises, loggedSets),
          bottomNavigationBar: _buildBottomBar(
            colorScheme,
            currentExercise,
            exercises,
            workout,
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading workout', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              AppButton.secondary(
                text: 'Go Back',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoWorkout(BuildContext context, ColorScheme colorScheme) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text('Workout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'No workout scheduled',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            AppButton.primary(
              text: 'Go Back',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    ColorScheme colorScheme,
    TextTheme textTheme,
    DailyWorkout workout,
  ) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _showExitConfirmation(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.name,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _formatDuration(_elapsedTime),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () => _nextExercise(workout.exercises),
          tooltip: 'Next Exercise',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: _buildProgressBar(colorScheme, textTheme, workout.exercises.length),
      ),
    );
  }

  Widget _buildProgressBar(
    ColorScheme colorScheme,
    TextTheme textTheme,
    int totalExercises,
  ) {
    final progress = (totalExercises > 0)
        ? (_currentExerciseIndex + 1) / totalExercises
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise ${_currentExerciseIndex + 1} of $totalExercises',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Exercise exercise,
    List<Exercise> allExercises,
    List<LoggedSet> loggedSets,
  ) {
    // Filter logged sets for this exercise
    final exerciseSets = loggedSets.where((s) => s.exerciseName == exercise.name).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active exercise card
          ActiveExerciseCard(
            name: exercise.name,
            currentSet: _currentSetIndex + 1,
            totalSets: exercise.sets,
            targetReps: exercise.reps,
            targetRPE: exercise.targetRPE,
            weight: _currentWeight ?? 0,
            formCues: exercise.cues,
            onComplete: () => _showSetLoggingSheet(context, exercise),
            onSkip: () => _skipSet(exercise, allExercises),
          ),
          const SizedBox(height: 24),

          // Set history for this exercise
          _buildSetHistory(colorScheme, textTheme, exercise, exerciseSets),
          const SizedBox(height: 24),

          // Upcoming exercises
          _buildUpcomingExercises(colorScheme, textTheme, allExercises),
        ],
      ),
    );
  }

  Widget _buildSetHistory(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Exercise exercise,
    List<LoggedSet> completedSets,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sets',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(exercise.sets, (index) {
          final isCompleted = index < completedSets.length;
          final isActive = index == _currentSetIndex;
          final completedSet = isCompleted ? completedSets[index] : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SetRow(
              setNumber: index + 1,
              weight: completedSet?.weight ?? _currentWeight ?? 0,
              reps: completedSet?.reps ?? exercise.reps,
              targetRPE: exercise.targetRPE,
              actualRPE: completedSet?.rpe,
              isCompleted: isCompleted,
              isActive: isActive,
              onTap: isCompleted ? () {} : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUpcomingExercises(
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<Exercise> exercises,
  ) {
    if (_currentExerciseIndex >= exercises.length - 1) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Up Next',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          (exercises.length - _currentExerciseIndex - 1).clamp(0, 2),
          (index) {
            final exercise = exercises[_currentExerciseIndex + 1 + index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ExerciseListItem.compact(
                name: exercise.name,
                sets: exercise.sets,
                reps: exercise.reps,
                targetRPE: exercise.targetRPE,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRestTimer(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: RestTimer(
          seconds: _restSeconds,
          recommendedSeconds: 120,
          onSkip: _skipRest,
          onAdd30Seconds: () => setState(() => _restSeconds += 30),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    ColorScheme colorScheme,
    Exercise currentExercise,
    List<Exercise> exercises,
    DailyWorkout workout,
  ) {
    final isLastSetOfLastExercise =
        _currentExerciseIndex == exercises.length - 1 &&
        _currentSetIndex == currentExercise.sets - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: AppButton.primary(
          text: isLastSetOfLastExercise ? 'Finish Workout' : 'Complete Set',
          onPressed: () => _showSetLoggingSheet(context, currentExercise),
          isFullWidth: true,
          leading: const Icon(Icons.check, size: 20),
        ),
      ),
    );
  }

  void _showSetLoggingSheet(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SetLoggingSheet(
        exerciseName: exercise.name,
        setNumber: _currentSetIndex + 1,
        targetWeight: _currentWeight ?? exercise.suggestedWeight ?? 0,
        targetReps: _currentReps ?? exercise.reps,
        targetRPE: exercise.targetRPE,
        onComplete: (weight, reps, rpe) {
          _logSet(exercise, weight, reps, rpe);
        },
      ),
    );
  }

  void _logSet(Exercise exercise, double weight, int reps, double rpe) {
    final sessionId = ref.read(activeSessionIdProvider);

    // Create logged set
    final loggedSet = LoggedSet.create(
      workoutSessionId: sessionId ?? 'temp_session',
      exerciseId: exercise.name.toLowerCase().replaceAll(' ', '_'),
      exerciseName: exercise.name,
      setNumber: _currentSetIndex + 1,
      weight: weight,
      weightUnit: 'kg',
      reps: reps,
      rpe: rpe,
      targetRPE: exercise.targetRPE,
    );

    // Add to logged sets
    ref.read(addLoggedSetProvider)(loggedSet);

    // Update current values for next set
    _currentWeight = weight;
    _currentReps = reps;
    _currentRPE = rpe;

    // Move to next set or exercise
    _completeSet(exercise, ref.read(workoutForDayProvider(DateTime.now().weekday)).value?.exercises ?? []);
  }

  void _completeSet(Exercise currentExercise, List<Exercise> exercises) {
    if (_currentSetIndex < currentExercise.sets - 1) {
      // More sets remaining - start rest timer
      setState(() {
        _currentSetIndex++;
        _isResting = true;
        _restSeconds = 120;
      });
      _startRestTimer();
    } else if (_currentExerciseIndex < exercises.length - 1) {
      // Move to next exercise
      _nextExercise(exercises);
    } else {
      // Workout complete
      _finishWorkout();
    }
  }

  void _skipSet(Exercise exercise, List<Exercise> exercises) {
    _completeSet(exercise, exercises);
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
    });
  }

  void _nextExercise(List<Exercise> exercises) {
    if (_currentExerciseIndex < exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
        _isResting = false;
        // Reset current values for new exercise
        final nextExercise = exercises[_currentExerciseIndex];
        _currentWeight = nextExercise.suggestedWeight;
        _currentReps = nextExercise.reps;
        _currentRPE = null;
      });
    }
  }

  void _finishWorkout() async {
    // Complete the session
    final completeSession = ref.read(completeWorkoutSessionProvider);
    await completeSession();

    // Mark workout as completed for today
    final completeWorkout = ref.read(completeWorkoutProvider);
    completeWorkout(DateTime.now().weekday);

    if (mounted) {
      // Show completion dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.amber),
              SizedBox(width: 8),
              Text('Workout Complete!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Duration: ${_formatDuration(_elapsedTime)}'),
              const SizedBox(height: 8),
              Text('Sets completed: ${ref.read(loggedSetsProvider).length}'),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Workout?'),
        content: const Text(
          'Your progress will be saved. You can continue this workout later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet for logging a completed set
class SetLoggingSheet extends StatefulWidget {
  final String exerciseName;
  final int setNumber;
  final double targetWeight;
  final int targetReps;
  final double? targetRPE;
  final void Function(double weight, int reps, double rpe) onComplete;

  const SetLoggingSheet({
    super.key,
    required this.exerciseName,
    required this.setNumber,
    required this.targetWeight,
    required this.targetReps,
    this.targetRPE,
    required this.onComplete,
  });

  @override
  State<SetLoggingSheet> createState() => _SetLoggingSheetState();
}

class _SetLoggingSheetState extends State<SetLoggingSheet> {
  late double _weight;
  late int _reps;
  double _rpe = 7.0;

  @override
  void initState() {
    super.initState();
    _weight = widget.targetWeight;
    _reps = widget.targetReps;
    _rpe = widget.targetRPE ?? 7.0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log Set ${widget.setNumber}',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.exerciseName,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Weight input
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight (kg)', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => setState(() => _weight = (_weight - 2.5).clamp(0, 500)),
                        ),
                        Expanded(
                          child: Text(
                            _weight.toStringAsFixed(1),
                            style: textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _weight = (_weight + 2.5).clamp(0, 500)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reps', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => setState(() => _reps = (_reps - 1).clamp(1, 100)),
                        ),
                        Expanded(
                          child: Text(
                            _reps.toString(),
                            style: textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _reps = (_reps + 1).clamp(1, 100)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // RPE slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('RPE', style: textTheme.labelMedium),
                  Text(
                    _rpe.toStringAsFixed(1),
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _rpe,
                min: 5.0,
                max: 10.0,
                divisions: 10,
                label: _rpe.toStringAsFixed(1),
                onChanged: (value) => setState(() => _rpe = value),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Easy', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  Text('Max Effort', style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Complete button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                widget.onComplete(_weight, _reps, _rpe);
                Navigator.pop(context);
              },
              child: const Text('Complete Set'),
            ),
          ),
        ],
      ),
    );
  }
}
