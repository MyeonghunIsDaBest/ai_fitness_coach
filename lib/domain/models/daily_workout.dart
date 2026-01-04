import 'package:equatable/equatable.dart';
import '../../core/enums/lift_type.dart';
import 'exercise.dart';

/// Domain model representing a single day's workout
class DailyWorkout extends Equatable {
  final String id;
  final String dayId; // e.g., "mon", "tue", "wed"
  final String dayName; // "Monday", "Tuesday"
  final int dayNumber; // 1-7 (Monday = 1)
  final String focus; // e.g., "Upper Power", "Lower Hypertrophy"
  final List<Exercise> exercises;
  final bool isRestDay;
  final int estimatedDurationMinutes;
  final String? warmupNotes;
  final String? cooldownNotes;
  final String? coachNotes;

  const DailyWorkout({
    required this.id,
    required this.dayId,
    required this.dayName,
    required this.dayNumber,
    required this.focus,
    required this.exercises,
    this.isRestDay = false,
    this.estimatedDurationMinutes = 60,
    this.warmupNotes,
    this.cooldownNotes,
    this.coachNotes,
  });

  /// Factory constructor for creating a training day
  factory DailyWorkout.trainingDay({
    required String dayId,
    required String dayName,
    required int dayNumber,
    required String focus,
    required List<Exercise> exercises,
    int? estimatedDurationMinutes,
    String? warmupNotes,
    String? cooldownNotes,
    String? coachNotes,
  }) {
    // Auto-calculate duration if not provided
    final duration = estimatedDurationMinutes ?? _calculateDuration(exercises);

    return DailyWorkout(
      id: _generateId(),
      dayId: dayId,
      dayName: dayName,
      dayNumber: dayNumber,
      focus: focus,
      exercises: exercises,
      isRestDay: false,
      estimatedDurationMinutes: duration,
      warmupNotes: warmupNotes,
      cooldownNotes: cooldownNotes,
      coachNotes: coachNotes,
    );
  }

  /// Factory constructor for creating a rest day
  factory DailyWorkout.restDay({
    required String dayId,
    required String dayName,
    required int dayNumber,
    String? coachNotes,
  }) {
    return DailyWorkout(
      id: _generateId(),
      dayId: dayId,
      dayName: dayName,
      dayNumber: dayNumber,
      focus: 'Rest & Recovery',
      exercises: const [],
      isRestDay: true,
      estimatedDurationMinutes: 0,
      coachNotes: coachNotes ??
          'Active recovery: light stretching, walking, or mobility work',
    );
  }

  /// Copy with method
  DailyWorkout copyWith({
    String? id,
    String? dayId,
    String? dayName,
    int? dayNumber,
    String? focus,
    List<Exercise>? exercises,
    bool? isRestDay,
    int? estimatedDurationMinutes,
    String? warmupNotes,
    String? cooldownNotes,
    String? coachNotes,
  }) {
    return DailyWorkout(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      dayName: dayName ?? this.dayName,
      dayNumber: dayNumber ?? this.dayNumber,
      focus: focus ?? this.focus,
      exercises: exercises ?? this.exercises,
      isRestDay: isRestDay ?? this.isRestDay,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      warmupNotes: warmupNotes ?? this.warmupNotes,
      cooldownNotes: cooldownNotes ?? this.cooldownNotes,
      coachNotes: coachNotes ?? this.coachNotes,
    );
  }

  /// Get exercise count
  int get exerciseCount => exercises.length;

  /// Check if workout has main lifts
  bool get hasMainLift => exercises.any((e) => e.isMain);

  /// Get main lifts only
  List<Exercise> get mainLifts => exercises.where((e) => e.isMain).toList();

  /// Get accessory exercises only
  List<Exercise> get accessories => exercises.where((e) => !e.isMain).toList();

  /// Calculate total sets for the day
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);

  /// Calculate total reps for the day
  int get totalReps => exercises.fold(0, (sum, e) => sum + e.totalVolume);

  /// Get unique muscle groups trained
  List<MuscleGroup> get muscleGroupsTrained {
    final groups = <MuscleGroup>{};
    for (final exercise in exercises) {
      groups.addAll(exercise.muscleGroups);
    }
    return groups.toList();
  }

  /// Format duration for display
  String get durationDisplay {
    if (isRestDay) return 'Rest Day';
    if (estimatedDurationMinutes < 60) return '$estimatedDurationMinutes min';
    final hours = estimatedDurationMinutes ~/ 60;
    final minutes = estimatedDurationMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  /// Get workout summary
  String get summary {
    if (isRestDay) return 'Rest & Recovery';
    return '$exerciseCount exercises • $totalSets sets • $durationDisplay';
  }

  /// Check if workout is valid
  bool get isValid {
    if (isRestDay) return true;
    return dayName.isNotEmpty &&
        focus.isNotEmpty &&
        exercises.isNotEmpty &&
        exercises.every((e) => e.isValid) &&
        estimatedDurationMinutes > 0;
  }

  /// Calculate estimated duration based on exercises
  static int _calculateDuration(List<Exercise> exercises) {
    if (exercises.isEmpty) return 0;

    // Warmup: 10 minutes
    int totalMinutes = 10;

    // Exercise time
    for (final exercise in exercises) {
      // Assume 30 seconds per rep
      final workTime = (exercise.totalVolume * 0.5) / 60; // Convert to minutes
      // Rest time between sets
      final restTime = (exercise.sets * exercise.restSeconds) / 60;
      totalMinutes += (workTime + restTime).ceil();
    }

    // Cooldown: 5 minutes
    totalMinutes += 5;

    return totalMinutes;
  }

  static String _generateId() {
    return 'day_${DateTime.now().millisecondsSinceEpoch}';
  }

  // ==========================================
  // SERIALIZATION
  // ==========================================

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayId': dayId,
      'dayName': dayName,
      'dayNumber': dayNumber,
      'focus': focus,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'isRestDay': isRestDay,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'warmupNotes': warmupNotes,
      'cooldownNotes': cooldownNotes,
      'coachNotes': coachNotes,
    };
  }

  /// Create from JSON
  factory DailyWorkout.fromJson(Map<String, dynamic> json) {
    return DailyWorkout(
      id: json['id'] as String,
      dayId: json['dayId'] as String,
      dayName: json['dayName'] as String,
      dayNumber: json['dayNumber'] as int,
      focus: json['focus'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRestDay: json['isRestDay'] as bool? ?? false,
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int? ?? 60,
      warmupNotes: json['warmupNotes'] as String?,
      cooldownNotes: json['cooldownNotes'] as String?,
      coachNotes: json['coachNotes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        dayId,
        dayName,
        dayNumber,
        focus,
        exercises,
        isRestDay,
        estimatedDurationMinutes,
        warmupNotes,
        cooldownNotes,
        coachNotes,
      ];

  @override
  String toString() {
    return 'DailyWorkout(dayName: $dayName, focus: $focus, '
        'exercises: $exerciseCount, isRestDay: $isRestDay)';
  }
}
