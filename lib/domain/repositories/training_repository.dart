import '../../domain/models/logged_set.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/athlete_profile.dart';
import '../../domain/models/workout_session.dart';

export '../../domain/models/workout_session.dart';

/// Repository interface for training-related data operations
/// Defines contracts for data access without specifying implementation
///
/// Implementations can use:
/// - Local storage (Hive, SQLite)
/// - Remote storage (Firebase, REST API)
/// - In-memory (for testing)
abstract class TrainingRepository {
  // ==========================================
  // WORKOUT SESSION MANAGEMENT
  // ==========================================

  /// Log a single set to a workout session
  Future<void> logSet(String sessionId, LoggedSet set);

  /// Get a specific workout session
  Future<WorkoutSession?> getSession(String sessionId);

  /// Get all sessions for a specific week
  Future<List<WorkoutSession>> getWeekSessions(
    String programId,
    int weekNumber,
  );

  /// Get all sessions for a program
  Future<List<WorkoutSession>> getAllProgramSessions(String programId);

  /// Create a new workout session
  Future<String> createSession({
    required String programId,
    required int weekNumber,
    required int dayNumber,
    required String workoutName,
    required DateTime startTime,
  });

  /// Complete a workout session
  Future<void> completeSession(
    String sessionId, {
    required DateTime endTime,
    String? notes,
  });

  /// Delete a workout session
  Future<void> deleteSession(String sessionId);

  /// Update session notes
  Future<void> updateSessionNotes(String sessionId, String notes);

  // ==========================================
  // PROGRAM MANAGEMENT
  // ==========================================

  /// Save a workout program
  Future<void> saveProgram(WorkoutProgram program);

  /// Load a workout program by ID
  Future<WorkoutProgram?> loadProgram(String programId);

  /// Get all available programs
  Future<List<WorkoutProgram>> getAllPrograms();

  /// Get active program for user
  Future<WorkoutProgram?> getActiveProgram();

  /// Set a program as active
  Future<void> setActiveProgram(String programId);

  /// Deactivate current program
  Future<void> deactivateProgram(String programId);

  /// Delete a program
  Future<void> deleteProgram(String programId);

  /// Update program progress
  Future<void> updateProgramProgress(
    String programId,
    int currentWeek,
  );

  // ==========================================
  // WEEK MANAGEMENT
  // ==========================================

  /// Mark a week as completed
  Future<void> completeWeek(String programId, int weekNumber);

  /// Get completed weeks for a program
  Future<List<int>> getCompletedWeeks(String programId);

  /// Update week data (for progression adjustments)
  Future<void> updateWeek(
    String programId,
    int weekNumber,
    ProgramWeek updatedWeek,
  );

  // ==========================================
  // ATHLETE PROFILE
  // ==========================================

  /// Save athlete profile
  Future<void> saveProfile(AthleteProfile profile);

  /// Load athlete profile
  Future<AthleteProfile?> loadProfile(String profileId);

  /// Get current user's profile
  Future<AthleteProfile?> getCurrentProfile();

  /// Update profile
  Future<void> updateProfile(AthleteProfile profile);

  /// Update max lift
  Future<void> updateMaxLift(
    String profileId,
    String liftName,
    double maxWeight,
  );

  // ==========================================
  // STATISTICS & ANALYTICS
  // ==========================================

  /// Get total workouts completed
  Future<int> getTotalWorkoutsCompleted();

  /// Get current training streak (consecutive days)
  Future<int> getCurrentStreak();

  /// Get personal records
  Future<Map<String, double>> getPersonalRecords();

  /// Get total volume lifted (all time)
  Future<double> getTotalVolume();

  /// Get workout history (last N workouts)
  Future<List<WorkoutSession>> getWorkoutHistory({
    int limit = 20,
    int offset = 0,
  });

  /// Get RPE trends for a date range
  Future<List<RPETrend>> getRPETrends({
    required DateTime startDate,
    required DateTime endDate,
  });

  // ==========================================
  // SEARCH & FILTERING
  // ==========================================

  /// Search workout sessions by exercise name
  Future<List<WorkoutSession>> searchSessionsByExercise(String exerciseName);

  /// Get sessions within date range
  Future<List<WorkoutSession>> getSessionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get best sets for an exercise
  Future<List<LoggedSet>> getBestSetsForExercise(
    String exerciseName, {
    int limit = 10,
  });
}

/// Data class for RPE trends over time
class RPETrend {
  final DateTime date;
  final double averageRPE;
  final int totalSets;

  const RPETrend({
    required this.date,
    required this.averageRPE,
    required this.totalSets,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'averageRPE': averageRPE,
      'totalSets': totalSets,
    };
  }

  factory RPETrend.fromJson(Map<String, dynamic> json) {
    return RPETrend(
      date: DateTime.parse(json['date']),
      averageRPE: json['averageRPE'],
      totalSets: json['totalSets'],
    );
  }
}
