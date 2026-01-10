// lib/features/programs/widgets/exercise_picker.dart

import 'package:flutter/material.dart';
import '../../../domain/models/exercise.dart';
import '../../../core/enums/lift_type.dart';

/// Dialog for picking and configuring an exercise
class ExercisePicker extends StatefulWidget {
  final Exercise? initialExercise;

  const ExercisePicker({Key? key, this.initialExercise}) : super(key: key);

  @override
  State<ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<ExercisePicker> {
  late LiftType _selectedLift;
  late String _customName;
  late int _sets;
  late int _reps;
  late bool _isMain;
  late double _targetRPEMin;
  late double _targetRPEMax;
  late int _restSeconds;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialExercise != null) {
      final ex = widget.initialExercise!;
      _selectedLift = ex.liftType;
      _customName = ex.name;
      _sets = ex.sets;
      _reps = ex.reps;
      _isMain = ex.isMain;
      _targetRPEMin = ex.targetRPEMin ?? 7.0;
      _targetRPEMax = ex.targetRPEMax ?? 8.5;
      _restSeconds = ex.restSeconds;
      _nameController.text = ex.name;
    } else {
      _selectedLift = LiftType.squat;
      _customName = '';
      _sets = 3;
      _reps = 8;
      _isMain = false;
      _targetRPEMin = 7.0;
      _targetRPEMax = 8.5;
      _restSeconds = 120;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveExercise() {
    if (_formKey.currentState!.validate()) {
      final name =
          _customName.isNotEmpty ? _customName : _selectedLift.displayName;

      final exercise = _isMain
          ? Exercise.mainLift(
              name: name,
              liftType: _selectedLift,
              sets: _sets,
              reps: _reps,
              targetRPEMin: _targetRPEMin,
              targetRPEMax: _targetRPEMax,
              restSeconds: _restSeconds,
              order: 0,
            )
          : Exercise.accessory(
              name: name,
              liftType: _selectedLift,
              sets: _sets,
              reps: _reps,
              targetRPEMin: _targetRPEMin,
              targetRPEMax: _targetRPEMax,
              restSeconds: _restSeconds,
              order: 0,
            );

      Navigator.pop(context, exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Exercise',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Exercise Type Toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton('Main Lift', true),
                      ),
                      Expanded(
                        child: _buildTypeButton('Accessory', false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Exercise Selection
                DropdownButtonFormField<LiftType>(
                  value: _selectedLift,
                  decoration: InputDecoration(
                    labelText: 'Exercise',
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: const Color(0xFF2A2A2A),
                  items: LiftType.values.map((lift) {
                    return DropdownMenuItem(
                      value: lift,
                      child: Text(
                        lift.displayName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLift = value;
                        if (_customName.isEmpty) {
                          _nameController.text = value.displayName;
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Custom Name
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Custom Name (Optional)',
                    hintText: _selectedLift.displayName,
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _customName = value),
                ),
                const SizedBox(height: 20),

                // Sets and Reps
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        'Sets',
                        _sets,
                        (value) => setState(() => _sets = value),
                        min: 1,
                        max: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNumberField(
                        'Reps',
                        _reps,
                        (value) => setState(() => _reps = value),
                        min: 1,
                        max: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // RPE Range
                const Text(
                  'Target RPE Range',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Min: ${_targetRPEMin.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Slider(
                            value: _targetRPEMin,
                            min: 6.0,
                            max: 10.0,
                            divisions: 8,
                            activeColor: const Color(0xFFB4F04D),
                            onChanged: (value) {
                              setState(() {
                                _targetRPEMin = value;
                                if (_targetRPEMin > _targetRPEMax) {
                                  _targetRPEMax = _targetRPEMin;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Max: ${_targetRPEMax.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Slider(
                            value: _targetRPEMax,
                            min: 6.0,
                            max: 10.0,
                            divisions: 8,
                            activeColor: const Color(0xFFB4F04D),
                            onChanged: (value) {
                              setState(() {
                                _targetRPEMax = value;
                                if (_targetRPEMax < _targetRPEMin) {
                                  _targetRPEMin = _targetRPEMax;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Rest Time
                _buildNumberField(
                  'Rest (seconds)',
                  _restSeconds,
                  (value) => setState(() => _restSeconds = value),
                  min: 30,
                  max: 600,
                  step: 30,
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4F04D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.initialExercise != null
                          ? 'Update Exercise'
                          : 'Add Exercise',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool isMain) {
    final isSelected = _isMain == isMain;
    return GestureDetector(
      onTap: () => setState(() => _isMain = isMain),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB4F04D) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.white60,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(
    String label,
    int value,
    Function(int) onChanged, {
    int min = 1,
    int max = 100,
    int step = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white70),
                onPressed: value > min
                    ? () => onChanged((value - step).clamp(min, max))
                    : null,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white70),
                onPressed: value < max
                    ? () => onChanged((value + step).clamp(min, max))
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
