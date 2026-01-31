import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/workout_program.dart';
import '../../../domain/models/program_week.dart';
import '../../../domain/models/daily_workout.dart';

// Semi-dark theme colors
const _backgroundColor = Color(0xFF0F172A);
const _cardColor = Color(0xFF1E293B);
const _cardBorder = Color(0xFF334155);
const _accentBlue = Color(0xFF3B82F6);
const _accentGreen = Color(0xFFB4F04D);
const _textPrimary = Color(0xFFE2E8F0);
const _textSecondary = Color(0xFF94A3B8);

/// WeekDashboardScreen - Shows the current week's workouts with day cards
class WeekDashboardScreen extends ConsumerStatefulWidget {
  const WeekDashboardScreen({super.key});

  @override
  ConsumerState<WeekDashboardScreen> createState() => _WeekDashboardScreenState();
}

class _WeekDashboardScreenState extends ConsumerState<WeekDashboardScreen> {
  int _selectedWeek = 1;
  final Set<int> _completedDays = {};

  int get _todayDayOfWeek => DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final programAsync = ref.watch(activeProgramProvider);

    return programAsync.when(
      data: (program) {
        if (program == null) {
          return _buildNoProgramView(textTheme);
        }
        return _buildDashboard(context, textTheme, program);
      },
      loading: () => Scaffold(
        backgroundColor: _backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: _accentBlue),
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
              const SizedBox(height: 16),
              Text('Error loading program', style: textTheme.titleMedium?.copyWith(color: _textPrimary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, TextTheme textTheme, WorkoutProgram program) {
    final week = _selectedWeek <= program.weeks.length
        ? program.weeks[_selectedWeek - 1]
        : null;

    if (week == null) {
      return _buildInvalidWeekView(textTheme);
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(activeProgramProvider);
        },
        color: _accentBlue,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: _backgroundColor,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: textTheme.titleMedium?.copyWith(
                        color: _textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Week $_selectedWeek of ${program.durationWeeks}',
                      style: textTheme.bodySmall?.copyWith(color: _textSecondary),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history, color: _textPrimary),
                  onPressed: () => context.push('/history'),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: _textPrimary),
                  onPressed: () => _showOptionsMenu(context),
                ),
              ],
            ),

            // Week Selector
            SliverToBoxAdapter(
              child: _buildWeekSelector(program),
            ),

            // Progress Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _WeekProgressBar(
                  completedWorkouts: _completedDays.length,
                  totalWorkouts: week.scheduledWorkouts,
                ),
              ),
            ),

            // Week Summary
            SliverToBoxAdapter(
              child: _buildWeekSummary(textTheme, week),
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
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DayCard(
                        workout: workout,
                        dayOfWeek: dayOfWeek,
                        isCompleted: isCompleted,
                        isToday: isToday,
                        onTap: () => _handleDayTap(context, dayOfWeek, workout),
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

  Widget _buildWeekSelector(WorkoutProgram program) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: program.weeks.length,
        itemBuilder: (context, index) {
          final weekNumber = index + 1;
          final isSelected = weekNumber == _selectedWeek;

          return GestureDetector(
            onTap: () => setState(() => _selectedWeek = weekNumber),
            child: Container(
              width: 56,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(colors: [_accentBlue, Color(0xFF8B5CF6)])
                    : null,
                color: isSelected ? null : _cardColor,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: _cardBorder),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'W$weekNumber',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : _textPrimary,
                    ),
                  ),
                  if (weekNumber == 1) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : _accentGreen,
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

  Widget _buildWeekSummary(TextTheme textTheme, ProgramWeek week) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              icon: Icons.fitness_center,
              value: '${week.uniqueExercises.length}',
              label: 'Exercises',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              icon: Icons.format_list_numbered,
              value: '${week.totalSets}',
              label: 'Total Sets',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              icon: Icons.speed,
              value: week.averageTargetRPE.toStringAsFixed(1),
              label: 'Avg RPE',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProgramView(TextTheme textTheme) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 80,
                color: _textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'No Active Program',
                style: textTheme.headlineSmall?.copyWith(
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select a training program to get started',
                style: textTheme.bodyMedium?.copyWith(color: _textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/programs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Browse Programs'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvalidWeekView(TextTheme textTheme) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text('Week Dashboard', style: TextStyle(color: _textPrimary)),
      ),
      body: Center(
        child: Text(
          'Invalid week selected',
          style: textTheme.bodyMedium?.copyWith(color: _textSecondary),
        ),
      ),
    );
  }

  DailyWorkout? _getWorkoutForDay(ProgramWeek week, int dayOfWeek) {
    try {
      return week.workouts.firstWhere((w) => w.dayNumber == dayOfWeek);
    } catch (e) {
      return null;
    }
  }

  void _handleDayTap(BuildContext context, int dayOfWeek, DailyWorkout? workout) {
    if (workout == null) {
      _showRestDayDialog(context);
      return;
    }
    context.push('/workout');
  }

  void _showRestDayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Rest Day', style: TextStyle(color: _textPrimary)),
        content: const Text(
          'No workout scheduled for this day. Recovery is just as important as training!',
          style: TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: _accentBlue)),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: _textPrimary),
              title: const Text('Edit Program', style: TextStyle(color: _textPrimary)),
              onTap: () {
                Navigator.pop(context);
                context.push('/program-editor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: _textPrimary),
              title: const Text('Change Program', style: TextStyle(color: _textPrimary)),
              onTap: () {
                Navigator.pop(context);
                context.go('/programs');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined, color: _textPrimary),
              title: const Text('View Analytics', style: TextStyle(color: _textPrimary)),
              onTap: () {
                Navigator.pop(context);
                context.push('/analytics');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _WeekProgressBar extends StatelessWidget {
  final int completedWorkouts;
  final int totalWorkouts;

  const _WeekProgressBar({
    required this.completedWorkouts,
    required this.totalWorkouts,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalWorkouts > 0 ? completedWorkouts / totalWorkouts : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Progress',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$completedWorkouts / $totalWorkouts workouts',
                style: const TextStyle(color: _textSecondary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(_accentGreen),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: _accentBlue, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: _textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final DailyWorkout? workout;
  final int dayOfWeek;
  final bool isCompleted;
  final bool isToday;
  final VoidCallback? onTap;

  const _DayCard({
    required this.workout,
    required this.dayOfWeek,
    this.isCompleted = false,
    this.isToday = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRestDay = workout == null;

    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday ? _accentBlue : _cardBorder,
          width: isToday ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isRestDay ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                if (isRestDay)
                  _buildRestDay()
                else
                  _buildWorkoutContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getDayName(dayOfWeek),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isToday ? _accentBlue : _textSecondary,
          ),
        ),
        if (isToday)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _accentBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'TODAY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        if (isCompleted)
          const Icon(Icons.check_circle, color: _accentGreen, size: 24),
      ],
    );
  }

  Widget _buildRestDay() {
    return Row(
      children: [
        const Icon(Icons.spa, color: _accentGreen, size: 20),
        const SizedBox(width: 8),
        const Text(
          'Rest Day',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
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
        Text(
          workout!.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildStat(Icons.fitness_center, '$totalExercises exercises'),
            const SizedBox(width: 16),
            _buildStat(Icons.format_list_numbered, '$totalSets sets'),
          ],
        ),
        const SizedBox(height: 12),
        _buildExercisePreview(),
        if (!isCompleted) ...[
          const SizedBox(height: 12),
          _buildActionButton(context),
        ],
      ],
    );
  }

  Widget _buildStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _textSecondary),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
      ],
    );
  }

  Widget _buildExercisePreview() {
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
                decoration: const BoxDecoration(
                  color: _accentBlue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exercise.name,
                  style: TextStyle(fontSize: 13, color: _textPrimary.withOpacity(0.8)),
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
          backgroundColor: isToday ? _accentBlue : _cardBorder,
          foregroundColor: isToday ? Colors.white : _textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          isToday ? 'Start Workout' : 'View Workout',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Color _getCardColor() {
    if (isCompleted) return const Color(0xFF1A3A2A);
    return _cardColor;
  }

  String _getDayName(int dayOfWeek) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dayOfWeek - 1];
  }
}
