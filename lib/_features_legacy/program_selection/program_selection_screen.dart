import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';

/// Program Selection Screen - Choose training program
/// Simplified version with built-in program data
/// TODO: Connect to real program templates when they're created
class ProgramSelectionScreen extends StatefulWidget {
  final Sport? sport;

  const ProgramSelectionScreen({
    super.key,
    this.sport,
  });

  @override
  State<ProgramSelectionScreen> createState() => _ProgramSelectionScreenState();
}

class _ProgramSelectionScreenState extends State<ProgramSelectionScreen> {
  int? _selectedProgramIndex;

  @override
  Widget build(BuildContext context) {
    // Get programs based on sport
    final programs = _getProgramsForSport(widget.sport);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Your Program',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Programs List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: programs.length,
              itemBuilder: (context, index) {
                final program = programs[index];
                final isSelected = _selectedProgramIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildProgramCard(
                    context,
                    program,
                    isSelected,
                    () {
                      setState(() {
                        _selectedProgramIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Start Button
          if (_selectedProgramIndex != null)
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedProgram = programs[_selectedProgramIndex!];
                      // TODO: Pass selected program data to main app
                      Navigator.pushReplacementNamed(
                        context,
                        '/main',
                        arguments: selectedProgram,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB4F04D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start This Program',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(
    BuildContext context,
    _ProgramInfo program,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFB4F04D)
              : Colors.white.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: program.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        program.icon,
                        color: program.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Title and Duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${program.weeks} weeks • ${program.sportName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selection Indicator
                    if (isSelected)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFB4F04D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.black,
                        ),
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
                    _buildTag('${program.weeks} weeks', Icons.calendar_today),
                    _buildTag(program.level, Icons.trending_up),
                    _buildTag('RPE-Based', Icons.favorite),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFFB4F04D),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // PROGRAM DATA
  // ============================================================================

  List<_ProgramInfo> _getProgramsForSport(Sport? sport) {
    switch (sport) {
      case Sport.powerlifting:
        return [
          _ProgramInfo(
            id: 'pl_beginner',
            name: 'Beginner Linear Progression',
            description:
                'Perfect for beginners. Classic 3x per week full-body program focused on the main lifts with progressive overload.',
            weeks: 12,
            sportName: 'Powerlifting',
            level: 'Beginner',
            icon: Icons.trending_up,
            color: const Color(0xFFFF6B6B),
          ),
          _ProgramInfo(
            id: 'pl_intermediate',
            name: 'Intermediate Block Periodization',
            description:
                '16-week program with accumulation, intensification, and peaking phases. Ideal for those with 1-2 years of experience.',
            weeks: 16,
            sportName: 'Powerlifting',
            level: 'Intermediate',
            icon: Icons.analytics,
            color: const Color(0xFFFF6B6B),
          ),
          _ProgramInfo(
            id: 'pl_advanced',
            name: 'Advanced DUP',
            description:
                'Daily Undulating Periodization for advanced lifters. Varies intensity and volume day-to-day for maximum gains.',
            weeks: 12,
            sportName: 'Powerlifting',
            level: 'Advanced',
            icon: Icons.speed,
            color: const Color(0xFFFF6B6B),
          ),
        ];

      case Sport.bodybuilding:
        return [
          _ProgramInfo(
            id: 'bb_ppl',
            name: 'Push Pull Legs Split',
            description:
                'Classic 6-day split focusing on volume and muscle hypertrophy. Perfect for building mass and aesthetics.',
            weeks: 12,
            sportName: 'Bodybuilding',
            level: 'Intermediate',
            icon: Icons.fitness_center,
            color: const Color(0xFF4ECDC4),
          ),
          _ProgramInfo(
            id: 'bb_upper_lower',
            name: 'Upper Lower Split',
            description:
                '4-day split alternating upper and lower body. Great for balanced development and recovery.',
            weeks: 10,
            sportName: 'Bodybuilding',
            level: 'Beginner',
            icon: Icons.assessment,
            color: const Color(0xFF4ECDC4),
          ),
        ];

      case Sport.olympicLifting:
        return [
          _ProgramInfo(
            id: 'ol_beginner',
            name: 'Olympic Lifting Fundamentals',
            description:
                'Learn the snatch and clean & jerk with proper technique. Focus on movement quality and strength building.',
            weeks: 8,
            sportName: 'Olympic Lifting',
            level: 'Beginner',
            icon: Icons.bolt,
            color: const Color(0xFFFFD93D),
          ),
          _ProgramInfo(
            id: 'ol_competition',
            name: 'Competition Prep Program',
            description:
                'Advanced program preparing for competition. Includes specificity work and peaking strategy.',
            weeks: 12,
            sportName: 'Olympic Lifting',
            level: 'Advanced',
            icon: Icons.emoji_events,
            color: const Color(0xFFFFD93D),
          ),
        ];

      case Sport.crossfit:
        return [
          _ProgramInfo(
            id: 'cf_essentials',
            name: 'CrossFit Essentials',
            description:
                'Build your foundation with varied functional movements. Focus on cardio, strength, and gymnastics.',
            weeks: 8,
            sportName: 'CrossFit',
            level: 'Beginner',
            icon: Icons.directions_run,
            color: const Color(0xFFB4F04D),
          ),
          _ProgramInfo(
            id: 'cf_competition',
            name: 'Competition Ready',
            description:
                'High-intensity program for competitive CrossFit athletes. Includes benchmark WODs and skill work.',
            weeks: 12,
            sportName: 'CrossFit',
            level: 'Advanced',
            icon: Icons.whatshot,
            color: const Color(0xFFB4F04D),
          ),
        ];

      case Sport.generalFitness:
      default:
        return [
          _ProgramInfo(
            id: 'gf_general',
            name: 'General Fitness Program',
            description:
                'Well-rounded program focusing on overall health, strength, and conditioning. Perfect for general wellness.',
            weeks: 10,
            sportName: 'General Fitness',
            level: 'All Levels',
            icon: Icons.favorite,
            color: const Color(0xFF95E1D3),
          ),
          _ProgramInfo(
            id: 'gf_strength',
            name: 'Strength & Conditioning',
            description:
                'Balanced approach to building strength and cardiovascular fitness. Great for athletes in any sport.',
            weeks: 12,
            sportName: 'General Fitness',
            level: 'Intermediate',
            icon: Icons.fitness_center,
            color: const Color(0xFF95E1D3),
          ),
        ];
    }
  }
}

// ============================================================================
// HELPER CLASS
// ============================================================================

/// Program information for display
/// TODO: Replace with actual TrainingProgram model when templates are created
class _ProgramInfo {
  final String id;
  final String name;
  final String description;
  final int weeks;
  final String sportName;
  final String level;
  final IconData icon;
  final Color color;

  _ProgramInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.weeks,
    required this.sportName,
    required this.level,
    required this.icon,
    required this.color,
  });
}
