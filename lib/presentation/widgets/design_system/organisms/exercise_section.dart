import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';
import '../atoms/app_button.dart';
import '../molecules/exercise_list_item.dart';

/// ExerciseSection - Organism component for grouped exercises
///
/// A section containing a header and list of exercises, used in
/// workout views and program details.
///
/// Example:
/// ```dart
/// ExerciseSection(
///   title: 'Main Lifts',
///   exercises: [
///     ExerciseItem(name: 'Squat', sets: 5, reps: 5),
///     ExerciseItem(name: 'Bench Press', sets: 5, reps: 5),
///   ],
/// )
/// ```
class ExerciseSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ExerciseItem> exercises;
  final VoidCallback? onAddExercise;
  final void Function(int index)? onExerciseTap;
  final void Function(int index)? onExerciseLongPress;
  final bool showAddButton;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;
  final EdgeInsetsGeometry? padding;

  const ExerciseSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.exercises,
    this.onAddExercise,
    this.onExerciseTap,
    this.onExerciseLongPress,
    this.showAddButton = false,
    this.isExpanded = true,
    this.onToggleExpand,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(colorScheme, textTheme),

          // Exercise list
          if (isExpanded) ...[
            const SizedBox(height: 12),
            ...exercises.asMap().entries.map((entry) {
              final index = entry.key;
              final exercise = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ExerciseListItem(
                  name: exercise.name,
                  sets: exercise.sets,
                  reps: exercise.reps,
                  targetRPE: exercise.targetRPE,
                  weight: exercise.weight,
                  weightUnit: exercise.weightUnit,
                  isMainLift: exercise.isMain,
                  isCompleted: exercise.isCompleted,
                  completedSets: exercise.completedSets,
                  notes: exercise.notes,
                  onTap: onExerciseTap != null ? () => onExerciseTap!(index) : null,
                  onLongPress: onExerciseLongPress != null
                      ? () => onExerciseLongPress!(index)
                      : null,
                ),
              );
            }),

            // Add button
            if (showAddButton && onAddExercise != null) ...[
              const SizedBox(height: 8),
              Center(
                child: AppButton.text(
                  text: 'Add Exercise',
                  onPressed: onAddExercise,
                  leading: const Icon(Icons.add, size: 18),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return InkWell(
      onTap: onToggleExpand,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Section indicator
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Exercise count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${exercises.length}',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Expand/collapse icon
            if (onToggleExpand != null) ...[
              const SizedBox(width: 8),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Exercise item data for exercise sections
class ExerciseItem {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final double? targetRPE;
  final double? weight;
  final String weightUnit;
  final bool isMain;
  final bool isCompleted;
  final int? completedSets;
  final String? notes;

  const ExerciseItem({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.targetRPE,
    this.weight,
    this.weightUnit = 'kg',
    this.isMain = false,
    this.isCompleted = false,
    this.completedSets,
    this.notes,
  });
}

/// ActiveExerciseCard - Card for the currently active exercise
///
/// Example:
/// ```dart
/// ActiveExerciseCard(
///   name: 'Bench Press',
///   currentSet: 3,
///   totalSets: 5,
///   targetReps: 8,
///   targetRPE: 8.0,
///   weight: 100,
///   onComplete: () => completeSet(),
/// )
/// ```
class ActiveExerciseCard extends StatelessWidget {
  final String name;
  final int currentSet;
  final int totalSets;
  final int targetReps;
  final double? targetRPE;
  final double? weight;
  final String weightUnit;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final VoidCallback? onEdit;
  final List<String>? formCues;

  const ActiveExerciseCard({
    super.key,
    required this.name,
    required this.currentSet,
    required this.totalSets,
    required this.targetReps,
    this.targetRPE,
    this.weight,
    this.weightUnit = 'kg',
    this.onComplete,
    this.onSkip,
    this.onEdit,
    this.formCues,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.15),
            colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set $currentSet of $totalSets',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Targets
          Row(
            children: [
              _TargetDisplay(
                label: 'Weight',
                value: weight != null
                    ? '${weight!.toStringAsFixed(weight! % 1 == 0 ? 0 : 1)}'
                    : '-',
                unit: weightUnit,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              const SizedBox(width: 24),
              _TargetDisplay(
                label: 'Reps',
                value: '$targetReps',
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              if (targetRPE != null) ...[
                const SizedBox(width: 24),
                _TargetDisplay(
                  label: 'RPE',
                  value: targetRPE!.toStringAsFixed(targetRPE! % 1 == 0 ? 0 : 1),
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  valueColor: colorScheme.getRPEColor(targetRPE!),
                ),
              ],
            ],
          ),

          // Form cues
          if (formCues != null && formCues!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Cues',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...formCues!.take(3).map((cue) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cue,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Actions
          Row(
            children: [
              if (onSkip != null)
                Expanded(
                  child: AppButton.secondary(
                    text: 'Skip',
                    onPressed: onSkip,
                  ),
                ),
              if (onSkip != null && onComplete != null) const SizedBox(width: 12),
              if (onComplete != null)
                Expanded(
                  flex: 2,
                  child: AppButton.primary(
                    text: 'Complete Set',
                    onPressed: onComplete,
                    leading: const Icon(Icons.check, size: 20),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TargetDisplay extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Color? valueColor;

  const _TargetDisplay({
    required this.label,
    required this.value,
    this.unit,
    required this.colorScheme,
    required this.textTheme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                color: valueColor ?? colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// RestTimer - Timer display for rest periods
///
/// Example:
/// ```dart
/// RestTimer(
///   seconds: 90,
///   onSkip: () => skipRest(),
///   onAdd30Seconds: () => addTime(),
/// )
/// ```
class RestTimer extends StatelessWidget {
  final int seconds;
  final int? recommendedSeconds;
  final VoidCallback? onSkip;
  final VoidCallback? onAdd30Seconds;
  final bool isPaused;
  final VoidCallback? onTogglePause;

  const RestTimer({
    super.key,
    required this.seconds,
    this.recommendedSeconds,
    this.onSkip,
    this.onAdd30Seconds,
    this.isPaused = false,
    this.onTogglePause,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    final progress = recommendedSeconds != null
        ? (seconds / recommendedSeconds!).clamp(0.0, 1.0)
        : null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Rest',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Timer display
          Stack(
            alignment: Alignment.center,
            children: [
              if (progress != null)
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      progress > 1.0 ? colorScheme.error : colorScheme.primary,
                    ),
                  ),
                ),
              Column(
                children: [
                  Text(
                    timeString,
                    style: textTheme.displayMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (recommendedSeconds != null)
                    Text(
                      'of ${(recommendedSeconds! ~/ 60).toString().padLeft(2, '0')}:${(recommendedSeconds! % 60).toString().padLeft(2, '0')}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onAdd30Seconds != null)
                OutlinedButton(
                  onPressed: onAdd30Seconds,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('+30s'),
                ),
              if (onAdd30Seconds != null) const SizedBox(width: 12),
              if (onTogglePause != null)
                IconButton.filled(
                  onPressed: onTogglePause,
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                ),
              if (onTogglePause != null) const SizedBox(width: 12),
              if (onSkip != null)
                FilledButton(
                  onPressed: onSkip,
                  child: const Text('Skip'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
