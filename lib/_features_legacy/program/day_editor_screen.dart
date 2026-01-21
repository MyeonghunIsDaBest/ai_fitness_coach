// lib/features/programs/day_editor_screen.dart

import 'package:flutter/material.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/lift_type.dart';
import 'widgets/exercise_picker.dart';

/// Screen for editing a single day's workout
/// Allows adding/removing/reordering exercises
class DayEditorScreen extends StatefulWidget {
  final ProgramWeek week;
  final Function(ProgramWeek) onSave;

  const DayEditorScreen({
    Key? key,
    required this.week,
    required this.onSave,
  }) : super(key: key);

  @override
  State<DayEditorScreen> createState() => _DayEditorScreenState();
}

class _DayEditorScreenState extends State<DayEditorScreen> {
  late List<DailyWorkout> _workouts;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _workouts = List.from(widget.week.dailyWorkouts);
  }

  DailyWorkout get _currentWorkout => _workouts[_selectedDayIndex];

  void _updateCurrentWorkout(DailyWorkout updated) {
    setState(() {
      _workouts[_selectedDayIndex] = updated;
    });
  }

  void _addExercise() async {
    final exercise = await showDialog<Exercise>(
      context: context,
      builder: (context) => const ExercisePicker(),
    );

    if (exercise != null) {
      final updatedExercises = [..._currentWorkout.exercises, exercise];
      _updateCurrentWorkout(
        _currentWorkout.copyWith(exercises: updatedExercises),
      );
    }
  }

  void _removeExercise(int index) {
    final updatedExercises = List<Exercise>.from(_currentWorkout.exercises)
      ..removeAt(index);
    _updateCurrentWorkout(
      _currentWorkout.copyWith(exercises: updatedExercises),
    );
  }

  void _editExercise(int index) async {
    final exercise = await showDialog<Exercise>(
      context: context,
      builder: (context) => ExercisePicker(
        initialExercise: _currentWorkout.exercises[index],
      ),
    );

    if (exercise != null) {
      final updatedExercises = List<Exercise>.from(_currentWorkout.exercises);
      updatedExercises[index] = exercise;
      _updateCurrentWorkout(
        _currentWorkout.copyWith(exercises: updatedExercises),
      );
    }
  }

  void _toggleRestDay(bool isRest) {
    if (isRest) {
      _updateCurrentWorkout(
        DailyWorkout.restDay(
          dayId: _currentWorkout.dayId,
          dayName: _currentWorkout.dayName,
          dayNumber: _currentWorkout.dayNumber,
        ),
      );
    } else {
      _updateCurrentWorkout(
        DailyWorkout.trainingDay(
          dayId: _currentWorkout.dayId,
          dayName: _currentWorkout.dayName,
          dayNumber: _currentWorkout.dayNumber,
          focus: 'Training Day',
          exercises: [],
        ),
      );
    }
  }

  void _saveDays() {
    final updatedWeek = widget.week.copyWith(dailyWorkouts: _workouts);
    widget.onSave(updatedWeek);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('Edit Week ${widget.week.weekNumber}'),
        actions: [
          TextButton(
            onPressed: _saveDays,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFB4F04D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(
            child: _currentWorkout.isRestDay
                ? _buildRestDayView()
                : _buildTrainingDayView(),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          final isSelected = index == _selectedDayIndex;

          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB4F04D)
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: workout.isRestDay
                    ? Border.all(color: const Color(0xFF4ECDC4), width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    workout.dayName.substring(0, 3),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    workout.isRestDay ? Icons.spa : Icons.fitness_center,
                    size: 20,
                    color: isSelected
                        ? Colors.black
                        : (workout.isRestDay
                            ? const Color(0xFF4ECDC4)
                            : Colors.white60),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestDayView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa,
            size: 80,
            color: const Color(0xFF4ECDC4).withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Rest Day',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Recovery is essential for progress',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _toggleRestDay(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB4F04D),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Convert to Training Day'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingDayView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutFocusField(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton.icon(
                onPressed: () => _toggleRestDay(true),
                icon: const Icon(Icons.spa, size: 16),
                label: const Text('Make Rest Day'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF4ECDC4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_currentWorkout.exercises.isEmpty)
            _buildEmptyState()
          else
            ..._currentWorkout.exercises.asMap().entries.map((entry) {
              return _buildExerciseCard(entry.key, entry.value);
            }),
          const SizedBox(height: 16),
          _buildAddExerciseButton(),
        ],
      ),
    );
  }

  Widget _buildWorkoutFocusField() {
    return TextField(
      controller: TextEditingController(text: _currentWorkout.focus),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Workout Focus',
        hintText: 'e.g., Upper Power, Lower Hypertrophy',
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        _updateCurrentWorkout(_currentWorkout.copyWith(focus: value));
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.fitness_center,
            size: 48,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No exercises added',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first exercise',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(int index, Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: exercise.isMain
              ? const Color(0xFFB4F04D).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: exercise.isMain
                ? const Color(0xFFB4F04D).withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.fitness_center,
            color: exercise.isMain ? const Color(0xFFB4F04D) : Colors.white60,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            if (exercise.isMain)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4F04D),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'MAIN',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            Expanded(
              child: Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${exercise.sets} sets × ${exercise.reps} reps ${exercise.intensityDisplay != null ? "• ${exercise.intensityDisplay}" : ""}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => _editExercise(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeExercise(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddExerciseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _addExercise,
        icon: const Icon(Icons.add),
        label: const Text('Add Exercise'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: const Color(0xFFB4F04D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFB4F04D)),
          ),
        ),
      ),
    );
  }
}
