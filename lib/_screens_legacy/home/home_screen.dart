// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'widgets/today_workout_card.dart';
import 'widgets/quick_stats_card.dart';
import 'widgets/recent_workouts_list.dart';
import 'widgets/quick_access_card.dart';

/// Home Screen - Main dashboard showing today's workout and quick stats
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String? _activeProgramId;
  Map<String, dynamic>? _todayWorkout;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // TODO: Load from repository
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for now
    setState(() {
      _activeProgramId = 'pl_beginner_lp';
      _todayWorkout = {
        'name': 'Squat & Bench Day',
        'exercises': 3,
        'estimatedTime': 60,
        'dayNumber': DateTime.now().weekday,
      };
      _stats = {
        'currentStreak': 5,
        'totalWorkouts': 24,
        'weekProgress': 3,
        'weekTotal': 4,
      };
      _isLoading = false;
    });
  }

  Future<void> _handleRefresh() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                color: Theme.of(context).colorScheme.primary,
                child: CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _getMotivationalText(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            // TODO: Navigate to notifications
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                        ),
                      ],
                    ),

                    // Quick Stats
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: QuickStatsCard(
                          currentStreak: _stats?['currentStreak'] ?? 0,
                          totalWorkouts: _stats?['totalWorkouts'] ?? 0,
                          weekProgress: _stats?['weekProgress'] ?? 0,
                          weekTotal: _stats?['weekTotal'] ?? 0,
                        ),
                      ),
                    ),

                    // Today's Workout
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Workout',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TodayWorkoutCard(
                              workoutName: _todayWorkout?['name'] ?? 'Rest Day',
                              exerciseCount: _todayWorkout?['exercises'] ?? 0,
                              estimatedTime:
                                  _todayWorkout?['estimatedTime'] ?? 0,
                              isRestDay: _todayWorkout == null,
                              onStart: _handleStartWorkout,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Quick Access
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Access',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: QuickAccessCard(
                                    icon: Icons.calendar_today,
                                    label: 'This Week',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/week-dashboard');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: QuickAccessCard(
                                    icon: Icons.video_library,
                                    label: 'Form Check',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/form-check');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Recent Workouts
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Workouts',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/history');
                                  },
                                  child: const Text('See All'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const RecentWorkoutsList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getMotivationalText() {
    final dayOfWeek = DateTime.now().weekday;
    if (_todayWorkout == null) {
      return 'Rest day - recovery is progress 💪';
    }
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Let\'s crush this week! 🔥';
      case DateTime.friday:
        return 'Finish the week strong! 💯';
      case DateTime.saturday:
      case DateTime.sunday:
        return 'Weekend gains! 💪';
      default:
        return 'Keep pushing forward! 🚀';
    }
  }

  void _handleStartWorkout() {
    if (_todayWorkout == null) return;

    // Navigate to workout logger
    Navigator.pushNamed(
      context,
      '/workout-logger',
      arguments: {
        'programId': _activeProgramId,
        'dayNumber': _todayWorkout!['dayNumber'],
      },
    );
  }
}
