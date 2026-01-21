import 'package:hive/hive.dart';

part 'workout_program_dto.g.dart';

/// Data Transfer Object for WorkoutProgram with Hive serialization
@HiveType(typeId: 3)
class WorkoutProgramDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String sport; // Sport enum name

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<ProgramWeekDto> weeks;

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final DateTime? endDate;

  @HiveField(7)
  final bool isActive;

  @HiveField(8)
  final bool isCustom;

  @HiveField(9)
  final String? athleteProfileId;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  WorkoutProgramDto({
    required this.id,
    required this.name,
    required this.sport,
    required this.description,
    required this.weeks,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.isCustom,
    this.athleteProfileId,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Data Transfer Object for ProgramWeek with Hive serialization
@HiveType(typeId: 4)
class ProgramWeekDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int weekNumber;

  @HiveField(2)
  final String phase; // Phase enum name

  @HiveField(3)
  final String weekType; // WeekType enum name

  @HiveField(4)
  final double targetRPEMin;

  @HiveField(5)
  final double targetRPEMax;

  @HiveField(6)
  final double intensityMultiplier;

  @HiveField(7)
  final double volumeMultiplier;

  @HiveField(8)
  final List<DailyWorkoutDto> dailyWorkouts;

  @HiveField(9)
  final String? coachNotes;

  @HiveField(10)
  final bool isCompleted;

  @HiveField(11)
  final DateTime? completedDate;

  ProgramWeekDto({
    required this.id,
    required this.weekNumber,
    required this.phase,
    required this.weekType,
    required this.targetRPEMin,
    required this.targetRPEMax,
    required this.intensityMultiplier,
    required this.volumeMultiplier,
    required this.dailyWorkouts,
    this.coachNotes,
    required this.isCompleted,
    this.completedDate,
  });
}

/// Data Transfer Object for DailyWorkout with Hive serialization
@HiveType(typeId: 5)
class DailyWorkoutDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String dayId;

  @HiveField(2)
  final String dayName;

  @HiveField(3)
  final int dayNumber;

  @HiveField(4)
  final String focus;

  @HiveField(5)
  final List<ExerciseDto> exercises;

  @HiveField(6)
  final bool isRestDay;

  @HiveField(7)
  final int estimatedDurationMinutes;

  @HiveField(8)
  final String? warmupNotes;

  @HiveField(9)
  final String? cooldownNotes;

  @HiveField(10)
  final String? coachNotes;

  DailyWorkoutDto({
    required this.id,
    required this.dayId,
    required this.dayName,
    required this.dayNumber,
    required this.focus,
    required this.exercises,
    required this.isRestDay,
    required this.estimatedDurationMinutes,
    this.warmupNotes,
    this.cooldownNotes,
    this.coachNotes,
  });
}

/// Data Transfer Object for Exercise with Hive serialization
@HiveType(typeId: 6)
class ExerciseDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String liftType; // LiftType enum name

  @HiveField(3)
  final int sets;

  @HiveField(4)
  final int reps;

  @HiveField(5)
  final bool isMain;

  @HiveField(6)
  final double? targetRPEMin;

  @HiveField(7)
  final double? targetRPEMax;

  @HiveField(8)
  final double? targetPercentage;

  @HiveField(9)
  final int restSeconds;

  @HiveField(10)
  final String? intensityDisplay;

  @HiveField(11)
  final List<String> formCues;

  @HiveField(12)
  final String? notes;

  @HiveField(13)
  final int order;

  ExerciseDto({
    required this.id,
    required this.name,
    required this.liftType,
    required this.sets,
    required this.reps,
    required this.isMain,
    this.targetRPEMin,
    this.targetRPEMax,
    this.targetPercentage,
    required this.restSeconds,
    this.intensityDisplay,
    required this.formCues,
    this.notes,
    required this.order,
  });
}
