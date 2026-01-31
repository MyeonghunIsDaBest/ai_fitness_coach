import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Semi-dark theme colors
const _cardColor = Color(0xFF1E293B);
const _cardBorder = Color(0xFF334155);
const _textPrimary = Color(0xFFE2E8F0);
const _textSecondary = Color(0xFF94A3B8);

/// RPE Feedback Widget - Interactive slider for logging Rate of Perceived Exertion
/// Provides visual feedback with color-coded intensity levels
class RPEFeedbackWidget extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  final bool showLabels;
  final bool showDescription;
  final bool compact;

  const RPEFeedbackWidget({
    super.key,
    this.initialValue = 7.0,
    required this.onChanged,
    this.showLabels = true,
    this.showDescription = true,
    this.compact = false,
  });

  @override
  State<RPEFeedbackWidget> createState() => _RPEFeedbackWidgetState();
}

class _RPEFeedbackWidgetState extends State<RPEFeedbackWidget> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(RPEFeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _currentValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return _buildCompactVersion();
    }
    return _buildFullVersion();
  }

  Widget _buildFullVersion() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rate of Perceived Exertion',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getRPEColor(_currentValue).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getRPEColor(_currentValue).withOpacity(0.3)),
                ),
                child: Text(
                  _currentValue.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _getRPEColor(_currentValue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Slider
          _buildSlider(),

          if (widget.showLabels) ...[
            const SizedBox(height: 12),
            _buildLabels(),
          ],

          if (widget.showDescription) ...[
            const SizedBox(height: 16),
            _buildDescription(),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactVersion() {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: _buildSliderTheme(),
            child: Slider(
              value: _currentValue,
              min: 1,
              max: 10,
              divisions: 18,
              onChanged: _handleChange,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _getRPEColor(_currentValue).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              _currentValue.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _getRPEColor(_currentValue),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider() {
    return SliderTheme(
      data: _buildSliderTheme(),
      child: Slider(
        value: _currentValue,
        min: 1,
        max: 10,
        divisions: 18,
        onChanged: _handleChange,
      ),
    );
  }

  SliderThemeData _buildSliderTheme() {
    return SliderThemeData(
      activeTrackColor: _getRPEColor(_currentValue),
      inactiveTrackColor: _cardBorder,
      thumbColor: _getRPEColor(_currentValue),
      overlayColor: _getRPEColor(_currentValue).withOpacity(0.2),
      trackHeight: 8,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
    );
  }

  Widget _buildLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel('1', 'Easy'),
        _buildLabel('5', 'Moderate'),
        _buildLabel('10', 'Max'),
      ],
    );
  }

  Widget _buildLabel(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textSecondary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getRPEColor(_currentValue).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getRPEColor(_currentValue).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            _getIntensityIcon(_currentValue),
            color: _getRPEColor(_currentValue),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getIntensityLabel(_currentValue),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _getRPEColor(_currentValue),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getIntensityDescription(_currentValue),
                  style: const TextStyle(
                    fontSize: 12,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleChange(double value) {
    HapticFeedback.selectionClick();
    setState(() => _currentValue = value);
    widget.onChanged(value);
  }

  Color _getRPEColor(double rpe) {
    if (rpe <= 4) return const Color(0xFF4CAF50); // Green - Easy
    if (rpe <= 6) return const Color(0xFF8BC34A); // Light green - Moderate
    if (rpe <= 7) return const Color(0xFFFFC107); // Yellow - Challenging
    if (rpe <= 8) return const Color(0xFFFF9800); // Orange - Hard
    if (rpe <= 9) return const Color(0xFFFF5722); // Deep orange - Very hard
    return const Color(0xFFF44336); // Red - Maximum
  }

  IconData _getIntensityIcon(double rpe) {
    if (rpe <= 4) return Icons.sentiment_very_satisfied;
    if (rpe <= 6) return Icons.sentiment_satisfied;
    if (rpe <= 7) return Icons.sentiment_neutral;
    if (rpe <= 8) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  String _getIntensityLabel(double rpe) {
    if (rpe <= 2) return 'Very Light';
    if (rpe <= 4) return 'Light';
    if (rpe <= 5) return 'Moderate';
    if (rpe <= 6) return 'Somewhat Hard';
    if (rpe <= 7) return 'Hard';
    if (rpe <= 8) return 'Very Hard';
    if (rpe <= 9) return 'Near Maximum';
    return 'Maximum Effort';
  }

  String _getIntensityDescription(double rpe) {
    if (rpe <= 2) return 'Could do many more reps with ease';
    if (rpe <= 4) return 'Could do 4-6 more reps';
    if (rpe <= 5) return 'Could do 3-4 more reps';
    if (rpe <= 6) return 'Could do 2-3 more reps';
    if (rpe <= 7) return 'Could do 2 more reps';
    if (rpe <= 8) return 'Could do 1 more rep';
    if (rpe <= 9) return 'Could maybe do 1 more rep';
    return 'Could not do any more reps';
  }
}

/// Quick RPE Selector - Grid of buttons for fast selection
class RPEQuickSelector extends StatelessWidget {
  final double? selectedValue;
  final ValueChanged<double> onSelected;

  const RPEQuickSelector({
    super.key,
    this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick RPE',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [6, 7, 8, 9, 10].map((rpe) {
              final isSelected = selectedValue == rpe.toDouble();
              final color = _getRPEColor(rpe.toDouble());
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(rpe.toDouble());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? color : color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? color : color.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$rpe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getRPEColor(double rpe) {
    if (rpe <= 4) return const Color(0xFF4CAF50);
    if (rpe <= 6) return const Color(0xFF8BC34A);
    if (rpe <= 7) return const Color(0xFFFFC107);
    if (rpe <= 8) return const Color(0xFFFF9800);
    if (rpe <= 9) return const Color(0xFFFF5722);
    return const Color(0xFFF44336);
  }
}

/// RPE Badge - Small display of RPE value with color
class RPEBadge extends StatelessWidget {
  final double value;
  final bool showLabel;
  final double size;

  const RPEBadge({
    super.key,
    required this.value,
    this.showLabel = false,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getRPEColor(value);

    return Container(
      width: showLabel ? null : size,
      height: size,
      padding: showLabel
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4)
          : null,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(size / 4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              'RPE',
              style: TextStyle(
                fontSize: size * 0.35,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getRPEColor(double rpe) {
    if (rpe <= 4) return const Color(0xFF4CAF50);
    if (rpe <= 6) return const Color(0xFF8BC34A);
    if (rpe <= 7) return const Color(0xFFFFC107);
    if (rpe <= 8) return const Color(0xFFFF9800);
    if (rpe <= 9) return const Color(0xFFFF5722);
    return const Color(0xFFF44336);
  }
}
