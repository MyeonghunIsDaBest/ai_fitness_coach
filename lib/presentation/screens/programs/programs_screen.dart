import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../core/enums/sport.dart';
import '../../../domain/models/workout_program.dart';
import '../../widgets/design_system/atoms/atoms.dart';
import '../../widgets/design_system/molecules/molecules.dart';
import '../../widgets/design_system/organisms/organisms.dart';

/// ProgramsScreen - Program management and selection screen
///
/// Displays available programs, active program progress,
/// and program creation options.
class ProgramsScreen extends ConsumerStatefulWidget {
  const ProgramsScreen({super.key});

  @override
  ConsumerState<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends ConsumerState<ProgramsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  Sport? _selectedSport;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        children: [
          // Header
          _buildHeader(colorScheme, textTheme),

          // Tab bar
          _buildTabBar(colorScheme),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveProgram(colorScheme, textTheme),
                _buildBrowsePrograms(colorScheme, textTheme),
                _buildMyPrograms(colorScheme, textTheme),
              ],
            ),
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
            children: [
              Expanded(
                child: Text(
                  'Programs',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppButton.icon(
                icon: Icons.add,
                onPressed: () {
                  // Navigate to create program
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppSearchBar(
            hint: 'Search programs...',
            onChanged: (query) => setState(() => _searchQuery = query),
            onFilterTap: () => _showFilterSheet(context),
            showFilter: true,
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Sport',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChip.choice(
                  label: 'All',
                  selected: _selectedSport == null,
                  onTap: () {
                    setState(() => _selectedSport = null);
                    Navigator.pop(context);
                  },
                ),
                ...Sport.values.map((sport) => AppChip.choice(
                      label: sport.displayName,
                      selected: _selectedSport == sport,
                      onTap: () {
                        setState(() => _selectedSport = sport);
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorColor: colorScheme.primary,
        tabs: const [
          Tab(text: 'Active'),
          Tab(text: 'Browse'),
          Tab(text: 'My Programs'),
        ],
      ),
    );
  }

  Widget _buildActiveProgram(ColorScheme colorScheme, TextTheme textTheme) {
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final currentWeek = ref.watch(currentWeekProvider);
    final currentWeekWorkoutsAsync = ref.watch(currentWeekWorkoutsProvider);
    final completedWorkouts = ref.watch(completedWorkoutsProvider);
    final selectedDay = ref.watch(selectedDayProvider);

    return activeProgramAsync.when(
      data: (program) {
        if (program == null) {
          return _buildNoActiveProgram(colorScheme, textTheme);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current program
              ProgramCard(
                name: program.name,
                sport: program.sport.displayName,
                description: program.description,
                weeksTotal: program.weeks.length,
                weeksCompleted: currentWeek - 1,
                isActive: true,
                onTap: () {},
                onStart: () {
                  // Navigate to today's workout
                },
              ),
              const SizedBox(height: 24),

              // Week selector
              SectionHeader(
                title: 'Week Overview',
                action: TextButton(
                  onPressed: () {},
                  child: const Text('Calendar'),
                ),
              ),
              const SizedBox(height: 12),
              WorkoutDaySelector(
                selectedDay: selectedDay - 1,
                completedDays: completedWorkouts,
                restDays: const {},
                onDaySelected: (day) {
                  ref.read(selectedDayProvider.notifier).state = day + 1;
                },
              ),
              const SizedBox(height: 24),

              // Week details
              SectionHeader(
                title: 'Week $currentWeek - ${program.getWeek(currentWeek)?.phase.displayName ?? "Training"}',
              ),
              const SizedBox(height: 12),
              currentWeekWorkoutsAsync.when(
                data: (workouts) {
                  if (workouts.isEmpty) {
                    return const Text('No workouts scheduled for this week');
                  }
                  return Column(
                    children: workouts.map((workout) {
                      final isCompleted = completedWorkouts.contains(workout.dayNumber);
                      final isToday = workout.dayNumber == DateTime.now().weekday;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: WorkoutCard.compact(
                          title: workout.name,
                          focus: workout.focus,
                          exerciseCount: workout.exercises.length,
                          estimatedDuration: workout.estimatedDurationMinutes,
                          isCompleted: isCompleted,
                          isActive: isToday && !isCompleted,
                          onTap: () {
                            // Navigate to workout detail
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading workouts'),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => _buildNoActiveProgram(colorScheme, textTheme),
    );
  }

  Widget _buildNoActiveProgram(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 64,
              color: colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Program',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse our collection of training programs or create your own to get started.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton.primary(
              text: 'Browse Programs',
              onPressed: () {
                _tabController.animateTo(1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowsePrograms(ColorScheme colorScheme, TextTheme textTheme) {
    final programsAsync = ref.watch(programsBySportProvider(_selectedSport));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sport filter chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppChip.choice(
                label: 'All',
                selected: _selectedSport == null,
                onTap: () => setState(() => _selectedSport = null),
              ),
              ...Sport.values.map((sport) => AppChip.choice(
                    label: sport.displayName,
                    selected: _selectedSport == sport,
                    onTap: () => setState(() => _selectedSport = sport),
                  )),
            ],
          ),
          const SizedBox(height: 24),

          // Programs list
          programsAsync.when(
            data: (programs) {
              final filtered = _searchQuery.isEmpty
                  ? programs
                  : programs.where((p) =>
                      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      p.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No programs found',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Available Programs (${filtered.length})'),
                  const SizedBox(height: 12),
                  ...filtered.map((program) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProgramCard.preview(
                          name: program.name,
                          sport: program.sport.displayName,
                          description: program.description ?? '',
                          weeksTotal: program.weeks.length,
                          onStart: () => _selectProgram(program),
                        ),
                      )),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('Error loading programs: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectProgram(WorkoutProgram program) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start ${program.name}?'),
        content: Text(
          'This will set ${program.name} as your active program. '
          'Your current program (if any) will be deactivated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
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
            SnackBar(content: Text('Started ${program.name}')),
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

  Widget _buildMyPrograms(ColorScheme colorScheme, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create new program card
          ActionCard(
            title: 'Create Custom Program',
            description: 'Design your own training program from scratch',
            icon: Icons.add_circle_outline,
            iconColor: colorScheme.primary,
            primaryAction: AppButton.primary(
              text: 'Create',
              onPressed: () {
                // Navigate to program builder
              },
              size: AppButtonSize.small,
            ),
          ),
          const SizedBox(height: 24),

          // Custom programs section
          SectionHeader(title: 'My Custom Programs'),
          const SizedBox(height: 12),

          // Placeholder for custom programs
          AppCard.outlined(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No custom programs yet',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create your first custom program above',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension to display sport names nicely
extension SportDisplay on Sport {
  String get displayName {
    switch (this) {
      case Sport.powerlifting:
        return 'Powerlifting';
      case Sport.bodybuilding:
        return 'Bodybuilding';
      case Sport.crossfit:
        return 'CrossFit';
      case Sport.olympicLifting:
        return 'Olympic Lifting';
      case Sport.generalFitness:
        return 'General Fitness';
    }
  }
}
