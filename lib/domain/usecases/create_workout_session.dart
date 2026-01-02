import '../repositories/training_repository.dart';

/// Use Case: Create a new workout session
///
/// Purpose: Start tracking a workout
///
/// Example usage:
/// ```dart
/// final createSession = CreateWorkoutSession(repository);
///
/// final sessionId = await createSession(
///   programId: 'program_123',
///   weekNumber: 5,
///   dayNumber: 1,
///   workoutName: 'Upper Body Power',
/// );
///
/// // Now you can log sets to this session
/// ```
class CreateWorkoutSession {
  final TrainingRepository repository;

  CreateWorkoutSession(this.repository);

  /// Execute the use case
  /// Returns the new session ID
  Future<String> call({
    required String programId,
    required int weekNumber,
    required int dayNumber,
    required String workoutName,
  }) async {
    return await repository.createSession(
      programId: programId,
      weekNumber: weekNumber,
      dayNumber: dayNumber,
      workoutName: workoutName,
      startTime: DateTime.now(),
    );
  }
}
