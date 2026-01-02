import '../../core/utils/rpe_math.dart';

/// Use Case: Determine athlete's current fatigue status
///
/// Purpose: Provide feedback on recovery state
///
/// Example usage:
/// ```dart
/// final getFatigue = GetFatigueStatus();
///
/// final status = getFatigue(
///   avgRPE: 9.2,
///   targetMin: 7.0,
///   targetMax: 8.5,
/// );
///
/// if (status == FatigueStatus.high) {
///   print('Consider a deload!');
/// }
/// ```
class GetFatigueStatus {
  /// Execute the use case
  /// Returns current fatigue level
  FatigueStatus call({
    required double avgRPE,
    required double targetMin,
    required double targetMax,
  }) {
    final targetMid = (targetMin + targetMax) / 2;

    if (RPEMath.isHighFatigue(avgRPE, targetMax)) {
      return FatigueStatus.high;
    } else if (RPEMath.isRecovering(avgRPE, targetMin)) {
      return FatigueStatus.recovering;
    } else if (avgRPE >= targetMin && avgRPE <= targetMax) {
      return FatigueStatus.optimal;
    }

    return FatigueStatus.normal;
  }
}

/// Fatigue status levels
enum FatigueStatus {
  recovering,
  optimal,
  normal,
  high;

  String get displayName {
    switch (this) {
      case FatigueStatus.recovering:
        return 'Recovering Well';
      case FatigueStatus.optimal:
        return 'Optimal';
      case FatigueStatus.normal:
        return 'Normal';
      case FatigueStatus.high:
        return 'High Fatigue';
    }
  }

  String get description {
    switch (this) {
      case FatigueStatus.recovering:
        return 'Your body is recovering well. Consider increasing intensity.';
      case FatigueStatus.optimal:
        return 'Perfect training stimulus. Keep it up!';
      case FatigueStatus.normal:
        return 'Normal fatigue levels. Continue as planned.';
      case FatigueStatus.high:
        return 'High fatigue detected. Consider a deload or rest day.';
    }
  }
}
