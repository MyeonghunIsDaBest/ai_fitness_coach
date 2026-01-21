import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Input field type for different keyboard layouts
enum AppTextFieldType {
  /// Standard text input
  text,

  /// Email keyboard with @ symbol
  email,

  /// Number keyboard
  number,

  /// Decimal number keyboard
  decimal,

  /// Phone number keyboard
  phone,

  /// Multiline text area
  multiline,

  /// Password field with obscure text
  password,
}

/// AppTextField - Atomic design system text input component
///
/// A unified text field component that supports validation, different input types,
/// and follows Material 3 design principles with full theme integration.
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   type: AppTextFieldType.email,
///   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
/// )
/// ```
class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final AppTextFieldType type;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool autocorrect;
  final TextCapitalization textCapitalization;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.type = AppTextFieldType.text,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.inputFormatters,
    this.autofocus = false,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Email input field
  const AppTextField.email({
    super.key,
    this.controller,
    this.label,
    this.hint = 'Enter your email',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
  })  : type = AppTextFieldType.email,
        onTap = null,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        textInputAction = TextInputAction.next,
        prefixText = null,
        suffixText = null,
        inputFormatters = null,
        autocorrect = false,
        textCapitalization = TextCapitalization.none;

  /// Password input field
  const AppTextField.password({
    super.key,
    this.controller,
    this.label,
    this.hint = 'Enter your password',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.prefixIcon,
    this.autofocus = false,
  })  : type = AppTextFieldType.password,
        onTap = null,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        maxLength = null,
        textInputAction = TextInputAction.done,
        suffixIcon = null,
        prefixText = null,
        suffixText = null,
        inputFormatters = null,
        autocorrect = false,
        textCapitalization = TextCapitalization.none;

  /// Number input field
  const AppTextField.number({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.maxLength,
    this.autofocus = false,
  })  : type = AppTextFieldType.number,
        onTap = null,
        readOnly = false,
        maxLines = 1,
        minLines = null,
        textInputAction = TextInputAction.done,
        prefixText = null,
        inputFormatters = null,
        autocorrect = false,
        textCapitalization = TextCapitalization.none;

  /// Multiline text area
  const AppTextField.multiline({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
    this.autofocus = false,
  })  : type = AppTextFieldType.multiline,
        onTap = null,
        readOnly = false,
        textInputAction = TextInputAction.newline,
        prefixIcon = null,
        suffixIcon = null,
        prefixText = null,
        suffixText = null,
        inputFormatters = null,
        autocorrect = true,
        textCapitalization = TextCapitalization.sentences;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.type == AppTextFieldType.password) {
      _obscureText = true;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      setState(() {
        _validationError = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final effectiveError = widget.errorText ?? _validationError;
    final hasError = effectiveError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.type == AppTextFieldType.password && _obscureText,
          keyboardType: _getKeyboardType(),
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autocorrect: widget.autocorrect,
          autofocus: widget.autofocus,
          maxLines: widget.type == AppTextFieldType.password ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters ?? _getDefaultFormatters(),
          onChanged: (value) {
            _validate(value);
            widget.onChanged?.call(value);
          },
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
            helperText: hasError ? null : widget.helperText,
            helperStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
            errorText: effectiveError,
            errorStyle: TextStyle(
              color: colorScheme.error,
              fontSize: 12,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(colorScheme),
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            filled: true,
            fillColor: widget.enabled
                ? colorScheme.surfaceContainerHighest
                : colorScheme.surfaceContainerHighest.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    if (widget.type == AppTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        color: colorScheme.onSurfaceVariant,
      );
    }
    return widget.suffixIcon;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.password:
      case AppTextFieldType.text:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getDefaultFormatters() {
    switch (widget.type) {
      case AppTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case AppTextFieldType.decimal:
        return [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];
      default:
        return null;
    }
  }
}
