import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/providers.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/workout_program.dart';

/// MainDashboardScreen - Central hub for the fitness app
/// Features:
/// - Personalized greeting header
/// - Active program summary with current week
/// - Today's workout card with quick start
/// - Weekly progress stats (workouts, volume, RPE)
/// - Quick actions grid
/// - Recent achievements & PRs
/// - Workout history
class MainDashboardScreen extends ConsumerWidget {
  const MainDashboardScreen({super.key});

  // Semi-dark theme colors (consistent with app design)
  static const _backgroundColor = Color(0xFF0F172A);
  static const _cardColor = Color(0xFF1E293B);
  static const _cardColorLight = Color(0xFF334155);
  static const _accentBlue = Color(0xFF3B82F6);
  static const _accentBlueEnd = Color(0xFF2563EB);
  static const _accentGreen = Color(0xFFB4F04D);
  static const _accentCyan = Color(0xFF00D9FF);
  static const _accentPurple = Color(0xFF8B5CF6);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);
  static const _achievementGold = Color(0xFFF59E0B);
  static const _successGreen = Color(0xFF10B981);
  static const _warningRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all providers
    final profileAsync = ref.watch(currentAthleteProfileProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final todayWorkoutAsync = ref.watch(workoutForDayProvider(DateTime.now().weekday));
    final totalWorkoutsAsync = ref.watch(totalWorkoutsProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final workoutHistoryAsync = ref.watch(workoutHistoryProvider(5));
    final currentWeek = ref.watch(currentWeekProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentAthleteProfileProvider);
            ref.invalidate(activeProgramProvider);
            ref.invalidate(totalWorkoutsProvider);
            ref.invalidate(workoutHistoryProvider);
            ref.invalidate(currentStreakProvider);
          },
          color: _accentGreen,
          child: CustomScrollView(
            slivers: [
              // Header with greeting
              SliverToBoxAdapter(
                child: _buildHeader(profileAsync),
              ),

              // Active Program Summary (NEW)
              SliverToBoxAdapter(
                child: _buildProgramSummary(context, activeProgramAsync, currentWeek),
              ),

              // Today's Workout Card
              SliverToBoxAdapter(
                child: _buildTodayWorkoutCard(
                  context,
                  ref,
                  todayWorkoutAsync,
                  activeProgramAsync,
                ),
              ),

              // Weekly Progress Stats
              SliverToBoxAdapter(
                child: _buildWeeklyProgress(
                  totalWorkoutsAsync,
                  currentStreakAsync,
                  workoutHistoryAsync,
                ),
              ),

              // Quick Actions Grid
              SliverToBoxAdapter(
                child: _buildQuickActions(context),
              ),

              // Recent Achievements
              SliverToBoxAdapter(
                child: _buildRecentAchievements(workoutHistoryAsync),
              ),

              // Recent Workouts
              SliverToBoxAdapter(
                child: _buildRecentWorkouts(context, workoutHistoryAsync),
              ),

              // Bottom spacing for FAB
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Personalized greeting header
  Widget _buildHeader(AsyncValue<dynamic> profileAsync) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    if (hour < 12) {
      greeting = 'Good Morning';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_cloudy_outlined;
    } else {
      greeting = 'Good Evening';
      greetingIcon = Icons.nights_stay_outlined;
    }

    final userName = profileAsync.whenOrNull<String?>(
      data: (profile) => profile?.name as String?,
    );

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(greetingIcon, color: _accentGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  userName ?? 'Athlete',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Let's crush today's workout",
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: _textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Active program summary card (NEW)
  Widget _buildProgramSummary(
    BuildContext context,
    AsyncValue<WorkoutProgram?> activeProgramAsync,
    int currentWeek,
  ) {
    return activeProgramAsync.when(
      data: (program) {
        if (program == null) return const SizedBox.shrink();

        final totalWeeks = program.weeks.length;
        final progress = currentWeek / totalWeeks;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _accentPurple.withOpacity(0.3)),
          ),
          child: InkWell(
            onTap: () => context.push('/program/${program.id}'),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accentPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.event_note,
                        color: _accentPurple,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Program',
                            style: TextStyle(
                              fontSize: 11,
                              color: _textSecondary.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            program.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accentGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Week $currentWeek/$totalWeeks',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _accentGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: _cardColorLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(_accentPurple),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}% complete',
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.chevron_right, color: _textSecondary, size: 16),
                        Text(
                          'View Program',
                          style: TextStyle(
                            fontSize: 12,
                            color: _accentPurple.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Today's workout card
  Widget _buildTodayWorkoutCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<DailyWorkout?> todayWorkoutAsync,
    AsyncValue<WorkoutProgram?> activeProgramAsync,
  ) {
    return todayWorkoutAsync.when(
      data: (workout) {
        if (workout == null) {
          return activeProgramAsync.when(
            data: (program) {
              if (program == null) {
                return _buildNoProgramCard(context);
              }
              return _buildRestDayCard();
            },
            loading: () => _buildLoadingCard(),
            error: (_, __) => _buildNoProgramCard(context),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_accentBlue, _accentBlueEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _accentBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fitness_center, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Today's Workout",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      workout.dayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                workout.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  workout.focus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildWorkoutStat(Icons.access_time, '${workout.estimatedDurationMinutes} min'),
                  const SizedBox(width: 24),
                  _buildWorkoutStat(Icons.list_alt_rounded, '${workout.exercises.length} exercises'),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _startWorkout(context, ref, workout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Start Workout',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (_, __) => _buildNoProgramCard(context),
    );
  }

  Widget _buildWorkoutStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNoProgramCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardColorLight.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _accentGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note_outlined,
              size: 40,
              color: _accentGreen,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Program Selected',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a training program to get started\nwith structured workouts',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go('/programs'),
            icon: const Icon(Icons.search),
            label: const Text('Browse Programs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentGreen,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestDayCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardColorLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _accentCyan.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.self_improvement,
              color: _accentCyan,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rest Day',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Recovery is part of the process. Take it easy and let your muscles repair!',
                  style: TextStyle(color: _textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: _accentGreen),
      ),
    );
  }

  /// Weekly progress stats
  Widget _buildWeeklyProgress(
    AsyncValue<int> totalWorkoutsAsync,
    AsyncValue<int> currentStreakAsync,
    AsyncValue<List<dynamic>> workoutHistoryAsync,
  ) {
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    double totalVolume = 0;
    double avgRPE = 0;
    int rpeCount = 0;

    for (final session in sessions) {
      if (session.sets != null) {
        for (final set in session.sets) {
          totalVolume += (set.weight ?? 0) * (set.reps ?? 0);
          if (set.rpe != null && set.rpe > 0) {
            avgRPE += set.rpe;
            rpeCount++;
          }
        }
      }
    }

    if (rpeCount > 0) avgRPE /= rpeCount;

    String formatVolume(double volume) {
      if (volume >= 1000) {
        return '${(volume / 1000).toStringAsFixed(1)}k';
      }
      return '${volume.toStringAsFixed(0)}';
    }

    final workoutCount = totalWorkoutsAsync.valueOrNull ?? 0;
    final streak = currentStreakAsync.valueOrNull ?? 0;
    const workoutGoal = 5;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "This Week's Progress",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _achievementGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: _achievementGold, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$streak day streak',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _achievementGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Workouts',
                  '$workoutCount/$workoutGoal',
                  (workoutCount / workoutGoal).clamp(0.0, 1.0),
                  _accentBlue,
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Volume',
                  '${formatVolume(totalVolume)} lbs',
                  0.65,
                  _accentGreen,
                  Icons.show_chart,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Avg RPE',
                  rpeCount > 0 ? '${avgRPE.toStringAsFixed(1)}/10' : '-',
                  rpeCount > 0 ? (avgRPE / 10).clamp(0.0, 1.0) : 0,
                  _accentCyan,
                  Icons.speed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, double progress, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: _textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _cardColorLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  /// Quick actions grid
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _buildQuickActionButton(
                Icons.analytics_outlined,
                'Analytics',
                _accentBlue,
                () => context.push('/analytics'),
              ),
              _buildQuickActionButton(
                Icons.add_box_outlined,
                'Create Program',
                _warningRed,
                () => context.push('/program-editor'),
              ),
              _buildQuickActionButton(
                Icons.calendar_view_week,
                'Week View',
                _successGreen,
                () => context.push('/week-dashboard'),
              ),
              _buildQuickActionButton(
                Icons.history,
                'History',
                _accentCyan,
                () => context.push('/history'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardColorLight.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Recent achievements (enhanced with actual data)
  Widget _buildRecentAchievements(AsyncValue<List<dynamic>> workoutHistoryAsync) {
    // Build achievements from actual data when available
    final sessions = workoutHistoryAsync.valueOrNull ?? [];

    final achievements = <_Achievement>[];

    // Find highest weight lifts from recent sessions
    for (final session in sessions) {
      if (session.sets != null) {
        for (final set in session.sets) {
          if (set.weight != null && set.weight > 200) {
            achievements.add(_Achievement(
              '${set.exerciseName ?? "Heavy Lift"}',
              '${set.weight.toStringAsFixed(0)} lbs',
              'Recent',
            ));
          }
        }
      }
    }

    // Add default achievements if none found
    if (achievements.isEmpty) {
      achievements.addAll([
        _Achievement('Getting Started', 'Complete your first workout', 'Available'),
        _Achievement('Consistency', 'Log 5 workouts', 'In Progress'),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...achievements.take(2).map((achievement) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _achievementGold.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: _achievementGold,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        achievement.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  achievement.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  /// Recent workouts list
  Widget _buildRecentWorkouts(
    BuildContext context,
    AsyncValue<List<dynamic>> workoutHistoryAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Workouts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/history'),
                child: const Text(
                  'See All',
                  style: TextStyle(color: _accentGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          workoutHistoryAsync.when(
            data: (sessions) {
              if (sessions.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _cardColorLight.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          size: 36,
                          color: _textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No workouts yet',
                          style: TextStyle(color: _textSecondary),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Start your first workout to see history',
                          style: TextStyle(color: _textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: sessions.take(3).map((session) {
                  final duration = session.duration?.inMinutes ?? 0;
                  final setCount = session.sets?.length ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _cardColorLight.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: session.isCompleted
                                ? _successGreen.withOpacity(0.15)
                                : _achievementGold.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            session.isCompleted ? Icons.check : Icons.pause,
                            color: session.isCompleted ? _successGreen : _achievementGold,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.workoutName ?? 'Workout',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: _textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$setCount sets • $duration min',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: _textSecondary,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: _accentGreen),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Start workout action
  void _startWorkout(BuildContext context, WidgetRef ref, DailyWorkout workout) async {
    final program = await ref.read(activeProgramProvider.future);
    if (program == null) return;

    final weekNumber = ref.read(currentWeekProvider);

    try {
      final startSession = ref.read(startWorkoutSessionProvider);
      await startSession(
        programId: program.id,
        weekNumber: weekNumber,
        dayNumber: workout.dayNumber,
        workoutName: workout.name,
      );

      if (context.mounted) {
        context.push('/workout');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting workout: $e'),
            backgroundColor: _warningRed,
          ),
        );
      }
    }
  }
}

/// Achievement model
class _Achievement {
  final String name;
  final String value;
  final String date;

  _Achievement(this.name, this.value, this.date);
}
