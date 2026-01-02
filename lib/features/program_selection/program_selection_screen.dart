import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/lift_type.dart';
import '../../core/enums/week_type.dart';

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
    // TODO: Replace with actual program service when ready
    // For now, create sample programs
    setState(() {
      availablePrograms = _getSamplePrograms();
    });
  }

  List<WorkoutProgram> _getSamplePrograms() {
    // Sample beginner program
    final beginnerProgram = WorkoutProgram.create(
      name: 'Beginner Linear Progression',
      sport: widget.sport ?? Sport.powerlifting,
      description:
          'Perfect for beginners. Classic 3x per week full-body program focused on the main lifts with progressive overload.',
      weeks: _generateSampleWeeks(12, isDeload: false),
      isCustom: false,
    );

    final intermediateProgram = WorkoutProgram.create(
      name: 'Intermediate Block Periodization',
      sport: widget.sport ?? Sport.powerlifting,
      description:
          '16-week program with accumulation, intensification, and peaking phases. Ideal for those with 1-2 years of experience.',
      weeks: _generateSampleWeeks(16, isDeload: true),
      isCustom: false,
    );

    final advancedProgram = WorkoutProgram.create(
      name: 'Advanced DUP',
      sport: widget.sport ?? Sport.powerlifting,
      description:
          'Daily Undulating Periodization for advanced lifters. Varies intensity and volume day-to-day for maximum gains.',
      weeks: _generateSampleWeeks(12, isDeload: true),
      isCustom: false,
    );

    return [beginnerProgram, intermediateProgram, advancedProgram];
  }

  List<ProgramWeek> _generateSampleWeeks(int weekCount,
      {bool isDeload = false}) {
    final weeks = <ProgramWeek>[];

    for (int i = 1; i <= weekCount; i++) {
      // Every 4th week is a deload if enabled
      final isDeloadWeek = isDeload && i % 4 == 0;

      weeks.add(
        isDeloadWeek
            ? ProgramWeek.deload(
                weekNumber: i,
                phase: Phase.hypertrophy,
                dailyWorkouts: _generateSampleDays(),
                coachNotes: 'Recovery week - focus on technique',
              )
            : ProgramWeek.normal(
                weekNumber: i,
                phase: _getPhaseForWeek(i),
                targetRPEMin: 7.0,
                targetRPEMax: 8.5,
                dailyWorkouts: _generateSampleDays(),
              ),
      );
    }

    return weeks;
  }

  Phase _getPhaseForWeek(int weekNumber) {
    if (weekNumber <= 4) return Phase.hypertrophy;
    if (weekNumber <= 8) return Phase.strength;
    if (weekNumber <= 11) return Phase.power;
    return Phase.peaking;
  }

  List<DailyWorkout> _generateSampleDays() {
    return [
      DailyWorkout.trainingDay(
        dayId: 'mon',
        dayName: 'Monday',
        dayNumber: 1,
        focus: 'Upper Body Power',
        exercises: [
          Exercise.mainLift(
            name: 'Bench Press',
            liftType: LiftType.benchPress,
            sets: 4,
            reps: 5,
            targetRPEMin: 7.5,
            targetRPEMax: 8.5,
            order: 0,
          ),
          Exercise.accessory(
            name: 'Bent Over Row',
            liftType: LiftType.bentOverRow,
            sets: 3,
            reps: 8,
            targetRPEMin: 7.0,
            targetRPEMax: 8.0,
            order: 1,
          ),
        ],
      ),
      DailyWorkout.restDay(
        dayId: 'tue',
        dayName: 'Tuesday',
        dayNumber: 2,
      ),
      DailyWorkout.trainingDay(
        dayId: 'wed',
        dayName: 'Wednesday',
        dayNumber: 3,
        focus: 'Lower Body Power',
        exercises: [
          Exercise.mainLift(
            name: 'Back Squat',
            liftType: LiftType.squat,
            sets: 4,
            reps: 5,
            targetRPEMin: 7.5,
            targetRPEMax: 8.5,
            order: 0,
          ),
        ],
      ),
    ];
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
            // TODO: Save selected program and navigate to week dashboard
            Navigator.pushNamed(
              context,
              '/week-dashboard',
              arguments: selectedProgram,
            );
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
