import '../models/athlete_profile_dto.dart';
import '../models/workout_program_dto.dart';
import '../models/workout_session_dto.dart';

/// Abstract interface for local data storage operations
/// This abstraction allows us to swap out Hive for other storage solutions if needed
abstract class LocalDataSource {
  // ==========================================
  // INITIALIZATION
  // ==========================================

  /// Initialize the local storage system
  Future<void> initialize();

  /// Close all storage connections
  Future<void> close();

  /// Clear all data (for testing or reset)
  Future<void> clearAll();

  // ==========================================
  // ATHLETE PROFILE OPERATIONS
  // ==========================================

  /// Get the athlete profile (there should only be one)
  Future<AthleteProfileDto?> getAthleteProfile();

  /// Save or update the athlete profile
  Future<void> saveAthleteProfile(AthleteProfileDto profile);

  /// Delete the athlete profile
  Future<void> deleteAthleteProfile();

  // ==========================================
  // WORKOUT PROGRAM OPERATIONS
  // ==========================================

  /// Get all workout programs
  Future<List<WorkoutProgramDto>> getAllPrograms();

  /// Get a specific program by ID
  Future<WorkoutProgramDto?> getProgramById(String id);

  /// Get the active program
  Future<WorkoutProgramDto?> getActiveProgram();

  /// Save or update a workout program
  Future<void> saveProgram(WorkoutProgramDto program);

  /// Delete a program by ID
  Future<void> deleteProgram(String id);

  /// Set a program as active (and deactivate others)
  Future<void> setActiveProgram(String programId);

  // ==========================================
  // WORKOUT SESSION OPERATIONS
  // ==========================================

  /// Get all workout sessions
  Future<List<WorkoutSessionDto>> getAllSessions();

  /// Get a specific session by ID
  Future<WorkoutSessionDto?> getSessionById(String id);

  /// Get sessions for a specific program
  Future<List<WorkoutSessionDto>> getSessionsByProgram(String programId);

  /// Get sessions for a specific week in a program
  Future<List<WorkoutSessionDto>> getSessionsByWeek(
    String programId,
    int weekNumber,
  );

  /// Get the most recent session
  Future<WorkoutSessionDto?> getMostRecentSession();

  /// Get completed sessions only
  Future<List<WorkoutSessionDto>> getCompletedSessions();

  /// Save or update a workout session
  Future<void> saveSession(WorkoutSessionDto session);

  /// Delete a session by ID
  Future<void> deleteSession(String id);

  /// Get sessions within a date range
  Future<List<WorkoutSessionDto>> getSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  // ==========================================
  // STATISTICS & QUERIES
  // ==========================================

  /// Get total number of completed workouts
  Future<int> getTotalCompletedWorkouts();

  /// Get workout count in date range
  Future<int> getWorkoutCountInRange(DateTime startDate, DateTime endDate);

  /// Check if a specific workout day has been completed
  Future<bool> isWorkoutCompleted(String programId, int weekNumber, int dayNumber);
}
