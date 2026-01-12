import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/lift_type.dart';
import '../../data/templates/powerlifting_templates.dart';
import '../../data/templates/bodybuilding_templates.dart';
import '../../data/templates/crossfit_templates.dart';
import '../../data/templates/general_fitness_templates.dart';

/// Program selection screen with animated cards and program templates
class ProgramSelectionScreen extends StatefulWidget {
  final Sport? sport;

  const ProgramSelectionScreen({Key? key, this.sport}) : super(key: key);

  @override
  State<ProgramSelectionScreen> createState() => _ProgramSelectionScreenState();
}

class _ProgramSelectionScreenState extends State<ProgramSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  WorkoutProgram? selectedProgram;
  List<WorkoutProgram> availablePrograms = [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animController.forward();

    // Load programs based on sport
    _loadPrograms();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _loadPrograms() {
    setState(() {
      // Load templates based on selected sport
      switch (widget.sport) {
        case Sport.powerlifting:
          availablePrograms = PowerliftingTemplates.getAllTemplates();
          break;
        case Sport.bodybuilding:
          availablePrograms = BodybuildingTemplates.getAllTemplates();
          break;
        case Sport.crossfit:
          availablePrograms = CrossFitTemplates.getAllTemplates();
          break;
        case Sport.generalFitness:
          availablePrograms = GeneralFitnessTemplates.getAllTemplates();
          break;
        default:
          // If no sport selected, show all
          availablePrograms = [
            ...PowerliftingTemplates.getAllTemplates(),
            ...BodybuildingTemplates.getAllTemplates(),
          ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Select Your Program'),
        elevation: 0,
      ),
      body: SafeArea(
        child: availablePrograms.isEmpty
            ? _buildEmptyState()
            : _buildProgramList(),
      ),
      bottomNavigationBar:
          selectedProgram != null ? _buildContinueButton() : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'No programs available',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Check back soon for new programs!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProgramList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availablePrograms.length,
      itemBuilder: (context, index) {
        return _buildProgramCard(availablePrograms[index], index);
      },
    );
  }

  Widget _buildProgramCard(WorkoutProgram program, int index) {
    final isSelected = selectedProgram?.id == program.id;
    final delay = index * 100;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(
            delay / 1500,
            (delay + 500) / 1500,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(
              delay / 1500,
              (delay + 500) / 1500,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => setState(() => selectedProgram = program),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Color(program.sport.colorValue).withOpacity(0.3),
                        Color(program.sport.colorValue).withOpacity(0.1),
                      ],
                    )
                  : null,
              color: isSelected ? null : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Color(program.sport.colorValue)
                    : Colors.white.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(program.sport.colorValue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${program.totalWeeks} weeks • ${program.sport.displayName}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Color(program.sport.colorValue),
                        size: 28,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  program.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFeatureBadge(
                      Icons.calendar_today,
                      '${program.totalWeeks} weeks',
                      program.sport.colorValue,
                    ),
                    _buildFeatureBadge(
                      Icons.trending_up,
                      'Progressive',
                      program.sport.colorValue,
                    ),
                    _buildFeatureBadge(
                      Icons.psychology,
                      'RPE-Based',
                      program.sport.colorValue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String label, int colorValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(colorValue).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(colorValue).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Color(colorValue)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(colorValue),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            if (selectedProgram != null) {
              // Activate the program
              final activatedProgram = selectedProgram!.activate();

              // TODO: Save to repository
              // For now, just navigate to main navigation

              // Navigate to main navigation (with bottom tabs)
              Navigator.pushReplacementNamed(
                context,
                '/main',
                arguments: {
                  'program': activatedProgram,
                },
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB4F04D),
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
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
    );
  }
}
