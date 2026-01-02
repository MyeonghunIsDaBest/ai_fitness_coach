import '../repositories/training_repository.dart';
import '../models/workout_program.dart';

/// Use Case: Get a workout program by ID
///
/// Purpose: Load a program from storage or templates
///
/// Example usage:
/// ```dart
/// final getProgram = GetProgram(repository);
/// final program = await getProgram('program_123');
/// ```
class GetProgram {
  final TrainingRepository repository;

  GetProgram(this.repository);

  /// Execute the use case
  /// Returns the program if found, null otherwise
  Future<WorkoutProgram?> call(String programId) async {
    return await repository.loadProgram(programId);
  }
}
