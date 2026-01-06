import 'logged_set.dart';

/// Represents a complete workout session with all logged sets
class WorkoutSession {
  final String id;
  final String programId;
  final int weekNumber;
  final int dayNumber;
  final String workoutName;
  final DateTime startTime;
  final DateTime? endTime;
  final List<LoggedSet> sets;
  final bool isCompleted;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.programId,
    required this.weekNumber,
    required this.dayNumber,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    required this.sets,
    required this.isCompleted,
    this.notes,
  });

  /// Calculate total duration of workout
  Duration get duration {
    if (endTime == null) return Duration.zero;
    return endTime!.difference(startTime);
  }

  /// Calculate total volume (weight × reps) for entire session
  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + set.volume);
  }

  /// Calculate average RPE across all sets
  double get averageRPE {
    if (sets.isEmpty) return 0.0;
    final totalRPE = sets.fold(0.0, (sum, set) => sum + set.rpe);
    return totalRPE / sets.length;
  }

  /// Get total number of sets performed
  int get totalSets => sets.length;

  /// Get unique exercises performed
  Set<String> get exercisesPerformed {
    return sets.map((set) => set.exerciseName).toSet();
  }

  /// Get sets grouped by exercise
  Map<String, List<LoggedSet>> get setsByExercise {
    final Map<String, List<LoggedSet>> grouped = {};
    for (var set in sets) {
      grouped.putIfAbsent(set.exerciseName, () => []).add(set);
    }
    return grouped;
  }

  /// Check if workout is in progress
  bool get isInProgress => !isCompleted && endTime == null;

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'weekNumber': weekNumber,
      'dayNumber': dayNumber,
      'workoutName': workoutName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'sets': sets.map((set) => set.toJson()).toList(),
      'isCompleted': isCompleted,
      'notes': notes,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      programId: json['programId'] as String,
      weekNumber: json['weekNumber'] as int,
      dayNumber: json['dayNumber'] as int,
      workoutName: json['workoutName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      sets: (json['sets'] as List)
          .map((setJson) => LoggedSet.fromJson(setJson as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool,
      notes: json['notes'] as String?,
    );
  }

  // CopyWith for immutability
  WorkoutSession copyWith({
    String? id,
    String? programId,
    int? weekNumber,
    int? dayNumber,
    String? workoutName,
    DateTime? startTime,
    DateTime? endTime,
    List<LoggedSet>? sets,
    bool? isCompleted,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      weekNumber: weekNumber ?? this.weekNumber,
      dayNumber: dayNumber ?? this.dayNumber,
      workoutName: workoutName ?? this.workoutName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      sets: sets ?? this.sets,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'WorkoutSession(id: $id, workout: $workoutName, sets: ${sets.length}, completed: $isCompleted)';
  }
}
