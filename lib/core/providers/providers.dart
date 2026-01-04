import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import '../enums/sport.dart';

// Domain
import '../../domain/repositories/training_repository.dart';
import '../../domain/entities/workout_program.dart';
import '../../domain/entities/daily_workout.dart';

// Data
import '../../data/repositories/training_repository_impl.dart';

// Services
import '../../services/program_service.dart';
import '../../services/rpe_feedback_service.dart';
import '../../services/progression_service.dart';
import '../../services/workout_session_service.dart';

// ==========================================
// HIVE BOX PROVIDERS
// ==========================================

final workoutBoxProvider = Provider<Box>((ref) {
  return Hive.box('workouts');
});

final programBoxProvider = Provider<Box>((ref) {
  return Hive.box('programs');
});

final profileBoxProvider = Provider<Box>((ref) {
  return Hive.box('profiles');
});

final sessionBoxProvider = Provider<Box>((ref) {
  return Hive.box('sessions');
});

// ==========================================
// REPOSITORY PROVIDER
// ==========================================

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return TrainingRepositoryImpl(
    workoutBox: ref.watch(workoutBoxProvider),
    programBox: ref.watch(programBoxProvider),
    profileBox: ref.watch(profileBoxProvider),
    sessionBox: ref.watch(sessionBoxProvider),
  );
});

// ==========================================
// SERVICE PROVIDERS
// ==========================================

final programServiceProvider = Provider<ProgramService>((ref) {
  return ProgramService(ref.watch(trainingRepositoryProvider));
});

final rpeFeedbackServiceProvider = Provider<RPEFeedbackService>((ref) {
  return RPEFeedbackService();
});

final progressionServiceProvider = Provider<ProgressionService>((ref) {
  return ProgressionService(ref.watch(trainingRepositoryProvider));
});

final workoutSessionServiceProvider = Provider<WorkoutSessionService>((ref) {
  return WorkoutSessionService(ref.watch(trainingRepositoryProvider));
});

// ==========================================
// STATE PROVIDERS
// ==========================================

/// Current active program ID
final currentProgramIdProvider = StateProvider<String?>((ref) => null);

/// Current workout session ID
final currentSessionIdProvider = StateProvider<String?>((ref) => null);

/// Current week number in program
final currentWeekProvider = StateProvider<int>((ref) => 1);

/// Selected sport
final selectedSportProvider = StateProvider<Sport?>((ref) => null);

/// User experience level
final experienceLevelProvider = StateProvider<String?>((ref) => null);

/// Primary training goal
final primaryGoalProvider = StateProvider<String?>((ref) => null);

/// Workouts per week
final workoutsPerWeekProvider = StateProvider<int>((ref) => 3);

// ==========================================
// ASYNC DATA PROVIDERS
// ==========================================

/// Get all available programs
final availableProgramsProvider =
    FutureProvider.autoDispose<List<WorkoutProgram>>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  final result = await repository.getAllPrograms();

  return result.fold(
    (failure) {
      throw Exception(failure.message);
    },
    (programs) => programs,
  );
});

/// Get current active program
final currentProgramProvider =
    FutureProvider.autoDispose<WorkoutProgram?>((ref) async {
  final programId = ref.watch(currentProgramIdProvider);
  if (programId == null) return null;

  final repository = ref.watch(trainingRepositoryProvider);
  final result = await repository.getProgram(programId);

  return result.fold(
    (failure) => null,
    (program) => program,
  );
});

/// Get current week's workouts
final currentWeekWorkoutsProvider =
    FutureProvider.autoDispose<List<DailyWorkout>>((ref) async {
  final program = await ref.watch(currentProgramProvider.future);
  if (program == null) return [];

  final weekNumber = ref.watch(currentWeekProvider);

  // Find the week
  final week = program.weeks.firstWhere(
    (w) => w.weekNumber == weekNumber,
    orElse: () => program.weeks.first,
  );

  return week.workouts;
});

/// Get workout sessions history
final workoutHistoryProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  final result = await repository.getWorkoutSessions();

  return result.fold(
    (failure) => [],
    (sessions) => sessions,
  );
});
