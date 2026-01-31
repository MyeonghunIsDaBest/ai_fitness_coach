import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/workout_session.dart';

/// ProgressScreen - Analytics and progress tracking screen (Semi-dark theme)
/// Features:
/// - Summary stats cards with icons
/// - Weekly activity heatmap
/// - Workout consistency chart
/// - Recent PRs
/// - RPE/Training intensity summary
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  String _selectedTimeRange = '4W';

  // Semi-dark theme colors
  static const _backgroundColor = Color(0xFF0F172A);
  static const _cardColor = Color(0xFF1E293B);
  static const _cardColorLight = Color(0xFF334155);
  static const _accentBlue = Color(0xFF3B82F6);
  static const _accentGreen = Color(0xFFB4F04D);
  static const _accentCyan = Color(0xFF00D9FF);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);
  static const _achievementGold = Color(0xFFF59E0B);

  int get _timeRangeDays {
    switch (_selectedTimeRange) {
      case '1W':
        return 7;
      case '4W':
        return 28;
      case '3M':
        return 90;
      case '1Y':
        return 365;
      default:
        return 28;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalWorkoutsAsync = ref.watch(totalWorkoutsProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final workoutHistoryAsync = ref.watch(workoutHistoryProvider(50));
    final completedWorkouts = ref.watch(completedWorkoutsProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(totalWorkoutsProvider);
            ref.invalidate(currentStreakProvider);
            ref.invalidate(workoutHistoryProvider);
          },
          color: _accentGreen,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(
                child: _buildSummaryStats(totalWorkoutsAsync, currentStreakAsync, workoutHistoryAsync),
              ),
              SliverToBoxAdapter(child: _buildWeeklyActivity(completedWorkouts)),
              SliverToBoxAdapter(child: _buildConsistencyChart(workoutHistoryAsync)),
              SliverToBoxAdapter(child: _buildRecentPRs()),
              SliverToBoxAdapter(child: _buildRPESummary(workoutHistoryAsync)),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Progress',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textPrimary),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Row(
              children: ['1W', '4W', '3M', '1Y'].map((range) {
                final isSelected = _selectedTimeRange == range;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTimeRange = range),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? _accentGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      range,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : _textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(
    AsyncValue<int> totalWorkoutsAsync,
    AsyncValue<int> currentStreakAsync,
    AsyncValue<List<WorkoutSession>> workoutHistoryAsync,
  ) {
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    final recentSessions = sessions.where((s) {
      final daysDiff = DateTime.now().difference(s.startTime).inDays;
      return daysDiff <= _timeRangeDays;
    }).toList();

    final totalVolume = recentSessions.fold<double>(0, (sum, session) {
      return sum + session.sets.fold<double>(0, (setSum, set) {
        return setSum + (set.weight * set.reps);
      });
    });

    final avgDuration = recentSessions.isEmpty
        ? 0
        : recentSessions
            .where((s) => s.duration != null)
            .fold<int>(0, (sum, s) => sum + (s.duration?.inMinutes ?? 0)) ~/
            recentSessions.where((s) => s.duration != null).length.clamp(1, 100);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.fitness_center,
                  iconColor: _accentGreen,
                  label: 'Workouts',
                  value: totalWorkoutsAsync.when(
                    data: (count) => count.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_fire_department,
                  iconColor: const Color(0xFFEF4444),
                  label: 'Day Streak',
                  value: currentStreakAsync.when(
                    data: (streak) => streak.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.monitor_weight_outlined,
                  iconColor: _accentBlue,
                  label: 'Volume',
                  value: _formatVolume(totalVolume),
                  unit: 'kg',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.timer_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  label: 'Avg Duration',
                  value: avgDuration.toString(),
                  unit: 'min',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    String? unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textPrimary)),
                    if (unit != null) ...[
                      const SizedBox(width: 4),
                      Text(unit, style: const TextStyle(fontSize: 12, color: _textSecondary)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000) return '${(volume / 1000000).toStringAsFixed(1)}M';
    if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(1)}k';
    return volume.toStringAsFixed(0);
  }

  Widget _buildWeeklyActivity(Set<int> completedWorkouts) {
    final now = DateTime.now();
    final todayWeekday = now.weekday;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This Week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                final dayNum = index + 1;
                final isCompleted = completedWorkouts.contains(dayNum);
                final isToday = dayNum == todayWeekday;
                final isPast = dayNum < todayWeekday;

                return Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? _accentGreen
                            : isToday
                                ? _accentBlue.withOpacity(0.2)
                                : isPast
                                    ? _cardColorLight
                                    : _cardColorLight.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: isToday ? Border.all(color: _accentBlue, width: 2) : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, color: Colors.black, size: 20)
                            : Text(
                                dayNum.toString(),
                                style: TextStyle(
                                  color: isToday ? _textPrimary : _textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isToday ? _textPrimary : _textSecondary,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencyChart(AsyncValue<List<WorkoutSession>> workoutHistoryAsync) {
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    final weeklyCounts = List<int>.filled(12, 0);
    final now = DateTime.now();

    for (final session in sessions) {
      final weeksDiff = now.difference(session.startTime).inDays ~/ 7;
      if (weeksDiff >= 0 && weeksDiff < 12) {
        weeklyCounts[11 - weeksDiff]++;
      }
    }

    final maxCount = weeklyCounts.reduce((a, b) => a > b ? a : b).clamp(1, 7);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Workout Consistency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary)),
              Text('Last 12 weeks', style: TextStyle(fontSize: 13, color: _textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 140,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(12, (index) {
                final count = weeklyCounts[index];
                final height = count > 0 ? (count / maxCount) * 90 : 10.0;
                final isCurrentWeek = index == 11;

                return Tooltip(
                  message: '$count workouts',
                  child: Container(
                    width: 22,
                    height: height,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? isCurrentWeek
                              ? _accentGreen
                              : _accentBlue
                          : _cardColorLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPRs() {
    final prs = [
      _PRData('Bench Press', '120 kg', 'Dec 20'),
      _PRData('Squat', '180 kg', 'Dec 18'),
      _PRData('Deadlift', '200 kg', 'Dec 15'),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent PRs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary)),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: _accentGreen)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...prs.map((pr) => Container(
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _achievementGold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.emoji_events, color: _achievementGold, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pr.exercise, style: const TextStyle(fontWeight: FontWeight.bold, color: _textPrimary, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(pr.date, style: const TextStyle(fontSize: 12, color: _textSecondary)),
                        ],
                      ),
                    ),
                    Text(pr.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _accentGreen)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRPESummary(AsyncValue<List<WorkoutSession>> workoutHistoryAsync) {
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    double totalRPE = 0;
    int rpeCount = 0;

    for (final session in sessions) {
      for (final set in session.sets) {
        if (set.rpe > 0) {
          totalRPE += set.rpe;
          rpeCount++;
        }
      }
    }

    final avgRPE = rpeCount > 0 ? totalRPE / rpeCount : 0.0;

    String rpeDescription;
    Color rpeColor;
    if (avgRPE < 6) {
      rpeDescription = 'Too Easy - Consider increasing intensity';
      rpeColor = _accentCyan;
    } else if (avgRPE < 7.5) {
      rpeDescription = 'Moderate - Good for building volume';
      rpeColor = const Color(0xFF10B981);
    } else if (avgRPE < 8.5) {
      rpeDescription = 'Challenging - Great for strength gains';
      rpeColor = _accentGreen;
    } else {
      rpeDescription = 'Very Hard - Consider a deload';
      rpeColor = const Color(0xFFF59E0B);
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Training Intensity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Average RPE', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: rpeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        rpeCount > 0 ? avgRPE.toStringAsFixed(1) : '-',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: rpeColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: avgRPE / 10,
                    backgroundColor: _cardColorLight,
                    valueColor: AlwaysStoppedAnimation<Color>(rpeColor),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: _textSecondary.withOpacity(0.7)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(rpeDescription, style: const TextStyle(fontSize: 13, color: _textSecondary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PRData {
  final String exercise;
  final String value;
  final String date;

  _PRData(this.exercise, this.value, this.date);
}
