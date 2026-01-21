import 'package:flutter/material.dart';
import '../../core/enums/sport.dart';

/// Sport Selection Screen - Choose primary training focus
/// Allows user to select their main sport/training type
class SportSelectionScreen extends StatelessWidget {
  const SportSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Choose Your Sport',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Select your primary training focus',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 32),

              // Sport Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildSportCard(
                      context,
                      Sport.powerlifting,
                      Icons.fitness_center,
                      'Powerlifting',
                      'Squat, Bench, Deadlift',
                      const Color(0xFFFF6B6B),
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.bodybuilding,
                      Icons.self_improvement,
                      'Bodybuilding',
                      'Muscle & Aesthetics',
                      const Color(0xFF4ECDC4),
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.olympicLifting,
                      Icons.bolt,
                      'Olympic Lifting',
                      'Snatch & Clean & Jerk',
                      const Color(0xFFFFD93D),
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.crossfit,
                      Icons.directions_run,
                      'CrossFit',
                      'Functional Fitness',
                      const Color(0xFFB4F04D),
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.generalFitness,
                      Icons.favorite,
                      'General Fitness',
                      'Health & Wellness',
                      const Color(0xFF95E1D3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportCard(
    BuildContext context,
    Sport sport,
    IconData icon,
    String title,
    String subtitle,
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/goal-setup',
              arguments: sport,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
