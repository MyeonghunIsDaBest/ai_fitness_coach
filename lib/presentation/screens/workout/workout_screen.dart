import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/daily_workout.dart';
import '../../../domain/models/exercise.dart';
import '../../../domain/models/logged_set.dart';

/// WorkoutScreen - Active workout execution screen (Semi-dark theme design)
/// Features:
/// - RPE slider control with visual feedback
/// - Exercise cards with sets table
/// - Weight/Reps input fields
/// - Set completion checkmarks
/// - Rest timer
/// - Finish workout button
class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  double _currentRPE = 7.0;
  bool _isResting = false;
  int _restSeconds = 0;
  Timer? _restTimer;
  DateTime? _workoutStartTime;
  Timer? _elapsedTimer;
  Duration _elapsedTime = Duration.zero;

  // Semi-dark theme colors
  static const _backgroundColor = Color(0xFF0F172A);
  static const _cardColor = Color(0xFF1E293B);
  static const _cardColorLight = Color(0xFF334155);
  static const _accentBlue = Color(0xFF3B82F6);
  static const _accentGreen = Color(0xFFB4F04D);
  static const _accentCyan = Color(0xFF00D9FF);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);

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

  void _startRestTimer(int seconds) {
    setState(() {
      _isResting = true;
      _restSeconds = seconds;
    });
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

  Color _getRPEColor(double rpe) {
    if (rpe <= 4) return const Color(0xFF10B981);
    if (rpe <= 6) return _accentGreen;
    if (rpe <= 8) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final todayWorkoutAsync = ref.watch(workoutForDayProvider(DateTime.now().weekday));
    final loggedSets = ref.watch(loggedSetsProvider);

    return todayWorkoutAsync.when(
      data: (workout) {
        if (workout == null || workout.exercises.isEmpty) {
          return _buildNoWorkout(context);
        }
        return _buildWorkoutTracker(context, workout, loggedSets);
      },
      loading: () => _buildLoading(),
      error: (error, _) => _buildError(context),
    );
  }

  Widget _buildWorkoutTracker(
    BuildContext context,
    DailyWorkout workout,
    List<LoggedSet> loggedSets,
  ) {
    final completedSets = loggedSets.length;
    final totalSets = workout.exercises.fold<int>(0, (sum, e) => sum + e.sets);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: _textPrimary),
          onPressed: () => _showExitConfirmation(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            Text(
              '${workout.focus} • ${_formatDuration(_elapsedTime)}',
              style: const TextStyle(
                fontSize: 12,
                color: _textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _cardColorLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$completedSets/$totalSets sets',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: _textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildRPEControl(),
          if (_isResting) _buildRestTimer(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(
                  workout.exercises[index],
                  index,
                  loggedSets,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(context, workout),
    );
  }

  Widget _buildRPEControl() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current RPE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getRPEColor(_currentRPE).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentRPE.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getRPEColor(_currentRPE),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getRPEColor(_currentRPE),
              inactiveTrackColor: _cardColorLight,
              thumbColor: _getRPEColor(_currentRPE),
              overlayColor: _getRPEColor(_currentRPE).withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _currentRPE,
              min: 1,
              max: 10,
              divisions: 18,
              onChanged: (value) {
                setState(() {
                  _currentRPE = value;
                });
              },
            ),
          ),
          const Text(
            'Rate of Perceived Exertion (1-10 scale)',
            style: TextStyle(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestTimer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentBlue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.timer, color: _accentBlue, size: 24),
              ),
              const SizedBox(width: 14),
              const Text(
                'Rest Timer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${_restSeconds}s',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _accentBlue,
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  _restTimer?.cancel();
                  setState(() => _isResting = false);
                },
                style: TextButton.styleFrom(
                  backgroundColor: _accentBlue.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Skip', style: TextStyle(color: _accentBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    Exercise exercise,
    int exerciseIndex,
    List<LoggedSet> loggedSets,
  ) {
    final exerciseSets = loggedSets.where((s) => s.exerciseName == exercise.name).toList();
    final completedSetsCount = exerciseSets.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${exercise.sets} sets × ${exercise.reps} reps • RPE ${exercise.targetRPEMid?.toStringAsFixed(0) ?? '-'}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: completedSetsCount >= exercise.sets
                      ? const Color(0xFF10B981).withOpacity(0.15)
                      : _cardColorLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completedSetsCount/${exercise.sets}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: completedSetsCount >= exercise.sets
                        ? const Color(0xFF10B981)
                        : _textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSetsTable(exercise, exerciseSets),
        ],
      ),
    );
  }

  Widget _buildSetsTable(Exercise exercise, List<LoggedSet> completedSets) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _textSecondary)),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, size: 12, color: _textSecondary.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text('Weight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _textSecondary)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.numbers, size: 12, color: _textSecondary.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text('Reps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _textSecondary)),
                  ],
                ),
              ),
              Expanded(
                child: Text('RPE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _textSecondary)),
              ),
              const SizedBox(width: 44),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(exercise.sets, (setIndex) {
          final isCompleted = setIndex < completedSets.length;
          final completedSet = isCompleted ? completedSets[setIndex] : null;

          return _SetRowWidget(
            setNumber: setIndex + 1,
            isCompleted: isCompleted,
            completedSet: completedSet,
            exercise: exercise,
            currentRPE: _currentRPE,
            onComplete: (weight, reps, rpe) {
              _logSet(exercise, setIndex + 1, weight, reps, rpe);
            },
          );
        }),
      ],
    );
  }

  void _logSet(Exercise exercise, int setNumber, double weight, int reps, double rpe) {
    final sessionId = ref.read(activeSessionIdProvider);

    final loggedSet = LoggedSet.create(
      workoutSessionId: sessionId ?? 'temp_session',
      exerciseId: exercise.name.toLowerCase().replaceAll(' ', '_'),
      exerciseName: exercise.name,
      setNumber: setNumber,
      weight: weight,
      weightUnit: 'kg',
      reps: reps,
      rpe: rpe,
      targetRPE: exercise.targetRPEMid,
    );

    ref.read(addLoggedSetProvider)(loggedSet);
    _startRestTimer(exercise.restSeconds);
  }

  Widget _buildBottomActions(BuildContext context, DailyWorkout workout) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border(top: BorderSide(color: _cardColorLight.withOpacity(0.3))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showExitConfirmation(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: _cardColorLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save for Later', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _finishWorkout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Finish Workout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finishWorkout(BuildContext context) async {
    final loggedSets = ref.read(loggedSetsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Finish Workout?', style: TextStyle(color: _textPrimary)),
        content: Text(
          'You completed ${loggedSets.length} sets in ${_formatDuration(_elapsedTime)}.',
          style: const TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final completeSession = ref.read(completeWorkoutSessionProvider);
              await completeSession();
              final completeWorkout = ref.read(completeWorkoutProvider);
              completeWorkout(DateTime.now().weekday);
              if (mounted) {
                context.go('/workout/summary');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit Workout?', style: TextStyle(color: _textPrimary)),
        content: const Text(
          'Your progress will be saved. You can continue this workout later.',
          style: TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Exit', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  Widget _buildNoWorkout(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _cardColor,
        elevation: 0,
        title: const Text('Workout', style: TextStyle(color: _textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: _textSecondary.withOpacity(0.5)),
            const SizedBox(height: 20),
            const Text(
              'No workout scheduled',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textPrimary),
            ),
            const SizedBox(height: 10),
            const Text('Select a program to get started', style: TextStyle(color: _textSecondary)),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Go Back', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(child: CircularProgressIndicator(color: _accentGreen)),
    );
  }

  Widget _buildError(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 20),
            const Text('Error loading workout', style: TextStyle(color: _textPrimary, fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentGreen,
                foregroundColor: Colors.black,
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetRowWidget extends StatefulWidget {
  final int setNumber;
  final bool isCompleted;
  final LoggedSet? completedSet;
  final Exercise exercise;
  final double currentRPE;
  final void Function(double weight, int reps, double rpe) onComplete;

  const _SetRowWidget({
    required this.setNumber,
    required this.isCompleted,
    this.completedSet,
    required this.exercise,
    required this.currentRPE,
    required this.onComplete,
  });

  @override
  State<_SetRowWidget> createState() => _SetRowWidgetState();
}

class _SetRowWidgetState extends State<_SetRowWidget> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;

  static const _cardColorLight = Color(0xFF334155);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.completedSet?.weight.toString() ?? '0',
    );
    _repsController = TextEditingController(
      text: widget.completedSet?.reps.toString() ?? widget.exercise.reps.toString(),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isCompleted
            ? const Color(0xFF10B981).withOpacity(0.1)
            : _cardColorLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: widget.isCompleted
            ? Border.all(color: const Color(0xFF10B981).withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              '${widget.setNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: _textPrimary, fontSize: 15),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                enabled: !widget.isCompleted,
                style: const TextStyle(fontSize: 15, color: _textPrimary),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: _cardColorLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                enabled: !widget.isCompleted,
                style: const TextStyle(fontSize: 15, color: _textPrimary),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: _cardColorLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Text(
                widget.completedSet?.rpe.toStringAsFixed(1) ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold, color: _textPrimary, fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: IconButton(
              onPressed: widget.isCompleted
                  ? null
                  : () {
                      final weight = double.tryParse(_weightController.text) ?? 0;
                      final reps = int.tryParse(_repsController.text) ?? widget.exercise.reps;
                      widget.onComplete(weight, reps, widget.currentRPE);
                    },
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.isCompleted ? const Color(0xFF10B981) : _cardColorLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: widget.isCompleted ? Colors.white : _textSecondary,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
