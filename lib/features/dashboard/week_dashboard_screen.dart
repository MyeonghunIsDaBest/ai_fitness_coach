import 'package:flutter/material.dart';
import '../../../domain/models/workout_program.dart';
import '../../../domain/models/program_week.dart';
import '../../../domain/models/daily_workout.dart';
import 'widgets/day_card.dart';
import 'widgets/week_progress_bar.dart';

/// Main dashboard showing the current week's workouts
/// Displays 7 days, progress tracking, and navigation
class WeekDashboardScreen extends StatefulWidget {
  final WorkoutProgram? program;
  final int currentWeek;

  const WeekDashboardScreen({
    Key? key,
    this.program,
    this.currentWeek = 1,
  }) : super(key: key);

  @override
  State<WeekDashboardScreen> createState() => _WeekDashboardScreenState();
}

class _WeekDashboardScreenState extends State<WeekDashboardScreen> {
  late int _selectedWeek;
  final Set<int> _completedDays = {}; // Track completed days

  @override
  void initState() {
    super.initState();
    _selectedWeek = widget.currentWeek;
    _loadCompletedDays();
  }

  void _loadCompletedDays() {
    // TODO: Load from repository
    // For now, just initialize empty
    setState(() {});
  }

  ProgramWeek? get _currentProgramWeek {
    if (widget.program == null) return null;
    if (_selectedWeek < 1 || _selectedWeek > widget.program!.weeks.length) {
      return null;
    }
    return widget.program!.weeks[_selectedWeek - 1];
  }

  int get _todayDayOfWeek => DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    if (widget.program == null) {
      return _buildNoProgramView();
    }

    final week = _currentProgramWeek;
    if (week == null) {
      return _buildInvalidWeekView();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Week Selector
            SliverToBoxAdapter(
              child: _buildWeekSelector(),
            ),

            // Progress Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WeekProgressBar(
                  completedWorkouts: _completedDays.length,
                  totalWorkouts: week.scheduledWorkouts,
                ),
              ),
            ),

            // Week Summary
            SliverToBoxAdapter(
              child: _buildWeekSummary(week),
            ),

            // Day Cards
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final dayOfWeek = index + 1;
                    final workout = _getWorkoutForDay(week, dayOfWeek);
                    final isCompleted = _completedDays.contains(dayOfWeek);
                    final isToday = dayOfWeek == _todayDayOfWeek;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DayCard(
                        workout: workout,
                        dayOfWeek: dayOfWeek,
                        isCompleted: isCompleted,
                        isToday: isToday,
                        onTap: () => _handleDayTap(dayOfWeek, workout),
                      ),
                    );
                  },
                  childCount: 7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.program!.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Week $_selectedWeek of ${widget.program!.duration}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () => _navigateToHistory(),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _showOptionsMenu(),
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.program!.weeks.length,
        itemBuilder: (context, index) {
          final weekNumber = index + 1;
          final isSelected = weekNumber == _selectedWeek;
          final isCurrent = weekNumber == widget.currentWeek;

          return GestureDetector(
            onTap: () => _selectWeek(weekNumber),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: isCurrent
                    ? Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'W$weekNumber',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black
                            : Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeekSummary(ProgramWeek week) {
    final totalSets = week.totalSets;
    final totalExercises = week.uniqueExercises.length;
    final avgRPE = week.averageTargetRPE;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context,
              Icons.fitness_center,
              '$totalExercises',
              'Exercises',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context,
              Icons.list,
              '$totalSets',
              'Total Sets',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context,
              Icons.speed,
              avgRPE.toStringAsFixed(1),
              'Avg RPE',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white60,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoProgramView() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Active Program',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select a training program to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/program-selection');
                },
                child: const Text('Browse Programs'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvalidWeekView() {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('Week Dashboard')),
      body: Center(
        child: Text(
          'Invalid week selected',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      ),
    );
  }

  DailyWorkout? _getWorkoutForDay(ProgramWeek week, int dayOfWeek) {
    try {
      return week.workouts.firstWhere(
        (workout) => workout.dayOfWeek == dayOfWeek,
      );
    } catch (e) {
      return null; // Rest day
    }
  }

  void _selectWeek(int weekNumber) {
    setState(() {
      _selectedWeek = weekNumber;
      _completedDays.clear();
      _loadCompletedDays();
    });
  }

  void _handleDayTap(int dayOfWeek, DailyWorkout? workout) {
    if (workout == null) {
      _showRestDayDialog();
      return;
    }

    Navigator.pushNamed(
      context,
      '/workout-logger',
      arguments: {
        'program': widget.program,
        'week': _selectedWeek,
        'day': dayOfWeek,
        'workout': workout,
      },
    );
  }

  void _showRestDayDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Rest Day', style: TextStyle(color: Colors.white)),
        content: const Text(
          'No workout scheduled for this day. Recovery is just as important as training!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // TODO: Reload data from repository
    await Future.delayed(const Duration(seconds: 1));
    _loadCompletedDays();
  }

  void _navigateToHistory() {
    Navigator.pushNamed(context, '/history');
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.white),
              title: const Text('Edit Program',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to program editor
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.white),
              title: const Text('Change Program',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/program-selection');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.white),
              title:
                  const Text('AI Coach', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chat');
              },
            ),
          ],
        ),
      ),
    );
  }
}
