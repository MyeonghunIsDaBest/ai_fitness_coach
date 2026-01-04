import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import '../enums/sport.dart';

// Domain
import '../../domain/repositories/training_repository.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/daily_workout.dart';

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

final currentProgramIdProvider = StateProvider<String?>((ref) => null);
final currentSessionIdProvider = StateProvider<String?>((ref) => null);
final currentWeekProvider = StateProvider<int>((ref) => 1);
final selectedSportProvider = StateProvider<Sport?>((ref) => null);

// ==========================================
// ASYNC DATA PROVIDERS
// ==========================================

final availableProgramsProvider =
    FutureProvider.autoDispose<List<WorkoutProgram>>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  final result = await repository.getAllPrograms();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (programs) => programs,
  );
});

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

final currentWeekWorkoutsProvider =
    FutureProvider.autoDispose<List<DailyWorkout>>((ref) async {
  final program = await ref.watch(currentProgramProvider.future);
  if (program == null) return [];

  final weekNumber = ref.watch(currentWeekProvider);
  final week = program.weeks.firstWhere(
    (w) => w.weekNumber == weekNumber,
    orElse: () => program.weeks.first,
  );

  return week.workouts;
});

