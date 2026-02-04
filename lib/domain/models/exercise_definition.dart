import 'package:equatable/equatable.dart';
import '../../core/enums/equipment_type.dart';
import '../../core/enums/movement_pattern.dart';
import '../../core/enums/difficulty_level.dart';
import '../../core/enums/lift_type.dart';
import '../../core/enums/sport.dart';

/// Domain model representing an exercise in the exercise database
/// This is a reference definition, separate from workout-specific Exercise model
/// Used for exercise lookup, substitution, and the exercise picker
class ExerciseDefinition extends Equatable {
  /// Unique identifier for the exercise (e.g., 'ex_barbell_back_squat')
  final String id;

  /// Primary name of the exercise
  final String name;

  /// Alternative names for the exercise (for search matching)
  final List<String> aliases;

  /// Primary movement pattern category
  final MovementPattern movementPattern;

  /// Primary muscle groups targeted (most important)
  final List<MuscleGroup> primaryMuscles;

  /// Secondary muscle groups involved
  final List<MuscleGroup> secondaryMuscles;

  /// Equipment required to perform this exercise
  final List<EquipmentType> requiredEquipment;

  /// Optional equipment that can enhance the exercise
  final List<EquipmentType> optionalEquipment;

  /// Difficulty/skill level required
  final DifficultyLevel difficulty;

  /// Sports/disciplines where this exercise is commonly used
  final Set<Sport> sportCategories;

  /// Mapping to existing LiftType enum (if applicable)
  final LiftType? liftType;

  /// Form cues and technique tips
  final List<String> formCues;

  /// Common mistakes to avoid
  final List<String> commonMistakes;

  /// Whether this is a compound (multi-joint) movement
  final bool isCompound;

  /// Whether this exercise works one side at a time
  final bool isUnilateral;

  /// Path to icon asset (for future SVG support)
  final String? iconAsset;

  const ExerciseDefinition({
    required this.id,
    required this.name,
    this.aliases = const [],
    required this.movementPattern,
    required this.primaryMuscles,
    this.secondaryMuscles = const [],
    required this.requiredEquipment,
    this.optionalEquipment = const [],
    required this.difficulty,
    required this.sportCategories,
    this.liftType,
    this.formCues = const [],
    this.commonMistakes = const [],
    this.isCompound = true,
    this.isUnilateral = false,
    this.iconAsset,
  });

  /// All muscle groups involved (primary + secondary)
  List<MuscleGroup> get allMuscles {
    return [...primaryMuscles, ...secondaryMuscles];
  }

  /// Check if this exercise can be performed with the given equipment
  bool canPerformWith(Set<EquipmentType> availableEquipment) {
    // Bodyweight exercises can always be performed
    if (requiredEquipment.isEmpty ||
        requiredEquipment.contains(EquipmentType.none) ||
        requiredEquipment.contains(EquipmentType.bodyweight)) {
      return true;
    }

    // Check if all required equipment is available
    return requiredEquipment.every((eq) => availableEquipment.contains(eq));
  }

  /// Calculate how well another exercise substitutes for this one
  /// Returns a score from 0-100
  int substitutionScore(ExerciseDefinition other, {Set<EquipmentType>? availableEquipment}) {
    int score = 0;

    // Primary muscle match (50% weight)
    final primaryOverlap = primaryMuscles
        .where((m) => other.primaryMuscles.contains(m))
        .length;
    if (primaryMuscles.isNotEmpty) {
      score += ((primaryOverlap / primaryMuscles.length) * 50).round();
    }

    // Movement pattern match (30% weight)
    if (other.movementPattern == movementPattern) {
      score += 30;
    } else if (movementPattern.relatedPatterns.contains(other.movementPattern)) {
      score += 15;
    }

    // Equipment availability (20% weight)
    if (availableEquipment != null) {
      if (other.canPerformWith(availableEquipment)) {
        score += 20;
      }
    } else {
      score += 20; // Assume equipment is available if not specified
    }

    return score.clamp(0, 100);
  }

  /// Check if this exercise matches a search query
  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();

    // Check name
    if (name.toLowerCase().contains(lowerQuery)) return true;

    // Check aliases
    if (aliases.any((alias) => alias.toLowerCase().contains(lowerQuery))) {
      return true;
    }

    // Check muscle groups
    if (primaryMuscles.any((m) => m.displayName.toLowerCase().contains(lowerQuery))) {
      return true;
    }

    // Check movement pattern
    if (movementPattern.displayName.toLowerCase().contains(lowerQuery)) {
      return true;
    }

    return false;
  }

  /// Create a copy with updated fields
  ExerciseDefinition copyWith({
    String? id,
    String? name,
    List<String>? aliases,
    MovementPattern? movementPattern,
    List<MuscleGroup>? primaryMuscles,
    List<MuscleGroup>? secondaryMuscles,
    List<EquipmentType>? requiredEquipment,
    List<EquipmentType>? optionalEquipment,
    DifficultyLevel? difficulty,
    Set<Sport>? sportCategories,
    LiftType? liftType,
    List<String>? formCues,
    List<String>? commonMistakes,
    bool? isCompound,
    bool? isUnilateral,
    String? iconAsset,
  }) {
    return ExerciseDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      aliases: aliases ?? this.aliases,
      movementPattern: movementPattern ?? this.movementPattern,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      requiredEquipment: requiredEquipment ?? this.requiredEquipment,
      optionalEquipment: optionalEquipment ?? this.optionalEquipment,
      difficulty: difficulty ?? this.difficulty,
      sportCategories: sportCategories ?? this.sportCategories,
      liftType: liftType ?? this.liftType,
      formCues: formCues ?? this.formCues,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      isCompound: isCompound ?? this.isCompound,
      isUnilateral: isUnilateral ?? this.isUnilateral,
      iconAsset: iconAsset ?? this.iconAsset,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        aliases,
        movementPattern,
        primaryMuscles,
        secondaryMuscles,
        requiredEquipment,
        optionalEquipment,
        difficulty,
        sportCategories,
        liftType,
        formCues,
        commonMistakes,
        isCompound,
        isUnilateral,
        iconAsset,
      ];

  @override
  String toString() {
    return 'ExerciseDefinition(name: $name, pattern: ${movementPattern.displayName}, '
        'muscles: ${primaryMuscles.map((m) => m.displayName).join(", ")})';
  }
}
