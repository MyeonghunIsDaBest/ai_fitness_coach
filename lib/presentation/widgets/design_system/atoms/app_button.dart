import 'package:flutter/material.dart';

/// Button variant types following Material 3 design
enum AppButtonVariant {
  /// Filled button with high emphasis (default)
  primary,

  /// Outlined button with medium emphasis
  secondary,

  /// Text button with low emphasis
  text,

  /// Icon button for compact actions
  icon,
}

/// Button size options
enum AppButtonSize {
  /// Small button (32px height)
  small,

  /// Medium button (48px height) - default
  medium,

  /// Large button (56px height)
  large,
}

/// AppButton - Atomic design system button component
///
/// A unified button component that supports multiple variants and follows
/// Material 3 design principles with full theme integration.
///
/// Example:
/// ```dart
/// AppButton(
///   text: 'Continue',
///   onPressed: () => print('Pressed'),
///   variant: AppButtonVariant.primary,
/// )
///
/// AppButton.icon(
///   icon: Icons.add,
///   onPressed: () => print('Add'),
/// )
/// ```
class AppButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final Widget? trailing;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.leading,
    this.trailing,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided');

  /// Primary filled button (high emphasis)
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leading,
    this.trailing,
  })  : variant = AppButtonVariant.primary,
        icon = null,
        padding = null;

  /// Secondary outlined button (medium emphasis)
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leading,
    this.trailing,
  })  : variant = AppButtonVariant.secondary,
        icon = null,
        padding = null;

  /// Text button (low emphasis)
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leading,
    this.trailing,
  })  : variant = AppButtonVariant.text,
        icon = null,
        padding = null;

  /// Icon-only button
  const AppButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.padding,
  })  : variant = AppButtonVariant.icon,
        text = null,
        isFullWidth = false,
        leading = null,
        trailing = null;

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.icon && icon != null) {
      return _buildIconButton(context);
    }

    return _buildTextButton(context);
  }

  Widget _buildIconButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double iconSize = _getIconSize();
    final double buttonSize = _getButtonHeight();

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: IconButton(
        icon: isLoading
            ? SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onSurface,
                ),
              )
            : Icon(icon, size: iconSize),
        onPressed: isLoading ? null : onPressed,
        style: IconButton.styleFrom(
          padding: padding ?? EdgeInsets.zero,
          foregroundColor: colorScheme.onSurface,
          disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget buttonChild = _buildButtonContent(context);

    if (isFullWidth) {
      buttonChild = SizedBox(
        width: double.infinity,
        child: buttonChild,
      );
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(_getMinWidth(), _getButtonHeight()),
            padding: padding ?? _getDefaultPadding(),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
            disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
            textStyle: _getTextStyle(textTheme),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(_getMinWidth(), _getButtonHeight()),
            padding: padding ?? _getDefaultPadding(),
            foregroundColor: colorScheme.primary,
            disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
            side: BorderSide(
              color: isLoading || onPressed == null
                  ? colorScheme.onSurface.withOpacity(0.12)
                  : colorScheme.outline,
              width: 1,
            ),
            textStyle: _getTextStyle(textTheme),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(_getMinWidth(), _getButtonHeight()),
            padding: padding ?? _getDefaultPadding(),
            foregroundColor: colorScheme.primary,
            disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
            textStyle: _getTextStyle(textTheme),
          ),
          child: buttonChild,
        );

      case AppButtonVariant.icon:
        // Should not reach here as icon variant is handled in _buildIconButton
        return const SizedBox.shrink();
    }
  }

  Widget _buildButtonContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.primary
              ? colorScheme.onPrimary
              : colorScheme.primary,
        ),
      );
    }

    final List<Widget> children = [];

    if (leading != null) {
      children.add(leading!);
      children.add(const SizedBox(width: 8));
    }

    if (text != null) {
      children.add(Text(text!));
    }

    if (trailing != null) {
      children.add(const SizedBox(width: 8));
      children.add(trailing!);
    }

    if (children.length == 1) {
      return children.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _getMinWidth() {
    if (variant == AppButtonVariant.icon) return _getButtonHeight();
    switch (size) {
      case AppButtonSize.small:
        return 48;
      case AppButtonSize.medium:
        return 64;
      case AppButtonSize.large:
        return 80;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle? _getTextStyle(TextTheme textTheme) {
    switch (size) {
      case AppButtonSize.small:
        return textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600);
      case AppButtonSize.medium:
        return textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600);
      case AppButtonSize.large:
        return textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);
    }
  }
}
