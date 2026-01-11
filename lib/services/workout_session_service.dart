import '../domain/repositories/training_repository.dart';
import '../domain/models/logged_set.dart';

/// Service for managing workout sessions
class WorkoutSessionService {
  final TrainingRepository _repository;

  WorkoutSessionService(this._repository);

  // ==========================================
  // SESSION LIFECYCLE
  // ==========================================

  /// Start a new workout session
  Future<String> startSession({
    required String programId,
    required int weekNumber,
    required int dayNumber,
    required String workoutName,
  }) async {
    final sessionId = await _repository.createSession(
      programId: programId,
      weekNumber: weekNumber,
      dayNumber: dayNumber,
      workoutName: workoutName,
      startTime: DateTime.now(),
    );
    return sessionId;
  }

  /// Complete a workout session
  Future<void> completeSession(String sessionId, {String? notes}) async {
    await _repository.completeSession(
      sessionId,
      endTime: DateTime.now(),
      notes: notes,
    );
  }

  /// Delete a workout session
  Future<void> deleteSession(String sessionId) async {
    await _repository.deleteSession(sessionId);
  }

  // ==========================================
  // SET LOGGING
  // ==========================================

  /// Log a single set to a workout session
  Future<void> logSet({
    required String sessionId,
    required String exerciseId,
    required String exerciseName,
    required int setNumber,
    required double weight,
    required String weightUnit,
    required int reps,
    required double rpe,
    double? targetRPE,
    String? notes,
  }) async {
    final set = LoggedSet.create(
      workoutSessionId: sessionId,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      setNumber: setNumber,
      weight: weight,
      weightUnit: weightUnit,
      reps: reps,
      rpe: rpe,
      targetRPE: targetRPE,
      notes: notes,
    );

    await _repository.logSet(sessionId, set);
  }

  // ==========================================
  // SESSION RETRIEVAL
  // ==========================================

  /// Get a specific workout session by ID
  Future<WorkoutSession?> getSession(String sessionId) async {
    return await _repository.getSession(sessionId);
  }

  /// Get all sessions for a specific week
  Future<List<WorkoutSession>> getWeekSessions(
    String programId,
    int weekNumber,
  ) async {
    return await _repository.getWeekSessions(programId, weekNumber);
  }

  /// Get all sessions for a program
  Future<List<WorkoutSession>> getAllProgramSessions(String programId) async {
    return await _repository.getAllProgramSessions(programId);
  }

  /// Get recent workout sessions (for history)
  Future<List<WorkoutSession>> getRecentSessions({int limit = 20}) async {
    return await _repository.getWorkoutHistory(limit: limit);
  }

  // ==========================================
  // SESSION UPDATES
  // ==========================================

  /// Update session notes
  Future<void> updateSessionNotes(String sessionId, String notes) async {
    await _repository.updateSessionNotes(sessionId, notes);
  }

  // ==========================================
  // STATISTICS
  // ==========================================

  /// Calculate session statistics
  Future<SessionStatistics> getSessionStatistics(String sessionId) async {
    final session = await getSession(sessionId);
    if (session == null) {
      throw Exception('Session not found');
    }

    // Calculate total sets
    final totalSets = session.sets.length;

    // Calculate total volume (sum of weight * reps for all sets)
    final totalVolume = session.sets.fold<double>(
      0.0,
      (sum, set) => sum + (set.weight * set.reps),
    );

    // Calculate average RPE
    final averageRPE = session.sets.isEmpty
        ? 0.0
        : session.sets.fold<double>(0.0, (sum, set) => sum + set.rpe) /
            session.sets.length;

    // Get unique exercises
    final uniqueExercises = session.sets.map((s) => s.exerciseName).toSet();

    // Calculate duration
    Duration? duration;
    if (session.endTime != null) {
      duration = session.endTime!.difference(session.startTime);
    }

    return SessionStatistics(
      totalSets: totalSets,
      totalVolume: totalVolume,
      averageRPE: averageRPE,
      duration: duration,
      completedExercises: uniqueExercises.length,
    );
  }

  /// Check if a session is in progress
  Future<bool> hasActiveSession() async {
    final recent = await getRecentSessions(limit: 1);
    if (recent.isEmpty) return false;
    return recent.first.endTime == null;
  }

  /// Get the active session ID if one exists
  Future<String?> getActiveSessionId() async {
    final recent = await getRecentSessions(limit: 1);
    if (recent.isEmpty) return null;
    if (recent.first.endTime == null) {
      return recent.first.id;
    }
    return null;
  }

  // ==========================================
  // LEGACY METHODS
  // ==========================================

  @Deprecated('Use startSession instead')
  Future<void> saveSession(dynamic session) async {
    throw UnimplementedError('Use startSession instead');
  }

  @Deprecated('Use getRecentSessions instead')
  Future<List<dynamic>> getSessions() async {
    return await getRecentSessions();
  }
}

/// Statistics for a workout session
class SessionStatistics {
  final int totalSets;
  final double totalVolume;
  final double averageRPE;
  final Duration? duration;
  final int completedExercises;

  const SessionStatistics({
    required this.totalSets,
    required this.totalVolume,
    required this.averageRPE,
    this.duration,
    required this.completedExercises,
  });

  /// Format duration for display
  String get durationDisplay {
    if (duration == null) return 'In Progress';
    final hours = duration!.inHours;
    final minutes = duration!.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Check if session was completed successfully
  bool get wasCompleted => duration != null;

  @override
  String toString() {
    return 'SessionStatistics(sets: $totalSets, volume: ${totalVolume.toStringAsFixed(1)}kg, '
        'avgRPE: ${averageRPE.toStringAsFixed(1)}, duration: $durationDisplay)';
  }
}
