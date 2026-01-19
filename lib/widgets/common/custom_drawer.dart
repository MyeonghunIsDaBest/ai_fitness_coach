import 'package:flutter/material.dart';

/// Custom Bottom Sheet Drawer - Flutter equivalent of drawer.tsx
///
/// Usage:
/// ```dart
/// showCustomDrawer(
///   context: context,
///   title: 'Filter Options',
///   content: FilterOptionsWidget(),
///   actions: [
///     OutlinedButton(
///       onPressed: () => Navigator.pop(context),
///       child: Text('Cancel'),
///     ),
///     ElevatedButton(
///       onPressed: () {
///         // Apply filters
///         Navigator.pop(context);
///       },
///       child: Text('Apply'),
///     ),
///   ],
/// );
/// ```

/// Shows a bottom sheet drawer
Future<T?> showCustomDrawer<T>({
  required BuildContext context,
  String? title,
  String? description,
  required Widget content,
  List<Widget>? actions,
  bool isDismissible = true,
  bool showDragHandle = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CustomDrawer(
      title: title,
      description: description,
      content: content,
      actions: actions,
      showDragHandle: showDragHandle,
    ),
  );
}

class CustomDrawer extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget content;
  final List<Widget>? actions;
  final bool showDragHandle;

  const CustomDrawer({
    super.key,
    this.title,
    this.description,
    required this.content,
    this.actions,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            if (showDragHandle)
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            // Header
            if (title != null || description != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: content,
              ),
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    for (int i = 0; i < actions!.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(child: actions![i]),
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

/// Filter drawer - Common pattern for filtering
Future<Map<String, dynamic>?> showFilterDrawer({
  required BuildContext context,
  required List<FilterOption> options,
  Map<String, dynamic>? initialValues,
}) {
  final Map<String, dynamic> selectedValues = Map.from(initialValues ?? {});

  return showCustomDrawer<Map<String, dynamic>>(
    context: context,
    title: 'Filter',
    description: 'Customize your view',
    content: StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: options.map((option) {
            return _FilterOptionWidget(
              option: option,
              value: selectedValues[option.key],
              onChanged: (value) {
                setState(() {
                  selectedValues[option.key] = value;
                });
              },
            );
          }).toList(),
        );
      },
    ),
    actions: [
      OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, selectedValues),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB4F04D),
          foregroundColor: Colors.black,
        ),
        child: const Text('Apply'),
      ),
    ],
  );
}

class FilterOption {
  final String key;
  final String label;
  final FilterType type;
  final List<String>? choices;
  final double? min;
  final double? max;

  const FilterOption({
    required this.key,
    required this.label,
    required this.type,
    this.choices,
    this.min,
    this.max,
  });
}

enum FilterType {
  checkbox,
  radio,
  slider,
  dateRange,
}

class _FilterOptionWidget extends StatelessWidget {
  final FilterOption option;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const _FilterOptionWidget({
    required this.option,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (option.type) {
      case FilterType.checkbox:
        return CheckboxListTile(
          title: Text(option.label),
          value: value ?? false,
          onChanged: onChanged,
          activeColor: const Color(0xFFB4F04D),
        );

      case FilterType.radio:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                option.label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...?option.choices?.map((choice) {
              return RadioListTile<String>(
                title: Text(choice),
                value: choice,
                groupValue: value,
                onChanged: (val) => onChanged(val),
                activeColor: const Color(0xFFB4F04D),
              );
            }),
          ],
        );

      case FilterType.slider:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(option.label),
            Slider(
              value: (value ?? option.min ?? 0).toDouble(),
              min: option.min ?? 0,
              max: option.max ?? 100,
              onChanged: onChanged,
              activeColor: const Color(0xFFB4F04D),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
