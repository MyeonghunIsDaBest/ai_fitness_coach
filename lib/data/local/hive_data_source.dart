import 'package:hive_flutter/hive_flutter.dart';
import '../models/athlete_profile_dto.dart';
import '../models/workout_program_dto.dart';
import '../models/workout_session_dto.dart';
import 'local_data_source.dart';

/// Hive implementation of LocalDataSource
/// Provides type-safe storage using Hive with generated type adapters
class HiveDataSource implements LocalDataSource {
  // Box names as constants
  static const String _athleteProfileBoxName = 'athlete_profile';
  static const String _programsBoxName = 'workout_programs';
  static const String _sessionsBoxName = 'workout_sessions';

  // Hive boxes
  Box<AthleteProfileDto>? _athleteBox;
  Box<WorkoutProgramDto>? _programsBox;
  Box<WorkoutSessionDto>? _sessionsBox;

  // Singleton instance
  static final HiveDataSource _instance = HiveDataSource._internal();
  factory HiveDataSource() => _instance;
  HiveDataSource._internal();

  // ==========================================
  // INITIALIZATION
  // ==========================================

  @override
  Future<void> initialize() async {
    // Hive.initFlutter() should already be called in main.dart
    // Here we just open the boxes

    // Open athlete profile box
    if (!Hive.isBoxOpen(_athleteProfileBoxName)) {
      _athleteBox = await Hive.openBox<AthleteProfileDto>(_athleteProfileBoxName);
    } else {
      _athleteBox = Hive.box<AthleteProfileDto>(_athleteProfileBoxName);
    }

    // Open programs box
    if (!Hive.isBoxOpen(_programsBoxName)) {
      _programsBox = await Hive.openBox<WorkoutProgramDto>(_programsBoxName);
    } else {
      _programsBox = Hive.box<WorkoutProgramDto>(_programsBoxName);
    }

    // Open sessions box
    if (!Hive.isBoxOpen(_sessionsBoxName)) {
      _sessionsBox = await Hive.openBox<WorkoutSessionDto>(_sessionsBoxName);
    } else {
      _sessionsBox = Hive.box<WorkoutSessionDto>(_sessionsBoxName);
    }
  }

  @override
  Future<void> close() async {
    await _athleteBox?.close();
    await _programsBox?.close();
    await _sessionsBox?.close();
  }

  @override
  Future<void> clearAll() async {
    await _athleteBox?.clear();
    await _programsBox?.clear();
    await _sessionsBox?.clear();
  }

  // Helper to ensure boxes are initialized
  void _ensureInitialized() {
    if (_athleteBox == null || _programsBox == null || _sessionsBox == null) {
      throw StateError(
        'HiveDataSource not initialized. Call initialize() first.',
      );
    }
  }

  // ==========================================
  // ATHLETE PROFILE OPERATIONS
  // ==========================================

  @override
  Future<AthleteProfileDto?> getAthleteProfile() async {
    _ensureInitialized();
    // We store only one profile with key 'current'
    return _athleteBox!.get('current');
  }

  @override
  Future<void> saveAthleteProfile(AthleteProfileDto profile) async {
    _ensureInitialized();
    await _athleteBox!.put('current', profile);
  }

  @override
  Future<void> deleteAthleteProfile() async {
    _ensureInitialized();
    await _athleteBox!.delete('current');
  }

  // ==========================================
  // WORKOUT PROGRAM OPERATIONS
  // ==========================================

  @override
  Future<List<WorkoutProgramDto>> getAllPrograms() async {
    _ensureInitialized();
    return _programsBox!.values.toList();
  }

  @override
  Future<WorkoutProgramDto?> getProgramById(String id) async {
    _ensureInitialized();
    return _programsBox!.get(id);
  }

