import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/logged_set.dart';
import '../../../domain/models/workout_session.dart';

/// WorkoutHistoryScreen - View all past workouts
class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  // Semi-dark theme colors
  static const _backgroundColor = Color(0xFF0F172A);
  static const _textPrimary = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final historyAsync = ref.watch(workoutHistoryProvider(50));

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Workout History',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: historyAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return _buildEmptyState(colorScheme, textTheme);
          }

          // Group sessions by month
          final grouped = _groupByMonth(sessions);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(workoutHistoryProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final entry = grouped.entries.elementAt(index);
                return _MonthSection(
                  month: entry.key,
                  sessions: entry.value,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading history', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(workoutHistoryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Workouts Yet',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete a workout to see it here',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<WorkoutSession>> _groupByMonth(List<WorkoutSession> sessions) {
    final Map<String, List<WorkoutSession>> grouped = {};
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    for (final session in sessions) {
      final key = '${months[session.startTime.month - 1]} ${session.startTime.year}';
      grouped.putIfAbsent(key, () => []).add(session);
    }

    return grouped;
  }
}

class _MonthSection extends StatelessWidget {
  final String month;
  final List<WorkoutSession> sessions;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _MonthSection({
    required this.month,
    required this.sessions,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
          child: Text(
            month,
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...sessions.map((session) => _WorkoutHistoryCard(
          session: session,
          colorScheme: colorScheme,
          textTheme: textTheme,
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _WorkoutHistoryCard extends StatelessWidget {
  final WorkoutSession session;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WorkoutHistoryCard({
    required this.session,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final totalVolume = session.sets.fold<double>(
      0,
      (sum, set) => sum + (set.weight * set.reps),
    );

    final avgRPE = session.sets.isNotEmpty
        ? session.sets.fold<double>(0, (sum, set) => sum + set.rpe) / session.sets.length
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showSessionDetail(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.workoutName,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(session.startTime),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (session.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats row
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.format_list_numbered,
                      label: '${session.sets.length} sets',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.monitor_weight_outlined,
                      label: _formatVolume(totalVolume),
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    if (avgRPE > 0) ...[
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.speed,
                        label: 'RPE ${avgRPE.toStringAsFixed(1)}',
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                    if (session.duration != null) ...[
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.timer_outlined,
                        label: _formatDuration(session.duration!),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatVolume(double volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}k kg';
    }
    return '${volume.toStringAsFixed(0)} kg';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  void _showSessionDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _SessionDetailSheet(
          session: session,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SessionDetailSheet extends StatelessWidget {
  final WorkoutSession session;
  final ScrollController scrollController;

  const _SessionDetailSheet({
    required this.session,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Group sets by exercise
    final exerciseMap = <String, List<LoggedSet>>{};
    for (final set in session.sets) {
      exerciseMap.putIfAbsent(set.exerciseName, () => []).add(set);
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.workoutName,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatFullDate(session.startTime),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: colorScheme.outlineVariant, height: 1),

          // Exercise list
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: exerciseMap.length,
              itemBuilder: (context, index) {
                final entry = exerciseMap.entries.elementAt(index);
                return _ExerciseSection(
                  exerciseName: entry.key,
                  sets: entry.value,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ExerciseSection extends StatelessWidget {
  final String exerciseName;
  final List<LoggedSet> sets;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _ExerciseSection({
    required this.exerciseName,
    required this.sets,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exerciseName,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...sets.asMap().entries.map((entry) {
          final index = entry.key;
          final set = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    '${index + 1}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${set.weight.toStringAsFixed(1)} kg × ${set.reps}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (set.rpe > 0)
                  Text(
                    'RPE ${set.rpe.toStringAsFixed(1)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }
}
