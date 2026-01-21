// lib/features/program_selection/program_selection_screen.dart

import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';
import '../../core/theme/color_schemes.dart';
import '../../domain/models/workout_program.dart';
import '../../data/templates/powerlifting_templates.dart';
import '../../data/templates/bodybuilding_templates.dart';
import '../../data/templates/crossfit_templates.dart';
import '../../data/templates/general_fitness_templates.dart';

class ProgramSelectionScreen extends StatefulWidget {
  final Sport? sport;

  const ProgramSelectionScreen({Key? key, this.sport}) : super(key: key);

  @override
  State<ProgramSelectionScreen> createState() => _ProgramSelectionScreenState();
}

class _ProgramSelectionScreenState extends State<ProgramSelectionScreen> {
  WorkoutProgram? _selectedProgram;
  List<WorkoutProgram> _availablePrograms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
  }

  Future<void> _loadPrograms() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    // Load programs based on sport
    List<WorkoutProgram> programs = [];

    switch (widget.sport) {
      case Sport.powerlifting:
        programs = PowerliftingTemplates.getAllTemplates();
        break;
      case Sport.bodybuilding:
        programs = BodybuildingTemplates.getAllTemplates();
        break;
      case Sport.crossfit:
        programs = CrossFitTemplates.getAllTemplates();
        break;
      case Sport.generalFitness:
        programs = GeneralFitnessTemplates.getAllTemplates();
        break;
      default:
        programs = GeneralFitnessTemplates.getAllTemplates();
    }

    setState(() {
      _availablePrograms = programs;
      _isLoading = false;
    });
  }

  Future<void> _selectProgram() async {
    if (_selectedProgram == null) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // TODO: Save program to repository
    await Future.delayed(const Duration(seconds: 1));

    // Close loading dialog
    if (mounted) Navigator.pop(context);

    // Navigate to main navigation (home screen)
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/main',
        (route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Select Your Program'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _availablePrograms.length,
                    itemBuilder: (context, index) {
                      final program = _availablePrograms[index];
                      final isSelected = _selectedProgram?.id == program.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildProgramCard(
                          program: program,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedProgram = program;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed:
                          _selectedProgram != null ? _selectProgram : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Start This Program',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProgramCard({
    required WorkoutProgram program,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getProgramColor(program).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getProgramIcon(program),
                    color: _getProgramColor(program),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Title and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${program.duration} weeks • ${program.sport.displayName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              program.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(
                  context,
                  Icons.calendar_today,
                  '${program.duration} weeks',
                ),
                _buildTag(
                  context,
                  Icons.trending_up,
                  _getDifficultyText(program),
                ),
                _buildTag(
                  context,
                  Icons.psychology,
                  'RPE-Based',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgramColor(WorkoutProgram program) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (program.sport) {
      case Sport.powerlifting:
        return colorScheme.sportPowerlifting;
      case Sport.bodybuilding:
        return colorScheme.sportBodybuilding;
      case Sport.crossfit:
        return colorScheme.sportCrossfit;
      case Sport.olympicLifting:
        return colorScheme.sportOlympicLifting;
      case Sport.generalFitness:
        return colorScheme.sportGeneralFitness;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getProgramIcon(WorkoutProgram program) {
    switch (program.sport) {
      case Sport.powerlifting:
        return Icons.fitness_center;
      case Sport.bodybuilding:
        return Icons.self_improvement;
      case Sport.crossfit:
        return Icons.directions_run;
      case Sport.generalFitness:
        return Icons.favorite;
      default:
        return Icons.fitness_center;
    }
  }

  String _getDifficultyText(WorkoutProgram program) {
    if (program.name.toLowerCase().contains('beginner')) {
      return 'Beginner';
    } else if (program.name.toLowerCase().contains('intermediate')) {
      return 'Intermediate';
    } else if (program.name.toLowerCase().contains('advanced')) {
      return 'Advanced';
    }
    return 'All Levels';
  }
}
