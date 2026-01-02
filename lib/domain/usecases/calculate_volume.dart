import '../models/logged_set.dart';
import '../../core/utils/session_stats.dart';

/// Use Case: Calculate total volume (tonnage) for a workout
///
/// Purpose: Sum up weight × reps for all sets
///
/// Example usage:
/// ```dart
/// final calculateVolume = CalculateVolume();
///
/// final sets = [set1, set2, set3];
/// final totalVolume = calculateVolume(sets);
///
/// print('Total volume: $totalVolume kg');
/// ```
class CalculateVolume {
  /// Execute the use case
  /// Returns total volume in the weight unit used (kg or lbs)
  double call(List<LoggedSet> sets) {
    return SessionStats.calculateTotalVolume(sets);
  }
}
