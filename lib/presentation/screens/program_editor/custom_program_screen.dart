import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums/phase.dart';
import '../../../core/enums/sport.dart';
import '../../../domain/models/workout_program.dart';
import '../../../domain/models/program_week.dart';
import '../../../domain/models/daily_workout.dart';

// Semi-dark theme colors
const _backgroundColor = Color(0xFF0F172A);
const _cardColor = Color(0xFF1E293B);
const _cardBorder = Color(0xFF334155);
const _accentBlue = Color(0xFF3B82F6);
const _accentGreen = Color(0xFFB4F04D);
const _textPrimary = Color(0xFFE2E8F0);
const _textSecondary = Color(0xFF94A3B8);

/// CustomProgramScreen - Create and edit custom workout programs
class CustomProgramScreen extends ConsumerStatefulWidget {
  const CustomProgramScreen({super.key});

  @override
  ConsumerState<CustomProgramScreen> createState() => _CustomProgramScreenState();
}

class _CustomProgramScreenState extends ConsumerState<CustomProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Sport _selectedSport = Sport.powerlifting;
  int _weekCount = 4;
  final List<ProgramWeek> _weeks = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Create Program',
          style: textTheme.titleLarge?.copyWith(
            color: _textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: _textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveProgram,
            icon: const Icon(Icons.check, color: _accentGreen),
            label: const Text(
              'Save',
              style: TextStyle(
                color: _accentGreen,
                fontWeight: FontWeight.w600,
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
              _buildQuickTemplates(textTheme),
              const SizedBox(height: 24),
              _buildProgramInfo(textTheme),
              const SizedBox(height: 24),
              _buildWeekBuilder(textTheme),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTemplates(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Start',
          style: textTheme.titleMedium?.copyWith(
            color: _textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a program from a template',
          style: textTheme.bodySmall?.copyWith(color: _textSecondary),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickTemplateCard(
                title: "Today's Workout",
                subtitle: '1 Day',
                icon: Icons.today,
                onTap: () => _createQuickProgram(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickTemplateCard(
                title: 'Monthly Plan',
                subtitle: '4 Weeks',
                icon: Icons.calendar_view_month,
                onTap: () => _createQuickProgram(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickTemplateCard(
                title: 'Full Block',
                subtitle: '12 Weeks',
                icon: Icons.calendar_month,
                onTap: () => _createQuickProgram(12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgramInfo(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Program Details',
          style: textTheme.titleMedium?.copyWith(
            color: _textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Program Name
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: _textPrimary),
          decoration: _inputDecoration(
            labelText: 'Program Name',
            hintText: 'My Custom Program',
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
          style: const TextStyle(color: _textPrimary),
          maxLines: 3,
          decoration: _inputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Describe your program...',
          ),
        ),
        const SizedBox(height: 16),

        // Sport Selection
        DropdownButtonFormField<Sport>(
          value: _selectedSport,
          dropdownColor: _cardColor,
          style: const TextStyle(color: _textPrimary),
          decoration: _inputDecoration(labelText: 'Sport / Focus'),
          items: Sport.values.map((sport) {
            return DropdownMenuItem(
              value: sport,
              child: Text(sport.displayName),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Program Duration',
                    style: textTheme.bodyMedium?.copyWith(color: _textSecondary),
                  ),
                  Text(
                    '$_weekCount ${_weekCount == 1 ? 'Week' : 'Weeks'}',
                    style: textTheme.titleMedium?.copyWith(
                      color: _accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: _accentBlue,
                  inactiveTrackColor: _cardBorder,
                  thumbColor: _accentBlue,
                  overlayColor: _accentBlue.withOpacity(0.2),
                ),
                child: Slider(
                  value: _weekCount.toDouble(),
                  min: 1,
                  max: 52,
                  divisions: 51,
                  onChanged: (value) {
                    setState(() => _weekCount = value.toInt());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekBuilder(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Schedule',
              style: textTheme.titleMedium?.copyWith(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_weeks.isNotEmpty)
              Text(
                '${_weeks.length} ${_weeks.length == 1 ? 'week' : 'weeks'}',
                style: textTheme.bodySmall?.copyWith(color: _textSecondary),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_weeks.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: _textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No weeks added yet',
                  style: textTheme.bodyLarge?.copyWith(color: _textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use Quick Start or build week by week',
                  style: textTheme.bodySmall?.copyWith(
                    color: _textSecondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ..._weeks.asMap().entries.map((entry) {
            return _buildWeekCard(entry.key + 1, entry.value, textTheme);
          }),
      ],
    );
  }

  Widget _buildWeekCard(int weekNumber, ProgramWeek week, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_accentBlue, Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Week $weekNumber',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: _textSecondary),
                onPressed: () => _editWeek(weekNumber - 1),
                tooltip: 'Edit week',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                onPressed: () => _deleteWeek(weekNumber - 1),
                tooltip: 'Delete week',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildWeekStat(Icons.fitness_center, '${week.trainingDaysCount} days'),
              const SizedBox(width: 16),
              _buildWeekStat(Icons.format_list_numbered, '${week.totalSets} sets'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: _textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _addWeek,
            icon: const Icon(Icons.add, color: _accentBlue),
            label: const Text(
              'Add Week',
              style: TextStyle(color: _accentBlue, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _accentBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _saveProgram,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentGreen,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Save Program',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    String? labelText,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(color: _textSecondary),
      hintStyle: TextStyle(color: _textSecondary.withOpacity(0.5)),
      filled: true,
      fillColor: _cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accentBlue, width: 2),
      ),
    );
  }

  void _createQuickProgram(int weeks) {
    setState(() {
      _weekCount = weeks;
      _weeks.clear();
      for (int i = 1; i <= weeks; i++) {
        _weeks.add(_createEmptyWeek(i));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Created $weeks-week template. Customize it below!'),
        backgroundColor: _accentGreen,
      ),
    );
  }

  ProgramWeek _createEmptyWeek(int weekNumber) {
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
            exercises: [],
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
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dayNumber - 1];
  }

  void _addWeek() {
    setState(() {
      _weeks.add(_createEmptyWeek(_weeks.length + 1));
    });
  }

  void _editWeek(int index) {
    // TODO: Navigate to week editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Week editor coming soon!'),
        backgroundColor: _cardColor,
      ),
    );
  }

  void _deleteWeek(int index) {
    setState(() {
      _weeks.removeAt(index);
      for (int i = 0; i < _weeks.length; i++) {
        _weeks[i] = _weeks[i].copyWith(weekNumber: i + 1);
      }
    });
  }

  void _saveProgram() {
    if (!_formKey.currentState!.validate()) return;

    if (_weeks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one week'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final program = WorkoutProgram.create(
      name: _nameController.text,
      sport: _selectedSport,
      description: _descriptionController.text.isEmpty
          ? 'Custom program created by user'
          : _descriptionController.text,
      weeks: _weeks,
      isCustom: true,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Program Created!', style: TextStyle(color: _textPrimary)),
        content: Text(
          'Your custom program "${program.name}" has been saved.',
          style: const TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(program);
            },
            child: const Text('Done', style: TextStyle(color: _accentGreen)),
          ),
        ],
      ),
    );
  }
}

class _QuickTemplateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickTemplateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: _accentBlue, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: _textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
