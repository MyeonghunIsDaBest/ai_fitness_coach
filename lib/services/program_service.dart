import '../domain/repositories/training_repository.dart';

/// Service for managing training programs
class ProgramService {
  final TrainingRepository _repository;

  ProgramService(this._repository);

  // Legacy methods for compatibility
  @Deprecated('Use repository methods directly')
  Future<void> saveProgram(dynamic program) async {
    throw UnimplementedError('Use repository methods directly');
  }

  @Deprecated('Use repository methods directly')
  Future<List<dynamic>> getPrograms() async {
    throw UnimplementedError('Use repository methods directly');
  }
}
