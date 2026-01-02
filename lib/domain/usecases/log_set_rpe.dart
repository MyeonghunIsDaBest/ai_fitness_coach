import '../repositories/training_repository.dart';
import '../models/logged_set.dart';
import '../../core/errors/failure.dart';

/// Use Case: Log a set with RPE tracking
///
/// Purpose: Validate and save a logged set to a workout session
///
/// Example usage:
/// ```dart
/// final logSet = LogSetRPE(repository);
///
/// await logSet(
///   sessionId: 'session_123',
///   set: myLoggedSet,
/// );
/// ```
class LogSetRPE {
  final TrainingRepository repository;

  LogSetRPE(this.repository);

  /// Execute the use case
  /// Validates RPE, weight, and reps before saving
  Future<void> call({
    required String sessionId,
    required LoggedSet set,
  }) async {
    // Validate RPE range (1-10)
    if (set.rpe < 1 || set.rpe > 10) {
      throw ValidationFailure('RPE must be between 1 and 10');
    }

    // Validate weight is positive
    if (set.weight <= 0) {
      throw ValidationFailure('Weight must be greater than 0');
    }

    // Validate reps is positive
    if (set.reps <= 0) {
      throw ValidationFailure('Reps must be greater than 0');
    }

    // Save to repository
    await repository.logSet(sessionId, set);
  }
}
