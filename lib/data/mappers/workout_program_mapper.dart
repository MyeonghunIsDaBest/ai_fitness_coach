import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/week_type.dart';
import '../../core/enums/lift_type.dart';
import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../models/workout_program_dto.dart';

/// Mapper for converting between WorkoutProgram entity and DTO
class WorkoutProgramMapper {
  /// Convert DTO to domain entity
  static WorkoutProgram toEntity(WorkoutProgramDto dto) {
    return WorkoutProgram(
      id: dto.id,
      name: dto.name,
      sport: Sport.values.byName(dto.sport),
      description: dto.description,
      weeks: dto.weeks
          .map((week) => ProgramWeekMapper.toEntity(week))
          .toList(),
      startDate: dto.startDate,
      endDate: dto.endDate,
      isActive: dto.isActive,
      isCustom: dto.isCustom,
      athleteProfileId: dto.athleteProfileId,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Convert domain entity to DTO
  static WorkoutProgramDto toDto(WorkoutProgram entity) {
    return WorkoutProgramDto(
      id: entity.id,
      name: entity.name,
      sport: entity.sport.name,
      description: entity.description,
      weeks: entity.weeks
          .map((week) => ProgramWeekMapper.toDto(week))
          .toList(),
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      isCustom: entity.isCustom,
      athleteProfileId: entity.athleteProfileId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

/// Mapper for converting between ProgramWeek entity and DTO
class ProgramWeekMapper {
  /// Convert DTO to domain entity
  static ProgramWeek toEntity(ProgramWeekDto dto) {
    return ProgramWeek(
      id: dto.id,
      weekNumber: dto.weekNumber,
      phase: Phase.values.byName(dto.phase),
      weekType: WeekType.values.byName(dto.weekType),
      targetRPEMin: dto.targetRPEMin,
      targetRPEMax: dto.targetRPEMax,
      intensityMultiplier: dto.intensityMultiplier,
      volumeMultiplier: dto.volumeMultiplier,
      dailyWorkouts: dto.dailyWorkouts
          .map((workout) => DailyWorkoutMapper.toEntity(workout))
          .toList(),
      coachNotes: dto.coachNotes,
      isCompleted: dto.isCompleted,
      completedDate: dto.completedDate,
    );
  }

  /// Convert domain entity to DTO
  static ProgramWeekDto toDto(ProgramWeek entity) {
    return ProgramWeekDto(
      id: entity.id,
      weekNumber: entity.weekNumber,
      phase: entity.phase.name,
      weekType: entity.weekType.name,
      targetRPEMin: entity.targetRPEMin,
      targetRPEMax: entity.targetRPEMax,
      intensityMultiplier: entity.intensityMultiplier,
      volumeMultiplier: entity.volumeMultiplier,
      dailyWorkouts: entity.dailyWorkouts
          .map((workout) => DailyWorkoutMapper.toDto(workout))
          .toList(),
      coachNotes: entity.coachNotes,
      isCompleted: entity.isCompleted,
      completedDate: entity.completedDate,
    );
  }
}

/// Mapper for converting between DailyWorkout entity and DTO
class DailyWorkoutMapper {
  /// Convert DTO to domain entity
  static DailyWorkout toEntity(DailyWorkoutDto dto) {
    return DailyWorkout(
      id: dto.id,
      dayId: dto.dayId,
      dayName: dto.dayName,
      dayNumber: dto.dayNumber,
      focus: dto.focus,
      exercises: dto.exercises
          .map((exercise) => ExerciseMapper.toEntity(exercise))
          .toList(),
      isRestDay: dto.isRestDay,
      estimatedDurationMinutes: dto.estimatedDurationMinutes,
      warmupNotes: dto.warmupNotes,
      cooldownNotes: dto.cooldownNotes,
      coachNotes: dto.coachNotes,
    );
  }

  /// Convert domain entity to DTO
  static DailyWorkoutDto toDto(DailyWorkout entity) {
    return DailyWorkoutDto(
      id: entity.id,
      dayId: entity.dayId,
      dayName: entity.dayName,
      dayNumber: entity.dayNumber,
      focus: entity.focus,
      exercises: entity.exercises
          .map((exercise) => ExerciseMapper.toDto(exercise))
          .toList(),
      isRestDay: entity.isRestDay,
      estimatedDurationMinutes: entity.estimatedDurationMinutes,
      warmupNotes: entity.warmupNotes,
      cooldownNotes: entity.cooldownNotes,
      coachNotes: entity.coachNotes,
    );
  }
}

/// Mapper for converting between Exercise entity and DTO
class ExerciseMapper {
  /// Convert DTO to domain entity
  static Exercise toEntity(ExerciseDto dto) {
    return Exercise(
      id: dto.id,
      name: dto.name,
      liftType: LiftType.values.byName(dto.liftType),
      sets: dto.sets,
      reps: dto.reps,
      isMain: dto.isMain,
      targetRPEMin: dto.targetRPEMin,
      targetRPEMax: dto.targetRPEMax,
      targetPercentage: dto.targetPercentage,
      restSeconds: dto.restSeconds,
      intensityDisplay: dto.intensityDisplay,
      formCues: dto.formCues,
      notes: dto.notes,
      order: dto.order,
    );
  }

  /// Convert domain entity to DTO
  static ExerciseDto toDto(Exercise entity) {
    return ExerciseDto(
      id: entity.id,
      name: entity.name,
      liftType: entity.liftType.name,
      sets: entity.sets,
      reps: entity.reps,
      isMain: entity.isMain,
      targetRPEMin: entity.targetRPEMin,
      targetRPEMax: entity.targetRPEMax,
      targetPercentage: entity.targetPercentage,
      restSeconds: entity.restSeconds,
      intensityDisplay: entity.intensityDisplay,
      formCues: entity.formCues,
      notes: entity.notes,
      order: entity.order,
    );
  }
}
