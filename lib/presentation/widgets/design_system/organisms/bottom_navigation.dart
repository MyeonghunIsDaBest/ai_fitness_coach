import 'package:flutter/material.dart';
import '../atoms/app_badge.dart';

/// AppBottomNavigation - Organism component for bottom navigation
///
/// A customizable bottom navigation bar that supports badges,
/// custom icons, and various styles.
///
/// Example:
/// ```dart
/// AppBottomNavigation(
///   currentIndex: 0,
///   onTap: (index) => setState(() => _currentIndex = index),
///   items: [
///     BottomNavItem(icon: Icons.home, label: 'Home'),
///     BottomNavItem(icon: Icons.fitness_center, label: 'Workout'),
///     BottomNavItem(icon: Icons.analytics, label: 'Progress'),
///     BottomNavItem(icon: Icons.person, label: 'Profile'),
///   ],
/// )
/// ```
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final bool showLabels;
  final double elevation;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showLabels = true,
    this.elevation = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _NavItem(
                item: item,
                isSelected: isSelected,
                showLabel: showLabels,
                selectedColor: selectedItemColor ?? colorScheme.primary,
                unselectedColor:
                    unselectedItemColor ?? colorScheme.onSurfaceVariant,
                onTap: () => onTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final bool showLabel;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIcon = isSelected ? (item.selectedIcon ?? item.icon) : item.icon;
    final effectiveColor = isSelected ? selectedColor : unselectedColor;

    Widget iconWidget = Icon(effectiveIcon, color: effectiveColor, size: 24);

    // Add badge if needed
    if (item.badgeCount != null && item.badgeCount! > 0) {
      iconWidget = BadgedWidget(
        badge: AppBadge.count(
          count: item.badgeCount!,
          size: AppBadgeSize.small,
        ),
        offset: const EdgeInsets.only(top: -4, right: -8),
        child: iconWidget,
      );
    } else if (item.showBadge) {
      iconWidget = BadgedWidget(
        badge: const AppBadge.dot(),
        offset: const EdgeInsets.only(top: -2, right: -2),
        child: iconWidget,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  color: selectedColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              if (showLabel) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: textTheme.labelSmall?.copyWith(
                    color: effectiveColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation item data
class BottomNavItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final int? badgeCount;
  final bool showBadge;

  const BottomNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount,
    this.showBadge = false,
  });
}

/// FloatingActionNavigation - FAB-style center action button
///
/// Example:
/// ```dart
/// FloatingActionNavigation(
///   icon: Icons.add,
///   onTap: () => startNewWorkout(),
///   label: 'Start Workout',
/// )
/// ```
class FloatingActionNavigation extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool extended;
  final bool mini;

  const FloatingActionNavigation({
    super.key,
    required this.icon,
    this.label,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.extended = false,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onTap,
        backgroundColor: backgroundColor ?? colorScheme.primary,
        foregroundColor: foregroundColor ?? colorScheme.onPrimary,
        icon: Icon(icon),
        label: Text(label!),
      );
    }

    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      mini: mini,
      child: Icon(icon),
    );
  }
}

/// AppNavigationRail - Side navigation for larger screens
///
/// Example:
/// ```dart
/// AppNavigationRail(
///   selectedIndex: 0,
///   onDestinationSelected: (index) => navigateTo(index),
///   destinations: [
///     NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
///   ],
/// )
/// ```
class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationRailDestination> destinations;
  final Widget? leading;
  final Widget? trailing;
  final bool extended;
  final double? minWidth;
  final double? minExtendedWidth;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.leading,
    this.trailing,
    this.extended = false,
    this.minWidth,
    this.minExtendedWidth,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      leading: leading,
      trailing: trailing,
      extended: extended,
      minWidth: minWidth ?? 72,
      minExtendedWidth: minExtendedWidth ?? 200,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      selectedIconTheme: IconThemeData(color: colorScheme.onPrimaryContainer),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      selectedLabelTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
