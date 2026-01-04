import 'package:equatable/equatable.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/lift_type.dart';

/// Domain model representing an athlete's profile
/// Contains all relevant information for program personalization
class AthleteProfile extends Equatable {
  final String id;
  final String name;
  final Sport sport;
  final ExperienceLevel experienceLevel;
  final double bodyweight;
  final BodyweightUnit bodyweightUnit;
  final Map<LiftType, double> maxLifts; // 1RM for main lifts
  final List<WeakPoint> weakPoints;
  final List<Injury> injuries;
  final int preferredWorkoutDays;
  final TrainingGoal primaryGoal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AthleteProfile({
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

  /// Create a new athlete profile with default values
  factory AthleteProfile.create({
    required String name,
    required Sport sport,
    required ExperienceLevel experienceLevel,
    required double bodyweight,
    required BodyweightUnit bodyweightUnit,
    required int preferredWorkoutDays,
    required TrainingGoal primaryGoal,
  }) {
    final now = DateTime.now();
    return AthleteProfile(
      id: _generateId(),
      name: name,
      sport: sport,
      experienceLevel: experienceLevel,
      bodyweight: bodyweight,
      bodyweightUnit: bodyweightUnit,
      maxLifts: {},
      weakPoints: [],
      injuries: [],
      preferredWorkoutDays: preferredWorkoutDays,
      primaryGoal: primaryGoal,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Copy with method for immutable updates
  AthleteProfile copyWith({
    String? id,
    String? name,
    Sport? sport,
    ExperienceLevel? experienceLevel,
    double? bodyweight,
    BodyweightUnit? bodyweightUnit,
    Map<LiftType, double>? maxLifts,
    List<WeakPoint>? weakPoints,
    List<Injury>? injuries,
    int? preferredWorkoutDays,
    TrainingGoal? primaryGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AthleteProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      bodyweight: bodyweight ?? this.bodyweight,
      bodyweightUnit: bodyweightUnit ?? this.bodyweightUnit,
      maxLifts: maxLifts ?? this.maxLifts,
      weakPoints: weakPoints ?? this.weakPoints,
      injuries: injuries ?? this.injuries,
      preferredWorkoutDays: preferredWorkoutDays ?? this.preferredWorkoutDays,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Update a single lift max
  AthleteProfile updateLiftMax(LiftType lift, double max) {
    final newMaxLifts = Map<LiftType, double>.from(maxLifts);
    newMaxLifts[lift] = max;
    return copyWith(maxLifts: newMaxLifts);
  }

  /// Add a weak point
  AthleteProfile addWeakPoint(WeakPoint weakPoint) {
    return copyWith(
      weakPoints: [...weakPoints, weakPoint],
    );
  }

  /// Remove a weak point
  AthleteProfile removeWeakPoint(WeakPoint weakPoint) {
    return copyWith(
      weakPoints: weakPoints.where((w) => w != weakPoint).toList(),
    );
  }

  /// Add an injury
  AthleteProfile addInjury(Injury injury) {
    return copyWith(
      injuries: [...injuries, injury],
    );
  }

  /// Mark injury as healed
  AthleteProfile markInjuryHealed(String injuryId) {
    final updatedInjuries = injuries.map((injury) {
      if (injury.id == injuryId) {
        return injury.copyWith(
          isHealed: true,
          healedDate: DateTime.now(),
        );
      }
      return injury;
    }).toList();

    return copyWith(injuries: updatedInjuries);
  }

  /// Get active (unhealed) injuries
  List<Injury> get activeInjuries {
    return injuries.where((injury) => !injury.isHealed).toList();
  }

  /// Check if athlete has a specific max recorded
  bool hasMaxFor(LiftType lift) {
    return maxLifts.containsKey(lift) && maxLifts[lift]! > 0;
  }

  /// Get max for a specific lift (returns 0 if not set)
  double getMaxFor(LiftType lift) {
    return maxLifts[lift] ?? 0.0;
  }

  /// Calculate estimated 1RM based on experience level
  /// Used when athlete doesn't have recorded maxes
  double estimateMax(LiftType lift) {
    // Bodyweight multipliers based on experience and lift type
    final multipliers = _getBodyweightMultipliers();
    final multiplier = multipliers[lift] ?? 1.0;

    return bodyweight * multiplier;
  }

  /// Get bodyweight multipliers for estimation
  Map<LiftType, double> _getBodyweightMultipliers() {
    // Based on experience level and gender (simplified)
    switch (experienceLevel) {
      case ExperienceLevel.beginner:
        return {
          LiftType.squat: 1.0,
          LiftType.benchPress: 0.75,
          LiftType.deadlift: 1.25,
          LiftType.overheadPress: 0.5,
        };
      case ExperienceLevel.intermediate:
        return {
          LiftType.squat: 1.5,
          LiftType.benchPress: 1.0,
          LiftType.deadlift: 1.75,
          LiftType.overheadPress: 0.7,
        };
      case ExperienceLevel.advanced:
        return {
          LiftType.squat: 2.0,
          LiftType.benchPress: 1.5,
          LiftType.deadlift: 2.5,
          LiftType.overheadPress: 1.0,
        };
    }
  }

  /// Check if profile is complete enough to generate program
  bool get isComplete {
    return name.isNotEmpty &&
        bodyweight > 0 &&
        preferredWorkoutDays >= 2 &&
        preferredWorkoutDays <= 7;
  }

  /// Get profile completion percentage
  double get completionPercentage {
    int completed = 0;
    const int total = 5;

    if (name.isNotEmpty) completed++;
    if (bodyweight > 0) completed++;
    if (maxLifts.isNotEmpty) completed++;
    if (preferredWorkoutDays >= 2) completed++;
    if (weakPoints.isNotEmpty || injuries.isEmpty) completed++;

    return (completed / total) * 100;
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        sport,
        experienceLevel,
        bodyweight,
        bodyweightUnit,
        maxLifts,
        weakPoints,
        injuries,
        preferredWorkoutDays,
        primaryGoal,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'AthleteProfile(id: $id, name: $name, sport: ${sport.displayName}, '
        'experience: ${experienceLevel.displayName}, '
        'bodyweight: $bodyweight${bodyweightUnit.symbol})';
  }
}

// ════════════════════════════════════════════════════════════════
// SUPPORTING ENUMS AND VALUE OBJECTS
// ════════════════════════════════════════════════════════════════

/// Experience level of the athlete
enum ExperienceLevel {
  beginner,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.advanced:
        return 'Advanced';
    }
  }

  String get description {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'New to training (< 1 year)';
      case ExperienceLevel.intermediate:
        return '1-3 years of consistent training';
      case ExperienceLevel.advanced:
        return '3+ years of consistent training';
    }
  }
}

/// Bodyweight unit
enum BodyweightUnit {
  kg,
  lbs;

  String get symbol {
    switch (this) {
      case BodyweightUnit.kg:
        return 'kg';
      case BodyweightUnit.lbs:
        return 'lbs';
    }
  }

  String get displayName {
    switch (this) {
      case BodyweightUnit.kg:
        return 'Kilograms';
      case BodyweightUnit.lbs:
        return 'Pounds';
    }
  }

  /// Convert to the other unit
  double convert(double value, BodyweightUnit to) {
    if (this == to) return value;

    if (this == BodyweightUnit.kg && to == BodyweightUnit.lbs) {
      return value * 2.20462;
    } else if (this == BodyweightUnit.lbs && to == BodyweightUnit.kg) {
      return value / 2.20462;
    }

    return value;
  }
}

/// Training goal
enum TrainingGoal {
  buildStrength,
  gainMuscle,
  loseFat,
  improvePerformance,
  generalFitness;

  String get displayName {
    switch (this) {
      case TrainingGoal.buildStrength:
        return 'Build Strength';
      case TrainingGoal.gainMuscle:
        return 'Gain Muscle';
      case TrainingGoal.loseFat:
        return 'Lose Fat';
      case TrainingGoal.improvePerformance:
        return 'Improve Performance';
      case TrainingGoal.generalFitness:
        return 'General Fitness';
    }
  }

  String get description {
    switch (this) {
      case TrainingGoal.buildStrength:
        return 'Maximize strength in main lifts';
      case TrainingGoal.gainMuscle:
        return 'Build muscle mass and size';
      case TrainingGoal.loseFat:
        return 'Reduce body fat while maintaining muscle';
      case TrainingGoal.improvePerformance:
        return 'Enhance athletic performance';
      case TrainingGoal.generalFitness:
        return 'Overall health and fitness';
    }
  }
}

/// Weak point in training
class WeakPoint extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<LiftType> affectedLifts;
  final DateTime identifiedDate;

  const WeakPoint({
    required this.id,
    required this.name,
    required this.description,
    required this.affectedLifts,
    required this.identifiedDate,
  });

  factory WeakPoint.create({
    required String name,
    required String description,
    required List<LiftType> affectedLifts,
  }) {
    return WeakPoint(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      affectedLifts: affectedLifts,
      identifiedDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'affectedLifts': affectedLifts.map((l) => l.name).toList(),
      'identifiedDate': identifiedDate.toIso8601String(),
    };
  }

  /// Create from JSON
  factory WeakPoint.fromJson(Map<String, dynamic> json) {
    return WeakPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      affectedLifts: (json['affectedLifts'] as List)
          .map((l) => LiftType.values.byName(l as String))
          .toList(),
      identifiedDate: DateTime.parse(json['identifiedDate'] as String),
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, affectedLifts, identifiedDate];
}

/// Injury tracking
class Injury extends Equatable {
  final String id;
  final String name;
  final String description;
  final InjurySeverity severity;
  final List<LiftType> restrictedLifts;
  final DateTime injuryDate;
  final DateTime? healedDate;
  final bool isHealed;
  final String? treatmentNotes;

  const Injury({
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

  factory Injury.create({
    required String name,
    required String description,
    required InjurySeverity severity,
    required List<LiftType> restrictedLifts,
    String? treatmentNotes,
  }) {
    return Injury(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      severity: severity,
      restrictedLifts: restrictedLifts,
      injuryDate: DateTime.now(),
      isHealed: false,
      treatmentNotes: treatmentNotes,
    );
  }

  Injury copyWith({
    String? id,
    String? name,
    String? description,
    InjurySeverity? severity,
    List<LiftType>? restrictedLifts,
    DateTime? injuryDate,
    DateTime? healedDate,
    bool? isHealed,
    String? treatmentNotes,
  }) {
    return Injury(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      restrictedLifts: restrictedLifts ?? this.restrictedLifts,
      injuryDate: injuryDate ?? this.injuryDate,
      healedDate: healedDate ?? this.healedDate,
      isHealed: isHealed ?? this.isHealed,
      treatmentNotes: treatmentNotes ?? this.treatmentNotes,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'severity': severity.name,
      'restrictedLifts': restrictedLifts.map((l) => l.name).toList(),
      'injuryDate': injuryDate.toIso8601String(),
      'healedDate': healedDate?.toIso8601String(),
      'isHealed': isHealed,
      'treatmentNotes': treatmentNotes,
    };
  }

  /// Create from JSON
  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      severity: InjurySeverity.values.byName(json['severity'] as String),
      restrictedLifts: (json['restrictedLifts'] as List)
          .map((l) => LiftType.values.byName(l as String))
          .toList(),
      injuryDate: DateTime.parse(json['injuryDate'] as String),
      healedDate: json['healedDate'] != null
          ? DateTime.parse(json['healedDate'] as String)
          : null,
      isHealed: json['isHealed'] as bool,
      treatmentNotes: json['treatmentNotes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        severity,
        restrictedLifts,
        injuryDate,
        healedDate,
        isHealed,
        treatmentNotes,
      ];
}

/// Injury severity
enum InjurySeverity {
  minor,
  moderate,
  severe;

  String get displayName {
    switch (this) {
      case InjurySeverity.minor:
        return 'Minor';
      case InjurySeverity.moderate:
        return 'Moderate';
      case InjurySeverity.severe:
        return 'Severe';
    }
  }

  String get description {
    switch (this) {
      case InjurySeverity.minor:
        return 'Can train with modifications';
      case InjurySeverity.moderate:
        return 'Requires significant modifications';
      case InjurySeverity.severe:
        return 'Cannot train affected areas';
    }
  }
}
