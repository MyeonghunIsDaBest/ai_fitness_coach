import 'package:hive/hive.dart';

part 'workout_session_dto.g.dart';

/// Data Transfer Object for WorkoutSession with Hive serialization
@HiveType(typeId: 7)
class WorkoutSessionDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String programId;

  @HiveField(2)
  final int weekNumber;

  @HiveField(3)
  final int dayNumber;

  @HiveField(4)
  final String workoutName;

  @HiveField(5)
  final DateTime startTime;

  @HiveField(6)
  final DateTime? endTime;

  @HiveField(7)
  final List<LoggedSetDto> sets;

  @HiveField(8)
  final bool isCompleted;

  @HiveField(9)
  final String? notes;

  WorkoutSessionDto({
    required this.id,
    required this.programId,
    required this.weekNumber,
    required this.dayNumber,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    required this.sets,
    required this.isCompleted,
    this.notes,
  });
}

/// Data Transfer Object for LoggedSet with Hive serialization
@HiveType(typeId: 8)
class LoggedSetDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workoutSessionId;

  @HiveField(2)
  final String exerciseId;

  @HiveField(3)
  final String exerciseName;

  @HiveField(4)
  final int setNumber;

  @HiveField(5)
  final double weight;

  @HiveField(6)
  final String weightUnit;

  @HiveField(7)
  final int reps;

  @HiveField(8)
  final double rpe;

  @HiveField(9)
  final bool completed;

  @HiveField(10)
  final DateTime timestamp;

  @HiveField(11)
  final String? notes;

  @HiveField(12)
  final double? targetRPE;

  LoggedSetDto({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.exerciseName,
    required this.setNumber,
    required this.weight,
    required this.weightUnit,
    required this.reps,
    required this.rpe,
    required this.completed,
    required this.timestamp,
    this.notes,
    this.targetRPE,
  });
}
