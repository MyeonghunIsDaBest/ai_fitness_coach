import 'package:flutter/material.dart';

/// Home Tab - Converts Dashboard.tsx from React
/// Features:
/// - Header with greeting
/// - Today's workout card (gradient blue)
/// - Weekly progress stats
/// - Program selection
/// - Quick actions grid
/// - Recent achievements
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedProgramIndex = 0;

  final List<_ProgramData> _programs = [
    _ProgramData(
      id: 'powerlifting',
      name: 'Powerlifting',
      icon: Icons.fitness_center,
      color:
          const LinearGradient(colors: [Color(0xFFef4444), Color(0xFFf97316)]),
      description: 'Build maximal strength in squat, bench, and deadlift',
    ),
    _ProgramData(
      id: 'bodybuilding',
      name: 'Bodybuilding',
      icon: Icons.fitness_center,
      color:
          const LinearGradient(colors: [Color(0xFF3b82f6), Color(0xFF8b5cf6)]),
      description: 'Hypertrophy-focused training for muscle growth',
    ),
    _ProgramData(
      id: 'crossfit',
      name: 'CrossFit/HYROX',
      icon: Icons.directions_run,
      color:
          const LinearGradient(colors: [Color(0xFF10b981), Color(0xFF14b8a6)]),
      description: 'Functional fitness and conditioning',
    ),
    _ProgramData(
      id: 'weightlifting',
      name: 'Olympic Weightlifting',
      icon: Icons.fitness_center,
      color:
          const LinearGradient(colors: [Color(0xFFf59e0b), Color(0xFFf97316)]),
      description: 'Master snatch and clean & jerk technique',
    ),
    _ProgramData(
      id: 'general',
      name: 'General Fitness',
      icon: Icons.sports_gymnastics,
      color:
          const LinearGradient(colors: [Color(0xFF06b6d4), Color(0xFF3b82f6)]),
      description: 'Balanced strength and conditioning',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // Today's Workout Card
            SliverToBoxAdapter(
              child: _buildTodayWorkoutCard(),
            ),

            // Weekly Progress
            SliverToBoxAdapter(
              child: _buildWeeklyProgress(),
            ),

            // Program Selection Header
            SliverToBoxAdapter(
              child: _buildProgramHeader(),
            ),

            // Program Tabs
            SliverToBoxAdapter(
              child: _buildProgramTabs(),
            ),

            // Selected Program Content
            SliverToBoxAdapter(
              child: _buildProgramContent(),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: _buildQuickActions(),
            ),

            // Recent Achievements
            SliverToBoxAdapter(
              child: _buildAchievements(),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back, Athlete',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Let's crush today's workout",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWorkoutCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3b82f6), Color(0xFF2563eb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fitness_center, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                "Today's Workout",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Upper Body Power',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Powerlifting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              const Text('60 min', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 16),
              const Icon(Icons.list, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              const Text('6 exercises',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to workout tracker
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3b82f6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Workout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "This Week's Progress",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Workouts', '3/5', 60)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Volume', '37.1k lbs', 65)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Avg RPE', '7.5/10', 75)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade800,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFB4F04D)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Choose Your Sport',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file, size: 16),
            label: const Text('Import Guide', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramTabs() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _programs.length,
        itemBuilder: (context, index) {
          final program = _programs[index];
          final isSelected = _selectedProgramIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedProgramIndex = index;
              });
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF1E1E1E) : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFB4F04D) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    program.icon,
                    color: isSelected ? const Color(0xFFB4F04D) : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramContent() {
    final program = _programs[_selectedProgramIndex];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: program.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  program.icon,
                  color: Colors.white,
                  size: 32,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle file upload
              },
              icon: const Icon(Icons.upload),
              label: const Text('Import Your Training Spreadsheet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4F04D),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Upload your program as CSV or Excel file. We\'ll parse your sets, reps, and progression scheme.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildQuickActionButton(
                Icons.trending_up,
                'Progression',
                () {},
              ),
              _buildQuickActionButton(
                Icons.local_fire_department,
                'AI Coach',
                () {},
              ),
              _buildQuickActionButton(
                Icons.center_focus_strong,
                'Form Check',
                () {},
              ),
              _buildQuickActionButton(
                Icons.calendar_today,
                'Start Workout',
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFB4F04D), size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievementCard(
            'Bench Press PR',
            '225 lbs',
            '2 days ago',
          ),
          const SizedBox(height: 12),
          _buildAchievementCard(
            '5-Day Streak',
            'Consistency',
            'Today',
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String name, String value, String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.yellow.shade700.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.yellow.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramData {
  final String id;
  final String name;
  final IconData icon;
  final LinearGradient color;
  final String description;

  _ProgramData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}
