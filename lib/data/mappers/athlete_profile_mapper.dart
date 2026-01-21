import '../../core/enums/sport.dart';
import '../../core/enums/lift_type.dart';
import '../../domain/models/athlete_profile.dart';
import '../models/athlete_profile_dto.dart';

/// Mapper for converting between AthleteProfile entity and DTO
class AthleteProfileMapper {
  /// Convert DTO to domain entity
  static AthleteProfile toEntity(AthleteProfileDto dto) {
    return AthleteProfile(
      id: dto.id,
      name: dto.name,
      sport: Sport.values.byName(dto.sport),
      experienceLevel: ExperienceLevel.values.byName(dto.experienceLevel),
      bodyweight: dto.bodyweight,
      bodyweightUnit: BodyweightUnit.values.byName(dto.bodyweightUnit),
      maxLifts: dto.maxLifts.map(
        (key, value) => MapEntry(
          LiftType.values.byName(key),
          value,
        ),
      ),
      weakPoints: dto.weakPoints
          .map((weakPoint) => WeakPointMapper.toEntity(weakPoint))
          .toList(),
      injuries: dto.injuries
          .map((injury) => InjuryMapper.toEntity(injury))
          .toList(),
      preferredWorkoutDays: dto.preferredWorkoutDays,
      primaryGoal: TrainingGoal.values.byName(dto.primaryGoal),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  /// Convert domain entity to DTO
  static AthleteProfileDto toDto(AthleteProfile entity) {
    return AthleteProfileDto(
      id: entity.id,
      name: entity.name,
      sport: entity.sport.name,
      experienceLevel: entity.experienceLevel.name,
      bodyweight: entity.bodyweight,
      bodyweightUnit: entity.bodyweightUnit.name,
      maxLifts: entity.maxLifts.map(
        (key, value) => MapEntry(key.name, value),
      ),
      weakPoints: entity.weakPoints
          .map((weakPoint) => WeakPointMapper.toDto(weakPoint))
          .toList(),
      injuries: entity.injuries
          .map((injury) => InjuryMapper.toDto(injury))
          .toList(),
      preferredWorkoutDays: entity.preferredWorkoutDays,
      primaryGoal: entity.primaryGoal.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

/// Mapper for converting between WeakPoint entity and DTO
class WeakPointMapper {
  /// Convert DTO to domain entity
  static WeakPoint toEntity(WeakPointDto dto) {
    return WeakPoint(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      affectedLifts: dto.affectedLifts
          .map((lift) => LiftType.values.byName(lift))
          .toList(),
      identifiedDate: dto.identifiedDate,
    );
  }

  /// Convert domain entity to DTO
  static WeakPointDto toDto(WeakPoint entity) {
    return WeakPointDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      affectedLifts: entity.affectedLifts.map((lift) => lift.name).toList(),
      identifiedDate: entity.identifiedDate,
    );
  }
}

/// Mapper for converting between Injury entity and DTO
class InjuryMapper {
  /// Convert DTO to domain entity
  static Injury toEntity(InjuryDto dto) {
    return Injury(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      severity: InjurySeverity.values.byName(dto.severity),
      restrictedLifts: dto.restrictedLifts
          .map((lift) => LiftType.values.byName(lift))
          .toList(),
      injuryDate: dto.injuryDate,
      healedDate: dto.healedDate,
      isHealed: dto.isHealed,
      treatmentNotes: dto.treatmentNotes,
    );
  }

  /// Convert domain entity to DTO
  static InjuryDto toDto(Injury entity) {
    return InjuryDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      severity: entity.severity.name,
      restrictedLifts: entity.restrictedLifts.map((lift) => lift.name).toList(),
      injuryDate: entity.injuryDate,
      healedDate: entity.healedDate,
      isHealed: entity.isHealed,
      treatmentNotes: entity.treatmentNotes,
    );
  }
}
