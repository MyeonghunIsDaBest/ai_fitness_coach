import 'package:flutter/material.dart';

/// Workout Tracker Screen - Converts WorkoutTracker.tsx
/// Features:
/// - RPE slider control
/// - Exercise cards with sets table
/// - Weight/Reps input fields
/// - Set completion checkmarks
/// - Rest timer
/// - Finish workout button
class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  double _currentRPE = 7.0;
  int? _restTimer;

  // Mock workout data
  final List<_Exercise> _exercises = [
    _Exercise(
      id: '1',
      name: 'Barbell Bench Press',
      targetSets: 4,
      targetReps: '5',
      previousBest: '215 lbs x 5',
      sets: [
        _Set(id: 's1', reps: 5, weight: 185, completed: true, rpe: 6),
        _Set(id: 's2', reps: 5, weight: 205, completed: true, rpe: 7),
        _Set(id: 's3', reps: 5, weight: 225, completed: false),
        _Set(id: 's4', reps: 5, weight: 225, completed: false),
      ],
    ),
    _Exercise(
      id: '2',
      name: 'Incline Dumbbell Press',
      targetSets: 3,
      targetReps: '8-10',
      previousBest: '80 lbs x 10',
      sets: [
        _Set(id: 's5', reps: 10, weight: 75, completed: false),
        _Set(id: 's6', reps: 10, weight: 75, completed: false),
        _Set(id: 's7', reps: 10, weight: 75, completed: false),
      ],
    ),
    _Exercise(
      id: '3',
      name: 'Weighted Dips',
      targetSets: 3,
      targetReps: '8-12',
      previousBest: '+45 lbs x 12',
      sets: [
        _Set(id: 's8', reps: 12, weight: 45, completed: false),
        _Set(id: 's9', reps: 12, weight: 45, completed: false),
        _Set(id: 's10', reps: 12, weight: 45, completed: false),
      ],
    ),
  ];

  int get _completedSets {
    return _exercises.fold(
      0,
      (sum, exercise) => sum + exercise.sets.where((s) => s.completed).length,
    );
  }

  int get _totalSets {
    return _exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upper Body Power',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Powerlifting • Week 4, Day 1',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_completedSets/$_totalSets sets',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // RPE Control Card
          _buildRPEControl(),

          // Rest Timer (if active)
          if (_restTimer != null) _buildRestTimer(),

          // Exercise List
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.only(bottom: 80), // Space for bottom button
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(_exercises[index], index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildRPEControl() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
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
                  color: Colors.white,
                ),
              ),
              Text(
                _currentRPE.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB4F04D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFB4F04D),
              inactiveTrackColor: Colors.grey.shade700,
              thumbColor: const Color(0xFFB4F04D),
              overlayColor: const Color(0xFFB4F04D).withOpacity(0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: _currentRPE,
              min: 1,
              max: 10,
              divisions: 18, // 0.5 increments
              onChanged: (value) {
                setState(() {
                  _currentRPE = value;
                });
              },
            ),
          ),
          Text(
            'Rate of Perceived Exertion (1-10 scale)',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestTimer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3b82f6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3b82f6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.timer, color: Color(0xFF3b82f6)),
              SizedBox(width: 8),
              Text(
                'Rest Timer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            '${_restTimer}s',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3b82f6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(_Exercise exercise, int exerciseIndex) {
    final completedSets = exercise.sets.where((s) => s.completed).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Header
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise.targetSets} sets × ${exercise.targetReps} reps',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$completedSets/${exercise.sets.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // Previous Best
          if (exercise.previousBest != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.trending_up, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Previous: ${exercise.previousBest}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Sets Table
          _buildSetsTable(exercise),
        ],
      ),
    );
  }

  Widget _buildSetsTable(_Exercise exercise) {
    return Column(
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const SizedBox(
                width: 40,
                child: Text(
                  'Set',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.fitness_center, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Weight',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.numbers, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Reps',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Text(
                  'RPE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Set Rows
        ...exercise.sets.asMap().entries.map((entry) {
          final index = entry.key;
          final set = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: set.completed
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Set Number
                SizedBox(
                  width: 40,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Weight Input
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: TextEditingController(text: '${set.weight}'),
                      keyboardType: TextInputType.number,
                      enabled: !set.completed,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Reps Input
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: TextEditingController(text: '${set.reps}'),
                      keyboardType: TextInputType.number,
                      enabled: !set.completed,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // RPE Display
                Expanded(
                  child: Center(
                    child: Text(
                      set.rpe?.toString() ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Checkmark Button
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        set.completed = !set.completed;
                        if (set.completed && set.rpe == null) {
                          set.rpe = _currentRPE;
                        } else if (!set.completed) {
                          set.rpe = null;
                        }
                      });
                    },
                    icon: Icon(
                      Icons.check_circle,
                      color: set.completed ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Save for later
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save for Later'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _finishWorkout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Finish Workout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finishWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Workout?'),
        content: Text('You completed $_completedSets out of $_totalSets sets.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Save workout and navigate back
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}

// Models
class _Exercise {
  final String id;
  final String name;
  final int targetSets;
  final String targetReps;
  final String? previousBest;
  final List<_Set> sets;

  _Exercise({
    required this.id,
    required this.name,
    required this.targetSets,
    required this.targetReps,
    this.previousBest,
    required this.sets,
  });
}

class _Set {
  final String id;
  int reps;
  int weight;
  bool completed;
  double? rpe;

  _Set({
    required this.id,
    required this.reps,
    required this.weight,
    this.completed = false,
    this.rpe,
  });
}
