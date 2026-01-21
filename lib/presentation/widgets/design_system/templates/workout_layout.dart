import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';
import '../atoms/app_button.dart';
import '../organisms/app_header.dart';

/// WorkoutLayout - Template for active workout screens
///
/// Provides a specialized layout for workout execution with
/// progress tracking, timer display, and exercise navigation.
///
/// Example:
/// ```dart
/// WorkoutLayout(
///   title: 'Push Day A',
///   currentExercise: 1,
///   totalExercises: 6,
///   elapsedTime: Duration(minutes: 15),
///   body: ExerciseContent(),
///   onPause: () => pauseWorkout(),
///   onFinish: () => finishWorkout(),
/// )
/// ```
class WorkoutLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final int currentExercise;
  final int totalExercises;
  final Duration? elapsedTime;
  final VoidCallback? onBack;
  final VoidCallback? onPause;
  final VoidCallback? onFinish;
  final VoidCallback? onSettings;
  final Widget? bottomBar;
  final bool showProgress;
  final bool isPaused;

  const WorkoutLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.currentExercise,
    required this.totalExercises,
    this.elapsedTime,
    this.onBack,
    this.onPause,
    this.onFinish,
    this.onSettings,
    this.bottomBar,
    this.showProgress = true,
    this.isPaused = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (elapsedTime != null)
              Text(
                _formatDuration(elapsedTime!),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onBack,
          tooltip: 'Exit Workout',
        ),
        actions: [
          if (onPause != null)
            IconButton(
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: onPause,
              tooltip: isPaused ? 'Resume' : 'Pause',
            ),
          if (onSettings != null)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: onSettings,
              tooltip: 'Settings',
            ),
        ],
        bottom: showProgress
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: _WorkoutProgressBar(
                  current: currentExercise,
                  total: totalExercises,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              )
            : null,
      ),
      body: body,
      bottomNavigationBar: bottomBar ??
          (onFinish != null
              ? _WorkoutBottomBar(
                  onFinish: onFinish!,
                  colorScheme: colorScheme,
                )
              : null),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _WorkoutProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _WorkoutProgressBar({
    required this.current,
    required this.total,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise $current of $total',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutBottomBar extends StatelessWidget {
  final VoidCallback onFinish;
  final ColorScheme colorScheme;

  const _WorkoutBottomBar({
    required this.onFinish,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: AppButton.primary(
          text: 'Finish Workout',
          onPressed: onFinish,
          isFullWidth: true,
        ),
      ),
    );
  }
}

/// WorkoutSummaryLayout - Layout for workout completion summary
///
/// Example:
/// ```dart
/// WorkoutSummaryLayout(
///   title: 'Workout Complete!',
///   duration: Duration(minutes: 45),
///   totalVolume: 12500,
///   exercisesCompleted: 6,
///   body: WorkoutStats(),
///   onDone: () => Navigator.pop(context),
/// )
/// ```
class WorkoutSummaryLayout extends StatelessWidget {
  final String title;
  final Duration duration;
  final double? totalVolume;
  final String volumeUnit;
  final int exercisesCompleted;
  final int? personalRecords;
  final Widget? body;
  final VoidCallback? onDone;
  final VoidCallback? onShare;

  const WorkoutSummaryLayout({
    super.key,
    this.title = 'Workout Complete!',
    required this.duration,
    this.totalVolume,
    this.volumeUnit = 'kg',
    required this.exercisesCompleted,
    this.personalRecords,
    this.body,
    this.onDone,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Success icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: colorScheme.success,
                        size: 64,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      title,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Stats grid
                    _buildStatsGrid(colorScheme, textTheme),

                    // Additional content
                    if (body != null) ...[
                      const SizedBox(height: 24),
                      body!,
                    ],
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (onShare != null) ...[
                    AppButton.secondary(
                      text: 'Share Workout',
                      onPressed: onShare,
                      isFullWidth: true,
                      leading: const Icon(Icons.share, size: 20),
                    ),
                    const SizedBox(height: 12),
                  ],
                  AppButton.primary(
                    text: 'Done',
                    onPressed: onDone,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ColorScheme colorScheme, TextTheme textTheme) {
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
                child: _StatItem(
                  icon: Icons.timer_outlined,
                  label: 'Duration',
                  value: _formatDuration(duration),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.fitness_center,
                  label: 'Exercises',
                  value: '$exercisesCompleted',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
          if (totalVolume != null || personalRecords != null) ...[
            const SizedBox(height: 16),
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Row(
              children: [
                if (totalVolume != null)
                  Expanded(
                    child: _StatItem(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Total Volume',
                      value: '${totalVolume!.toStringAsFixed(0)} $volumeUnit',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ),
                if (totalVolume != null && personalRecords != null)
                  Container(
                    width: 1,
                    height: 50,
                    color: colorScheme.outlineVariant,
                  ),
                if (personalRecords != null && personalRecords! > 0)
                  Expanded(
                    child: _StatItem(
                      icon: Icons.emoji_events_outlined,
                      label: 'PRs',
                      value: '$personalRecords',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      valueColor: colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: valueColor ?? colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
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
