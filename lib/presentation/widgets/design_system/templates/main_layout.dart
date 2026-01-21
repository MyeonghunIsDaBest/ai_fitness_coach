import 'package:flutter/material.dart';
import '../organisms/bottom_navigation.dart';

/// MainLayout - Template for main app screens with bottom navigation
///
/// Provides a consistent layout structure for main app screens including
/// an optional app bar, body content, and bottom navigation.
///
/// Example:
/// ```dart
/// MainLayout(
///   currentIndex: 0,
///   onNavigationChanged: (index) => navigateTo(index),
///   body: HomeContent(),
/// )
/// ```
class MainLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavigationChanged;
  final List<BottomNavItem>? navigationItems;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;

  const MainLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.navigationItems,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
  });

  static const List<BottomNavItem> defaultNavigationItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    BottomNavItem(
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center,
      label: 'Workout',
    ),
    BottomNavItem(
      icon: Icons.event_note_outlined,
      selectedIcon: Icons.event_note,
      label: 'Programs',
    ),
    BottomNavItem(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Progress',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveNavigationItems = navigationItems ?? defaultNavigationItems;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      appBar: appBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: body,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTap: onNavigationChanged,
        items: effectiveNavigationItems,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// MainLayoutWithFAB - Main layout with centered FAB
///
/// Example:
/// ```dart
/// MainLayoutWithFAB(
///   currentIndex: 0,
///   onNavigationChanged: (index) => navigateTo(index),
///   body: HomeContent(),
///   onFABPressed: () => startWorkout(),
/// )
/// ```
class MainLayoutWithFAB extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavigationChanged;
  final VoidCallback? onFABPressed;
  final IconData fabIcon;
  final String? fabLabel;
  final List<BottomNavItem>? navigationItems;
  final PreferredSizeWidget? appBar;

  const MainLayoutWithFAB({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.onFABPressed,
    this.fabIcon = Icons.add,
    this.fabLabel,
    this.navigationItems,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MainLayout(
      currentIndex: currentIndex,
      onNavigationChanged: onNavigationChanged,
      navigationItems: navigationItems,
      appBar: appBar,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: onFABPressed,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: Icon(fabIcon),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/// AdaptiveLayout - Responsive layout for different screen sizes
///
/// Automatically switches between bottom navigation (mobile) and
/// navigation rail (tablet/desktop).
///
/// Example:
/// ```dart
/// AdaptiveLayout(
///   currentIndex: 0,
///   onNavigationChanged: (index) => navigateTo(index),
///   body: HomeContent(),
/// )
/// ```
class AdaptiveLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavigationChanged;
  final List<BottomNavItem>? navigationItems;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final double breakpoint;

  const AdaptiveLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.navigationItems,
    this.appBar,
    this.floatingActionButton,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= breakpoint;
    final effectiveNavigationItems =
        navigationItems ?? MainLayout.defaultNavigationItems;

    if (isWideScreen) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onNavigationChanged,
              labelType: NavigationRailLabelType.all,
              backgroundColor: colorScheme.surface,
              indicatorColor: colorScheme.primaryContainer,
              destinations: effectiveNavigationItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon ?? item.icon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: colorScheme.outlineVariant,
            ),
            Expanded(child: body),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    return MainLayout(
      currentIndex: currentIndex,
      onNavigationChanged: onNavigationChanged,
      navigationItems: effectiveNavigationItems,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
