import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/athlete_profile.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/workout_session.dart';
import '../../data/local/hive_data_source.dart';
import '../../data/mappers/athlete_profile_mapper.dart';
import '../../data/mappers/workout_program_mapper.dart';
import '../../data/mappers/workout_session_mapper.dart';

part 'training_providers.g.dart';

// ==========================================
// DATA SOURCE PROVIDER
// ==========================================

/// Provider for the Hive data source
/// KeepAlive ensures singleton behavior
@Riverpod(keepAlive: true)
HiveDataSource hiveDataSource(HiveDataSourceRef ref) {
  return HiveDataSource();
}

// ==========================================
// ATHLETE PROFILE PROVIDERS
// ==========================================

/// Provider for the athlete profile
/// Returns null if no profile exists
@riverpod
Future<AthleteProfile?> athleteProfile(AthleteProfileRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dto = await dataSource.getAthleteProfile();
  if (dto == null) return null;
  return AthleteProfileMapper.toEntity(dto);
}

/// Notifier for managing athlete profile state
@riverpod
class AthleteProfileNotifier extends _$AthleteProfileNotifier {
  @override
  Future<AthleteProfile?> build() async {
    final dataSource = ref.watch(hiveDataSourceProvider);
    final dto = await dataSource.getAthleteProfile();
    if (dto == null) return null;
    return AthleteProfileMapper.toEntity(dto);
  }

  /// Save or update athlete profile
  Future<void> saveProfile(AthleteProfile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      final dto = AthleteProfileMapper.toDto(profile);
      await dataSource.saveAthleteProfile(dto);
      return profile;
    });
  }

  /// Delete athlete profile
  Future<void> deleteProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      await dataSource.deleteAthleteProfile();
      return null;
    });
  }
}

// ==========================================
// WORKOUT PROGRAM PROVIDERS
// ==========================================

/// Provider for all workout programs
@riverpod
Future<List<WorkoutProgram>> allPrograms(AllProgramsRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dtos = await dataSource.getAllPrograms();
  return dtos.map((dto) => WorkoutProgramMapper.toEntity(dto)).toList();
}

/// Provider for the active workout program
@riverpod
Future<WorkoutProgram?> activeProgram(ActiveProgramRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dto = await dataSource.getActiveProgram();
  if (dto == null) return null;
  return WorkoutProgramMapper.toEntity(dto);
}

/// Provider for a specific program by ID
@riverpod
Future<WorkoutProgram?> programById(ProgramByIdRef ref, String id) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dto = await dataSource.getProgramById(id);
  if (dto == null) return null;
  return WorkoutProgramMapper.toEntity(dto);
}

/// Notifier for managing workout program state
@riverpod
class WorkoutProgramNotifier extends _$WorkoutProgramNotifier {
  @override
  Future<List<WorkoutProgram>> build() async {
    final dataSource = ref.watch(hiveDataSourceProvider);
    final dtos = await dataSource.getAllPrograms();
    return dtos.map((dto) => WorkoutProgramMapper.toEntity(dto)).toList();
  }

  /// Save or update a program
  Future<void> saveProgram(WorkoutProgram program) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      final dto = WorkoutProgramMapper.toDto(program);
      await dataSource.saveProgram(dto);

      // Refresh the list
      final dtos = await dataSource.getAllPrograms();
      return dtos.map((dto) => WorkoutProgramMapper.toEntity(dto)).toList();
    });
  }

  /// Delete a program
  Future<void> deleteProgram(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      await dataSource.deleteProgram(id);

      // Refresh the list
      final dtos = await dataSource.getAllPrograms();
      return dtos.map((dto) => WorkoutProgramMapper.toEntity(dto)).toList();
    });
  }

  /// Set a program as active
  Future<void> setActiveProgram(String programId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      await dataSource.setActiveProgram(programId);

      // Invalidate active program provider to trigger refresh
      ref.invalidate(activeProgramProvider);

      // Refresh the list
      final dtos = await dataSource.getAllPrograms();
      return dtos.map((dto) => WorkoutProgramMapper.toEntity(dto)).toList();
    });
  }
}

// ==========================================
// WORKOUT SESSION PROVIDERS
// ==========================================

/// Provider for all workout sessions
@riverpod
Future<List<WorkoutSession>> allSessions(AllSessionsRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dtos = await dataSource.getAllSessions();
  return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
}

/// Provider for completed sessions only
@riverpod
Future<List<WorkoutSession>> completedSessions(CompletedSessionsRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dtos = await dataSource.getCompletedSessions();
  return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
}

/// Provider for sessions by program
@riverpod
Future<List<WorkoutSession>> sessionsByProgram(
  SessionsByProgramRef ref,
  String programId,
) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dtos = await dataSource.getSessionsByProgram(programId);
  return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
}

/// Provider for sessions by week
@riverpod
Future<List<WorkoutSession>> sessionsByWeek(
  SessionsByWeekRef ref,
  String programId,
  int weekNumber,
) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dtos = await dataSource.getSessionsByWeek(programId, weekNumber);
  return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
}

/// Provider for most recent session
@riverpod
Future<WorkoutSession?> mostRecentSession(MostRecentSessionRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  final dto = await dataSource.getMostRecentSession();
  if (dto == null) return null;
  return WorkoutSessionMapper.toEntity(dto);
}

/// Notifier for managing workout session state
@riverpod
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier {
  @override
  Future<List<WorkoutSession>> build() async {
    final dataSource = ref.watch(hiveDataSourceProvider);
    final dtos = await dataSource.getAllSessions();
    return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
  }

  /// Save or update a session
  Future<void> saveSession(WorkoutSession session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      final dto = WorkoutSessionMapper.toDto(session);
      await dataSource.saveSession(dto);

      // Invalidate related providers
      ref.invalidate(mostRecentSessionProvider);
      ref.invalidate(completedSessionsProvider);

      // Refresh the list
      final dtos = await dataSource.getAllSessions();
      return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
    });
  }

  /// Delete a session
  Future<void> deleteSession(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dataSource = ref.read(hiveDataSourceProvider);
      await dataSource.deleteSession(id);

      // Refresh the list
      final dtos = await dataSource.getAllSessions();
      return dtos.map((dto) => WorkoutSessionMapper.toEntity(dto)).toList();
    });
  }
}

// ==========================================
// STATISTICS PROVIDERS
// ==========================================

/// Provider for total completed workouts count
@riverpod
Future<int> totalCompletedWorkouts(TotalCompletedWorkoutsRef ref) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  return await dataSource.getTotalCompletedWorkouts();
}

/// Provider to check if a workout is completed
@riverpod
Future<bool> isWorkoutCompleted(
  IsWorkoutCompletedRef ref,
  String programId,
  int weekNumber,
  int dayNumber,
) async {
  final dataSource = ref.watch(hiveDataSourceProvider);
  return await dataSource.isWorkoutCompleted(programId, weekNumber, dayNumber);
}
