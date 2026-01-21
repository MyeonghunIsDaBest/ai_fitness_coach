import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';
import '../atoms/app_badge.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../molecules/exercise_list_item.dart';

/// WorkoutCard - Organism component for displaying workout summaries
///
/// A comprehensive workout card that shows workout details, exercises,
/// and action buttons. Used in workout lists and program views.
///
/// Example:
/// ```dart
/// WorkoutCard(
///   title: 'Push Day A',
///   focus: 'Chest, Shoulders, Triceps',
///   exercises: [exercise1, exercise2],
///   estimatedDuration: 60,
///   onStart: () => startWorkout(),
/// )
/// ```
class WorkoutCard extends StatelessWidget {
  final String title;
  final String? focus;
  final String? subtitle;
  final int? exerciseCount;
  final int? estimatedDuration;
  final bool isCompleted;
  final bool isActive;
  final bool isRestDay;
  final DateTime? scheduledDate;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onEdit;
  final List<WorkoutExercisePreview>? exercises;
  final int maxExercisePreview;

  const WorkoutCard({
    super.key,
    required this.title,
    this.focus,
    this.subtitle,
    this.exerciseCount,
    this.estimatedDuration,
    this.isCompleted = false,
    this.isActive = false,
    this.isRestDay = false,
    this.scheduledDate,
    this.onTap,
    this.onStart,
    this.onEdit,
    this.exercises,
    this.maxExercisePreview = 3,
  });

  /// Compact card for lists
  const WorkoutCard.compact({
    super.key,
    required this.title,
    this.focus,
    this.exerciseCount,
    this.estimatedDuration,
    this.isCompleted = false,
    this.isActive = false,
    this.onTap,
  })  : subtitle = null,
        isRestDay = false,
        scheduledDate = null,
        onStart = null,
        onEdit = null,
        exercises = null,
        maxExercisePreview = 0;

  /// Rest day card
  const WorkoutCard.restDay({
    super.key,
    this.title = 'Rest Day',
    this.scheduledDate,
    this.onTap,
  })  : focus = null,
        subtitle = 'Recovery & Regeneration',
        exerciseCount = null,
        estimatedDuration = null,
        isCompleted = false,
        isActive = false,
        isRestDay = true,
        onStart = null,
        onEdit = null,
        exercises = null,
        maxExercisePreview = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isRestDay) {
      return _buildRestDayCard(colorScheme, textTheme);
    }

    return AppCard.outlined(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(colorScheme, textTheme),

          // Exercise previews
          if (exercises != null && exercises!.isNotEmpty) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            _buildExercisePreviews(colorScheme, textTheme),
          ],

          // Footer with actions
          if (onStart != null || onEdit != null) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            _buildActions(colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildRestDayCard(ColorScheme colorScheme, TextTheme textTheme) {
    return AppCard.outlined(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.self_improvement,
              color: colorScheme.secondary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.spa_outlined,
            color: colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status indicator
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getStatusColor(colorScheme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(colorScheme),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Title and focus
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          AppBadge.success(text: 'Done')
                        else if (isActive)
                          const AppBadge(
                            text: 'Today',
                            variant: AppBadgeVariant.info,
                          ),
                      ],
                    ),
                    if (focus != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        focus!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Metadata
          const SizedBox(height: 12),
          Row(
            children: [
              if (exerciseCount != null)
                _MetadataChip(
                  icon: Icons.fitness_center,
                  text: '$exerciseCount exercises',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              if (exerciseCount != null && estimatedDuration != null)
                const SizedBox(width: 16),
              if (estimatedDuration != null)
                _MetadataChip(
                  icon: Icons.schedule,
                  text: '$estimatedDuration min',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExercisePreviews(ColorScheme colorScheme, TextTheme textTheme) {
    final previewExercises = exercises!.take(maxExercisePreview).toList();
    final remainingCount = exercises!.length - previewExercises.length;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...previewExercises.map((exercise) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: exercise.isMain
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        exercise.name,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight:
                              exercise.isMain ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      '${exercise.sets} x ${exercise.reps}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )),
          if (remainingCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              '+$remainingCount more exercises',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (onEdit != null)
            Expanded(
              child: AppButton.secondary(
                text: 'Edit',
                onPressed: onEdit,
                size: AppButtonSize.small,
              ),
            ),
          if (onEdit != null && onStart != null) const SizedBox(width: 12),
          if (onStart != null)
            Expanded(
              child: AppButton.primary(
                text: isCompleted ? 'Review' : 'Start',
                onPressed: onStart,
                size: AppButtonSize.small,
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(ColorScheme colorScheme) {
    if (isCompleted) return colorScheme.success;
    if (isActive) return colorScheme.primary;
    return colorScheme.onSurfaceVariant;
  }

  IconData _getStatusIcon() {
    if (isCompleted) return Icons.check_circle;
    if (isActive) return Icons.play_circle_outline;
    return Icons.fitness_center;
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _MetadataChip({
    required this.icon,
    required this.text,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Exercise preview data for workout cards
class WorkoutExercisePreview {
  final String name;
  final int sets;
  final int reps;
  final bool isMain;

  const WorkoutExercisePreview({
    required this.name,
    required this.sets,
    required this.reps,
    this.isMain = false,
  });
}

/// WorkoutDaySelector - Week day selector for workout scheduling
///
/// Example:
/// ```dart
/// WorkoutDaySelector(
///   selectedDay: 1,
///   completedDays: [0, 1],
///   onDaySelected: (day) => selectDay(day),
/// )
/// ```
class WorkoutDaySelector extends StatelessWidget {
  final int? selectedDay;
  final Set<int> completedDays;
  final Set<int> restDays;
  final void Function(int)? onDaySelected;
  final List<String> dayLabels;

  const WorkoutDaySelector({
    super.key,
    this.selectedDay,
    this.completedDays = const {},
    this.restDays = const {},
    this.onDaySelected,
    this.dayLabels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final isSelected = selectedDay == index;
          final isCompleted = completedDays.contains(index);
          final isRest = restDays.contains(index);

          return _DayButton(
            label: dayLabels[index],
            isSelected: isSelected,
            isCompleted: isCompleted,
            isRest: isRest,
            onTap: () => onDaySelected?.call(index),
            colorScheme: colorScheme,
            textTheme: textTheme,
          );
        }),
      ),
    );
  }
}

class _DayButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isCompleted;
  final bool isRest;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DayButton({
    required this.label,
    required this.isSelected,
    required this.isCompleted,
    required this.isRest,
    this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (isSelected) {
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
    } else if (isCompleted) {
      backgroundColor = colorScheme.success.withOpacity(0.2);
      textColor = colorScheme.success;
    } else if (isRest) {
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurfaceVariant;
    } else {
      backgroundColor = Colors.transparent;
      textColor = colorScheme.onSurface;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: isCompleted && !isSelected
            ? Icon(Icons.check, size: 18, color: textColor)
            : Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
