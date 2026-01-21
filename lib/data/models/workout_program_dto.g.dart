// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_program_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutProgramDtoAdapter extends TypeAdapter<WorkoutProgramDto> {
  @override
  final int typeId = 3;

  @override
  WorkoutProgramDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutProgramDto(
      id: fields[0] as String,
      name: fields[1] as String,
      sport: fields[2] as String,
      description: fields[3] as String,
      weeks: (fields[4] as List).cast<ProgramWeekDto>(),
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime?,
      isActive: fields[7] as bool,
      isCustom: fields[8] as bool,
      athleteProfileId: fields[9] as String?,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutProgramDto obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sport)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.weeks)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.isCustom)
      ..writeByte(9)
      ..write(obj.athleteProfileId)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutProgramDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgramWeekDtoAdapter extends TypeAdapter<ProgramWeekDto> {
  @override
  final int typeId = 4;

  @override
  ProgramWeekDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramWeekDto(
      id: fields[0] as String,
      weekNumber: fields[1] as int,
      phase: fields[2] as String,
      weekType: fields[3] as String,
      targetRPEMin: fields[4] as double,
      targetRPEMax: fields[5] as double,
      intensityMultiplier: fields[6] as double,
      volumeMultiplier: fields[7] as double,
      dailyWorkouts: (fields[8] as List).cast<DailyWorkoutDto>(),
      coachNotes: fields[9] as String?,
      isCompleted: fields[10] as bool,
      completedDate: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgramWeekDto obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.weekNumber)
      ..writeByte(2)
      ..write(obj.phase)
      ..writeByte(3)
      ..write(obj.weekType)
      ..writeByte(4)
      ..write(obj.targetRPEMin)
      ..writeByte(5)
      ..write(obj.targetRPEMax)
      ..writeByte(6)
      ..write(obj.intensityMultiplier)
      ..writeByte(7)
      ..write(obj.volumeMultiplier)
      ..writeByte(8)
      ..write(obj.dailyWorkouts)
      ..writeByte(9)
      ..write(obj.coachNotes)
      ..writeByte(10)
      ..write(obj.isCompleted)
      ..writeByte(11)
      ..write(obj.completedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramWeekDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyWorkoutDtoAdapter extends TypeAdapter<DailyWorkoutDto> {
  @override
  final int typeId = 5;

  @override
  DailyWorkoutDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyWorkoutDto(
      id: fields[0] as String,
      dayId: fields[1] as String,
      dayName: fields[2] as String,
      dayNumber: fields[3] as int,
      focus: fields[4] as String,
      exercises: (fields[5] as List).cast<ExerciseDto>(),
      isRestDay: fields[6] as bool,
      estimatedDurationMinutes: fields[7] as int,
      warmupNotes: fields[8] as String?,
      cooldownNotes: fields[9] as String?,
      coachNotes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyWorkoutDto obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dayId)
      ..writeByte(2)
      ..write(obj.dayName)
      ..writeByte(3)
      ..write(obj.dayNumber)
      ..writeByte(4)
      ..write(obj.focus)
      ..writeByte(5)
      ..write(obj.exercises)
      ..writeByte(6)
      ..write(obj.isRestDay)
      ..writeByte(7)
      ..write(obj.estimatedDurationMinutes)
      ..writeByte(8)
      ..write(obj.warmupNotes)
      ..writeByte(9)
      ..write(obj.cooldownNotes)
      ..writeByte(10)
      ..write(obj.coachNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyWorkoutDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseDtoAdapter extends TypeAdapter<ExerciseDto> {
  @override
  final int typeId = 6;

  @override
  ExerciseDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseDto(
      id: fields[0] as String,
      name: fields[1] as String,
      liftType: fields[2] as String,
      sets: fields[3] as int,
      reps: fields[4] as int,
      isMain: fields[5] as bool,
      targetRPEMin: fields[6] as double?,
      targetRPEMax: fields[7] as double?,
      targetPercentage: fields[8] as double?,
      restSeconds: fields[9] as int,
      intensityDisplay: fields[10] as String?,
      formCues: (fields[11] as List).cast<String>(),
      notes: fields[12] as String?,
      order: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseDto obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.liftType)
      ..writeByte(3)
      ..write(obj.sets)
      ..writeByte(4)
      ..write(obj.reps)
      ..writeByte(5)
      ..write(obj.isMain)
      ..writeByte(6)
      ..write(obj.targetRPEMin)
      ..writeByte(7)
      ..write(obj.targetRPEMax)
      ..writeByte(8)
      ..write(obj.targetPercentage)
      ..writeByte(9)
      ..write(obj.restSeconds)
      ..writeByte(10)
      ..write(obj.intensityDisplay)
      ..writeByte(11)
      ..write(obj.formCues)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
