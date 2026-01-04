import 'package:equatable/equatable.dart';
import '../../core/enums/lift_type.dart';

/// Domain model representing a single exercise in a workout
class Exercise extends Equatable {
  final String id;
  final String name;
  final LiftType liftType;
  final int sets;
  final int reps;
  final bool isMain; // Main compound lift vs accessory
  final double? targetRPEMin;
  final double? targetRPEMax;
  final double? targetPercentage; // % of 1RM (alternative to RPE)
  final int restSeconds;
  final String? intensityDisplay; // e.g., "RPE 7-8", "70-75%"
  final List<String> formCues;
  final String? notes;
  final int order; // Position in workout

  const Exercise({
    required this.id,
    required this.name,
    required this.liftType,
    required this.sets,
    required this.reps,
    this.isMain = false,
    this.targetRPEMin,
    this.targetRPEMax,
    this.targetPercentage,
    this.restSeconds = 120,
    this.intensityDisplay,
    this.formCues = const [],
    this.notes,
    this.order = 0,
  });

  /// Factory constructor for creating a main compound lift
  factory Exercise.mainLift({
    required String name,
    required LiftType liftType,
    required int sets,
    required int reps,
    required double targetRPEMin,
    required double targetRPEMax,
    int restSeconds = 180,
    int order = 0,
    List<String>? formCues,
  }) {
    return Exercise(
      id: _generateId(),
      name: name,
      liftType: liftType,
      sets: sets,
      reps: reps,
      isMain: true,
      targetRPEMin: targetRPEMin,
      targetRPEMax: targetRPEMax,
      restSeconds: restSeconds,
      intensityDisplay: 'RPE ${targetRPEMin.toStringAsFixed(1)}-${targetRPEMax.toStringAsFixed(1)}',
      formCues: formCues ?? [],
      order: order,
    );
  }

  /// Factory constructor for creating an accessory exercise
  factory Exercise.accessory({
    required String name,
    required LiftType liftType,
    required int sets,
    required int reps,
    double? targetRPEMin,
    double? targetRPEMax,
    int restSeconds = 90,
    int order = 0,
    String? notes,
  }) {
    return Exercise(
      id: _generateId(),
      name: name,
      liftType: liftType,
      sets: sets,
      reps: reps,
      isMain: false,
      targetRPEMin: targetRPEMin,
      targetRPEMax: targetRPEMax,
      restSeconds: restSeconds,
      intensityDisplay: targetRPEMin != null
          ? 'RPE ${targetRPEMin.toStringAsFixed(1)}-${targetRPEMax?.toStringAsFixed(1) ?? "?"}'
          : null,
      order: order,
      notes: notes,
    );
  }

  /// Copy with method for immutable updates
  Exercise copyWith({
    String? id,
    String? name,
    LiftType? liftType,
    int? sets,
    int? reps,
    bool? isMain,
    double? targetRPEMin,
    double? targetRPEMax,
    double? targetPercentage,
    int? restSeconds,
    String? intensityDisplay,
    List<String>? formCues,
    String? notes,
    int? order,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      liftType: liftType ?? this.liftType,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      isMain: isMain ?? this.isMain,
      targetRPEMin: targetRPEMin ?? this.targetRPEMin,
      targetRPEMax: targetRPEMax ?? this.targetRPEMax,
      targetPercentage: targetPercentage ?? this.targetPercentage,
      restSeconds: restSeconds ?? this.restSeconds,
      intensityDisplay: intensityDisplay ?? this.intensityDisplay,
      formCues: formCues ?? this.formCues,
      notes: notes ?? this.notes,
      order: order ?? this.order,
    );
  }

  /// Calculate total volume (sets × reps)
  int get totalVolume => sets * reps;

  /// Get target RPE midpoint
  double? get targetRPEMid {
    if (targetRPEMin == null || targetRPEMax == null) return null;
    return (targetRPEMin! + targetRPEMax!) / 2;
  }

  /// Check if exercise has RPE targets
  bool get hasRPETarget => targetRPEMin != null && targetRPEMax != null;

  /// Check if exercise uses percentage-based intensity
  bool get usesPercentage => targetPercentage != null;

  /// Get muscle groups trained
  List<MuscleGroup> get muscleGroups => liftType.primaryMuscles;

  /// Get exercise category
  LiftCategory get category => liftType.category;

  /// Format rest time for display
  String get restTimeDisplay {
    if (restSeconds < 60) return '${restSeconds}s';
    final minutes = restSeconds ~/ 60;
    final seconds = restSeconds % 60;
    return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
  }

  /// Validate exercise data
  bool get isValid {
    return name.isNotEmpty &&
        sets > 0 &&
        reps > 0 &&
        restSeconds >= 0 &&
        (targetRPEMin == null || (targetRPEMin! >= 1.0 && targetRPEMin! <= 10.0)) &&
        (targetRPEMax == null || (targetRPEMax! >= 1.0 && targetRPEMax! <= 10.0)) &&
        (targetPercentage == null || (targetPercentage! > 0 && targetPercentage! <= 100));
  }

  static String _generateId() {
    return 'ex_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        liftType,
        sets,
        reps,
        isMain,
        targetRPEMin,
        targetRPEMax,
        targetPercentage,
        restSeconds,
        intensityDisplay,
        formCues,
        notes,
        order,
      ];

  @override
  String toString() {
    return 'Exercise(name: $name, sets: $sets, reps: $reps, '
        'isMain: $isMain, intensity: $intensityDisplay)';
  }
}