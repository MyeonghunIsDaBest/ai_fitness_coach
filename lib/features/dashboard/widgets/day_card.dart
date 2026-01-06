import 'package:flutter/material.dart';
import '../../../domain/models/daily_workout.dart';

/// Card widget displaying a single day's workout
/// Shows day name, workout details, completion status, and exercises preview
class DayCard extends StatelessWidget {
  final DailyWorkout? workout;
  final int dayOfWeek;
  final bool isCompleted;
  final bool isToday;
  final VoidCallback? onTap;

  const DayCard({
    Key? key,
    required this.workout,
    required this.dayOfWeek,
    this.isCompleted = false,
    this.isToday = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRestDay = workout == null;

    return Card(
      elevation: isToday ? 8 : 2,
      color: _getCardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isToday
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isRestDay ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getDayName(dayOfWeek),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isToday
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white70,
                    ),
                  ),
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Workout Name or Rest Day
              if (isRestDay)
                _buildRestDay(context)
              else
                _buildWorkoutContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestDay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.spa,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Rest Day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Recovery and adaptation',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutContent(BuildContext context) {
    final totalExercises = workout!.exercises.length;
    final totalSets = workout!.totalSets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Workout Name
        Text(
          workout!.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Stats Row
        Row(
          children: [
            _buildStat(
              context,
              Icons.fitness_center,
              '$totalExercises exercises',
            ),
            const SizedBox(width: 16),
            _buildStat(
              context,
              Icons.list,
              '$totalSets sets',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Exercise Preview (first 3 exercises)
        _buildExercisePreview(context),

        // Action Button
        if (!isCompleted) ...[
          const SizedBox(height: 12),
          _buildActionButton(context),
        ],
      ],
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildExercisePreview(BuildContext context) {
    final exercises = workout!.exercises.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: exercises.map((exercise) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exercise.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isToday
              ? Theme.of(context).colorScheme.primary
              : Colors.white.withOpacity(0.1),
          foregroundColor: isToday ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isToday ? 'Start Workout' : 'View Workout',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getCardColor(BuildContext context) {
    if (isCompleted) {
      return const Color(0xFF1E3A1E); // Dark green tint
    }
    if (isToday) {
      return const Color(0xFF2A2A2A); // Slightly lighter
    }
    return const Color(0xFF1E1E1E); // Standard dark
  }

  String _getDayName(int dayOfWeek) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dayOfWeek - 1];
  }
}
