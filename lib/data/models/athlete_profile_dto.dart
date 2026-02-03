import 'package:hive/hive.dart';

part 'athlete_profile_dto.g.dart';

/// Data Transfer Object for AthleteProfile with Hive serialization
@HiveType(typeId: 0)
class AthleteProfileDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String sport; // Stored as enum name string

  @HiveField(3)
  final String experienceLevel; // Stored as enum name string

  @HiveField(4)
  final double bodyweight;

  @HiveField(5)
  final String bodyweightUnit; // Stored as enum name string

  @HiveField(6)
  final Map<String, double> maxLifts; // LiftType name -> value

  @HiveField(7)
  final List<WeakPointDto> weakPoints;

  @HiveField(8)
  final List<InjuryDto> injuries;

  @HiveField(9)
  final int preferredWorkoutDays;

  @HiveField(10)
  final String primaryGoal; // Stored as enum name string

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  AthleteProfileDto({
    required this.id,
    required this.name,
    required this.sport,
    required this.experienceLevel,
    required this.bodyweight,
    required this.bodyweightUnit,
    required this.maxLifts,
    required this.weakPoints,
    required this.injuries,
    required this.preferredWorkoutDays,
    required this.primaryGoal,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Data Transfer Object for WeakPoint with Hive serialization
@HiveType(typeId: 1)
class WeakPointDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> affectedLifts; // LiftType names

  @HiveField(4)
  final DateTime identifiedDate;

  WeakPointDto({
    required this.id,
    required this.name,
    required this.description,
    required this.affectedLifts,
    required this.identifiedDate,
  });
}

/// Data Transfer Object for Injury with Hive serialization
@HiveType(typeId: 2)
class InjuryDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String severity; // InjurySeverity enum name

  @HiveField(4)
  final List<String> restrictedLifts; // LiftType names

  @HiveField(5)
  final DateTime injuryDate;

  @HiveField(6)
  final DateTime? healedDate;

  @HiveField(7)
  final bool isHealed;

  @HiveField(8)
  final String? treatmentNotes;

  InjuryDto({
    required this.id,
    required this.name,
    required this.description,
    required this.severity,
    required this.restrictedLifts,
    required this.injuryDate,
    this.healedDate,
    required this.isHealed,
    this.treatmentNotes,
  });
}
