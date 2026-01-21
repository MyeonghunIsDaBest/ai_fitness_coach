import 'package:flutter/material.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';

/// ActionCard - Molecule component for cards with action buttons
///
/// Combines AppCard with action buttons for interactive content.
/// Follows atomic design principles with full theme integration.
///
/// Example:
/// ```dart
/// ActionCard(
///   title: 'Start Workout',
///   description: 'Begin your scheduled training session',
///   icon: Icons.fitness_center,
///   primaryAction: AppButton.primary(
///     text: 'Start',
///     onPressed: () {},
///   ),
/// )
/// ```
class ActionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const ActionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.iconColor,
    this.primaryAction,
    this.secondaryAction,
    this.onTap,
    this.padding,
    this.showDivider = true,
  });

  /// Quick action card with single button
  const ActionCard.quick({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.iconColor,
    required this.primaryAction,
    this.onTap,
    this.padding,
  })  : secondaryAction = null,
        showDivider = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard.outlined(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (primaryAction != null || secondaryAction != null) ...[
            if (showDivider)
              Divider(
                height: 1,
                color: colorScheme.outlineVariant,
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (secondaryAction != null) ...[
                    secondaryAction!,
                    const SizedBox(width: 8),
                  ],
                  if (primaryAction != null) primaryAction!,
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ConfirmationCard - Card with confirm/cancel actions
///
/// Example:
/// ```dart
/// ConfirmationCard(
///   title: 'Delete Exercise?',
///   description: 'This action cannot be undone.',
///   onConfirm: () => deleteExercise(),
///   onCancel: () => Navigator.pop(context),
///   confirmText: 'Delete',
///   isDestructive: true,
/// )
/// ```
class ConfirmationCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final bool isLoading;

  const ConfirmationCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard.elevated(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isDestructive ? colorScheme.error : colorScheme.primary)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? colorScheme.error : colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  text: cancelText,
                  onPressed: onCancel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  text: confirmText,
                  onPressed: isLoading ? null : onConfirm,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// InfoCard - Informational card with optional action
///
/// Example:
/// ```dart
/// InfoCard(
///   title: 'Pro Tip',
///   message: 'Rest 2-3 minutes between heavy sets',
///   type: InfoCardType.tip,
/// )
/// ```
enum InfoCardType { info, success, warning, error, tip }

class InfoCard extends StatelessWidget {
  final String title;
  final String message;
  final InfoCardType type;
  final VoidCallback? onDismiss;
  final Widget? action;

  const InfoCard({
    super.key,
    required this.title,
    required this.message,
    this.type = InfoCardType.info,
    this.onDismiss,
    this.action,
  });

  const InfoCard.tip({
    super.key,
    required this.title,
    required this.message,
    this.onDismiss,
    this.action,
  }) : type = InfoCardType.tip;

  const InfoCard.success({
    super.key,
    required this.title,
    required this.message,
    this.onDismiss,
    this.action,
  }) : type = InfoCardType.success;

  const InfoCard.warning({
    super.key,
    required this.title,
    required this.message,
    this.onDismiss,
    this.action,
  }) : type = InfoCardType.warning;

  const InfoCard.error({
    super.key,
    required this.title,
    required this.message,
    this.onDismiss,
    this.action,
  }) : type = InfoCardType.error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final (color, icon) = _getTypeAttributes(colorScheme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 12),
                  action!,
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }

  (Color, IconData) _getTypeAttributes(ColorScheme colorScheme) {
    switch (type) {
      case InfoCardType.success:
        return (const Color(0xFF4ECDC4), Icons.check_circle_outline);
      case InfoCardType.warning:
        return (const Color(0xFFFFE66D), Icons.warning_amber_outlined);
      case InfoCardType.error:
        return (colorScheme.error, Icons.error_outline);
      case InfoCardType.tip:
        return (colorScheme.primary, Icons.lightbulb_outline);
      case InfoCardType.info:
        return (colorScheme.secondary, Icons.info_outline);
    }
  }
}
