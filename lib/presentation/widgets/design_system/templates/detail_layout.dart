import 'package:flutter/material.dart';
import '../organisms/app_header.dart';

/// DetailLayout - Template for detail/sub-screens
///
/// Provides a consistent layout for detail screens with back navigation,
/// optional actions, and scrollable content.
///
/// Example:
/// ```dart
/// DetailLayout(
///   title: 'Exercise Details',
///   onBack: () => Navigator.pop(context),
///   body: ExerciseContent(),
/// )
/// ```
class DetailLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final Widget body;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomBar;
  final bool showDivider;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const DetailLayout({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    required this.body,
    this.onBack,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomBar,
    this.showDivider = false,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      appBar: AppHeader(
        title: title,
        subtitle: subtitle,
        titleWidget: titleWidget,
        onBackPressed: onBack ?? () => Navigator.of(context).pop(),
        actions: actions,
        showDivider: showDivider,
        bottom: bottom,
      ),
      body: body,
      bottomNavigationBar: bottomBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// DetailLayoutWithActions - Detail layout with bottom action bar
///
/// Example:
/// ```dart
/// DetailLayoutWithActions(
///   title: 'Edit Exercise',
///   body: EditForm(),
///   primaryAction: AppButton.primary(text: 'Save', onPressed: save),
///   secondaryAction: AppButton.secondary(text: 'Cancel', onPressed: cancel),
/// )
/// ```
class DetailLayoutWithActions extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget body;
  final VoidCallback? onBack;
  final List<Widget>? headerActions;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Color? backgroundColor;

  const DetailLayoutWithActions({
    super.key,
    this.title,
    this.subtitle,
    required this.body,
    this.onBack,
    this.headerActions,
    this.primaryAction,
    this.secondaryAction,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget? bottomBar;
    if (primaryAction != null || secondaryAction != null) {
      bottomBar = Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              if (secondaryAction != null) Expanded(child: secondaryAction!),
              if (secondaryAction != null && primaryAction != null)
                const SizedBox(width: 12),
              if (primaryAction != null)
                Expanded(flex: secondaryAction != null ? 1 : 0, child: primaryAction!),
            ],
          ),
        ),
      );
    }

    return DetailLayout(
      title: title,
      subtitle: subtitle,
      body: body,
      onBack: onBack,
      actions: headerActions,
      bottomBar: bottomBar,
      backgroundColor: backgroundColor,
    );
  }
}

/// ScrollableDetailLayout - Detail layout with scrollable content and sticky header
///
/// Example:
/// ```dart
/// ScrollableDetailLayout(
///   title: 'Workout Details',
///   headerContent: WorkoutSummaryCard(),
///   slivers: [
///     SliverList(delegate: SliverChildListDelegate(exerciseCards)),
///   ],
/// )
/// ```
class ScrollableDetailLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? headerContent;
  final List<Widget> slivers;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final Color? backgroundColor;
  final double? expandedHeight;
  final bool stretch;

  const ScrollableDetailLayout({
    super.key,
    this.title,
    this.subtitle,
    this.headerContent,
    required this.slivers,
    this.onBack,
    this.actions,
    this.floatingActionButton,
    this.bottomBar,
    this.backgroundColor,
    this.expandedHeight,
    this.stretch = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: headerContent != null
                ? (expandedHeight ?? 200)
                : null,
            stretch: stretch,
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            ),
            actions: actions,
            flexibleSpace: headerContent != null
                ? FlexibleSpaceBar(
                    title: title != null
                        ? Text(
                            title!,
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                    background: headerContent,
                    collapseMode: CollapseMode.parallax,
                  )
                : null,
            title: headerContent == null && title != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title!,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  )
                : null,
          ),
          ...slivers,
        ],
      ),
      bottomNavigationBar: bottomBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// ModalLayout - Template for modal/bottom sheet content
///
/// Example:
/// ```dart
/// ModalLayout(
///   title: 'Select Exercise',
///   body: ExerciseList(),
///   onClose: () => Navigator.pop(context),
/// )
/// ```
class ModalLayout extends StatelessWidget {
  final String? title;
  final Widget body;
  final VoidCallback? onClose;
  final List<Widget>? actions;
  final Widget? bottomAction;
  final bool showHandle;
  final bool showCloseButton;
  final double? maxHeight;

  const ModalLayout({
    super.key,
    this.title,
    required this.body,
    this.onClose,
    this.actions,
    this.bottomAction,
    this.showHandle = true,
    this.showCloseButton = true,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : null,
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
          if (showHandle)
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
          if (title != null || showCloseButton || actions != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (actions != null) ...actions!,
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),

          // Body
          Flexible(child: body),

          // Bottom action
          if (bottomAction != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: bottomAction,
              ),
            ),
        ],
      ),
    );
  }
}
