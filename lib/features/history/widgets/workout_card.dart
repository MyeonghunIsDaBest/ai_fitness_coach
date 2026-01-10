// lib/features/history/widgets/workout_card.dart

import 'package:flutter/material.dart';
import '../../../domain/repositories/training_repository.dart';

/// Card widget displaying a single workout in the history list
/// Shows summary info: date, program, exercises, RPE, duration
class WorkoutCard extends StatelessWidget {
  final WorkoutSession session;
  final VoidCallback? onTap;
  final bool showDate;

  const WorkoutCard({
    Key? key,
    required this.session,
    this.onTap,
    this.showDate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Date + Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showDate) _buildDateBadge(),
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: 12),

              // Workout Name
              Text(
                session.workoutName,
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
                    Icons.fitness_center,
                    '${session.sets.length} sets',
                  ),
                  const SizedBox(width: 16),
                  _buildStat(
                    Icons.speed,
                    'RPE ${session.averageRPE.toStringAsFixed(1)}',
                    color: _getRPEColor(session.averageRPE),
                  ),
                  const SizedBox(width: 16),
                  if (session.duration != null)
                    _buildStat(
                      Icons.timer,
                      _formatDuration(session.duration!),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Exercise Tags (first 3)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: session.exercisesPerformed
                    .take(3)
                    .map((exercise) => _buildExerciseTag(exercise))
                    .toList(),
              ),

              // Show more indicator
              if (session.exercisesPerformed.length > 3) ...[
                const SizedBox(height: 8),
                Text(
                  '+${session.exercisesPerformed.length - 3} more exercises',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge() {
    final date = session.startTime;
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isToday
            ? const Color(0xFFB4F04D).withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 14,
            color: isToday ? const Color(0xFFB4F04D) : Colors.white70,
          ),
          const SizedBox(width: 6),
          Text(
            isToday ? 'Today' : _formatDate(date),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isToday ? const Color(0xFFB4F04D) : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: session.isCompleted
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            session.isCompleted ? Icons.check_circle : Icons.pending,
            size: 14,
            color: session.isCompleted ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            session.isCompleted ? 'Completed' : 'Incomplete',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: session.isCompleted ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color ?? Colors.white70,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color ?? Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseTag(String exercise) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFB4F04D).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFB4F04D).withOpacity(0.3),
        ),
      ),
      child: Text(
        exercise,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB4F04D),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${monthNames[date.month - 1]} ${date.day}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Color _getRPEColor(double rpe) {
    if (rpe <= 6.5) return Colors.blue;
    if (rpe <= 7.5) return Colors.green;
    if (rpe <= 8.5) return const Color(0xFFB4F04D);
    if (rpe <= 9.5) return Colors.orange;
    return Colors.red;
  }
}

/// Compact version for use in smaller spaces
class CompactWorkoutCard extends StatelessWidget {
  final WorkoutSession session;
  final VoidCallback? onTap;

  const CompactWorkoutCard({
    Key? key,
    required this.session,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // RPE Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getRPEColor(session.averageRPE).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  session.averageRPE.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getRPEColor(session.averageRPE),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.workoutName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.sets.length} sets • ${_formatDate(session.startTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) return 'Today';

    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return '${date.month}/${date.day}';
  }

  Color _getRPEColor(double rpe) {
    if (rpe <= 6.5) return Colors.blue;
    if (rpe <= 7.5) return Colors.green;
    if (rpe <= 8.5) return const Color(0xFFB4F04D);
    if (rpe <= 9.5) return Colors.orange;
    return Colors.red;
  }
}
