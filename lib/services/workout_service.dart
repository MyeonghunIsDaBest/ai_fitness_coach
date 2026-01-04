import '../domain/models/workout_program.dart';

class ProgramService {
  static final ProgramService _instance = ProgramService._internal();
  factory ProgramService() => _instance;
  ProgramService._internal();

  bool testMode = true;

  List<WorkoutProgram> getAllPrograms() => [];
}


