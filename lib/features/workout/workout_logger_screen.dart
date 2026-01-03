import 'package:flutter/material.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/logged_set.dart';
import '../../domain/repositories/training_repository.dart';
import '../../services/workout_session_service.dart';
import '../../services/rpe_feedback_service.dart';
import '../../core/utils/session_stats.dart';
import '../../core/constants/ui_strings.dart';
import '../../core/constants/rpe_thresholds.dart';
import '../../domain/usecases/calculate_session_rpe.dart';
import '../../domain/usecases/log_set_rpe.dart';

/// Production-ready workout logger with full service integration
class WorkoutLoggerScreen extends StatefulWidget {
  final DailyWorkout workout;
  final String programId;
  final int weekNumber;
  final double targetRPEMin;
  final double targetRPEMax;
  final WorkoutSessionService sessionService;
  final RPEFeedbackService rpeService;

  const WorkoutLoggerScreen({
    Key? key,
    required this.workout,
    required this.programId,
    required this.weekNumber,
    required this.targetRPEMin,
    required this.targetRPEMax,
    required this.sessionService,
    required this.rpeService,
  }) : super(key: key);

  @override
  State<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends State<WorkoutLoggerScreen> {
  // Session tracking
  String? _sessionId;
  DateTime? _startTime;

  // Logged data
  Map<String, List<LoggedSet>> _loggedSets = {};
  Map<String, bool> _completedExercises = {};

  // Current state
  int _currentExerciseIndex = 0;
  bool _isLoading = false;

  // Use cases
  late final CalculateSessionRPE _calculateSessionRPE;
  late final LogSetRPE _logSetUseCase;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _calculateSessionRPE = CalculateSessionRPE();
    // Note: _logSetUseCase needs repository, we'll handle this differently
    _initializeSession();
  }

