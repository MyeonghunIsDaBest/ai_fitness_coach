import 'package:flutter/material.dart';

/// Custom Dialog Widget - Flutter equivalent of dialog.tsx
///
/// Usage:
/// ```dart
/// showCustomDialog(
///   context: context,
///   title: 'Finish Workout?',
///   description: 'You completed 8 out of 12 sets.',
///   actions: [
///     TextButton(
///       onPressed: () => Navigator.pop(context),
///       child: Text('Cancel'),
///     ),
///     ElevatedButton(
///       onPressed: () {
///         // Handle confirm
///         Navigator.pop(context);
///       },
///       child: Text('Finish'),
///     ),
///   ],
/// );
/// ```
class CustomDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets? contentPadding;
  final bool showCloseButton;

  const CustomDialog({
    super.key,
    this.title,
    this.description,
    this.content,
    this.actions,
    this.contentPadding,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || showCloseButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 8),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey,
                      ),
                  ],
                ),
              ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Text(
                  description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            if (content != null)
              Padding(
                padding:
                    contentPadding ?? const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: content!,
              ),
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions!.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      actions![i],
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show custom dialog
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  String? title,
  String? description,
  Widget? content,
  List<Widget>? actions,
  bool barrierDismissible = true,
  bool showCloseButton = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => CustomDialog(
      title: title,
      description: description,
      content: content,
      actions: actions,
      showCloseButton: showCloseButton,
    ),
  );
}

/// Confirmation Dialog - Common pattern
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String description,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDangerous = false,
}) {
  return showCustomDialog<bool>(
    context: context,
    title: title,
    description: description,
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(cancelText),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDangerous ? Colors.red : const Color(0xFFB4F04D),
          foregroundColor: isDangerous ? Colors.white : Colors.black,
        ),
        child: Text(confirmText),
      ),
    ],
  );
}
