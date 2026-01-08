// lib/features/programs/custom_program_screen.dart

import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../programs/day_editor_screen.dart';

/// Screen for creating custom workout programs
/// Allows users to:
/// - Create quick programs (1 day, 4 weeks, 12 weeks)
/// - Build fully custom programs
/// - Import coach's programs
class CustomProgramScreen extends StatefulWidget {
  const CustomProgramScreen({Key? key}) : super(key: key);

  @override
  State<CustomProgramScreen> createState() => _CustomProgramScreenState();
}

class _CustomProgramScreenState extends State<CustomProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Sport _selectedSport = Sport.powerlifting;
  int _weekCount = 4;
  List<ProgramWeek> _weeks = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Create Custom Program'),
        actions: [
          TextButton.icon(
            onPressed: _saveProgram,
            icon: const Icon(Icons.save, color: Color(0xFFB4F04D)),
            label: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFB4F04D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickTemplates(),
              const SizedBox(height: 24),
              _buildProgramInfo(),
              const SizedBox(height: 24),
              _buildWeekBuilder(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a program from a template',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickTemplateCard(
                'Today\'s Workout',
                '1 Day',
                Icons.today,
                () => _createQuickProgram(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickTemplateCard(
                'Monthly Plan',
                '4 Weeks',
                Icons.calendar_view_month,
                () => _createQuickProgram(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickTemplateCard(
                'Full Block',
                '12 Weeks',
                Icons.calendar_month,
                () => _createQuickProgram(12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickTemplateCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFB4F04D).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB4F04D), size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Program Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        // Program Name
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Program Name',
            hintText: 'My Custom Program',
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a program name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        // Description
        TextFormField(
          controller: _descriptionController,
          style: const TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Describe your program...',
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Sport Selection
        DropdownButtonFormField<Sport>(
          value: _selectedSport,
          dropdownColor: const Color(0xFF1E1E1E),
          decoration: InputDecoration(
            labelText: 'Sport / Focus',
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: Sport.values.map((sport) {
            return DropdownMenuItem(
              value: sport,
              child: Text(
                sport.displayName,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedSport = value);
            }
          },
        ),
        const SizedBox(height: 16),
        // Week Count Slider
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Program Duration',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '$_weekCount ${_weekCount == 1 ? 'Week' : 'Weeks'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB4F04D),
                  ),
                ),
              ],
            ),
            Slider(
              value: _weekCount.toDouble(),
              min: 1,
              max: 52,
              divisions: 51,
              activeColor: const Color(0xFFB4F04D),
              inactiveColor: Colors.white.withOpacity(0.2),
              onChanged: (value) {
                setState(() => _weekCount = value.toInt());
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weekly Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (_weeks.isNotEmpty)
              Text(
                '${_weeks.length} ${_weeks.length == 1 ? 'week' : 'weeks'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_weeks.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No weeks added yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use Quick Start or build week by week',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ..._weeks.asMap().entries.map((entry) {
            return _buildWeekCard(entry.key + 1, entry.value);
          }),
      ],
    );
  }

  Widget _buildWeekCard(int weekNumber, ProgramWeek week) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4F04D).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Week $weekNumber',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB4F04D),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white70),
                onPressed: () => _editWeek(weekNumber - 1),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteWeek(weekNumber - 1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${week.trainingDaysCount} training days • ${week.totalSets} sets',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addWeek,
            icon: const Icon(Icons.add),
            label: const Text('Add Week'),
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
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveProgram,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB4F04D),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save Program',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _createQuickProgram(int weeks) {
    setState(() {
      _weekCount = weeks;
      _weeks.clear();

      // Create simple template weeks
      for (int i = 1; i <= weeks; i++) {
        _weeks.add(_createEmptyWeek(i));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Created $weeks-week template. Customize it below!'),
        backgroundColor: const Color(0xFFB4F04D),
      ),
    );
  }

  ProgramWeek _createEmptyWeek(int weekNumber) {
    // Create empty week with 7 days
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.hypertrophy,
      targetRPEMin: 7.0,
      targetRPEMax: 8.5,
      dailyWorkouts: List.generate(7, (dayIndex) {
        final dayNumber = dayIndex + 1;
        if (dayNumber <= 3) {
          return DailyWorkout.trainingDay(
            dayId: _getDayId(dayNumber),
            dayName: _getDayName(dayNumber),
            dayNumber: dayNumber,
            focus: 'Workout ${String.fromCharCode(65 + dayIndex)}',
            exercises: [], // Empty, user will add
          );
        } else {
          return DailyWorkout.restDay(
            dayId: _getDayId(dayNumber),
            dayName: _getDayName(dayNumber),
            dayNumber: dayNumber,
          );
        }
      }),
    );
  }

  String _getDayId(int dayNumber) {
    const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return days[dayNumber - 1];
  }

  String _getDayName(int dayNumber) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[dayNumber - 1];
  }

  void _addWeek() {
    setState(() {
      _weeks.add(_createEmptyWeek(_weeks.length + 1));
    });
  }

  void _editWeek(int index) {
    // Navigate to week editor
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DayEditorScreen(
          week: _weeks[index],
          onSave: (updatedWeek) {
            setState(() {
              _weeks[index] = updatedWeek;
            });
          },
        ),
      ),
    );
  }

  void _deleteWeek(int index) {
    setState(() {
      _weeks.removeAt(index);
      // Renumber remaining weeks
      for (int i = 0; i < _weeks.length; i++) {
        _weeks[i] = _weeks[i].copyWith(weekNumber: i + 1);
      }
    });
  }

  void _saveProgram() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_weeks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one week'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Save to repository
    final program = WorkoutProgram.create(
      name: _nameController.text,
      sport: _selectedSport,
      description: _descriptionController.text.isEmpty
          ? 'Custom program created by user'
          : _descriptionController.text,
      weeks: _weeks,
      isCustom: true,
    );

    // For now, just show success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Program Created!',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Your custom program "${program.name}" has been saved.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, program); // Return program
            },
            child:
                const Text('Done', style: TextStyle(color: Color(0xFFB4F04D))),
          ),
        ],
      ),
    );
  }
}
