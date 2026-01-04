import '../models/workout_program.dart';
import '../models/enums.dart';
import '../data/program_templates.dart';

class ProgramService {
  static final ProgramService _instance = ProgramService._internal();
  factory ProgramService() => _instance;
  ProgramService._internal();

  bool testMode = true;

  List<WorkoutProgram> getAllPrograms() {
    return ProgramTemplates.getAllTemplates();
  }

  WorkoutProgram? getProgramById(String id) {
    try {
      return getAllPrograms().firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  WorkoutProgram? getProgramBySport(Sport sport) {
    try {
      return getAllPrograms().firstWhere((p) => p.sport == sport);
    } catch (e) {
      return null;
    }
  }
}