import 'package:hive/hive.dart';
import '../../domain/repositories/training_repository.dart';
import '../../domain/models/logged_set.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/athlete_profile.dart';
import '../../core/errors/failure.dart';

/// Concrete implementation of TrainingRepository using Hive for local storage
/// Handles all data persistence operations
class TrainingRepositoryImpl implements TrainingRepository {
  final Box<Map<dynamic, dynamic>> _workoutBox;
  final Box<Map<dynamic, dynamic>> _programBox;
  final Box<Map<dynamic, dynamic>> _profileBox;
  final Box<Map<dynamic, dynamic>> _sessionBox;

  TrainingRepositoryImpl({
    required Box<Map<dynamic, dynamic>> workoutBox,
    required Box<Map<dynamic, dynamic>> programBox,
    required Box<Map<dynamic, dynamic>> profileBox,
    required Box<Map<dynamic, dynamic>> sessionBox,
  })  : _workoutBox = workoutBox,
        _programBox = programBox,
        _profileBox = profileBox,
        _sessionBox = sessionBox;

  // ==========================================
  // WORKOUT SESSION MANAGEMENT
  // ==========================================

  @override
  Future<void> logSet(String sessionId, LoggedSet set) async {
    try {
      final session = await getSession(sessionId);

      if (session == null) {
        throw WorkoutNotFoundFailure();
      }

      // Add set to session
      final updatedSets = List<LoggedSet>.from(session.sets)..add(set);

      final updatedSession = WorkoutSession(
        id: session.id,
        programId: session.programId,
        weekNumber: session.weekNumber,
        dayNumber: session.dayNumber,
        workoutName: session.workoutName,
        startTime: session.startTime,
        endTime: session.endTime,
        sets: updatedSets,
        isCompleted: session.isCompleted,
        notes: session.notes,
      );

      await _sessionBox.put(sessionId, _sessionToMap(updatedSession));
    } catch (e) {
      if (e is WorkoutNotFoundFailure) rethrow;
      throw StorageFailure('Failed to log set: $e');
    }
  }

  @override
  Future<WorkoutSession?> getSession(String sessionId) async {
    try {
      final data = _sessionBox.get(sessionId);
      if (data == null) return null;
      return _mapToSession(Map<String, dynamic>.from(data));
    } catch (e) {
      throw StorageFailure('Failed to get session: $e');
    }
  }

  @override
  Future<List<WorkoutSession>> getWeekSessions(
    String programId,
    int weekNumber,
  ) async {
    try {
      final allSessions = await getAllProgramSessions(programId);
      return allSessions
          .where((session) => session.weekNumber == weekNumber)
          .toList();
    } catch (e) {
      throw StorageFailure('Failed to get week sessions: $e');
    }
  }

  @override
  Future<List<WorkoutSession>> getAllProgramSessions(String programId) async {
    try {
      final List<WorkoutSession> sessions = [];

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          final session = _mapToSession(Map<String, dynamic>.from(data));
          if (session.programId == programId) {
            sessions.add(session);
          }
        }
      }

