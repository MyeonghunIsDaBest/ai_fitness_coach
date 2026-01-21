import 'package:flutter/material.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../services/workout_session_service.dart';
import '../../services/rpe_feedback_service.dart';
import '../workout/workout_logger_screen.dart';

/// Enhanced Week dashboard with progress tracking and better UX
/// NOW WITH: Service injection for workout logging
class WeekDashboardScreen extends StatefulWidget {
  final WorkoutProgram? program;
  final WorkoutSessionService sessionService;
  final RPEFeedbackService rpeService;

  const WeekDashboardScreen({
    Key? key,
    this.program,
    required this.sessionService,
    required this.rpeService,
  }) : super(key: key);

  @override
  State<WeekDashboardScreen> createState() => _WeekDashboardScreenState();
}

class _WeekDashboardScreenState extends State<WeekDashboardScreen> {
  int currentWeekNumber = 1;
  ProgramWeek? currentWeek;
  bool isLoading = false;
  String? errorMessage;

  // Track completed workouts (in production, load from storage)
  Set<String> completedWorkoutIds = {};

  // Track current week start date
  DateTime? weekStartDate;

  @override
  void initState() {
    super.initState();
    _loadCurrentWeek();
    _loadUserProgress();
  }

  Future<void> _loadCurrentWeek() async {
    if (widget.program == null) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        currentWeek = widget.program!.getWeek(currentWeekNumber);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load week data';
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserProgress() async {
    setState(() {
      completedWorkoutIds = {};
      weekStartDate = _getWeekStartDate();
    });
  }

  DateTime _getWeekStartDate() {
    final now = DateTime.now();
    final weeksSinceStart = currentWeekNumber - 1;
    return now
        .subtract(Duration(days: now.weekday - 1 + (weeksSinceStart * 7)));
  }

  void _changeWeek(int newWeekNumber) {
    if (widget.program == null) return;
    if (newWeekNumber < 1 || newWeekNumber > widget.program!.totalWeeks) {
      return;
    }

    setState(() {
      currentWeekNumber = newWeekNumber;
      isLoading = true;
    });

    _loadCurrentWeek();
  }

  bool _isWorkoutCompleted(DailyWorkout workout) {
    return completedWorkoutIds.contains(workout.id);
  }

  void _toggleWorkoutCompletion(DailyWorkout workout) {
    setState(() {
      if (completedWorkoutIds.contains(workout.id)) {
        completedWorkoutIds.remove(workout.id);
      } else {
        completedWorkoutIds.add(workout.id);
      }
    });
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    // TODO: Implement actual persistence via repository
  }

  int get completedWorkoutsCount {
    return currentWeek?.dailyWorkouts
            .where((w) => !w.isRestDay && _isWorkoutCompleted(w))
            .length ??
        0;
  }

  int get totalTrainingDays {
    return currentWeek?.trainingDaysCount ?? 0;
  }

  double get weekProgress {
    if (totalTrainingDays == 0) return 0;
    return completedWorkoutsCount / totalTrainingDays;
  }

  bool get isCurrentWeek {
    return currentWeekNumber == 1; // Simplified
  }

  @override
  Widget build(BuildContext context) {
    if (widget.program == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Week Dashboard'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Text(
                'No program selected',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Select a program to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4F04D),
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/program-selection');
                },
                child: const Text('Select Program'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.program!.name,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Week $currentWeekNumber of ${widget.program!.totalWeeks}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white60,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showProgramInfo(),
          ),
        ],
      ),
      body: errorMessage != null
          ? _buildErrorState()
          : isLoading
              ? _buildLoadingState()
              : _buildWeekContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB4F04D),
              foregroundColor: Colors.black,
            ),
            onPressed: () => _loadCurrentWeek(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFB4F04D),
      ),
    );
  }

  Widget _buildWeekContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekHeader(),
          _buildWeekProgress(),
          _buildWeekNavigation(),
          _buildWeekStats(),
          const SizedBox(height: 16),
          _buildWorkoutsList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWeekProgress() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFB4F04D).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Week Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completedWorkoutsCount / $totalTrainingDays',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB4F04D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: weekProgress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFB4F04D)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(weekProgress * 100).toStringAsFixed(0)}% Complete',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(currentWeek!.phase.colorValue).withOpacity(0.3),
            Color(currentWeek!.phase.colorValue).withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Color(currentWeek!.phase.colorValue).withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(currentWeek!.phase.colorValue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentWeek!.phase.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (currentWeek!.isDeload)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Deload Week',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              if (isCurrentWeek)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4F04D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Current Week',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Week $currentWeekNumber',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          if (weekStartDate != null)
            Text(
              _getWeekDateRange(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            currentWeek!.intensityRange,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          if (currentWeek!.coachNotes != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: Color(0xFFFFE66D),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentWeek!.coachNotes!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getWeekDateRange() {
    if (weekStartDate == null) return '';

    final endDate = weekStartDate!.add(const Duration(days: 6));
    final startMonth = _getMonthAbbr(weekStartDate!.month);
    final endMonth = _getMonthAbbr(endDate.month);

    if (weekStartDate!.month == endDate.month) {
      return '$startMonth ${weekStartDate!.day} - ${endDate.day}';
    } else {
      return '$startMonth ${weekStartDate!.day} - $endMonth ${endDate.day}';
    }
  }

  String _getMonthAbbr(int month) {
    const months = [
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
    return months[month - 1];
  }

  Widget _buildWeekNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: currentWeekNumber > 1
                ? () => _changeWeek(currentWeekNumber - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            color: currentWeekNumber > 1
                ? const Color(0xFFB4F04D)
                : Colors.white30,
          ),
          Text(
            'Week $currentWeekNumber / ${widget.program!.totalWeeks}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: currentWeekNumber < widget.program!.totalWeeks
                ? () => _changeWeek(currentWeekNumber + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: currentWeekNumber < widget.program!.totalWeeks
                ? const Color(0xFFB4F04D)
                : Colors.white30,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Training Days',
              '${currentWeek!.trainingDaysCount}',
              Icons.fitness_center,
              const Color(0xFF4ECDC4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Sets',
              '${currentWeek!.totalSets}',
              Icons.format_list_numbered,
              const Color(0xFFFFE66D),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Rest Days',
              '${currentWeek!.restDaysCount}',
              Icons.spa,
              const Color(0xFF95E1D3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workouts This Week',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...currentWeek!.dailyWorkouts.asMap().entries.map((entry) {
            final index = entry.key;
            final workout = entry.value;
            final dayDate = weekStartDate?.add(Duration(days: index));
            return _buildWorkoutCard(workout, dayDate);
          }),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(DailyWorkout workout, DateTime? date) {
    final isCompleted = _isWorkoutCompleted(workout);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFFB4F04D).withOpacity(0.5)
              : workout.isRestDay
                  ? const Color(0xFF95E1D3).withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: workout.isRestDay
          ? _buildRestDayContent(workout, date, isCompleted)
          : _buildTrainingDayContent(workout, date, isCompleted),
    );
  }

  Widget _buildRestDayContent(
      DailyWorkout workout, DateTime? date, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF95E1D3).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.spa,
              color: Color(0xFF95E1D3),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      workout.dayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (date != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• ${_getMonthAbbr(date.month)} ${date.day}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rest & Recovery',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? const Color(0xFFB4F04D) : Colors.white30,
            ),
            onPressed: () => _toggleWorkoutCompletion(workout),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingDayContent(
      DailyWorkout workout, DateTime? date, bool isCompleted) {
    return InkWell(
      onTap: () => _startWorkout(workout),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFB4F04D).withOpacity(0.3)
                    : const Color(0xFFB4F04D).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.fitness_center,
                color: const Color(0xFFB4F04D),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        workout.dayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted
                              ? Colors.white.withOpacity(0.6)
                              : Colors.white,
                        ),
                      ),
                      if (date != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${_getMonthAbbr(date.month)} ${date.day}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workout.focus,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${workout.exerciseCount} exercises • ${workout.durationDisplay}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white30,
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ NEW: Navigate to workout logger with services
  void _startWorkout(DailyWorkout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutLoggerScreen(
          workout: workout,
          programId: widget.program!.id,
          weekNumber: currentWeekNumber,
          targetRPEMin: currentWeek!.targetRPEMin,
          targetRPEMax: currentWeek!.targetRPEMax,
          sessionService: widget.sessionService,
          rpeService: widget.rpeService,
        ),
      ),
    ).then((_) {
      // Refresh progress when returning from workout
      _loadUserProgress();
    });
  }

  void _showProgramInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(widget.program!.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.program!.description),
            const SizedBox(height: 16),
            _buildInfoRow('Duration', '${widget.program!.totalWeeks} weeks'),
            _buildInfoRow(
                'Training Days', '${widget.program!.totalTrainingDays}'),
            _buildInfoRow('Total Sets', '${widget.program!.totalSets}'),
            const SizedBox(height: 12),
            Text(
              'Progress: $completedWorkoutsCount workouts completed',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFB4F04D),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFB4F04D)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
