// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete_profile_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AthleteProfileDtoAdapter extends TypeAdapter<AthleteProfileDto> {
  @override
  final int typeId = 0;

  @override
  AthleteProfileDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AthleteProfileDto(
      id: fields[0] as String,
      name: fields[1] as String,
      sport: fields[2] as String,
      experienceLevel: fields[3] as String,
      bodyweight: fields[4] as double,
      bodyweightUnit: fields[5] as String,
      maxLifts: (fields[6] as Map).cast<String, double>(),
      weakPoints: (fields[7] as List).cast<WeakPointDto>(),
      injuries: (fields[8] as List).cast<InjuryDto>(),
      preferredWorkoutDays: fields[9] as int,
      primaryGoal: fields[10] as String,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AthleteProfileDto obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sport)
      ..writeByte(3)
      ..write(obj.experienceLevel)
      ..writeByte(4)
      ..write(obj.bodyweight)
      ..writeByte(5)
      ..write(obj.bodyweightUnit)
      ..writeByte(6)
      ..write(obj.maxLifts)
      ..writeByte(7)
      ..write(obj.weakPoints)
      ..writeByte(8)
      ..write(obj.injuries)
      ..writeByte(9)
      ..write(obj.preferredWorkoutDays)
      ..writeByte(10)
      ..write(obj.primaryGoal)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AthleteProfileDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeakPointDtoAdapter extends TypeAdapter<WeakPointDto> {
  @override
  final int typeId = 1;

  @override
  WeakPointDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeakPointDto(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      affectedLifts: (fields[3] as List).cast<String>(),
      identifiedDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeakPointDto obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.affectedLifts)
      ..writeByte(4)
      ..write(obj.identifiedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeakPointDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InjuryDtoAdapter extends TypeAdapter<InjuryDto> {
  @override
  final int typeId = 2;

  @override
  InjuryDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InjuryDto(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      severity: fields[3] as String,
      restrictedLifts: (fields[4] as List).cast<String>(),
      injuryDate: fields[5] as DateTime,
      healedDate: fields[6] as DateTime?,
      isHealed: fields[7] as bool,
      treatmentNotes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InjuryDto obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.severity)
      ..writeByte(4)
      ..write(obj.restrictedLifts)
      ..writeByte(5)
      ..write(obj.injuryDate)
      ..writeByte(6)
      ..write(obj.healedDate)
      ..writeByte(7)
      ..write(obj.isHealed)
      ..writeByte(8)
      ..write(obj.treatmentNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InjuryDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
