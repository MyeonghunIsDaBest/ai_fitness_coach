import '../domain/repositories/training_repository.dart';
import '../domain/models/workout_program.dart';
import '../data/program_templates.dart';

class ProgramService {
  static final ProgramService _instance = ProgramService._internal();
  factory ProgramService() => _instance;
  ProgramService._internal();

  late TrainingRepository _repository;

  void setRepository(TrainingRepository repository) {
    _repository = repository;
  }

  Future<List<WorkoutProgram>> getAvailablePrograms() async {
    return ProgramTemplates.getAllTemplates();
  }

  Future<void> selectProgram(WorkoutProgram program) async {
    await _repository.saveProgram(program);
    await _repository.setActiveProgram(program.id);
  }
}
