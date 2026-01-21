import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/design_system/templates/templates.dart';
import '../home/home_screen.dart';
import '../programs/programs_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';

/// MainShell - Main app shell with bottom navigation
///
/// Hosts the primary navigation tabs and manages tab state.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    // Placeholder for workout tab - usually opens workout screen
    _WorkoutPlaceholder(),
    ProgramsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: _currentIndex,
      onNavigationChanged: (index) {
        if (index == 1) {
          // Workout tab - navigate to workout selection or start
          _showWorkoutOptions(context);
        } else {
          setState(() => _currentIndex = index);
        }
      },
      body: IndexedStack(
        index: _currentIndex > 1 ? _currentIndex : _currentIndex,
        children: _screens,
      ),
    );
  }

  void _showWorkoutOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Start Workout',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Options
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.play_circle_outline,
                  color: colorScheme.primary,
                ),
              ),
              title: const Text("Start Today's Workout"),
              subtitle: const Text('Push Day A - 6 exercises'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                // Navigate to workout screen
                Navigator.pushNamed(context, '/workout');
              },
            ),

            const Divider(),

            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add,
                  color: colorScheme.secondary,
                ),
              ),
              title: const Text('Quick Workout'),
              subtitle: const Text('Start an empty workout'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                // Navigate to empty workout
              },
            ),

            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.history,
                  color: colorScheme.tertiary,
                ),
              ),
              title: const Text('Repeat Workout'),
              subtitle: const Text('Redo a previous workout'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                // Navigate to workout history
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Placeholder widget for workout tab in IndexedStack
class _WorkoutPlaceholder extends StatelessWidget {
  const _WorkoutPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
