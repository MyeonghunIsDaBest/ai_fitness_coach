import 'package:flutter/material.dart';

/// Onboarding Screen - Welcome screen with app features
/// Shows key features and benefits, with option to get started or skip
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Title
              const Text(
                'Welcome to\nFitCoach AI',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              // Subtitle
              Text(
                'Your personalized AI-powered fitness coach. Get customized training programs, track your progress, and achieve your goals.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // Features
              _buildFeature(
                Icons.analytics_outlined,
                'Track RPE & Progress',
                'Monitor your training intensity and performance over time',
              ),
              const SizedBox(height: 20),
              _buildFeature(
                Icons.fitness_center,
                'Custom Training Programs',
                'Get personalized workout plans tailored to your goals',
              ),
              const SizedBox(height: 20),
              _buildFeature(
                Icons.smart_toy_outlined,
                'AI-Powered Coaching',
                'Real-time feedback and intelligent training adjustments',
              ),
              const SizedBox(height: 20),
              _buildFeature(
                Icons.video_library_outlined,
                'Form Check Analysis',
                'Upload videos for expert form analysis and corrections',
              ),

              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/sport-selection');
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
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Skip Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Skip to main app for testing
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                  child: Text(
                    'Skip to Main App',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFB4F04D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFB4F04D),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
