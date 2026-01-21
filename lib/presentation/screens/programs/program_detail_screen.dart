import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/workout_program.dart';
import '../../widgets/design_system/atoms/atoms.dart';
import '../../widgets/design_system/organisms/organisms.dart';

/// ProgramDetailScreen - Shows full program details and week overview
class ProgramDetailScreen extends ConsumerWidget {
  final String programId;

  const ProgramDetailScreen({
    super.key,
    required this.programId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final programsAsync = ref.watch(availableProgramsProvider);
    final activeProgram = ref.watch(activeProgramProvider);

    return programsAsync.when(
      data: (programs) {
        final program = programs.firstWhere(
          (p) => p.id == programId,
          orElse: () => programs.first,
        );

        final isActive = activeProgram.valueOrNull?.id == program.id;

        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              // Collapsing app bar with program info
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: colorScheme.primary,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    program.name,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                AppBadge(
                                  text: program.sport.displayName,
                                  variant: AppBadgeVariant.primary,
                                ),
                                const SizedBox(width: 8),
                                AppBadge(
                                  text: '${program.durationWeeks} weeks',
                                  variant: AppBadgeVariant.neutral,
                                ),
                                if (isActive) ...[
                                  const SizedBox(width: 8),
                                  const AppBadge(
                                    text: 'Active',
                                    variant: AppBadgeVariant.success,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Program content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      if (program.description.isNotEmpty) ...[
                        Text(
                          program.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Stats row
                      _buildStatsRow(context, colorScheme, textTheme, program),
                      const SizedBox(height: 24),

                      // Week overview
                      Text(
                        'Weekly Schedule',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildWeekSchedule(context, colorScheme, textTheme, program),
                      const SizedBox(height: 24),

                      // Program details
                      Text(
                        'Program Details',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildProgramDetails(context, colorScheme, textTheme, program),
                      const SizedBox(height: 100), // Space for button
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: SafeArea(
              top: false,
              child: isActive
                  ? AppButton.secondary(
                      text: 'Currently Active',
                      onPressed: null,
                      isFullWidth: true,
                    )
                  : AppButton.primary(
                      text: 'Start This Program',
                      onPressed: () => _startProgram(context, ref, program),
                      isFullWidth: true,
                    ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: const Text('Program')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(title: const Text('Program')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading program', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              AppButton.secondary(
                text: 'Go Back',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    WorkoutProgram program,
  ) {
    // Calculate days per week from first week's workouts
    final daysPerWeek = program.weeks.isNotEmpty
        ? program.weeks.first.workouts.length
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatColumn(
            label: 'Duration',
            value: '${program.durationWeeks}',
            unit: 'weeks',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outlineVariant,
          ),
          _StatColumn(
            label: 'Days/Week',
            value: '$daysPerWeek',
            unit: 'days',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outlineVariant,
          ),
          _StatColumn(
            label: 'Type',
            value: program.isCustom ? 'Custom' : 'Template',
            unit: '',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSchedule(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    WorkoutProgram program,
  ) {
    final week = program.weeks.isNotEmpty ? program.weeks.first : null;
    if (week == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'No schedule available',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: week.workouts.map((workout) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: WorkoutCard.compact(
            title: workout.name,
            focus: workout.focus,
            exerciseCount: workout.exercises.length,
            estimatedDuration: workout.estimatedDurationMinutes,
            isCompleted: false,
            isActive: false,
            onTap: () {
              // Could show workout detail
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgramDetails(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    WorkoutProgram program,
  ) {
    final daysPerWeek = program.weeks.isNotEmpty
        ? program.weeks.first.workouts.length
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Sport',
            value: program.sport.displayName,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          Divider(color: colorScheme.outlineVariant, height: 24),
          _DetailRow(
            label: 'Type',
            value: program.isCustom ? 'Custom Program' : 'Template Program',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          Divider(color: colorScheme.outlineVariant, height: 24),
          _DetailRow(
            label: 'Total Weeks',
            value: '${program.durationWeeks}',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          Divider(color: colorScheme.outlineVariant, height: 24),
          _DetailRow(
            label: 'Training Days',
            value: '$daysPerWeek per week',
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Future<void> _startProgram(
    BuildContext context,
    WidgetRef ref,
    WorkoutProgram program,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Program'),
        content: Text(
          'Start "${program.name}"? This will replace your current active program.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final selectProgram = ref.read(selectProgramProvider);
      await selectProgram(program);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Started ${program.name}')),
        );
        context.go('/');
      }
    }
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.unit,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (unit.isNotEmpty)
          Text(
            unit,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
