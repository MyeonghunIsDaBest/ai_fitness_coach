import '../repositories/training_repository.dart';

/// Use Case: Mark a workout session as complete
///
/// Purpose: Finalize a workout and save completion time
///
/// Example usage:
/// ```dart
/// final completeSession = CompleteWorkoutSession(repository);
///
/// await completeSession(
///   'session_123',
///   notes: 'Great workout! Felt strong.',
/// );
/// ```
class CompleteWorkoutSession {
  final TrainingRepository repository;

  CompleteWorkoutSession(this.repository);

  /// Execute the use case
  /// Marks session as completed with current timestamp
  Future<void> call(String sessionId, {String? notes}) async {
    await repository.completeSession(
      sessionId,
      endTime: DateTime.now(),
      notes: notes,
    );
  }
}