  @override
  Future<WorkoutProgramDto?> getActiveProgram() async {
    _ensureInitialized();
    try {
      return _programsBox!.values.firstWhere(
        (program) => program.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveProgram(WorkoutProgramDto program) async {
    _ensureInitialized();
    await _programsBox!.put(program.id, program);
  }

  @override
  Future<void> deleteProgram(String id) async {
    _ensureInitialized();
    await _programsBox!.delete(id);
  }

  @override
  Future<void> setActiveProgram(String programId) async {
    _ensureInitialized();

    // Deactivate all programs first
    final allPrograms = _programsBox!.values.toList();
    for (final program in allPrograms) {
      if (program.isActive && program.id != programId) {
        // Create updated program with isActive = false
        final updatedProgram = WorkoutProgramDto(
          id: program.id,
          name: program.name,
          sport: program.sport,
          description: program.description,
          weeks: program.weeks,
          startDate: program.startDate,
          endDate: program.endDate,
          isActive: false,
          isCustom: program.isCustom,
          athleteProfileId: program.athleteProfileId,
          createdAt: program.createdAt,
          updatedAt: program.updatedAt,
        );
        await _programsBox!.put(program.id, updatedProgram);
      }
    }

    // Activate the selected program
    final targetProgram = await getProgramById(programId);
    if (targetProgram != null) {
      final activatedProgram = WorkoutProgramDto(
        id: targetProgram.id,
        name: targetProgram.name,
        sport: targetProgram.sport,
        description: targetProgram.description,
        weeks: targetProgram.weeks,
        startDate: targetProgram.startDate,
        endDate: targetProgram.endDate,
        isActive: true,
        isCustom: targetProgram.isCustom,
        athleteProfileId: targetProgram.athleteProfileId,
        createdAt: targetProgram.createdAt,
        updatedAt: DateTime.now(),
      );
      await _programsBox!.put(programId, activatedProgram);
    }
  }

  // ==========================================
  // WORKOUT SESSION OPERATIONS
  // ==========================================

  @override
  Future<List<WorkoutSessionDto>> getAllSessions() async {
    _ensureInitialized();
    return _sessionsBox!.values.toList();
  }

  @override
  Future<WorkoutSessionDto?> getSessionById(String id) async {
    _ensureInitialized();
    return _sessionsBox!.get(id);
  }

  @override
  Future<List<WorkoutSessionDto>> getSessionsByProgram(String programId) async {
    _ensureInitialized();
    return _sessionsBox!.values
        .where((session) => session.programId == programId)
        .toList();
  }

  @override
  Future<List<WorkoutSessionDto>> getSessionsByWeek(
    String programId,
    int weekNumber,
  ) async {
    _ensureInitialized();
    return _sessionsBox!.values
        .where((session) =>
            session.programId == programId && session.weekNumber == weekNumber)
        .toList();
  }

  @override
  Future<WorkoutSessionDto?> getMostRecentSession() async {
    _ensureInitialized();
    final sessions = _sessionsBox!.values.toList();
    if (sessions.isEmpty) return null;

    // Sort by start time descending and return first
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions.first;
  }

  @override
  Future<List<WorkoutSessionDto>> getCompletedSessions() async {
    _ensureInitialized();
    return _sessionsBox!.values
        .where((session) => session.isCompleted)
        .toList();
  }

  @override
  Future<void> saveSession(WorkoutSessionDto session) async {
    _ensureInitialized();
    await _sessionsBox!.put(session.id, session);
  }

  @override
  Future<void> deleteSession(String id) async {
    _ensureInitialized();
    await _sessionsBox!.delete(id);
  }

  @override
  Future<List<WorkoutSessionDto>> getSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    _ensureInitialized();
    return _sessionsBox!.values
        .where((session) =>
            session.startTime.isAfter(startDate) &&
            session.startTime.isBefore(endDate))
        .toList();
  }

  // ==========================================
  // STATISTICS & QUERIES
  // ==========================================

  @override
  Future<int> getTotalCompletedWorkouts() async {
    _ensureInitialized();
    return _sessionsBox!.values
        .where((session) => session.isCompleted)
        .length;
  }

  @override
  Future<int> getWorkoutCountInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    _ensureInitialized();
    return _sessionsBox!.values
        .where((session) =>
            session.isCompleted &&
            session.startTime.isAfter(startDate) &&
            session.startTime.isBefore(endDate))
        .length;
  }

  @override
  Future<bool> isWorkoutCompleted(
    String programId,
    int weekNumber,
    int dayNumber,
  ) async {
    _ensureInitialized();
    return _sessionsBox!.values.any(
      (session) =>
          session.programId == programId &&
          session.weekNumber == weekNumber &&
          session.dayNumber == dayNumber &&
          session.isCompleted,
    );
  }
}
