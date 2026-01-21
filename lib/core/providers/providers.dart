import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import '../enums/sport.dart';
import '../enums/time_range.dart';

// Domain
import '../../domain/repositories/training_repository.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/athlete_profile.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/logged_set.dart';
import '../../domain/models/chart_data.dart';

// Data
import '../../data/repositories/training_repository_impl.dart';
import '../../data/program_templates.dart';
import '../../data/local/hive_service.dart';

// Services
import '../../services/program_service.dart';
import '../../services/rpe_feedback_service.dart';
import '../../services/progression_service.dart';
import '../../services/workout_session_service.dart';
import '../../services/rpe_analytics_service.dart';

// ==========================================
// LOCAL STORAGE PROVIDERS
// ==========================================

/// Hive service provider - manages all local data
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Hive box providers for type-safe access
final workoutBoxProvider = Provider<Box<Map<dynamic, dynamic>>>((ref) {
  return Hive.box<Map<dynamic, dynamic>>('workouts');
});

final programBoxProvider = Provider<Box<Map<dynamic, dynamic>>>((ref) {
  return Hive.box<Map<dynamic, dynamic>>('programs');
});

final profileBoxProvider = Provider<Box<Map<dynamic, dynamic>>>((ref) {
  return Hive.box<Map<dynamic, dynamic>>('profiles');
});

final sessionBoxProvider = Provider<Box<Map<dynamic, dynamic>>>((ref) {
  return Hive.box<Map<dynamic, dynamic>>('sessions');
});

final settingsBoxProvider = Provider<Box<Map<dynamic, dynamic>>>((ref) {
  return Hive.box<Map<dynamic, dynamic>>('settings');
});

// ==========================================
// REPOSITORY PROVIDER
// ==========================================

/// Training repository - handles all data operations
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

/// Program service - manages workout programs
final programServiceProvider = Provider<ProgramService>((ref) {
  return ProgramService(ref.watch(trainingRepositoryProvider));
});

/// RPE feedback service - provides coaching feedback
final rpeFeedbackServiceProvider = Provider<RPEFeedbackService>((ref) {
  return RPEFeedbackService();
});

/// Progression service - handles load adjustments
final progressionServiceProvider = Provider<ProgressionService>((ref) {
  return ProgressionService(ref.watch(trainingRepositoryProvider));
});

/// Workout session service - manages active workouts
final workoutSessionServiceProvider = Provider<WorkoutSessionService>((ref) {
  return WorkoutSessionService(ref.watch(trainingRepositoryProvider));
});

/// RPE analytics service - generates charts and insights
final rpeAnalyticsServiceProvider = Provider<RPEAnalyticsService>((ref) {
  return RPEAnalyticsService(ref.watch(trainingRepositoryProvider));
});

// ==========================================
// SIMPLE STATE PROVIDERS
// ==========================================

/// Currently selected sport (onboarding)
final selectedSportProvider = StateProvider<Sport?>((ref) => null);

/// Current week number in active program
final currentWeekProvider = StateProvider<int>((ref) => 1);

/// Selected time range for analytics
final selectedTimeRangeProvider =
    StateProvider<TimeRange>((ref) => TimeRange.month);

/// Onboarding completion status
final onboardingCompleteProvider = StateProvider<bool>((ref) {
  final profile = ref.watch(currentAthleteProfileProvider);
  return profile != null;
});

/// Active workout session ID (null when not in workout)
final activeSessionIdProvider = StateProvider<String?>((ref) => null);

/// Current day of week being viewed (1-7)
final selectedDayProvider = StateProvider<int>((ref) => DateTime.now().weekday);

/// Loading states
final isLoadingProvider = StateProvider<bool>((ref) => false);
final isSavingProvider = StateProvider<bool>((ref) => false);

// ==========================================
// ATHLETE PROFILE PROVIDERS
// ==========================================

/// Current athlete profile
final currentAthleteProfileProvider =
    FutureProvider<AthleteProfile?>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getCurrentProfile();
});

