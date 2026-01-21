import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../domain/models/logged_set.dart';
import '../../widgets/design_system/atoms/atoms.dart';

/// WorkoutSummaryScreen - Post-workout summary and stats
class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final loggedSets = ref.watch(loggedSetsProvider);
    final sessionAsync = ref.watch(activeWorkoutSessionProvider);

    // Calculate workout stats
    final stats = _calculateStats(loggedSets);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: colorScheme.success,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Workout Complete!',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              // Workout name from session
              sessionAsync.when(
                data: (session) => Text(
                  session?.workoutName ?? 'Great Job!',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),

              // Stats grid
              _buildStatsGrid(context, colorScheme, textTheme, stats),
              const SizedBox(height: 32),

              // Exercise breakdown
              _buildExerciseBreakdown(context, colorScheme, textTheme, loggedSets),
              const SizedBox(height: 32),

              // RPE distribution
              if (stats.avgRPE > 0)
                _buildRPESection(context, colorScheme, textTheme, stats),
              const SizedBox(height: 32),

              // Action buttons
              AppButton.primary(
                text: 'Done',
                onPressed: () {
                  // Clear session data and go home
                  ref.read(clearWorkoutSessionProvider)();
                  context.go('/');
                },
                isFullWidth: true,
              ),
              const SizedBox(height: 12),
              AppButton.secondary(
                text: 'Share Workout',
                onPressed: () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon!')),
                  );
                },
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _WorkoutStats _calculateStats(List<LoggedSet> sets) {
    if (sets.isEmpty) {
      return _WorkoutStats(
        totalSets: 0,
        totalReps: 0,
        totalVolume: 0,
        exerciseCount: 0,
        avgRPE: 0,
        duration: Duration.zero,
      );
    }

    final totalSets = sets.length;
    final totalReps = sets.fold<int>(0, (sum, s) => sum + s.reps);
    final totalVolume = sets.fold<double>(0, (sum, s) => sum + (s.weight * s.reps));
    final exerciseCount = sets.map((s) => s.exerciseName).toSet().length;
    final setsWithRPE = sets.where((s) => s.rpe > 0).toList();
    final avgRPE = setsWithRPE.isEmpty
        ? 0.0
        : setsWithRPE.fold<double>(0, (sum, s) => sum + s.rpe) / setsWithRPE.length;

    return _WorkoutStats(
      totalSets: totalSets,
      totalReps: totalReps,
      totalVolume: totalVolume,
      exerciseCount: exerciseCount,
      avgRPE: avgRPE,
      duration: Duration.zero, // TODO: Track actual duration
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    _WorkoutStats stats,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.fitness_center,
                  label: 'Exercises',
                  value: stats.exerciseCount.toString(),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              Container(width: 1, height: 60, color: colorScheme.outlineVariant),
              Expanded(
                child: _StatTile(
                  icon: Icons.format_list_numbered,
                  label: 'Sets',
                  value: stats.totalSets.toString(),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
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
                child: _StatTile(
                  icon: Icons.repeat,
                  label: 'Total Reps',
                  value: stats.totalReps.toString(),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              Container(width: 1, height: 60, color: colorScheme.outlineVariant),
              Expanded(
                child: _StatTile(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Volume',
                  value: _formatVolume(stats.totalVolume),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}k kg';
    }
    return '${volume.toStringAsFixed(0)} kg';
  }

  Widget _buildExerciseBreakdown(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<LoggedSet> sets,
  ) {
    // Group sets by exercise
    final exerciseMap = <String, List<LoggedSet>>{};
    for (final set in sets) {
      exerciseMap.putIfAbsent(set.exerciseName, () => []).add(set);
    }

    if (exerciseMap.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercise Breakdown',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...exerciseMap.entries.map((entry) {
          final exerciseSets = entry.value;
          final bestSet = exerciseSets.reduce((a, b) =>
              (a.weight * a.reps) > (b.weight * b.reps) ? a : b);
          final volume = exerciseSets.fold<double>(
              0, (sum, s) => sum + (s.weight * s.reps));

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
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
                        entry.key,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${exerciseSets.length} sets • Best: ${bestSet.weight.toStringAsFixed(1)}kg x ${bestSet.reps}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatVolume(volume),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRPESection(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    _WorkoutStats stats,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getRPEColor(stats.avgRPE, colorScheme).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                stats.avgRPE.toStringAsFixed(1),
                style: textTheme.titleMedium?.copyWith(
                  color: _getRPEColor(stats.avgRPE, colorScheme),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average RPE',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _getRPEDescription(stats.avgRPE),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRPEColor(double rpe, ColorScheme colorScheme) {
    if (rpe < 6) return colorScheme.success;
    if (rpe < 8) return colorScheme.primary;
    if (rpe < 9) return colorScheme.warning;
    return colorScheme.error;
  }

  String _getRPEDescription(double rpe) {
    if (rpe < 6) return 'Light session - good for recovery';
    if (rpe < 7) return 'Moderate effort - building capacity';
    if (rpe < 8) return 'Productive training - solid work';
    if (rpe < 9) return 'Hard session - pushing limits';
    return 'Maximum effort - peak intensity';
  }
}

class _WorkoutStats {
  final int totalSets;
  final int totalReps;
  final double totalVolume;
  final int exerciseCount;
  final double avgRPE;
  final Duration duration;

  const _WorkoutStats({
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.exerciseCount,
    required this.avgRPE,
    required this.duration,
  });
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
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
