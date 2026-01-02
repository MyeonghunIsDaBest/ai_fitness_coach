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

  const LoggedSet({
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
  });

  /// Factory constructor for creating a new logged set
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

  /// Create from JSON
  factory LoggedSet.fromJson(Map<String, dynamic> json) {
    return LoggedSet(
      id: json['id'] as String,
      workoutSessionId: json['workoutSessionId'] as String,
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      setNumber: json['setNumber'] as int,
      weight: (json['weight'] as num).toDouble(),
      weightUnit: json['weightUnit'] as String,
      reps: json['reps'] as int,
      rpe: (json['rpe'] as num).toDouble(),
      completed: json['completed'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
      targetRPE: json['targetRPE'] != null
          ? (json['targetRPE'] as num).toDouble()
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
