import '../models/program_week.dart';
import '../../core/utils/rpe_math.dart';

/// Use Case: Adjust next week's training load based on performance
///
/// Purpose: Auto-regulate training intensity using RPE feedback
///
/// Example usage:
/// ```dart
/// final adjustLoad = AdjustNextWeekLoad();
///
/// final adjusted = adjustLoad(
///   nextWeek: week5,
///   avgRPE: 9.2,  // Actual average RPE
///   targetRPE: 8.0,  // Target was 8.0
/// );
///
/// // adjusted will have reduced intensity multiplier
/// ```
class AdjustNextWeekLoad {
  /// Execute the use case
  /// Returns adjusted week with modified intensity multiplier
  ProgramWeek call({
    required ProgramWeek nextWeek,
    required double avgRPE,
    required double targetRPE,
  }) {
    // Calculate load adjustment based on RPE
    final adjustment = RPEMath.calculateLoadAdjustment(avgRPE, targetRPE);

    // If no adjustment needed, return original
    if (adjustment == 0) return nextWeek;

    // Adjust intensity multiplier
    // Example: if adjustment is -0.1 (reduce by 10%)
    // new multiplier = 1.0 * (1 + (-0.1)) = 0.9 (90% intensity)
    final newIntensityMultiplier =
        nextWeek.intensityMultiplier * (1 + adjustment);

    // Clamp between 0.5 (50%) and 1.2 (120%)
    // This prevents extreme adjustments
    final clampedMultiplier = newIntensityMultiplier.clamp(0.5, 1.2);

    return nextWeek.copyWith(
      intensityMultiplier: clampedMultiplier,
    );
  }
}