/// Save athlete profile
final saveAthleteProfileProvider =
    Provider<Future<void> Function(AthleteProfile)>((ref) {
  return (AthleteProfile profile) async {
    final repository = ref.watch(trainingRepositoryProvider);
    await repository.saveProfile(profile);
    // Refresh the profile provider
    ref.invalidate(currentAthleteProfileProvider);
  };
});

// ==========================================
// PROGRAM PROVIDERS
// ==========================================

/// All available program templates
final availableProgramsProvider =
    FutureProvider<List<WorkoutProgram>>((ref) async {
  return ProgramTemplates.getAllTemplates();
});

/// Currently selected/active program
final activeProgramProvider = FutureProvider<WorkoutProgram?>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getActiveProgram();
});

/// Programs filtered by sport
final programsBySportProvider =
    FutureProvider.family<List<WorkoutProgram>, Sport?>((ref, sport) async {
  final allPrograms = await ref.watch(availableProgramsProvider.future);
  if (sport == null) return allPrograms;
  return allPrograms.where((p) => p.sport == sport).toList();
});

/// Select and activate a program
final selectProgramProvider =
    Provider<Future<void> Function(WorkoutProgram)>((ref) {
  return (WorkoutProgram program) async {
    final repository = ref.watch(trainingRepositoryProvider);
    await repository.saveProgram(program);
    await repository.setActiveProgram(program.id);
    // Refresh active program
    ref.invalidate(activeProgramProvider);
    ref.invalidate(currentWeekProvider);
  };
});

// ==========================================
// WEEK & WORKOUT PROVIDERS
// ==========================================

/// Current week's workouts
final currentWeekWorkoutsProvider =
    FutureProvider<List<DailyWorkout>>((ref) async {
  final program = await ref.watch(activeProgramProvider.future);
  if (program == null) return [];

  final weekNumber = ref.watch(currentWeekProvider);
  final week = program.getWeek(weekNumber);
  if (week == null) return [];

  return week.dailyWorkouts;
});

/// Workout for a specific day
final workoutForDayProvider =
    FutureProvider.family<DailyWorkout?, int>((ref, dayNumber) async {
  final workouts = await ref.watch(currentWeekWorkoutsProvider.future);
  try {
    return workouts.firstWhere((w) => w.dayNumber == dayNumber);
  } catch (_) {
    return null;
  }
});

/// Completed workouts for current week
final completedWorkoutsProvider = StateProvider<Set<int>>((ref) => {});

/// Mark workout as complete
final completeWorkoutProvider = Provider<void Function(int)>((ref) {
  return (int dayNumber) {
    final completed = ref.read(completedWorkoutsProvider.notifier);
    completed.update((state) => {...state, dayNumber});
  };
});

// ==========================================
// WORKOUT SESSION PROVIDERS
// ==========================================

/// Active workout session data
final activeWorkoutSessionProvider =
    FutureProvider<WorkoutSession?>((ref) async {
  final sessionId = ref.watch(activeSessionIdProvider);
  if (sessionId == null) return null;

  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getSession(sessionId);
});

/// Logged sets in current session
final loggedSetsProvider = StateProvider<List<LoggedSet>>((ref) => []);

/// Add a logged set
final addLoggedSetProvider = Provider<void Function(LoggedSet)>((ref) {
  return (LoggedSet set) {
    ref.read(loggedSetsProvider.notifier).update((state) => [...state, set]);
  };
});

/// Start a new workout session
final startWorkoutSessionProvider = Provider<
    Future<String> Function({
      required String programId,
      required int weekNumber,
      required int dayNumber,
      required String workoutName,
    })>((ref) {
  return ({
    required String programId,
    required int weekNumber,
    required int dayNumber,
    required String workoutName,
  }) async {
    final service = ref.watch(workoutSessionServiceProvider);
    final sessionId = await service.saveSession({
      'programId': programId,
      'weekNumber': weekNumber,
      'dayNumber': dayNumber,
      'workoutName': workoutName,
      'startTime': DateTime.now(),
    } as dynamic);

    // Set as active session
    ref.read(activeSessionIdProvider.notifier).state = sessionId as String?;
    // Clear logged sets
    ref.read(loggedSetsProvider.notifier).state = [];

    return sessionId as String;
  };
});

