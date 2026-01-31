import 'package:equatable/equatable.dart';
import '../../core/enums/rpe_feedback.dart';

/// Domain model representing a single logged set during a workout
/// Tracks weight, reps, RPE, and calculates derived metrics
class LoggedSet extends Equatable {
  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final String exerciseName;
  final int setNumber;
  final double weight;
  final String weightUnit; // kg or lbs
  final int reps;
  final double rpe;
  final bool completed;
  final DateTime timestamp;
  final String? notes;
  final double? targetRPE;

  LoggedSet({
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
  })  : assert(rpe >= 1.0 && rpe <= 10.0, 'RPE must be between 1.0 and 10.0, got: $rpe'),
        assert(weight >= 0, 'Weight must be non-negative, got: $weight'),
        assert(reps >= 0, 'Reps must be non-negative, got: $reps'),
        assert(setNumber > 0, 'Set number must be positive, got: $setNumber'),
        assert(weightUnit == 'kg' || weightUnit == 'lbs', 'Weight unit must be kg or lbs, got: $weightUnit');

  /// Factory constructor for creating a new logged set with validation
  /// Throws [ArgumentError] if values are outside valid ranges
  factory LoggedSet.create({
    required String workoutSessionId,
    required String exerciseId,
    required String exerciseName,
    required int setNumber,
    required double weight,
    required String weightUnit,
    required int reps,
    required double rpe,
    double? targetRPE,
    String? notes,
  }) {
    // Validate inputs before creating
    if (rpe < 1.0 || rpe > 10.0) {
      throw ArgumentError('RPE must be between 1.0 and 10.0, got: $rpe');
    }
    if (weight < 0) {
      throw ArgumentError('Weight must be non-negative, got: $weight');
    }
    if (reps < 0) {
      throw ArgumentError('Reps must be non-negative, got: $reps');
    }
    if (setNumber < 1) {
      throw ArgumentError('Set number must be positive, got: $setNumber');
    }
    if (weightUnit != 'kg' && weightUnit != 'lbs') {
      throw ArgumentError('Weight unit must be kg or lbs, got: $weightUnit');
    }
    if (targetRPE != null && (targetRPE < 1.0 || targetRPE > 10.0)) {
      throw ArgumentError('Target RPE must be between 1.0 and 10.0, got: $targetRPE');
    }

    return LoggedSet(
      id: _generateId(),
      workoutSessionId: workoutSessionId,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      setNumber: setNumber,
      weight: weight,
      weightUnit: weightUnit,
      reps: reps,
      rpe: rpe,
      completed: true,
      timestamp: DateTime.now(),
      targetRPE: targetRPE,
      notes: notes,
    );
  }

  /// Copy with method for immutable updates
  LoggedSet copyWith({
    String? id,
    String? workoutSessionId,
    String? exerciseId,
    String? exerciseName,
    int? setNumber,
    double? weight,
    String? weightUnit,
    int? reps,
    double? rpe,
    bool? completed,
    DateTime? timestamp,
    String? notes,
    double? targetRPE,
  }) {
    return LoggedSet(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      completed: completed ?? this.completed,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      targetRPE: targetRPE ?? this.targetRPE,
    );
  }

  // ==========================================
  // DISPLAY METHODS
  // ==========================================

  /// Display weight with unit (e.g., "100kg" or "225lbs")
  String get weightDisplay => '$weight$weightUnit';

  /// Format set info for display (e.g., "100kg × 5 reps")
  String get setDisplay => '$weightDisplay × $reps reps';

  /// Format RPE for display (e.g., "RPE 8.5")
  String get rpeDisplay => 'RPE ${rpe.toStringAsFixed(1)}';

  /// Full set summary
  String get summary => '$setDisplay @ $rpeDisplay';

  // ==========================================
  // CALCULATIONS
  // ==========================================

  /// Calculate estimated 1RM using Epley formula
  /// Formula: weight × (1 + reps / 30)
  double get estimated1RM {
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }

  /// Calculate estimated 1RM using Brzycki formula (alternative)
  /// Formula: weight × (36 / (37 - reps))
  double get estimated1RMBrzycki {
    if (reps == 1) return weight;
    if (reps >= 37) return weight; // Formula breaks down at high reps
    return weight * (36 / (37 - reps));
  }

  /// Calculate total volume (weight × reps)
  double get volume => weight * reps;

  /// Calculate relative intensity (percentage of estimated 1RM)
  double get relativeIntensity {
    final e1rm = estimated1RM;
    return e1rm > 0 ? (weight / e1rm) * 100 : 0.0;
  }

  /// Estimate reps in reserve (RIR) from RPE
  /// RPE 10 = 0 RIR, RPE 9 = 1 RIR, etc.
  int get estimatedRIR {
    return (10 - rpe).round().clamp(0, 10);
  }

