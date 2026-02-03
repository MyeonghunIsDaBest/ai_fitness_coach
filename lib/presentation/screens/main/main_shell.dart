import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/dashboard/main_dashboard_screen.dart';
import '../programs/programs_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';

// Semi-dark theme colors
const _backgroundColor = Color(0xFF0F172A);
const _navBarColor = Color(0xFF1E293B);
const _navBarBorder = Color(0xFF334155);
const _accentGreen = Color(0xFFB4F04D);
const _accentBlue = Color(0xFF3B82F6);
const _accentCyan = Color(0xFF00D9FF);

/// MainShell - Main app shell with bottom navigation
/// Matches the legacy design with 4 main tabs and center FAB
class MainShell extends ConsumerStatefulWidget {
  final int initialTab;

  const MainShell({super.key, this.initialTab = 0});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  // Keep all tabs in memory for better performance (IndexedStack pattern)
  final List<Widget> _tabs = const [
    MainDashboardScreen(),
    ProgramsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => _showWorkoutOptions(context),
      backgroundColor: _accentGreen,
      foregroundColor: Colors.black,
      elevation: 4,
      child: const Icon(Icons.add, size: 28),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _navBarColor,
        border: Border(
          top: BorderSide(
            color: _navBarBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center,
                label: 'Programs',
                index: 1,
              ),
              // Empty space for FAB
              const SizedBox(width: 56),
              _buildNavItem(
                icon: Icons.trending_up_outlined,
                activeIcon: Icons.trending_up,
                label: 'Progress',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;
    final color = isActive ? _accentGreen : const Color(0xFF94A3B8);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWorkoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: _navBarColor,
          borderRadius: BorderRadius.vertical(
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
                  color: _navBarBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Start Workout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Options
            _buildWorkoutOption(
              context: context,
              icon: Icons.play_circle_outline,
              iconColor: _accentBlue,
              title: "Start Today's Workout",
              subtitle: 'Continue your program',
              onTap: () {
                Navigator.pop(context);
                context.push('/workout');
              },
            ),

            const Divider(color: _navBarBorder, height: 1),

            _buildWorkoutOption(
              context: context,
              icon: Icons.add,
              iconColor: _accentGreen,
              title: 'Quick Workout',
              subtitle: 'Start an empty workout',
              onTap: () {
                Navigator.pop(context);
                context.push('/workout');
              },
            ),

            _buildWorkoutOption(
              context: context,
              icon: Icons.history,
              iconColor: _accentCyan,
              title: 'Repeat Workout',
              subtitle: 'Redo a previous workout',
              onTap: () {
                Navigator.pop(context);
                context.push('/history');
              },
            ),

            _buildWorkoutOption(
              context: context,
              icon: Icons.calendar_view_week,
              iconColor: const Color(0xFF8B5CF6),
              title: 'Week Dashboard',
              subtitle: 'View your weekly schedule',
              onTap: () {
                Navigator.pop(context);
                context.push('/week-dashboard');
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF94A3B8)),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
      onTap: onTap,
    );
  }
}