/// Complete current workout session
final completeWorkoutSessionProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final sessionId = ref.read(activeSessionIdProvider);
    if (sessionId == null) return;

    final repository = ref.watch(trainingRepositoryProvider);
    await repository.completeSession(
      sessionId,
      endTime: DateTime.now(),
    );

    // Clear active session
    ref.read(activeSessionIdProvider.notifier).state = null;
    ref.read(loggedSetsProvider.notifier).state = [];
  };
});

/// Clear workout session data (for post-workout cleanup)
final clearWorkoutSessionProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(activeSessionIdProvider.notifier).state = null;
    ref.read(loggedSetsProvider.notifier).state = [];
  };
});

// ==========================================
// HISTORY PROVIDERS
// ==========================================

/// Workout history (most recent first)
final workoutHistoryProvider =
    FutureProvider.family<List<WorkoutSession>, int>((ref, limit) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getWorkoutHistory(limit: limit);
});

/// Workout history for a specific date range
final workoutHistoryByDateProvider =
    FutureProvider.family<List<WorkoutSession>, (DateTime, DateTime)>(
        (ref, dateRange) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getSessionsByDateRange(
    startDate: dateRange.$1,
    endDate: dateRange.$2,
  );
});

// ==========================================
// ANALYTICS PROVIDERS
// ==========================================

/// RPE chart data for selected time range
final rpeChartDataProvider = FutureProvider<RPEChartData>((ref) async {
  final timeRange = ref.watch(selectedTimeRangeProvider);
  final service = ref.watch(rpeAnalyticsServiceProvider);
  return await service.getRPEChartData(timeRange: timeRange);
});

/// Exercise statistics
final exerciseStatsProvider = FutureProvider<List<ExerciseStats>>((ref) async {
  final timeRange = ref.watch(selectedTimeRangeProvider);
  final service = ref.watch(rpeAnalyticsServiceProvider);
  return await service.getExerciseStats(timeRange: timeRange);
});

// ==========================================
// STATISTICS PROVIDERS
// ==========================================

/// Total workouts completed
final totalWorkoutsProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getTotalWorkoutsCompleted();
});

/// Current training streak
final currentStreakProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getCurrentStreak();
});

/// Personal records
final personalRecordsProvider =
    FutureProvider<Map<String, double>>((ref) async {
  final repository = ref.watch(trainingRepositoryProvider);
  return await repository.getPersonalRecords();
});

// ==========================================
// UI STATE PROVIDERS
// ==========================================

/// Selected tab in main navigation
final selectedNavTabProvider = StateProvider<int>((ref) => 0);

/// Show/hide bottom nav bar
final showBottomNavProvider = StateProvider<bool>((ref) => true);

/// Dark mode preference
final darkModeProvider = StateProvider<bool>((ref) => true);

/// Selected weight unit
final weightUnitProvider = StateProvider<String>((ref) => 'kg');

// ==========================================
// HELPER EXTENSIONS
// ==========================================

/// Extension to refresh providers easily
extension RefreshExtension on WidgetRef {
  /// Refresh all program-related data
  void refreshPrograms() {
    invalidate(availableProgramsProvider);
    invalidate(activeProgramProvider);
    invalidate(currentWeekWorkoutsProvider);
  }

  /// Refresh workout history
  void refreshHistory() {
    invalidate(workoutHistoryProvider);
    invalidate(rpeChartDataProvider);
    invalidate(exerciseStatsProvider);
  }

  /// Refresh statistics
  void refreshStats() {
    invalidate(totalWorkoutsProvider);
    invalidate(currentStreakProvider);
    invalidate(personalRecordsProvider);
  }
}
