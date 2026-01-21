import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';
import '../atoms/app_badge.dart';

/// ExerciseListItem - Molecule component for displaying exercises
///
/// A comprehensive exercise item component that shows exercise details,
/// sets, reps, RPE, and completion status.
///
/// Example:
/// ```dart
/// ExerciseListItem(
///   name: 'Bench Press',
///   sets: 4,
///   reps: 8,
///   targetRPE: 8.0,
///   isMainLift: true,
///   onTap: () => navigateToExercise(),
/// )
/// ```
class ExerciseListItem extends StatelessWidget {
  final String name;
  final int sets;
  final int reps;
  final double? targetRPE;
  final double? weight;
  final String? weightUnit;
  final bool isMainLift;
  final bool isCompleted;
  final int? completedSets;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  const ExerciseListItem({
    super.key,
    required this.name,
    required this.sets,
    required this.reps,
    this.targetRPE,
    this.weight,
    this.weightUnit = 'kg',
    this.isMainLift = false,
    this.isCompleted = false,
    this.completedSets,
    this.notes,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  /// Compact variant for lists
  factory ExerciseListItem.compact({
    Key? key,
    required String name,
    required int sets,
    required int reps,
    double? targetRPE,
    bool isCompleted = false,
    VoidCallback? onTap,
  }) {
    return ExerciseListItem(
      key: key,
      name: name,
      sets: sets,
      reps: reps,
      targetRPE: targetRPE,
      isCompleted: isCompleted,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: isMainLift
                ? Border.all(
                    color: colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading icon/indicator
              _buildLeadingIndicator(colorScheme),
              const SizedBox(width: 12),

              // Exercise info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: isMainLift
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isMainLift)
                          const AppBadge(
                            text: 'Main',
                            size: AppBadgeSize.small,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildDetailsRow(colorScheme, textTheme),
                    if (notes != null && notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        notes!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Progress or trailing widget
              if (trailing != null)
                trailing!
              else if (completedSets != null)
                _buildProgressIndicator(colorScheme, textTheme)
              else
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIndicator(ColorScheme colorScheme) {
    if (isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.success.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check,
          color: colorScheme.success,
          size: 20,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isMainLift ? Icons.fitness_center : Icons.sports_gymnastics,
        color: colorScheme.primary,
        size: 20,
      ),
    );
  }

  Widget _buildDetailsRow(ColorScheme colorScheme, TextTheme textTheme) {
    final details = <Widget>[];

    // Sets x Reps
    details.add(
      _DetailChip(
        icon: Icons.format_list_numbered,
        text: '$sets x $reps',
        colorScheme: colorScheme,
        textTheme: textTheme,
      ),
    );

    // Weight (if provided)
    if (weight != null) {
      details.add(
        _DetailChip(
          icon: Icons.monitor_weight_outlined,
          text: '${weight!.toStringAsFixed(weight! % 1 == 0 ? 0 : 1)} $weightUnit',
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      );
    }

    // RPE (if provided)
    if (targetRPE != null) {
      details.add(
        _DetailChip(
          icon: Icons.speed,
          text: 'RPE ${targetRPE!.toStringAsFixed(targetRPE! % 1 == 0 ? 0 : 1)}',
          colorScheme: colorScheme,
          textTheme: textTheme,
          color: colorScheme.getRPEColor(targetRPE!),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: details,
    );
  }

  Widget _buildProgressIndicator(ColorScheme colorScheme, TextTheme textTheme) {
    final progress = completedSets! / sets;
    final isComplete = completedSets! >= sets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$completedSets / $sets',
          style: textTheme.labelMedium?.copyWith(
            color: isComplete ? colorScheme.success : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                isComplete ? colorScheme.success : colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Color? color;

  const _DetailChip({
    required this.icon,
    required this.text,
    required this.colorScheme,
    required this.textTheme,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: color ?? colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: color ?? colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// ExerciseListHeader - Section header for exercise groups
///
/// Example:
/// ```dart
/// ExerciseListHeader(
///   title: 'Main Lifts',
///   subtitle: '3 exercises',
/// )
/// ```
class ExerciseListHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const ExerciseListHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// SetRow - Row for displaying a single set within an exercise
///
/// Example:
/// ```dart
/// SetRow(
///   setNumber: 1,
///   weight: 100,
///   reps: 8,
///   targetRPE: 8.0,
///   actualRPE: 7.5,
///   isCompleted: true,
/// )
/// ```
class SetRow extends StatelessWidget {
  final int setNumber;
  final double? weight;
  final String weightUnit;
  final int reps;
  final double? targetRPE;
  final double? actualRPE;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const SetRow({
    super.key,
    required this.setNumber,
    this.weight,
    this.weightUnit = 'kg',
    required this.reps,
    this.targetRPE,
    this.actualRPE,
    this.isCompleted = false,
    this.isActive = false,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary.withOpacity(0.1)
                : isCompleted
                    ? colorScheme.success.withOpacity(0.05)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: colorScheme.primary, width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Set number
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? colorScheme.success
                      : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isCompleted
                    ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary)
                    : Text(
                        '$setNumber',
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(width: 16),

              // Weight
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      weight != null
                          ? '${weight!.toStringAsFixed(weight! % 1 == 0 ? 0 : 1)} $weightUnit'
                          : '-',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Reps
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reps',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$reps',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // RPE
              if (targetRPE != null || actualRPE != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RPE',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Row(
                        children: [
                          if (actualRPE != null)
                            Text(
                              actualRPE!.toStringAsFixed(actualRPE! % 1 == 0 ? 0 : 1),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.getRPEColor(actualRPE!),
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else if (targetRPE != null)
                            Text(
                              '@${targetRPE!.toStringAsFixed(targetRPE! % 1 == 0 ? 0 : 1)}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

              // Complete button
              if (onComplete != null && !isCompleted)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: onComplete,
                  color: colorScheme.primary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
