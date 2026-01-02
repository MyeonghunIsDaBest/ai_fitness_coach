import '../models/logged_set.dart';
import '../../core/utils/rpe_math.dart';

/// Use Case: Calculate average RPE for a workout session
///
/// Purpose: Get the overall intensity of a workout
///
/// Example usage:
/// ```dart
/// final calculateSessionRPE = CalculateSessionRPE();
///
/// final sets = [set1, set2, set3];
/// final avgRPE = calculateSessionRPE(sets);
///
/// print('Session average: $avgRPE RPE');
/// ```
class CalculateSessionRPE {
  /// Execute the use case
  /// Returns average RPE, or 0.0 if no sets logged
  double call(List<LoggedSet> sets) {
    if (sets.isEmpty) return 0.0;

    final rpes = sets.map((s) => s.rpe).toList();
    return RPEMath.calculateAverageRPE(rpes);
  }
}
