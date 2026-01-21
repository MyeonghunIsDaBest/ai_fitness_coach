import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../domain/models/workout_session.dart';
import '../../widgets/design_system/atoms/atoms.dart';
import '../../widgets/design_system/molecules/molecules.dart';
import '../../widgets/design_system/organisms/organisms.dart';

/// ProgressScreen - Analytics and progress tracking screen
///
/// Displays workout history, volume trends, strength progress,
/// and personal records.
class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '4W';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          // Header
          _buildHeader(colorScheme, textTheme),

          // Tab bar
          _buildTabBar(colorScheme),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(colorScheme, textTheme),
                _buildStrengthTab(colorScheme, textTheme),
                _buildVolumeTab(colorScheme, textTheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Progress',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // Time range selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: ['1W', '4W', '3M', '1Y'].map((range) {
                final isSelected = _selectedTimeRange == range;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTimeRange = range),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      range,
                      style: textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
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

  Widget _buildTabBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Strength'),
          Tab(text: 'Volume'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ColorScheme colorScheme, TextTheme textTheme) {
    // Watch providers
    final totalWorkoutsAsync = ref.watch(totalWorkoutsProvider);
    final currentStreakAsync = ref.watch(currentStreakProvider);
    final workoutHistoryAsync = ref.watch(workoutHistoryProvider(20));
    final completedWorkouts = ref.watch(completedWorkoutsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(totalWorkoutsProvider);
        ref.invalidate(currentStreakProvider);
        ref.invalidate(workoutHistoryProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary stats
            _buildSummaryStats(
              colorScheme,
              textTheme,
              totalWorkoutsAsync,
              currentStreakAsync,
              workoutHistoryAsync,
            ),
            const SizedBox(height: 24),

            // Weekly summary
            SectionHeader(
              title: 'This Week',
              subtitle: _getWeekDateRange(),
            ),
            const SizedBox(height: 12),
            _buildWeeklySummary(
              colorScheme,
              textTheme,
              completedWorkouts,
              workoutHistoryAsync,
            ),
            const SizedBox(height: 24),

            // Recent PRs
            SectionHeader(
              title: 'Recent PRs',
              action: TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ),
            const SizedBox(height: 12),
            _buildRecentPRs(colorScheme, textTheme),
            const SizedBox(height: 24),

            // Workout consistency
            SectionHeader(title: 'Workout Consistency'),
            const SizedBox(height: 12),
            _buildConsistencyChart(colorScheme, textTheme, workoutHistoryAsync),
          ],
        ),
      ),
    );
  }

  String _getWeekDateRange() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[monday.month - 1]} ${monday.day} - ${months[sunday.month - 1]} ${sunday.day}';
  }

  Widget _buildSummaryStats(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<int> totalWorkoutsAsync,
    AsyncValue<int> currentStreakAsync,
    AsyncValue<List<WorkoutSession>> workoutHistoryAsync,
  ) {
    // Calculate stats from history
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatDisplay(
                  label: 'Workouts',
                  value: totalWorkoutsAsync.when(
                    data: (count) => count.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  icon: Icons.fitness_center,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: StatDisplay(
                  label: 'Total Volume',
                  value: _formatVolume(totalVolume),
                  unit: 'kg',
                  icon: Icons.monitor_weight_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatDisplay(
                  label: 'Avg Duration',
                  value: avgDuration.toString(),
                  unit: 'min',
                  icon: Icons.timer_outlined,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: StatDisplay(
                  label: 'Current Streak',
                  value: currentStreakAsync.when(
                    data: (streak) => streak.toString(),
                    loading: () => '-',
                    error: (_, __) => '0',
                  ),
                  unit: 'days',
                  icon: Icons.local_fire_department,
                  iconColor: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}k';
    }
    return volume.toStringAsFixed(0);
  }

  Widget _buildWeeklySummary(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Set<int> completedWorkouts,
    AsyncValue<List<WorkoutSession>> workoutHistoryAsync,
  ) {
    final now = DateTime.now();
    final todayWeekday = now.weekday;

    // Calculate this week's stats from history
    final sessions = workoutHistoryAsync.valueOrNull ?? [];
    final thisWeekSessions = sessions.where((s) {
      final sessionDate = s.startTime;
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      return sessionDate.isAfter(monday.subtract(const Duration(days: 1))) &&
          sessionDate.isBefore(sunday.add(const Duration(days: 1)));
    }).toList();

    final weekVolume = thisWeekSessions.fold<double>(0, (sum, session) {
      return sum + session.sets.fold<double>(0, (setSum, set) {
        return setSum + (set.weight * set.reps);
      });
    });

    final weekTime = thisWeekSessions
        .where((s) => s.duration != null)
        .fold<int>(0, (sum, s) => sum + (s.duration?.inMinutes ?? 0));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Days completed visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final dayNum = index + 1; // Monday = 1
              final isCompleted = completedWorkouts.contains(dayNum);
              final isToday = dayNum == todayWeekday;
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? colorScheme.success
                          : isToday
                              ? colorScheme.primary.withOpacity(0.2)
                              : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(color: colorScheme.primary, width: 2)
                          : null,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickStat(
                label: 'Completed',
                value: '${thisWeekSessions.length}',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _QuickStat(
                label: 'Volume',
                value: '${_formatVolume(weekVolume)} kg',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _QuickStat(
                label: 'Time',
                value: '${weekTime ~/ 60}h ${weekTime % 60}m',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPRs(ColorScheme colorScheme, TextTheme textTheme) {
    // TODO: Connect to actual PR tracking when implemented
    final prs = [
      _PRItem(exercise: 'Bench Press', value: '120 kg', date: 'Dec 20'),
      _PRItem(exercise: 'Squat', value: '180 kg', date: 'Dec 18'),
      _PRItem(exercise: 'Deadlift', value: '200 kg', date: 'Dec 15'),
    ];

    return Column(
      children: prs.map((pr) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pr.exercise,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      pr.date,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                pr.value,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConsistencyChart(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AsyncValue<List<WorkoutSession>> workoutHistoryAsync,
  ) {
    final sessions = workoutHistoryAsync.valueOrNull ?? [];

    // Group sessions by week for the last 12 weeks
    final weeklyCounts = List<int>.filled(12, 0);
    final now = DateTime.now();

    for (final session in sessions) {
      final weeksDiff = now.difference(session.startTime).inDays ~/ 7;
      if (weeksDiff >= 0 && weeksDiff < 12) {
        weeklyCounts[11 - weeksDiff]++;
      }
    }

    final maxCount = weeklyCounts.reduce((a, b) => a > b ? a : b).clamp(1, 7);

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(12, (index) {
          final count = weeklyCounts[index];
          final height = count > 0 ? (count / maxCount) * 80 : 8.0;
          return Tooltip(
            message: '$count workouts',
            child: Container(
              width: 20,
              height: height,
              decoration: BoxDecoration(
                color: count > 0
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStrengthTab(ColorScheme colorScheme, TextTheme textTheme) {
    // TODO: Connect to actual strength tracking
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main lifts summary
          SectionHeader(title: 'Main Lifts'),
          const SizedBox(height: 12),
          ...[
            _LiftProgress(
              name: 'Squat',
              current: 180,
              previous: 170,
              unit: 'kg',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            _LiftProgress(
              name: 'Bench Press',
              current: 120,
              previous: 115,
              unit: 'kg',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            _LiftProgress(
              name: 'Deadlift',
              current: 200,
              previous: 190,
              unit: 'kg',
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
          const SizedBox(height: 24),

          // Estimated 1RM
          SectionHeader(title: 'Estimated 1RM'),
          const SizedBox(height: 12),
          InfoCard.tip(
            title: 'Based on recent performance',
            message:
                'These estimates are calculated from your top sets using the Epley formula.',
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeTab(ColorScheme colorScheme, TextTheme textTheme) {
    // TODO: Connect to actual volume tracking by muscle group
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Volume by muscle group
          SectionHeader(title: 'Volume by Muscle Group'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _VolumeBar(
                  label: 'Chest',
                  value: 18,
                  max: 25,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _VolumeBar(
                  label: 'Back',
                  value: 22,
                  max: 25,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _VolumeBar(
                  label: 'Shoulders',
                  value: 15,
                  max: 25,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _VolumeBar(
                  label: 'Legs',
                  value: 20,
                  max: 25,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                _VolumeBar(
                  label: 'Arms',
                  value: 12,
                  max: 25,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PRItem {
  final String exercise;
  final String value;
  final String date;

  const _PRItem({
    required this.exercise,
    required this.value,
    required this.date,
  });
}

class _LiftProgress extends StatelessWidget {
  final String name;
  final double current;
  final double previous;
  final String unit;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _LiftProgress({
    required this.name,
    required this.current,
    required this.previous,
    required this.unit,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final change = current - previous;
    final changePercent = (change / previous * 100).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${previous.toStringAsFixed(0)} $unit',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      '${current.toStringAsFixed(0)} $unit',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 16,
                  color: colorScheme.success,
                ),
                const SizedBox(width: 4),
                Text(
                  '+$changePercent%',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeBar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _VolumeBar({
    required this.label,
    required this.value,
    required this.max,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final progress = value / max;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(
                  progress > 0.8
                      ? colorScheme.success
                      : progress > 0.5
                          ? colorScheme.primary
                          : colorScheme.warning,
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              '$value sets',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
