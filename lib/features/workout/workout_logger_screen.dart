import 'package:flutter/material.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/logged_set.dart';
import '../../core/utils/rpe_math.dart';
import '../../core/constants/rpe_thresholds.dart';

/// Workout logger screen for tracking sets and RPE
class WorkoutLoggerScreen extends StatefulWidget {
  final DailyWorkout? workout;

  const WorkoutLoggerScreen({Key? key, this.workout}) : super(key: key);

  @override
  State<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends State<WorkoutLoggerScreen> {
  Map<String, List<LoggedSet>> loggedSets = {};
  DateTime? workoutStartTime;
  int currentExerciseIndex = 0;

  @override
  void initState() {
    super.initState();
    workoutStartTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.workout == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Workout Logger'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Text(
                'No workout selected',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Select a workout from the week dashboard',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.workout!.focus),
            Text(
              _getElapsedTime(),
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
            onPressed: () => _showWorkoutHistory(),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () => _finishWorkout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildWorkoutStats(),
            Expanded(
              child: _buildExerciseList(),
            ),
          ],
        ),
      ),
    );
  }

  String _getElapsedTime() {
    if (workoutStartTime == null) return '0:00';
    final duration = DateTime.now().difference(workoutStartTime!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildWorkoutStats() {
    final totalSets =
        loggedSets.values.fold(0, (sum, sets) => sum + sets.length);
    final avgRPE = _calculateAverageRPE();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Sets',
              '$totalSets',
              Icons.format_list_numbered,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Avg RPE',
              avgRPE > 0 ? avgRPE.toStringAsFixed(1) : '-',
              Icons.trending_up,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Time',
              _getElapsedTime(),
              Icons.timer,
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  double _calculateAverageRPE() {
    final allSets = loggedSets.values.expand((sets) => sets).toList();
    if (allSets.isEmpty) return 0.0;

    final rpes = allSets.map((set) => set.rpe).toList();
    return RPEMath.calculateAverageRPE(rpes);
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.workout!.exercises.length,
      itemBuilder: (context, index) {
        final exercise = widget.workout!.exercises[index];
        return _buildExerciseCard(exercise, index);
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise, int index) {
    final sets = loggedSets[exercise.id] ?? [];
    final isExpanded = currentExerciseIndex == index;

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
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            if (expanded) {
              setState(() => currentExerciseIndex = index);
            }
          },
          title: Row(
            children: [
              if (exercise.isMain)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${exercise.sets} sets × ${exercise.reps} reps • ${exercise.intensityDisplay ?? "RPE-based"}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (sets.isNotEmpty) ...[
                    ...sets.asMap().entries.map((entry) {
                      return _buildSetRow(entry.value, entry.key + 1);
                    }),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton.icon(
                    onPressed: () => _logSet(exercise),
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(
                      sets.isEmpty
                          ? 'Log First Set'
                          : 'Log Set ${sets.length + 1}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4F04D),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
        border: Border.all(
          color: rpeColor.withOpacity(0.3),
        ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '× ${set.reps}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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

  void _logSet(Exercise exercise) {
    final sets = loggedSets[exercise.id] ?? [];
    final setNumber = sets.length + 1;

    // Pre-fill with last set's data if available
    double? lastWeight = sets.isNotEmpty ? sets.last.weight : null;
    int? lastReps = sets.isNotEmpty ? sets.last.reps : exercise.reps;

    showDialog(
      context: context,
      builder: (context) => _LogSetDialog(
        exercise: exercise,
        setNumber: setNumber,
        lastWeight: lastWeight,
        lastReps: lastReps,
        onSave: (set) {
          setState(() {
            if (!loggedSets.containsKey(exercise.id)) {
              loggedSets[exercise.id] = [];
            }
            loggedSets[exercise.id]!.add(set);
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Set $setNumber logged! 💪'),
              backgroundColor: const Color(0xFFB4F04D),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showWorkoutHistory() {
    // TODO: Implement workout history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Workout history coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _finishWorkout() {
    if (loggedSets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log at least one set before finishing!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final avgRPE = _calculateAverageRPE();
    final duration = DateTime.now().difference(workoutStartTime!);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Workout Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${duration.inMinutes} minutes'),
            Text(
                'Sets Logged: ${loggedSets.values.fold(0, (sum, sets) => sum + sets.length)}'),
            Text('Average RPE: ${avgRPE.toStringAsFixed(1)}'),
            const SizedBox(height: 16),
            Text(
              _getFeedbackMessage(avgRPE),
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
            child: const Text('Keep Logging'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save workout session
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to week dashboard
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB4F04D),
              foregroundColor: Colors.black,
            ),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  String _getFeedbackMessage(double avgRPE) {
    if (avgRPE >= 9.0) {
      return 'Intense session! Make sure to prioritize recovery.';
    } else if (avgRPE >= 7.5) {
      return 'Great work! Right in the sweet spot.';
    } else if (avgRPE >= 6.0) {
      return 'Good session. Consider increasing intensity next time.';
    } else {
      return 'Light day. Perfect for technique work!';
    }
  }
}

// ============================================
// LOG SET DIALOG
// ============================================

class _LogSetDialog extends StatefulWidget {
  final Exercise exercise;
  final int setNumber;
  final double? lastWeight;
  final int? lastReps;
  final Function(LoggedSet) onSave;

  const _LogSetDialog({
    required this.exercise,
    required this.setNumber,
    this.lastWeight,
    this.lastReps,
    required this.onSave,
  });

  @override
  State<_LogSetDialog> createState() => _LogSetDialogState();
}

class _LogSetDialogState extends State<_LogSetDialog> {
  late TextEditingController weightController;
  late TextEditingController repsController;
  double rpe = 7.5;
  String weightUnit = 'kg';

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController(
      text: widget.lastWeight?.toString() ?? '',
    );
    repsController = TextEditingController(
      text: widget.lastReps?.toString() ?? widget.exercise.reps.toString(),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rpeColor = Color(RPEThresholds.getRPEColor(rpe).value);

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text('Set ${widget.setNumber} - ${widget.exercise.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Weight',
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
                      labelText: 'Reps',
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
              'RPE: ${rpe.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: rpeColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              RPEThresholds.getRPEDescription(rpe),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            Slider(
              value: rpe,
              min: 1.0,
              max: 10.0,
              divisions: 18,
              activeColor: rpeColor,
              inactiveColor: Colors.white.withOpacity(0.1),
              onChanged: (value) => setState(() => rpe = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveSet,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB4F04D),
            foregroundColor: Colors.black,
          ),
          child: const Text('Save Set'),
        ),
      ],
    );
  }

  void _saveSet() {
    final weight = double.tryParse(weightController.text);
    final reps = int.tryParse(repsController.text);

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid weight'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (reps == null || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid reps'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final set = LoggedSet.create(
      workoutSessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
      exerciseId: widget.exercise.id,
      exerciseName: widget.exercise.name,
      setNumber: widget.setNumber,
      weight: weight,
      weightUnit: weightUnit,
      reps: reps,
      rpe: rpe,
      targetRPE: widget.exercise.targetRPEMid,
    );

    widget.onSave(set);
    Navigator.pop(context);
  }
}
