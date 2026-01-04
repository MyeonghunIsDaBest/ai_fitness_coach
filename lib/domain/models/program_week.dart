import 'package:equatable/equatable.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/week_type.dart';
import 'daily_workout.dart';

/// Domain model representing a single week in a training program
class ProgramWeek extends Equatable {
  final String id;
  final int weekNumber;
  final Phase phase;
  final WeekType weekType;
  final double targetRPEMin;
  final double targetRPEMax;
  final double intensityMultiplier; // For deload weeks
  final double volumeMultiplier; // For deload weeks
  final List<DailyWorkout> dailyWorkouts;
  final String? coachNotes;
  final bool isCompleted;
  final DateTime? completedDate;

  const ProgramWeek({
    required this.id,
    required this.weekNumber,
    required this.phase,
    required this.weekType,
    required this.targetRPEMin,
    required this.targetRPEMax,
    this.intensityMultiplier = 1.0,
    this.volumeMultiplier = 1.0,
    required this.dailyWorkouts,
    this.coachNotes,
    this.isCompleted = false,
    this.completedDate,
  });

  /// Factory constructor for creating a normal training week
  factory ProgramWeek.normal({
    required int weekNumber,
    required Phase phase,
    required double targetRPEMin,
    required double targetRPEMax,
    required List<DailyWorkout> dailyWorkouts,
    String? coachNotes,
  }) {
    return ProgramWeek(
      id: _generateId(),
      weekNumber: weekNumber,
      phase: phase,
      weekType: WeekType.normal,
      targetRPEMin: targetRPEMin,
      targetRPEMax: targetRPEMax,
      intensityMultiplier: 1.0,
      volumeMultiplier: 1.0,
      dailyWorkouts: dailyWorkouts,
      coachNotes: coachNotes,
    );
  }

  /// Factory constructor for creating a deload week
  factory ProgramWeek.deload({
    required int weekNumber,
    required Phase phase,
    required List<DailyWorkout> dailyWorkouts,
    String? coachNotes,
  }) {
    return ProgramWeek(
      id: _generateId(),
      weekNumber: weekNumber,
      phase: phase,
      weekType: WeekType.deload,
      targetRPEMin: 5.0,
      targetRPEMax: 7.0,
      intensityMultiplier: 0.6,
      volumeMultiplier: 0.5,
      dailyWorkouts: dailyWorkouts,
      coachNotes:
          coachNotes ?? 'Recovery week: focus on technique and feel good',
    );
  }

