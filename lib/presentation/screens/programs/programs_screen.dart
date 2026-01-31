import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../core/enums/sport.dart';
import '../../../domain/models/workout_program.dart';

/// ProgramsScreen - Program management and selection screen (Semi-dark theme)
/// Features:
/// - Sport selection tabs with gradient icons
/// - Program cards with sport-specific gradients
/// - Active program progress
/// - Browse available programs
class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Sport? _selectedSport;

  // Semi-dark theme colors
  static const _backgroundColor = Color(0xFF0F172A);
  static const _cardColor = Color(0xFF1E293B);
  static const _cardColorLight = Color(0xFF334155);
  static const _accentBlue = Color(0xFF3B82F6);
  static const _accentGreen = Color(0xFFB4F04D);
  static const _textPrimary = Color(0xFFE2E8F0);
  static const _textSecondary = Color(0xFF94A3B8);

  final List<_SportData> _sports = [
    _SportData(
      sport: Sport.powerlifting,
      name: 'Powerlifting',
      icon: Icons.fitness_center,
      gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFF97316)]),
      description: 'Build maximal strength in squat, bench, and deadlift',
    ),
    _SportData(
      sport: Sport.bodybuilding,
      name: 'Bodybuilding',
      icon: Icons.fitness_center,
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
      description: 'Hypertrophy-focused training for muscle growth',
    ),
    _SportData(
      sport: Sport.crossfit,
      name: 'CrossFit/HYROX',
      icon: Icons.directions_run,
      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF14B8A6)]),
      description: 'Functional fitness and conditioning',
    ),
    _SportData(
      sport: Sport.olympicLifting,
      name: 'Olympic Lifting',
      icon: Icons.fitness_center,
      gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFF97316)]),
      description: 'Master snatch and clean & jerk technique',
    ),
    _SportData(
      sport: Sport.generalFitness,
      name: 'General Fitness',
      icon: Icons.sports_gymnastics,
      gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)]),
      description: 'Balanced strength and conditioning',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveProgram(),
                  _buildBrowsePrograms(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Programs',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: _accentGreen),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: _textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: _accentGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Active'),
          Tab(text: 'Browse'),
        ],
      ),
    );
  }

  Widget _buildActiveProgram() {
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final currentWeek = ref.watch(currentWeekProvider);
    final currentWeekWorkoutsAsync = ref.watch(currentWeekWorkoutsProvider);
    final completedWorkouts = ref.watch(completedWorkoutsProvider);

    return activeProgramAsync.when(
      data: (program) {
        if (program == null) {
          return _buildNoActiveProgram();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActiveProgramCard(program, currentWeek),
              const SizedBox(height: 24),
              _buildWeekProgress(currentWeek, program.weeks.length),
              const SizedBox(height: 24),
              const Text(
                "This Week's Workouts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              currentWeekWorkoutsAsync.when(
                data: (workouts) {
                  if (workouts.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
                      ),
                      child: const Center(
                        child: Text(
                          'No workouts scheduled',
                          style: TextStyle(color: _textSecondary),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: workouts.map((workout) {
                      final isCompleted = completedWorkouts.contains(workout.dayNumber);
                      final isToday = workout.dayNumber == DateTime.now().weekday;
                      return _buildWorkoutCard(
                        workout.name,
                        workout.focus,
                        workout.exercises.length,
                        workout.estimatedDurationMinutes,
                        isCompleted,
                        isToday && !isCompleted,
                        () => context.push('/workout'),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: _accentGreen),
                ),
                error: (_, __) => const Text(
                  'Error loading workouts',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: _accentGreen),
      ),
      error: (_, __) => _buildNoActiveProgram(),
    );
  }

  Widget _buildActiveProgramCard(WorkoutProgram program, int currentWeek) {
    final sportData = _sports.firstWhere(
      (s) => s.sport == program.sport,
      orElse: () => _sports.last,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: sportData.gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: sportData.gradient.colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(sportData.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sportData.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Week $currentWeek',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            program.description ?? sportData.description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildProgramStat(Icons.calendar_today, '${program.weeks.length} weeks'),
              const SizedBox(width: 24),
              _buildProgramStat(
                Icons.fitness_center,
                '${program.weeks.first.workouts.length} days/week',
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Continue Program',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWeekProgress(int currentWeek, int totalWeeks) {
    final progress = currentWeek / totalWeeks;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Program Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                  fontSize: 16,
                ),
              ),
              Text(
                '$currentWeek of $totalWeeks weeks',
                style: const TextStyle(color: _textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _cardColorLight,
              valueColor: const AlwaysStoppedAnimation<Color>(_accentGreen),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
    String title,
    String focus,
    int exerciseCount,
    int duration,
    bool isCompleted,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? _accentGreen : _cardColorLight.withOpacity(0.3),
                width: isActive ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF10B981).withOpacity(0.15)
                        : isActive
                            ? _accentGreen.withOpacity(0.15)
                            : _cardColorLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.fitness_center,
                    color: isCompleted
                        ? const Color(0xFF10B981)
                        : isActive
                            ? _accentGreen
                            : _textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$focus • $exerciseCount exercises • $duration min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _accentGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.chevron_right,
                    color: _textSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoActiveProgram() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _accentGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_outlined,
                size: 56,
                color: _accentGreen,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No Active Program',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Browse our collection of training programs to get started.',
              style: TextStyle(color: _textSecondary, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Browse Programs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowsePrograms() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Sport',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sports.length,
              itemBuilder: (context, index) {
                final sport = _sports[index];
                final isSelected = _selectedSport == sport.sport;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSport = isSelected ? null : sport.sport;
                    });
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? _cardColor : _cardColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? _accentGreen : _cardColorLight.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          sport.icon,
                          color: isSelected ? _accentGreen : _textSecondary,
                          size: 26,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          sport.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? _textPrimary : _textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          _buildProgramsList(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProgramsList() {
    final programsAsync = ref.watch(programsBySportProvider(_selectedSport));

    return programsAsync.when(
      data: (programs) {
        if (programs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: _textSecondary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'No programs available',
                    style: TextStyle(color: _textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        final sportData = _selectedSport != null
            ? _sports.firstWhere((s) => s.sport == _selectedSport)
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sportData != null) ...[
              _buildSelectedSportCard(sportData),
              const SizedBox(height: 24),
            ],
            Text(
              'Available Programs (${programs.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...programs.map((program) => _buildProgramPreviewCard(program)),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: _accentGreen),
      ),
      error: (error, _) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }

  Widget _buildSelectedSportCard(_SportData sport) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardColorLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: sport.gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(sport.icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sport.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  sport.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramPreviewCard(WorkoutProgram program) {
    final sportData = _sports.firstWhere(
      (s) => s.sport == program.sport,
      orElse: () => _sports.last,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/program/${program.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardColorLight.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: sportData.gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(sportData.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${program.weeks.length} weeks • ${sportData.name}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectProgram(program),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectProgram(WorkoutProgram program) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Start ${program.name}?',
          style: const TextStyle(color: _textPrimary),
        ),
        content: Text(
          'This will set ${program.name} as your active program.',
          style: const TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentGreen,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Start Program'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        final selectProgram = ref.read(selectProgramProvider);
        await selectProgram(program);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Started ${program.name}'),
              backgroundColor: _cardColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          _tabController.animateTo(0);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}

class _SportData {
  final Sport sport;
  final String name;
  final IconData icon;
  final LinearGradient gradient;
  final String description;

  _SportData({
    required this.sport,
    required this.name,
    required this.icon,
    required this.gradient,
    required this.description,
  });
}
