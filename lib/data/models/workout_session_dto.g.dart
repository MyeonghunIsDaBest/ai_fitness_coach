// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutSessionDtoAdapter extends TypeAdapter<WorkoutSessionDto> {
  @override
  final int typeId = 7;

  @override
  WorkoutSessionDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSessionDto(
      id: fields[0] as String,
      programId: fields[1] as String,
      weekNumber: fields[2] as int,
      dayNumber: fields[3] as int,
      workoutName: fields[4] as String,
      startTime: fields[5] as DateTime,
      endTime: fields[6] as DateTime?,
      sets: (fields[7] as List).cast<LoggedSetDto>(),
      isCompleted: fields[8] as bool,
      notes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSessionDto obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.programId)
      ..writeByte(2)
      ..write(obj.weekNumber)
      ..writeByte(3)
      ..write(obj.dayNumber)
      ..writeByte(4)
      ..write(obj.workoutName)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.sets)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoggedSetDtoAdapter extends TypeAdapter<LoggedSetDto> {
  @override
  final int typeId = 8;

  @override
  LoggedSetDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedSetDto(
      id: fields[0] as String,
      workoutSessionId: fields[1] as String,
      exerciseId: fields[2] as String,
      exerciseName: fields[3] as String,
      setNumber: fields[4] as int,
      weight: fields[5] as double,
      weightUnit: fields[6] as String,
      reps: fields[7] as int,
      rpe: fields[8] as double,
      completed: fields[9] as bool,
      timestamp: fields[10] as DateTime,
      notes: fields[11] as String?,
      targetRPE: fields[12] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, LoggedSetDto obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workoutSessionId)
      ..writeByte(2)
      ..write(obj.exerciseId)
      ..writeByte(3)
      ..write(obj.exerciseName)
      ..writeByte(4)
      ..write(obj.setNumber)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.weightUnit)
      ..writeByte(7)
      ..write(obj.reps)
      ..writeByte(8)
      ..write(obj.rpe)
      ..writeByte(9)
      ..write(obj.completed)
      ..writeByte(10)
      ..write(obj.timestamp)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.targetRPE);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedSetDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