  // ==========================================
  // VALIDATION & FEEDBACK
  // ==========================================

  /// Check if RPE is valid (between 1-10)
  bool get isValidRPE => rpe >= 1.0 && rpe <= 10.0;

  /// Check if set data is valid
  bool get isValid {
    return exerciseId.isNotEmpty &&
        exerciseName.isNotEmpty &&
        setNumber > 0 &&
        weight > 0 &&
        reps > 0 &&
        isValidRPE &&
        (weightUnit == 'kg' || weightUnit == 'lbs');
  }

  /// Check if RPE is on target
  bool isOnTarget(double targetRPEMin, double targetRPEMax) {
    if (targetRPE != null) {
      return (rpe - targetRPE!).abs() <= 0.5;
    }
    return rpe >= targetRPEMin && rpe <= targetRPEMax;
  }

  /// Get RPE feedback compared to target
  RPEFeedback getRPEFeedback(double targetRPEMin, double targetRPEMax) {
    if (rpe < targetRPEMin - 1.5) return RPEFeedback.tooEasy;
    if (rpe < targetRPEMin) return RPEFeedback.belowTarget;
    if (rpe >= targetRPEMin && rpe <= targetRPEMax) return RPEFeedback.onTarget;
    if (rpe <= targetRPEMax + 1.5) return RPEFeedback.aboveTarget;
    return RPEFeedback.tooHard;
  }

  /// Check if this set represents a personal record
  bool isPR(double previousBest1RM) {
    return estimated1RM > previousBest1RM;
  }

  // ==========================================
  // WEIGHT CONVERSION
  // ==========================================

  /// Convert weight to kg
  double get weightInKg {
    if (weightUnit == 'kg') return weight;
    return weight / 2.20462; // lbs to kg
  }

  /// Convert weight to lbs
  double get weightInLbs {
    if (weightUnit == 'lbs') return weight;
    return weight * 2.20462; // kg to lbs
  }

  /// Get weight in specified unit
  double getWeightIn(String unit) {
    if (unit == 'kg') return weightInKg;
    if (unit == 'lbs') return weightInLbs;
    return weight;
  }

  // ==========================================
  // SERIALIZATION
  // ==========================================

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutSessionId': workoutSessionId,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'setNumber': setNumber,
      'weight': weight,
      'weightUnit': weightUnit,
      'reps': reps,
      'rpe': rpe,
      'completed': completed,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
      'targetRPE': targetRPE,
    };
  }

  /// Create from JSON with validation and safe defaults
  factory LoggedSet.fromJson(Map<String, dynamic> json) {
    // Validate and clamp RPE to valid range
    final rawRpe = (json['rpe'] as num?)?.toDouble() ?? 5.0;
    final validRpe = rawRpe.clamp(1.0, 10.0);

    // Validate weight is non-negative
    final rawWeight = (json['weight'] as num?)?.toDouble() ?? 0.0;
    final validWeight = rawWeight < 0 ? 0.0 : rawWeight;

    // Validate reps is non-negative
    final rawReps = (json['reps'] as int?) ?? 0;
    final validReps = rawReps < 0 ? 0 : rawReps;

    // Validate set number is positive
    final rawSetNumber = (json['setNumber'] as int?) ?? 1;
    final validSetNumber = rawSetNumber < 1 ? 1 : rawSetNumber;

    // Validate weight unit
    final rawWeightUnit = json['weightUnit'] as String? ?? 'lbs';
    final validWeightUnit = (rawWeightUnit == 'kg' || rawWeightUnit == 'lbs')
        ? rawWeightUnit
        : 'lbs';

    return LoggedSet(
      id: json['id'] as String? ?? _generateId(),
      workoutSessionId: json['workoutSessionId'] as String? ?? '',
      exerciseId: json['exerciseId'] as String? ?? '',
      exerciseName: json['exerciseName'] as String? ?? 'Unknown Exercise',
      setNumber: validSetNumber,
      weight: validWeight,
      weightUnit: validWeightUnit,
      reps: validReps,
      rpe: validRpe,
      completed: json['completed'] as bool? ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      notes: json['notes'] as String?,
      targetRPE: json['targetRPE'] != null
          ? (json['targetRPE'] as num).toDouble().clamp(1.0, 10.0)
          : null,
    );
  }

  /// Generate unique ID
  static String _generateId() {
    return 'set_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }

  @override
  List<Object?> get props => [
        id,
        workoutSessionId,
        exerciseId,
        exerciseName,
        setNumber,
        weight,
        weightUnit,
        reps,
        rpe,
        completed,
        timestamp,
        notes,
        targetRPE,
      ];

  @override
  String toString() {
    return 'LoggedSet(set: $setNumber, exercise: $exerciseName, $setDisplay, $rpeDisplay)';
  }
}