  /// Copy with method
  ProgramWeek copyWith({
    String? id,
    int? weekNumber,
    Phase? phase,
    WeekType? weekType,
    double? targetRPEMin,
    double? targetRPEMax,
    double? intensityMultiplier,
    double? volumeMultiplier,
    List<DailyWorkout>? dailyWorkouts,
    String? coachNotes,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return ProgramWeek(
      id: id ?? this.id,
      weekNumber: weekNumber ?? this.weekNumber,
      phase: phase ?? this.phase,
      weekType: weekType ?? this.weekType,
      targetRPEMin: targetRPEMin ?? this.targetRPEMin,
      targetRPEMax: targetRPEMax ?? this.targetRPEMax,
      intensityMultiplier: intensityMultiplier ?? this.intensityMultiplier,
      volumeMultiplier: volumeMultiplier ?? this.volumeMultiplier,
      dailyWorkouts: dailyWorkouts ?? this.dailyWorkouts,
      coachNotes: coachNotes ?? this.coachNotes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  /// Get intensity range display
  String get intensityRange =>
      'RPE ${targetRPEMin.toStringAsFixed(1)}–${targetRPEMax.toStringAsFixed(1)}';

  /// Get target RPE midpoint
  double get targetRPEMid => (targetRPEMin + targetRPEMax) / 2;

  /// Check if this is a deload week
  bool get isDeload => weekType == WeekType.deload;

  /// Check if this is a test week
  bool get isTestWeek => weekType == WeekType.test;

  /// Get workout for specific day
  DailyWorkout? getWorkoutForDay(String dayId) {
    try {
      return dailyWorkouts.firstWhere((d) => d.dayId == dayId);
    } catch (_) {
      return null;
    }
  }

  /// Get workout by day number (1-7)
  DailyWorkout? getWorkoutByDayNumber(int dayNumber) {
    try {
      return dailyWorkouts.firstWhere((d) => d.dayNumber == dayNumber);
    } catch (_) {
      return null;
    }
  }

  /// Get training days (exclude rest days)
  List<DailyWorkout> get trainingDays {
    return dailyWorkouts.where((d) => !d.isRestDay).toList();
  }

  /// Get rest days
  List<DailyWorkout> get restDays {
    return dailyWorkouts.where((d) => d.isRestDay).toList();
  }

  /// Get total training days count
  int get trainingDaysCount => trainingDays.length;

  /// Get total rest days count
  int get restDaysCount => restDays.length;

  /// Calculate total sets for the week
  int get totalSets {
    return trainingDays.fold(0, (sum, day) => sum + day.totalSets);
  }

  /// Calculate total reps for the week
  int get totalReps {
    return trainingDays.fold(0, (sum, day) => sum + day.totalReps);
  }

  /// Get week summary
  String get summary {
    return '${phase.displayName} • $trainingDaysCount training days • $totalSets sets';
  }

  /// Mark week as completed
  ProgramWeek markCompleted() {
    return copyWith(
      isCompleted: true,
      completedDate: DateTime.now(),
    );
  }

  /// Check if week is valid
  bool get isValid {
    return weekNumber > 0 &&
        targetRPEMin >= 1.0 &&
        targetRPEMin <= 10.0 &&
        targetRPEMax >= targetRPEMin &&
        targetRPEMax <= 10.0 &&
        dailyWorkouts.isNotEmpty &&
        dailyWorkouts.every((d) => d.isValid);
  }

  static String _generateId() {
    return 'week_${DateTime.now().millisecondsSinceEpoch}';
  }

// ==========================================
// JSON SERIALIZATION
// ==========================================

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weekNumber': weekNumber,
      'phase': phase.name,
      'weekType': weekType.name,
      'targetRPEMin': targetRPEMin,
      'targetRPEMax': targetRPEMax,
      'intensityMultiplier': intensityMultiplier,
      'volumeMultiplier': volumeMultiplier,
      'dailyWorkouts': dailyWorkouts.map((d) => d.toJson()).toList(),
      'coachNotes': coachNotes,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ProgramWeek.fromJson(Map<String, dynamic> json) {
    return ProgramWeek(
      id: json['id'] as String,
      weekNumber: json['weekNumber'] as int,
      phase: Phase.values.byName(json['phase'] as String),
      weekType: WeekType.values.byName(json['weekType'] as String),
      targetRPEMin: (json['targetRPEMin'] as num).toDouble(),
      targetRPEMax: (json['targetRPEMax'] as num).toDouble(),
      intensityMultiplier: json['intensityMultiplier'] != null
          ? (json['intensityMultiplier'] as num).toDouble()
          : 1.0,
      volumeMultiplier: json['volumeMultiplier'] != null
          ? (json['volumeMultiplier'] as num).toDouble()
          : 1.0,
      dailyWorkouts: (json['dailyWorkouts'] as List)
          .map((d) => DailyWorkout.fromJson(d as Map<String, dynamic>))
          .toList(),
      coachNotes: json['coachNotes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
    );
  }
  @override
  List<Object?> get props => [
        id,
        weekNumber,
        phase,
        weekType,
        targetRPEMin,
        targetRPEMax,
        intensityMultiplier,
        volumeMultiplier,
        dailyWorkouts,
        coachNotes,
        isCompleted,
        completedDate,
      ];

  @override
  String toString() {
    return 'ProgramWeek(week: $weekNumber, phase: ${phase.displayName}, '
        'type: ${weekType.displayName}, RPE: $intensityRange)';
  }
}
