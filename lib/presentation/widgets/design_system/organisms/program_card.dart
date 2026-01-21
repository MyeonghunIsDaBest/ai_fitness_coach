import 'package:flutter/material.dart';
import '../../../../core/theme/color_schemes.dart';
import '../atoms/app_badge.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';

/// ProgramCard - Organism component for workout program display
///
/// A comprehensive program card showing program details, progress,
/// and actions. Used in program lists and selection screens.
///
/// Example:
/// ```dart
/// ProgramCard(
///   name: 'Strength Builder',
///   sport: 'Powerlifting',
///   description: '12-week strength program',
///   weeksTotal: 12,
///   weeksCompleted: 4,
///   isActive: true,
///   onTap: () => viewProgram(),
/// )
/// ```
class ProgramCard extends StatelessWidget {
  final String name;
  final String sport;
  final String? description;
  final int weeksTotal;
  final int weeksCompleted;
  final bool isActive;
  final bool isCustom;
  final DateTime? startDate;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onEdit;
  final Color? sportColor;

  const ProgramCard({
    super.key,
    required this.name,
    required this.sport,
    this.description,
    required this.weeksTotal,
    this.weeksCompleted = 0,
    this.isActive = false,
    this.isCustom = false,
    this.startDate,
    this.onTap,
    this.onStart,
    this.onEdit,
    this.sportColor,
  });

  /// Compact card for lists
  const ProgramCard.compact({
    super.key,
    required this.name,
    required this.sport,
    required this.weeksTotal,
    this.weeksCompleted = 0,
    this.isActive = false,
    this.onTap,
    this.sportColor,
  })  : description = null,
        isCustom = false,
        startDate = null,
        onStart = null,
        onEdit = null;

  /// Preview card for program selection
  const ProgramCard.preview({
    super.key,
    required this.name,
    required this.sport,
    required this.description,
    required this.weeksTotal,
    this.isCustom = false,
    this.onTap,
    required this.onStart,
    this.sportColor,
  })  : weeksCompleted = 0,
        isActive = false,
        startDate = null,
        onEdit = null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveSportColor = sportColor ?? _getSportColor(sport, colorScheme);

    return AppCard.outlined(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with sport color accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: effectiveSportColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sport icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: effectiveSportColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getSportIcon(sport),
                        color: effectiveSportColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title and sport
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isActive)
                                const AppBadge(
                                  text: 'Active',
                                  variant: AppBadgeVariant.success,
                                  size: AppBadgeSize.small,
                                ),
                              if (isCustom && !isActive)
                                const AppBadge(
                                  text: 'Custom',
                                  variant: AppBadgeVariant.info,
                                  size: AppBadgeSize.small,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sport,
                            style: textTheme.bodySmall?.copyWith(
                              color: effectiveSportColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Description
                if (description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    description!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 16),

                // Progress or duration
                _buildProgressSection(colorScheme, textTheme, effectiveSportColor),

                // Actions
                if (onStart != null || onEdit != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (onEdit != null)
                        Expanded(
                          child: AppButton.secondary(
                            text: 'Edit',
                            onPressed: onEdit,
                            size: AppButtonSize.small,
                          ),
                        ),
                      if (onEdit != null && onStart != null)
                        const SizedBox(width: 12),
                      if (onStart != null)
                        Expanded(
                          child: AppButton.primary(
                            text: isActive ? 'Continue' : 'Start',
                            onPressed: onStart,
                            size: AppButtonSize.small,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
    Color sportColor,
  ) {
    final progress = weeksTotal > 0 ? weeksCompleted / weeksTotal : 0.0;
    final isComplete = weeksCompleted >= weeksTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isActive
                  ? 'Week $weeksCompleted of $weeksTotal'
                  : '$weeksTotal weeks',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (isActive)
              Text(
                '${(progress * 100).toInt()}%',
                style: textTheme.labelMedium?.copyWith(
                  color: isComplete ? colorScheme.success : sportColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        if (isActive) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                isComplete ? colorScheme.success : sportColor,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ],
    );
  }

  Color _getSportColor(String sport, ColorScheme colorScheme) {
    final lowerSport = sport.toLowerCase();
    if (lowerSport.contains('power')) return colorScheme.sportPowerlifting;
    if (lowerSport.contains('body')) return colorScheme.sportBodybuilding;
    if (lowerSport.contains('cross')) return colorScheme.sportCrossfit;
    if (lowerSport.contains('olympic')) return colorScheme.sportOlympicLifting;
    if (lowerSport.contains('general')) return colorScheme.sportGeneralFitness;
    return colorScheme.primary;
  }

  IconData _getSportIcon(String sport) {
    final lowerSport = sport.toLowerCase();
    if (lowerSport.contains('power')) return Icons.fitness_center;
    if (lowerSport.contains('body')) return Icons.self_improvement;
    if (lowerSport.contains('cross')) return Icons.sports_martial_arts;
    if (lowerSport.contains('olympic')) return Icons.sports;
    if (lowerSport.contains('general')) return Icons.directions_run;
    return Icons.fitness_center;
  }
}

/// ProgramWeekCard - Card for displaying a program week
///
/// Example:
/// ```dart
/// ProgramWeekCard(
///   weekNumber: 1,
///   phase: 'Hypertrophy',
///   isCompleted: true,
///   workoutCount: 4,
///   completedWorkouts: 4,
/// )
/// ```
class ProgramWeekCard extends StatelessWidget {
  final int weekNumber;
  final String phase;
  final String? weekType;
  final bool isCompleted;
  final bool isCurrent;
  final int workoutCount;
  final int completedWorkouts;
  final VoidCallback? onTap;

  const ProgramWeekCard({
    super.key,
    required this.weekNumber,
    required this.phase,
    this.weekType,
    this.isCompleted = false,
    this.isCurrent = false,
    required this.workoutCount,
    this.completedWorkouts = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color statusColor;
    IconData statusIcon;
    if (isCompleted) {
      statusColor = colorScheme.success;
      statusIcon = Icons.check_circle;
    } else if (isCurrent) {
      statusColor = colorScheme.primary;
      statusIcon = Icons.play_circle;
    } else {
      statusColor = colorScheme.onSurfaceVariant;
      statusIcon = Icons.circle_outlined;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primary.withOpacity(0.05)
              : colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: isCurrent
              ? Border.all(color: colorScheme.primary.withOpacity(0.3))
              : null,
        ),
        child: Row(
          children: [
            // Status icon
            Icon(statusIcon, color: statusColor, size: 28),
            const SizedBox(width: 16),

            // Week info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Week $weekNumber',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          phase,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (weekType != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          weekType!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$completedWorkouts/$workoutCount',
                  style: textTheme.labelLarge?.copyWith(
                    color: isCompleted
                        ? colorScheme.success
                        : colorScheme.onSurfaceVariant,
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
                      value: workoutCount > 0
                          ? completedWorkouts / workoutCount
                          : 0,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(
                        isCompleted ? colorScheme.success : colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
