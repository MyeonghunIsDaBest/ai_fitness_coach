import 'package:flutter/material.dart';

/// Enum representing Rate of Perceived Exertion (RPE) feedback
/// Used to assess workout intensity and provide guidance
enum RPEFeedback {
  tooEasy,
  belowTarget,
  onTarget,
  aboveTarget,
  tooHard,
}

extension RPEFeedbackExtension on RPEFeedback {
  /// User-friendly message for each RPE level
  String get message {
    switch (this) {
      case RPEFeedback.tooEasy:
        return '💪 You\'re feeling strong today! Consider adding weight.';
      case RPEFeedback.belowTarget:
        return 'Below target - add weight next set';
      case RPEFeedback.onTarget:
        return '🎯 Perfect! You\'re in the sweet spot.';
      case RPEFeedback.aboveTarget:
        return 'Above target - reduce weight or reps';
      case RPEFeedback.tooHard:
        return '😅 High RPE detected. Listen to your body.';
    }
  }

  /// Color coding for visual feedback
  Color get color {
    switch (this) {
      case RPEFeedback.tooEasy:
        return Colors.blue;
      case RPEFeedback.belowTarget:
        return Colors.orange;
      case RPEFeedback.onTarget:
        return Colors.green;
      case RPEFeedback.aboveTarget:
        return Colors.orange;
      case RPEFeedback.tooHard:
        return Colors.red;
    }
  }

  /// Alternative: Use app's custom color scheme
  int get colorValue {
    switch (this) {
      case RPEFeedback.tooEasy:
        return 0xFF4ECDC4; // Cyan/Blue
      case RPEFeedback.belowTarget:
        return 0xFFFFE66D; // Yellow
      case RPEFeedback.onTarget:
        return 0xFFB4F04D; // Green (your app's primary)
      case RPEFeedback.aboveTarget:
        return 0xFFFF9A9E; // Light Red
      case RPEFeedback.tooHard:
        return 0xFFFF6B6B; // Red
    }
  }

  /// Short display name
  String get displayName {
    switch (this) {
      case RPEFeedback.tooEasy:
        return 'Too Easy';
      case RPEFeedback.belowTarget:
        return 'Below Target';
      case RPEFeedback.onTarget:
        return 'On Target';
      case RPEFeedback.aboveTarget:
        return 'Above Target';
      case RPEFeedback.tooHard:
        return 'Too Hard';
    }
  }

  /// Icon representation for UI
  IconData get icon {
    switch (this) {
      case RPEFeedback.tooEasy:
        return Icons.sentiment_very_satisfied;
      case RPEFeedback.belowTarget:
        return Icons.trending_down;
      case RPEFeedback.onTarget:
        return Icons.check_circle;
      case RPEFeedback.aboveTarget:
        return Icons.trending_up;
      case RPEFeedback.tooHard:
        return Icons.warning;
    }
  }

  /// Suggested action for the coach/user
  String get actionAdvice {
    switch (this) {
      case RPEFeedback.tooEasy:
        return 'Increase weight by 5-10 lbs next set';
      case RPEFeedback.belowTarget:
        return 'Increase weight by 2.5-5 lbs';
      case RPEFeedback.onTarget:
        return 'Maintain current weight and reps';
      case RPEFeedback.aboveTarget:
        return 'Reduce weight by 2.5-5 lbs or decrease reps';
      case RPEFeedback.tooHard:
        return 'Reduce weight significantly or end set. Prioritize recovery.';
    }
  }

  /// Corresponding RPE range (1-10 scale)
  String get rpeRange {
    switch (this) {
      case RPEFeedback.tooEasy:
        return 'RPE 5-6';
      case RPEFeedback.belowTarget:
        return 'RPE 6-7';
      case RPEFeedback.onTarget:
        return 'RPE 7-8';
      case RPEFeedback.aboveTarget:
        return 'RPE 8-9';
      case RPEFeedback.tooHard:
        return 'RPE 9-10';
    }
  }

  /// Detailed description for educational purposes
  String get description {
    switch (this) {
      case RPEFeedback.tooEasy:
        return 'The weight feels very light. You could do many more reps with ease.';
      case RPEFeedback.belowTarget:
        return 'The weight is manageable. You have 3-4 reps left in the tank.';
      case RPEFeedback.onTarget:
        return 'Challenging but doable. You have 2-3 reps left in the tank.';
      case RPEFeedback.aboveTarget:
        return 'Very challenging. You have 0-1 reps left in the tank.';
      case RPEFeedback.tooHard:
        return 'Maximum effort. You could not complete another rep with good form.';
    }
  }

  /// Whether this RPE level requires immediate action/concern
  bool get requiresAttention {
    return this == RPEFeedback.tooHard;
  }

  /// Whether this is within an acceptable training range
  bool get isAcceptable {
    return this == RPEFeedback.belowTarget ||
        this == RPEFeedback.onTarget ||
        this == RPEFeedback.aboveTarget;
  }

  /// Convert from RPE numeric value (1-10 scale)
  static RPEFeedback fromRPE(double rpe, {double targetRPE = 8.0}) {
    if (rpe < targetRPE - 2) return RPEFeedback.tooEasy;
    if (rpe < targetRPE - 1) return RPEFeedback.belowTarget;
    if (rpe >= targetRPE - 0.5 && rpe <= targetRPE + 0.5) {
      return RPEFeedback.onTarget;
    }
    if (rpe < 9) return RPEFeedback.aboveTarget;
    return RPEFeedback.tooHard;
  }

  /// Convert from string (for storage/API)
  static RPEFeedback fromString(String value) {
    return RPEFeedback.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => RPEFeedback.onTarget,
    );
  }

  /// Get feedback based on reps in reserve (RIR)
  static RPEFeedback fromRIR(int rir, {int targetRIR = 2}) {
    if (rir > targetRIR + 2) return RPEFeedback.tooEasy;
    if (rir > targetRIR) return RPEFeedback.belowTarget;
    if (rir == targetRIR) return RPEFeedback.onTarget;
    if (rir == targetRIR - 1) return RPEFeedback.aboveTarget;
    return RPEFeedback.tooHard;
  }
}