  /// Initialize workout session
  Future<void> _initializeSession() async {
    setState(() => _isLoading = true);

    try {
      _sessionId = await widget.sessionService.startSession(
        programId: widget.programId,
        weekNumber: widget.weekNumber,
        dayNumber: widget.workout.dayNumber,
        workoutName: widget.workout.focus,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to start session: $e');
    }
  }

  /// Calculate current session average RPE
  double get _sessionAvgRPE {
    final allSets = _loggedSets.values.expand((sets) => sets).toList();
    if (allSets.isEmpty) return 0.0;
    return _calculateSessionRPE(allSets);
  }

  /// Get elapsed time
  String get _elapsedTime {
    if (_startTime == null) return '0:00';
    final duration = DateTime.now().difference(_startTime!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get total sets logged
  int get _totalSetsLogged {
    return _loggedSets.values.fold(0, (sum, sets) => sum + sets.length);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(widget.workout.focus),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFB4F04D)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.workout.focus, style: const TextStyle(fontSize: 16)),
            Text(
              _elapsedTime,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white60,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showWorkoutHistory,
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: _finishWorkout,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildWorkoutStats(),
            _buildRPEFeedback(),
            Expanded(child: _buildExerciseList()),
          ],
        ),
      ),
    );
  }

  /// Workout statistics header
  Widget _buildWorkoutStats() {
    final totalVolume = SessionStats.calculateTotalVolume(
      _loggedSets.values.expand((sets) => sets).toList(),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              UIStrings.sets,
              '$_totalSetsLogged',
              Icons.format_list_numbered,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              UIStrings.avgRPE,
              _sessionAvgRPE > 0 ? _sessionAvgRPE.toStringAsFixed(1) : '-',
              Icons.trending_up,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Volume',
              totalVolume > 0 ? '${totalVolume.toStringAsFixed(0)}kg' : '-',
              Icons.fitness_center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFB4F04D)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  /// RPE feedback banner
  Widget _buildRPEFeedback() {
    if (_sessionAvgRPE == 0) return const SizedBox.shrink();

    final feedback = widget.rpeService.getFatigueMessage(
      _sessionAvgRPE,
      widget.targetRPEMin.toInt(),
      widget.targetRPEMax.toInt(),
    );

    Color backgroundColor;
    if (_sessionAvgRPE < widget.targetRPEMin) {
      backgroundColor = Colors.blue.withOpacity(0.2);
    } else if (_sessionAvgRPE > widget.targetRPEMax) {
      backgroundColor = Colors.red.withOpacity(0.2);
    } else {
      backgroundColor = Colors.green.withOpacity(0.2);
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _sessionAvgRPE >= widget.targetRPEMin &&
                  _sessionAvgRPE <= widget.targetRPEMax
              ? Colors.green
              : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _sessionAvgRPE >= widget.targetRPEMin &&
                    _sessionAvgRPE <= widget.targetRPEMax
                ? Icons.check_circle
                : Icons.info_outline,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(feedback, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  /// Exercise list
  Widget _buildExerciseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.workout.exercises.length,
      itemBuilder: (context, index) {
        final exercise = widget.workout.exercises[index];
        return _buildExerciseCard(exercise, index);
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise, int index) {
    final sets = _loggedSets[exercise.id] ?? [];
    final isCompleted = _completedExercises[exercise.id] ?? false;
    final isExpanded = _currentExerciseIndex == index;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: exercise.isMain
              ? const Color(0xFFB4F04D).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            if (expanded) setState(() => _currentExerciseIndex = index);
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withOpacity(0.2)
                  : exercise.isMain
                      ? const Color(0xFFB4F04D).withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : exercise.isMain
                      ? Icons.fitness_center
                      : Icons.circle_outlined,
              color: isCompleted
                  ? Colors.green
                  : exercise.isMain
                      ? const Color(0xFFB4F04D)
                      : Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ),
          title: Row(
            children: [
              if (exercise.isMain)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4F04D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'MAIN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              if (exercise.isMain) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  exercise.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${exercise.sets} sets × ${exercise.reps} reps • ${exercise.intensityDisplay ?? "RPE-based"}',
              style:
                  TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
            ),
          ),
          trailing: sets.isNotEmpty
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4F04D).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${sets.length} logged',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB4F04D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (sets.isNotEmpty) ...[
                    ...sets.asMap().entries.map((entry) {
                      return _buildSetRow(entry.value, entry.key + 1);
                    }),
                    const SizedBox(height: 12),
                  ],
                  if (!isCompleted) ...[
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showLogSetDialog(exercise, sets.length + 1),
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(sets.isEmpty
                          ? UIStrings.logFirstSet
                          : 'Log Set ${sets.length + 1}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB4F04D),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (sets.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _markExerciseComplete(exercise.id),
                        icon: const Icon(Icons.check_circle),
                        label: Text(UIStrings.markComplete),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ] else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Exercise Completed',
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(LoggedSet set, int setNumber) {
    final rpeColor = Color(RPEThresholds.getRPEColor(set.rpe).value);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rpeColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rpeColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$setNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  set.weightDisplay,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '× ${set.reps}',
                  style: TextStyle(
                      fontSize: 16, color: Colors.white.withOpacity(0.7)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: rpeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'RPE ${set.rpe.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: rpeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog to log a set
  void _showLogSetDialog(Exercise exercise, int setNumber) {
    final weightController = TextEditingController();
    final repsController =
        TextEditingController(text: exercise.reps.toString());
    double currentRPE = (widget.targetRPEMin + widget.targetRPEMax) / 2;

    // Pre-fill with last set's weight if available
    final previousSets = _loggedSets[exercise.id];
    if (previousSets != null && previousSets.isNotEmpty) {
      weightController.text = previousSets.last.weight.toString();
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Set $setNumber - ${exercise.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target: ${exercise.sets} × ${exercise.reps} @ ${exercise.intensityDisplay}',
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withOpacity(0.6)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: UIStrings.weight,
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: repsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: UIStrings.reps,
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'RPE: ${currentRPE.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(RPEThresholds.getRPEColor(currentRPE).value),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  RPEThresholds.getRPEDescription(currentRPE),
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withOpacity(0.6)),
                ),
                const SizedBox(height: 12),
                Slider(
                  value: currentRPE,
                  min: 1.0,
                  max: 10.0,
                  divisions: 18,
                  activeColor:
                      Color(RPEThresholds.getRPEColor(currentRPE).value),
                  inactiveColor: Colors.white.withOpacity(0.1),
                  onChanged: (value) =>
                      setDialogState(() => currentRPE = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(UIStrings.cancel,
                  style: TextStyle(color: Colors.white.withOpacity(0.6))),
            ),
            ElevatedButton(
              onPressed: () => _saveSet(
                context,
                exercise,
                setNumber,
                weightController.text,
                repsController.text,
                currentRPE,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4F04D),
                foregroundColor: Colors.black,
              ),
              child: Text(UIStrings.saveSet),
            ),
          ],
        ),
      ),
    );
  }

  /// Save logged set
  Future<void> _saveSet(
    BuildContext dialogContext,
    Exercise exercise,
    int setNumber,
    String weightText,
    String repsText,
    double rpe,
  ) async {
    final weight = double.tryParse(weightText);
    final reps = int.tryParse(repsText);

    if (weight == null || weight <= 0) {
      _showError(UIStrings.enterValidWeight);
      return;
    }

    if (reps == null || reps <= 0) {
      _showError(UIStrings.enterValidReps);
      return;
    }

    if (_sessionId == null) {
      _showError('Session not initialized');
      return;
    }

    try {
      // Log set using service
      await widget.sessionService.logSet(
        sessionId: _sessionId!,
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        setNumber: setNumber,
        weight: weight,
        weightUnit: 'kg',
        reps: reps,
        rpe: rpe,
        targetRPE: exercise.targetRPEMid,
      );

      // Update local state
      setState(() {
        if (!_loggedSets.containsKey(exercise.id)) {
          _loggedSets[exercise.id] = [];
        }
        _loggedSets[exercise.id]!.add(
          LoggedSet.create(
            workoutSessionId: _sessionId!,
            exerciseId: exercise.id,
            exerciseName: exercise.name,
            setNumber: setNumber,
            weight: weight,
            weightUnit: 'kg',
            reps: reps,
            rpe: rpe,
            targetRPE: exercise.targetRPEMid,
          ),
        );
      });

      Navigator.pop(dialogContext);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set logged! 💪'),
          backgroundColor: Color(0xFFB4F04D),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      _showError('Failed to log set: $e');
    }
  }

  /// Mark exercise as complete
  void _markExerciseComplete(String exerciseId) {
    setState(() {
      _completedExercises[exerciseId] = true;
    });
  }

  /// Finish workout
  Future<void> _finishWorkout() async {
    if (_loggedSets.isEmpty) {
      _showError(UIStrings.logAtLeastOneSet);
      return;
    }

    final summary = widget.rpeService.getSessionSummary(
      avgRPE: _sessionAvgRPE,
      targetMin: widget.targetRPEMin.toInt(),
      targetMax: widget.targetRPEMax.toInt(),
      allCompleted:
          _completedExercises.length == widget.workout.exercises.length,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(UIStrings.workoutComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: $_elapsedTime'),
            Text('Sets Logged: $_totalSetsLogged'),
            Text('Average RPE: ${_sessionAvgRPE.toStringAsFixed(1)}'),
            const SizedBox(height: 16),
            Text(
              summary,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFFB4F04D),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(UIStrings.keepLogging),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_sessionId != null) {
                await widget.sessionService.completeSession(_sessionId!);
              }
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to week dashboard
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB4F04D),
              foregroundColor: Colors.black,
            ),
            child: Text(UIStrings.finish),
          ),
        ],
      ),
    );
  }

  void _showWorkoutHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout history coming soon!')),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
