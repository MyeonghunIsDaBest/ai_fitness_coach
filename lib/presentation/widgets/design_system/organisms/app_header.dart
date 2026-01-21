import 'package:flutter/material.dart';
import '../atoms/app_badge.dart';

/// AppHeader - Organism component for screen headers
///
/// A flexible header component that supports various configurations
/// for app bars, navigation headers, and section headers.
///
/// Example:
/// ```dart
/// AppHeader(
///   title: 'Workout',
///   subtitle: 'Push Day A',
///   leading: BackButton(),
///   actions: [IconButton(...)],
/// )
/// ```
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showDivider;
  final Color? backgroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  const AppHeader({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.showDivider = false,
    this.backgroundColor,
    this.elevation = 0,
    this.onBackPressed,
    this.bottom,
  });

  /// Simple header with back button
  factory AppHeader.withBack({
    Key? key,
    required String title,
    String? subtitle,
    List<Widget>? actions,
    required VoidCallback onBackPressed,
    bool centerTitle = false,
  }) {
    return AppHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      actions: actions,
      centerTitle: centerTitle,
      onBackPressed: onBackPressed,
    );
  }

  /// Transparent header for overlay use
  const AppHeader.transparent({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = false,
    this.onBackPressed,
    this.bottom,
  })  : showDivider = false,
        backgroundColor = Colors.transparent,
        elevation = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && onBackPressed != null) {
      effectiveLeading = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
        tooltip: 'Back',
      );
    }

    Widget? effectiveTitle = titleWidget;
    if (effectiveTitle == null && title != null) {
      effectiveTitle = Column(
        crossAxisAlignment:
            centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title!,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );
    }

    return AppBar(
      leading: effectiveLeading,
      title: effectiveTitle,
      centerTitle: centerTitle,
      actions: actions,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      elevation: elevation,
      scrolledUnderElevation: elevation,
      bottom: bottom ??
          (showDivider
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Divider(
                    height: 1,
                    color: colorScheme.outlineVariant,
                  ),
                )
              : null),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}

/// SectionHeader - Header for content sections
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: 'Recent Workouts',
///   action: TextButton(child: Text('See All'), onPressed: ...),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? action;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// ProfileHeader - User profile header component
///
/// Example:
/// ```dart
/// ProfileHeader(
///   name: 'John Doe',
///   subtitle: 'Intermediate Powerlifter',
///   avatarUrl: 'https://...',
///   onTap: () => navigateToProfile(),
/// )
/// ```
class ProfileHeader extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final IconData? avatarIcon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final int? notificationCount;

  const ProfileHeader({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.avatarIcon,
    this.onTap,
    this.trailing,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null
                  ? Icon(
                      avatarIcon ?? Icons.person,
                      color: colorScheme.onPrimaryContainer,
                      size: 28,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing or notification badge
            if (trailing != null)
              trailing!
            else if (notificationCount != null && notificationCount! > 0)
              BadgedWidget(
                badge: AppBadge.count(count: notificationCount!),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

/// PageHeader - Full-width header for pages
///
/// Example:
/// ```dart
/// PageHeader(
///   title: 'Good Morning!',
///   subtitle: 'Ready for today\'s workout?',
///   backgroundGradient: true,
/// )
/// ```
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showGradient;
  final List<Color>? gradientColors;
  final double? height;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showGradient = false,
    this.gradientColors,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget content = Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (showGradient) {
      final colors = gradientColors ??
          [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.surface,
          ];

      return Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: content,
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: content,
    );
  }
}
