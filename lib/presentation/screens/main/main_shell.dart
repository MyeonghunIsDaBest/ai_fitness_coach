import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../home/home_screen.dart';
import '../programs/programs_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';

/// MainShell - Main app shell with bottom navigation
/// Matches the legacy design with 4 main tabs and center FAB
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  // Keep all tabs in memory for better performance (IndexedStack pattern)
  final List<Widget> _tabs = const [
    HomeScreen(),
    ProgramsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
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
      backgroundColor: const Color(0xFFB4F04D),
      foregroundColor: Colors.black,
      elevation: 4,
      child: const Icon(Icons.add, size: 28),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade800,
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
    final color = isActive ? const Color(0xFFB4F04D) : Colors.grey;

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
          color: Color(0xFF1E1E1E),
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
                  color: Colors.grey.shade700,
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
              iconColor: const Color(0xFF3b82f6),
              title: "Start Today's Workout",
              subtitle: 'Continue your program',
              onTap: () {
                Navigator.pop(context);
                context.push('/workout');
              },
            ),

            Divider(color: Colors.grey.shade800, height: 1),

            _buildWorkoutOption(
              context: context,
              icon: Icons.add,
              iconColor: const Color(0xFFB4F04D),
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
              iconColor: const Color(0xFF00D9FF),
              title: 'Repeat Workout',
              subtitle: 'Redo a previous workout',
              onTap: () {
                Navigator.pop(context);
                context.push('/history');
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
        style: TextStyle(color: Colors.grey.shade400),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
      onTap: onTap,
    );
  }
}
