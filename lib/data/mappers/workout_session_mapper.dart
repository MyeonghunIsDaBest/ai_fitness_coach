import '../../domain/models/workout_session.dart';
import '../../domain/models/logged_set.dart';
import '../models/workout_session_dto.dart';

/// Mapper for converting between WorkoutSession entity and DTO
class WorkoutSessionMapper {
  /// Convert DTO to domain entity
  static WorkoutSession toEntity(WorkoutSessionDto dto) {
    return WorkoutSession(
      id: dto.id,
      programId: dto.programId,
      weekNumber: dto.weekNumber,
      dayNumber: dto.dayNumber,
      workoutName: dto.workoutName,
      startTime: dto.startTime,
      endTime: dto.endTime,
      sets: dto.sets.map((set) => LoggedSetMapper.toEntity(set)).toList(),
      isCompleted: dto.isCompleted,
      notes: dto.notes,
    );
  }

  /// Convert domain entity to DTO
  static WorkoutSessionDto toDto(WorkoutSession entity) {
    return WorkoutSessionDto(
      id: entity.id,
      programId: entity.programId,
      weekNumber: entity.weekNumber,
      dayNumber: entity.dayNumber,
      workoutName: entity.workoutName,
      startTime: entity.startTime,
      endTime: entity.endTime,
      sets: entity.sets.map((set) => LoggedSetMapper.toDto(set)).toList(),
      isCompleted: entity.isCompleted,
      notes: entity.notes,
    );
  }
}

/// Mapper for converting between LoggedSet entity and DTO
class LoggedSetMapper {
  /// Convert DTO to domain entity
  static LoggedSet toEntity(LoggedSetDto dto) {
    return LoggedSet(
      id: dto.id,
      workoutSessionId: dto.workoutSessionId,
      exerciseId: dto.exerciseId,
      exerciseName: dto.exerciseName,
      setNumber: dto.setNumber,
      weight: dto.weight,
      weightUnit: dto.weightUnit,
      reps: dto.reps,
      rpe: dto.rpe,
      completed: dto.completed,
      timestamp: dto.timestamp,
      notes: dto.notes,
      targetRPE: dto.targetRPE,
    );
  }

  /// Convert domain entity to DTO
  static LoggedSetDto toDto(LoggedSet entity) {
    return LoggedSetDto(
      id: entity.id,
      workoutSessionId: entity.workoutSessionId,
      exerciseId: entity.exerciseId,
      exerciseName: entity.exerciseName,
      setNumber: entity.setNumber,
      weight: entity.weight,
      weightUnit: entity.weightUnit,
      reps: entity.reps,
      rpe: entity.rpe,
      completed: entity.completed,
      timestamp: entity.timestamp,
      notes: entity.notes,
      targetRPE: entity.targetRPE,
    );
  }
}
