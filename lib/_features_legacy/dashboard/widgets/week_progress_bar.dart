import 'package:flutter/material.dart';

/// Animated progress bar showing weekly workout completion
/// Displays completed workouts vs total workouts with visual feedback
class WeekProgressBar extends StatelessWidget {
  final int completedWorkouts;
  final int totalWorkouts;
  final bool showStats;

  const WeekProgressBar({
    Key? key,
    required this.completedWorkouts,
    required this.totalWorkouts,
    this.showStats = true,
  }) : super(key: key);

  double get progress {
    if (totalWorkouts == 0) return 0.0;
    return completedWorkouts / totalWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Week Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (showStats)
                Text(
                  '$completedWorkouts / $totalWorkouts',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(context),
                ),
              ),
            ),
          ),

          if (showStats) ...[
            const SizedBox(height: 12),
            _buildStatsRow(context),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final percentage = (progress * 100).toInt();
    final remaining = totalWorkouts - completedWorkouts;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatChip(
          context,
          icon: Icons.check_circle_outline,
          label: '$percentage% Complete',
          color: _getProgressColor(context),
        ),
        if (remaining > 0)
          _buildStatChip(
            context,
            icon: Icons.schedule,
            label: '$remaining remaining',
            color: Colors.white.withOpacity(0.5),
          ),
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(BuildContext context) {
    if (progress >= 1.0) {
      return const Color(0xFF4CAF50); // Green - Completed
    } else if (progress >= 0.7) {
      return Theme.of(context).colorScheme.primary; // Yellow-green - Good
    } else if (progress >= 0.4) {
      return const Color(0xFFFF9800); // Orange - Progress
    } else {
      return const Color(0xFFFF5722); // Red - Behind
    }
  }
}

/// Compact version for use in headers or smaller spaces
class CompactWeekProgressBar extends StatelessWidget {
  final int completedWorkouts;
  final int totalWorkouts;

  const CompactWeekProgressBar({
    Key? key,
    required this.completedWorkouts,
    required this.totalWorkouts,
  }) : super(key: key);

  double get progress {
    if (totalWorkouts == 0) return 0.0;
    return completedWorkouts / totalWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$completedWorkouts/$totalWorkouts',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