      // Sort by start time
      sessions.sort((a, b) => a.startTime.compareTo(b.startTime));
      return sessions;
    } catch (e) {
      throw StorageFailure('Failed to get all sessions: $e');
    }
  }

  @override
  Future<String> createSession({
    required String programId,
    required int weekNumber,
    required int dayNumber,
    required String workoutName,
    required DateTime startTime,
  }) async {
    try {
      final sessionId = _generateSessionId();

      final session = WorkoutSession(
        id: sessionId,
        programId: programId,
        weekNumber: weekNumber,
        dayNumber: dayNumber,
        workoutName: workoutName,
        startTime: startTime,
        sets: [],
        isCompleted: false,
      );

      await _sessionBox.put(sessionId, _sessionToMap(session));
      return sessionId;
    } catch (e) {
      throw StorageFailure('Failed to create session: $e');
    }
  }

  @override
  Future<void> completeSession(
    String sessionId, {
    required DateTime endTime,
    String? notes,
  }) async {
    try {
      final session = await getSession(sessionId);
      if (session == null) throw WorkoutNotFoundFailure();

      final updatedSession = WorkoutSession(
        id: session.id,
        programId: session.programId,
        weekNumber: session.weekNumber,
        dayNumber: session.dayNumber,
        workoutName: session.workoutName,
        startTime: session.startTime,
        endTime: endTime,
        sets: session.sets,
        isCompleted: true,
        notes: notes ?? session.notes,
      );

      await _sessionBox.put(sessionId, _sessionToMap(updatedSession));
    } catch (e) {
      if (e is WorkoutNotFoundFailure) rethrow;
      throw StorageFailure('Failed to complete session: $e');
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    try {
      await _sessionBox.delete(sessionId);
    } catch (e) {
      throw StorageFailure('Failed to delete session: $e');
    }
  }

  @override
  Future<void> updateSessionNotes(String sessionId, String notes) async {
    try {
      final session = await getSession(sessionId);
      if (session == null) throw WorkoutNotFoundFailure();

      final updatedSession = WorkoutSession(
        id: session.id,
        programId: session.programId,
        weekNumber: session.weekNumber,
        dayNumber: session.dayNumber,
        workoutName: session.workoutName,
        startTime: session.startTime,
        endTime: session.endTime,
        sets: session.sets,
        isCompleted: session.isCompleted,
        notes: notes,
      );

      await _sessionBox.put(sessionId, _sessionToMap(updatedSession));
    } catch (e) {
      if (e is WorkoutNotFoundFailure) rethrow;
      throw StorageFailure('Failed to update notes: $e');
    }
  }

  // ==========================================
  // PROGRAM MANAGEMENT
  // ==========================================

  @override
  Future<void> saveProgram(WorkoutProgram program) async {
    try {
      await _programBox.put(program.id, _programToMap(program));
    } catch (e) {
      throw StorageFailure('Failed to save program: $e');
    }
  }

  @override
  Future<WorkoutProgram?> loadProgram(String programId) async {
    try {
      final data = _programBox.get(programId);
      if (data == null) return null;
      return _mapToProgram(Map<String, dynamic>.from(data));
    } catch (e) {
      throw StorageFailure('Failed to load program: $e');
    }
  }

  @override
  Future<List<WorkoutProgram>> getAllPrograms() async {
    try {
      final List<WorkoutProgram> programs = [];

      for (var key in _programBox.keys) {
        final data = _programBox.get(key);
        if (data != null) {
          programs.add(_mapToProgram(Map<String, dynamic>.from(data)));
        }
      }

      return programs;
    } catch (e) {
      throw StorageFailure('Failed to get all programs: $e');
    }
  }

  @override
  Future<WorkoutProgram?> getActiveProgram() async {
    try {
      final programs = await getAllPrograms();
      return programs.cast<WorkoutProgram?>().firstWhere(
            (p) => p?.isActive ?? false,
            orElse: () => null,
          );
    } catch (e) {
      throw StorageFailure('Failed to get active program: $e');
    }
  }

  @override
  Future<void> setActiveProgram(String programId) async {
    try {
      // Load the program to activate first (fail fast if it doesn't exist)
      final program = await loadProgram(programId);
      if (program == null) {
        throw const ProgramNotFoundFailure();
      }

      // Get all programs and prepare the updates
      final allPrograms = await getAllPrograms();

      // Prepare all updates before making any changes (atomic-like behavior)
      final updates = <Future<void>>[];

      // First, activate the new program (most important operation)
      // This ensures we always have an active program even if deactivation fails
      final activated = program.copyWith(
        isActive: true,
        startDate: program.startDate,
      );
      updates.add(saveProgram(activated));

      // Then, deactivate all other programs
      for (var p in allPrograms) {
        if (p.id != programId && p.isActive) {
          final deactivated = p.copyWith(isActive: false);
          updates.add(saveProgram(deactivated));
        }
      }

      // Execute all updates
      await Future.wait(updates);
    } catch (e) {
      if (e is ProgramNotFoundFailure) rethrow;
      throw StorageFailure('Failed to set active program: $e');
    }
  }

  @override
  Future<void> deactivateProgram(String programId) async {
    try {
      final program = await loadProgram(programId);
      if (program != null) {
        final deactivated = program.copyWith(isActive: false);
        await saveProgram(deactivated);
      }
    } catch (e) {
      throw StorageFailure('Failed to deactivate program: $e');
    }
  }

  @override
  Future<void> deleteProgram(String programId) async {
    try {
      await _programBox.delete(programId);
    } catch (e) {
      throw StorageFailure('Failed to delete program: $e');
    }
  }

  @override
  Future<void> updateProgramProgress(String programId, int currentWeek) async {
    try {
      final program = await loadProgram(programId);
      if (program != null) {
        // Store current week in a separate key for quick access
        await _programBox.put('${programId}_current_week', {
          'week': currentWeek,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw StorageFailure('Failed to update program progress: $e');
    }
  }

  // ==========================================
  // WEEK MANAGEMENT
  // ==========================================

  @override
  Future<void> completeWeek(String programId, int weekNumber) async {
    try {
      final key = '${programId}_completed_weeks';
      final data = _programBox.get(key);

      List<int> completedWeeks = [];
      if (data != null) {
        completedWeeks = List<int>.from(data['weeks'] ?? []);
      }

      if (!completedWeeks.contains(weekNumber)) {
        completedWeeks.add(weekNumber);
        await _programBox.put(key, {'weeks': completedWeeks});
      }
    } catch (e) {
      throw StorageFailure('Failed to complete week: $e');
    }
  }

  @override
  Future<List<int>> getCompletedWeeks(String programId) async {
    try {
      final key = '${programId}_completed_weeks';
      final data = _programBox.get(key);

      if (data == null) return [];
      return List<int>.from(data['weeks'] ?? []);
    } catch (e) {
      throw StorageFailure('Failed to get completed weeks: $e');
    }
  }

  @override
  Future<void> updateWeek(
    String programId,
    int weekNumber,
    ProgramWeek updatedWeek,
  ) async {
    try {
      final program = await loadProgram(programId);
      if (program == null) throw const ProgramNotFoundFailure();

      final updatedProgram = program.updateWeek(weekNumber, updatedWeek);
      await saveProgram(updatedProgram);
    } catch (e) {
      if (e is ProgramNotFoundFailure) rethrow;
      throw StorageFailure('Failed to update week: $e');
    }
  }

  // ==========================================
  // ATHLETE PROFILE
  // ==========================================

  @override
  Future<void> saveProfile(AthleteProfile profile) async {
    try {
      await _profileBox.put(profile.id, _profileToMap(profile));
      // Also save as current profile
      await _profileBox.put('current_profile_id', {'id': profile.id});
    } catch (e) {
      throw StorageFailure('Failed to save profile: $e');
    }
  }

  @override
  Future<AthleteProfile?> loadProfile(String profileId) async {
    try {
      final data = _profileBox.get(profileId);
      if (data == null) return null;
      return _mapToProfile(Map<String, dynamic>.from(data));
    } catch (e) {
      throw StorageFailure('Failed to load profile: $e');
    }
  }

  @override
  Future<AthleteProfile?> getCurrentProfile() async {
    try {
      final data = _profileBox.get('current_profile_id');
      if (data == null) return null;

      final profileId = data['id'] as String;
      return await loadProfile(profileId);
    } catch (e) {
      throw StorageFailure('Failed to get current profile: $e');
    }
  }

  @override
  Future<void> updateProfile(AthleteProfile profile) async {
    await saveProfile(profile);
  }

  @override
  Future<void> updateMaxLift(
    String profileId,
    String liftName,
    double maxWeight,
  ) async {
    try {
      final profile = await loadProfile(profileId);
      if (profile == null) throw const UserNotFoundFailure();

      // This would require LiftType mapping
      // For now, just update the profile
      final updated = profile.copyWith(updatedAt: DateTime.now());
      await saveProfile(updated);
    } catch (e) {
      if (e is UserNotFoundFailure) rethrow;
      throw StorageFailure('Failed to update max lift: $e');
    }
  }

  // ==========================================
  // STATISTICS & ANALYTICS
  // ==========================================

  @override
  Future<int> getTotalWorkoutsCompleted() async {
    try {
      int count = 0;
      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null && data['isCompleted'] == true) {
          count++;
        }
      }
      return count;
    } catch (e) {
      throw StorageFailure('Failed to get total workouts: $e');
    }
  }

  @override
  Future<int> getCurrentStreak() async {
    try {
      final sessions = await getWorkoutHistory(limit: 100);
      if (sessions.isEmpty) return 0;

      int streak = 0;
      DateTime? lastDate;

      for (var session in sessions.reversed) {
        if (!session.isCompleted) continue;

        final sessionDate = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );

        if (lastDate == null) {
          lastDate = sessionDate;
          streak = 1;
        } else {
          final daysDiff = lastDate.difference(sessionDate).inDays;
          if (daysDiff == 1) {
            streak++;
            lastDate = sessionDate;
          } else {
            break;
          }
        }
      }

      return streak;
    } catch (e) {
      throw StorageFailure('Failed to calculate streak: $e');
    }
  }

  @override
  Future<Map<String, double>> getPersonalRecords() async {
    try {
      final Map<String, double> prs = {};

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          final session = _mapToSession(Map<String, dynamic>.from(data));

          for (var set in session.sets) {
            final current = prs[set.exerciseName] ?? 0.0;
            if (set.estimated1RM > current) {
              prs[set.exerciseName] = set.estimated1RM;
            }
          }
        }
      }

      return prs;
    } catch (e) {
      throw StorageFailure('Failed to get personal records: $e');
    }
  }

  @override
  Future<double> getTotalVolume() async {
    try {
      double totalVolume = 0.0;

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          final session = _mapToSession(Map<String, dynamic>.from(data));
          totalVolume += session.totalVolume;
        }
      }

      return totalVolume;
    } catch (e) {
      throw StorageFailure('Failed to get total volume: $e');
    }
  }

  @override
  Future<List<WorkoutSession>> getWorkoutHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final List<WorkoutSession> sessions = [];

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          sessions.add(_mapToSession(Map<String, dynamic>.from(data)));
        }
      }

      // Sort by start time (most recent first)
      sessions.sort((a, b) => b.startTime.compareTo(a.startTime));

      // Apply pagination
      final start = offset;
      final end = (offset + limit).clamp(0, sessions.length);

      return sessions.sublist(start, end);
    } catch (e) {
      throw StorageFailure('Failed to get workout history: $e');
    }
  }

  @override
  Future<List<RPETrend>> getRPETrends({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final sessions = await getSessionsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      final Map<String, List<double>> dailyRPEs = {};
      final Map<String, int> dailySets = {};

      for (var session in sessions) {
        final dateKey = _formatDateKey(session.startTime);

        if (!dailyRPEs.containsKey(dateKey)) {
          dailyRPEs[dateKey] = [];
          dailySets[dateKey] = 0;
        }

        dailyRPEs[dateKey]!.addAll(session.sets.map((s) => s.rpe));
        dailySets[dateKey] = dailySets[dateKey]! + session.sets.length;
      }

      final List<RPETrend> trends = [];
      dailyRPEs.forEach((dateKey, rpes) {
        final avgRPE = rpes.reduce((a, b) => a + b) / rpes.length;
        trends.add(RPETrend(
          date: DateTime.parse(dateKey),
          averageRPE: avgRPE,
          totalSets: dailySets[dateKey]!,
        ));
      });

      trends.sort((a, b) => a.date.compareTo(b.date));
      return trends;
    } catch (e) {
      throw StorageFailure('Failed to get RPE trends: $e');
    }
  }

  // ==========================================
  // SEARCH & FILTERING
  // ==========================================

  @override
  Future<List<WorkoutSession>> searchSessionsByExercise(
    String exerciseName,
  ) async {
    try {
      final List<WorkoutSession> sessions = [];

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          final session = _mapToSession(Map<String, dynamic>.from(data));

          if (session.sets.any((set) => set.exerciseName
              .toLowerCase()
              .contains(exerciseName.toLowerCase()))) {
            sessions.add(session);
          }
        }
      }

      sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
      return sessions;
    } catch (e) {
      throw StorageFailure('Failed to search sessions: $e');
    }
  }

  @override
  Future<List<WorkoutSession>> getSessionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final List<WorkoutSession> sessions = [];

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          final session = _mapToSession(Map<String, dynamic>.from(data));

          if (session.startTime.isAfter(startDate) &&
              session.startTime.isBefore(endDate)) {
            sessions.add(session);
          }
        }
      }

      sessions.sort((a, b) => a.startTime.compareTo(b.startTime));
      return sessions;
    } catch (e) {
      throw StorageFailure('Failed to get sessions by date range: $e');
    }
  }

  @override
  Future<List<LoggedSet>> getBestSetsForExercise(
    String exerciseName, {
    int limit = 10,
  }) async {
    try {
      final List<LoggedSet> allSets = [];

      for (var key in _sessionBox.keys) {
        final data = _sessionBox.get(key);
        if (data != null) {
          final session = _mapToSession(Map<String, dynamic>.from(data));
          allSets.addAll(
            session.sets.where((set) =>
                set.exerciseName.toLowerCase() == exerciseName.toLowerCase()),
          );
        }
      }

      // Sort by estimated 1RM
      allSets.sort((a, b) => b.estimated1RM.compareTo(a.estimated1RM));

      return allSets.take(limit).toList();
    } catch (e) {
      throw StorageFailure('Failed to get best sets: $e');
    }
  }

  // ==========================================
  // HELPER METHODS
  // ==========================================

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> _sessionToMap(WorkoutSession session) {
    return session.toJson();
  }

  WorkoutSession _mapToSession(Map<String, dynamic> map) {
    return WorkoutSession.fromJson(map);
  }

  Map<String, dynamic> _programToMap(WorkoutProgram program) {
    // Implement program serialization
    return program.toJson();
  }

  WorkoutProgram _mapToProgram(Map<String, dynamic> map) {
    // Implement program deserialization
    return WorkoutProgram.fromJson(map);
  }

  Map<String, dynamic> _profileToMap(AthleteProfile profile) {
    // Implement profile serialization
    return profile.toJson();
  }

  AthleteProfile _mapToProfile(Map<String, dynamic> map) {
    // Implement profile deserialization
    return AthleteProfile.fromJson(map);
  }
}
