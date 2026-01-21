import 'package:flutter/material.dart';

/// FormGroup - Molecule component for labeled form inputs
///
/// Combines a label, input field, validation message, and optional helper text
/// into a cohesive form group following atomic design principles.
///
/// Example:
/// ```dart
/// FormGroup(
///   label: 'Weight',
///   required: true,
///   child: AppTextField.number(
///     hint: 'Enter weight',
///     suffixText: 'kg',
///   ),
///   helperText: 'Your current bodyweight',
/// )
/// ```
class FormGroup extends StatelessWidget {
  final String? label;
  final Widget child;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const FormGroup({
    super.key,
    this.label,
    required this.child,
    this.helperText,
    this.errorText,
    this.required = false,
    this.enabled = true,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Row(
                children: [
                  Text(
                    label!,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (required) ...[
                    const SizedBox(width: 4),
                    Text(
                      '*',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],
            AbsorbPointer(
              absorbing: !enabled,
              child: child,
            ),
            if (errorText != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 14,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      errorText!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (helperText != null) ...[
              const SizedBox(height: 6),
              Text(
                helperText!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// FormSection - Groups multiple FormGroups with a section title
///
/// Example:
/// ```dart
/// FormSection(
///   title: 'Personal Information',
///   children: [
///     FormGroup(label: 'Name', child: AppTextField()),
///     FormGroup(label: 'Email', child: AppTextField.email()),
///   ],
/// )
/// ```
class FormSection extends StatelessWidget {
  final String? title;
  final String? description;
  final List<Widget> children;
  final double spacing;
  final EdgeInsetsGeometry? padding;

  const FormSection({
    super.key,
    this.title,
    this.description,
    required this.children,
    this.spacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
          ...List.generate(
            children.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index < children.length - 1 ? spacing : 0,
              ),
              child: children[index],
            ),
          ),
        ],
      ),
    );
  }
}

/// FormRow - Horizontal layout for form fields
///
/// Example:
/// ```dart
/// FormRow(
///   children: [
///     Expanded(child: FormGroup(label: 'First Name', child: AppTextField())),
///     Expanded(child: FormGroup(label: 'Last Name', child: AppTextField())),
///   ],
/// )
/// ```
class FormRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const FormRow({
    super.key,
    required this.children,
    this.spacing = 16,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: List.generate(
        children.length,
        (index) => index < children.length - 1
            ? Padding(
                padding: EdgeInsets.only(right: spacing),
                child: children[index],
              )
            : children[index],
      ),
    );
  }
}
