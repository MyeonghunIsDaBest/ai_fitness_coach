import 'package:flutter/material.dart';
import '../atoms/app_badge.dart';

/// NavigationItem - Molecule component for navigation elements
///
/// A versatile navigation item that supports icons, labels, badges,
/// and selection states for bottom navigation, drawers, and menus.
///
/// Example:
/// ```dart
/// NavigationItem(
///   icon: Icons.home_outlined,
///   selectedIcon: Icons.home,
///   label: 'Home',
///   isSelected: true,
///   onTap: () => navigateToHome(),
/// )
/// ```
class NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool isSelected;
  final int? badgeCount;
  final bool showBadge;
  final VoidCallback? onTap;
  final NavigationItemLayout layout;

  const NavigationItem({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.isSelected = false,
    this.badgeCount,
    this.showBadge = false,
    this.onTap,
    this.layout = NavigationItemLayout.vertical,
  });

  /// Bottom navigation style
  const NavigationItem.bottom({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.isSelected = false,
    this.badgeCount,
    this.showBadge = false,
    this.onTap,
  }) : layout = NavigationItemLayout.vertical;

  /// Rail navigation style
  const NavigationItem.rail({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.isSelected = false,
    this.badgeCount,
    this.showBadge = false,
    this.onTap,
  }) : layout = NavigationItemLayout.vertical;

  /// Drawer navigation style
  const NavigationItem.drawer({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.isSelected = false,
    this.badgeCount,
    this.showBadge = false,
    this.onTap,
  }) : layout = NavigationItemLayout.horizontal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (layout == NavigationItemLayout.horizontal) {
      return _buildHorizontal(colorScheme, textTheme);
    }

    return _buildVertical(colorScheme, textTheme);
  }

  Widget _buildVertical(ColorScheme colorScheme, TextTheme textTheme) {
    final effectiveIcon = isSelected ? (selectedIcon ?? icon) : icon;
    final color = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconWithBadge(effectiveIcon, color, colorScheme),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal(ColorScheme colorScheme, TextTheme textTheme) {
    final effectiveIcon = isSelected ? (selectedIcon ?? icon) : icon;
    final color = isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    final backgroundColor = isSelected
        ? colorScheme.primary.withOpacity(0.1)
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildIconWithBadge(effectiveIcon, color, colorScheme),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (badgeCount != null && badgeCount! > 0)
                AppBadge.count(count: badgeCount!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithBadge(IconData iconData, Color color, ColorScheme colorScheme) {
    Widget iconWidget = Icon(iconData, color: color, size: 24);

    if (showBadge || (badgeCount != null && badgeCount! > 0)) {
      return BadgedWidget(
        badge: badgeCount != null && badgeCount! > 0
            ? AppBadge.count(
                count: badgeCount!,
                size: AppBadgeSize.small,
              )
            : const AppBadge.dot(),
        offset: const EdgeInsets.only(top: -4, right: -4),
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}

enum NavigationItemLayout { vertical, horizontal }

/// NavigationGroup - Group of navigation items
///
/// Example:
/// ```dart
/// NavigationGroup(
///   title: 'Training',
///   items: [
///     NavigationItem.drawer(icon: Icons.fitness_center, label: 'Workouts'),
///     NavigationItem.drawer(icon: Icons.event, label: 'Programs'),
///   ],
/// )
/// ```
class NavigationGroup extends StatelessWidget {
  final String? title;
  final List<NavigationItem> items;
  final EdgeInsetsGeometry? padding;

  const NavigationGroup({
    super.key,
    this.title,
    required this.items,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                title!.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
          ...items,
        ],
      ),
    );
  }
}

/// TabItem - Tab bar item component
///
/// Example:
/// ```dart
/// TabItem(
///   label: 'Overview',
///   isSelected: true,
///   onTap: () => switchTab(0),
/// )
/// ```
class TabItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const TabItem({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
