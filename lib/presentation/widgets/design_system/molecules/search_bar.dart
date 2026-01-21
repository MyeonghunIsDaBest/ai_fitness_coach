import 'package:flutter/material.dart';

/// AppSearchBar - Molecule component for search functionality
///
/// A search bar with icon, clear button, and optional filters.
/// Follows Material 3 design with full theme integration.
///
/// Example:
/// ```dart
/// AppSearchBar(
///   hint: 'Search exercises...',
///   onSearch: (query) => print(query),
///   onClear: () => print('Cleared'),
/// )
/// ```
class AppSearchBar extends StatefulWidget {
  final String? hint;
  final String? initialValue;
  final void Function(String)? onSearch;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final bool autofocus;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? leading;
  final List<Widget>? actions;

  const AppSearchBar({
    super.key,
    this.hint,
    this.initialValue,
    this.onSearch,
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.showFilter = false,
    this.autofocus = false,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.leading,
    this.actions,
  });

  /// Search bar with filter button
  const AppSearchBar.withFilter({
    super.key,
    this.hint = 'Search...',
    this.initialValue,
    this.onSearch,
    this.onChanged,
    this.onClear,
    required this.onFilterTap,
    this.autofocus = false,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.leading,
    this.actions,
  }) : showFilter = true;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    widget.onChanged?.call(_controller.text);
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    _focusNode.requestFocus();
  }

  void _submit() {
    widget.onSearch?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // Leading icon or custom widget
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: widget.leading ??
                Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),

          // Search input
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submit(),
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Search...',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Clear button
          if (_hasText)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clear,
              color: colorScheme.onSurfaceVariant,
              tooltip: 'Clear',
            ),

          // Filter button
          if (widget.showFilter)
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: widget.onFilterTap,
              color: colorScheme.onSurfaceVariant,
              tooltip: 'Filter',
            ),

          // Custom actions
          if (widget.actions != null) ...widget.actions!,

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// SearchSuggestions - Displays search suggestions below search bar
///
/// Example:
/// ```dart
/// SearchSuggestions(
///   suggestions: ['Bench Press', 'Squat', 'Deadlift'],
///   onSelect: (suggestion) => print('Selected: $suggestion'),
/// )
/// ```
class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String)? onSelect;
  final String? highlightText;
  final int maxSuggestions;

  const SearchSuggestions({
    super.key,
    required this.suggestions,
    this.onSelect,
    this.highlightText,
    this.maxSuggestions = 5,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final displaySuggestions = suggestions.take(maxSuggestions).toList();

    if (displaySuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: displaySuggestions.map((suggestion) {
          return InkWell(
            onTap: () => onSelect?.call(suggestion),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHighlightedText(
                      suggestion,
                      highlightText,
                      textTheme,
                      colorScheme,
                    ),
                  ),
                  Icon(
                    Icons.north_west,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String? highlight,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    if (highlight == null || highlight.isEmpty) {
      return Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase();
    final index = lowerText.indexOf(lowerHighlight);

    if (index == -1) {
      return Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, index),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          TextSpan(
            text: text.substring(index, index + highlight.length),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: text.substring(index + highlight.length),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
