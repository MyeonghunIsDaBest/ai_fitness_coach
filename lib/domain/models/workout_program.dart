import 'package:equatable/equatable.dart';
import '../../core/enums/sport.dart';
import 'program_week.dart';
import 'athlete_profile.dart';

/// Domain model representing a complete training program
class WorkoutProgram extends Equatable {
  final String id;
  final String name;
  final Sport sport;
  final String description;
  final List<ProgramWeek> weeks;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool isCustom;
  final String? athleteProfileId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutProgram({
    required this.id,
    required this.name,
    required this.sport,
    required this.description,
    required this.weeks,
    required this.startDate,
    this.endDate,
    this.isActive = false,
    this.isCustom = false,
    this.athleteProfileId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor for creating a new program
  factory WorkoutProgram.create({
    required String name,
    required Sport sport,
    required String description,
    required List<ProgramWeek> weeks,
    DateTime? startDate,
    String? athleteProfileId,
    bool isCustom = false,
  }) {
    final now = DateTime.now();
    final start = startDate ?? now;
    final end = start.add(Duration(days: weeks.length * 7));

    return WorkoutProgram(
      id: _generateId(),
      name: name,
      sport: sport,
      description: description,
      weeks: weeks,
      startDate: start,
      endDate: end,
      isActive: false,
      isCustom: isCustom,
      athleteProfileId: athleteProfileId,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Copy with method
  WorkoutProgram copyWith({
    String? id,
    String? name,
    Sport? sport,
    String? description,
    List<ProgramWeek>? weeks,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    bool? isCustom,
    String? athleteProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutProgram(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      description: description ?? this.description,
      weeks: weeks ?? this.weeks,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      isCustom: isCustom ?? this.isCustom,
      athleteProfileId: athleteProfileId ?? this.athleteProfileId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Get total number of weeks
  int get totalWeeks => weeks.length;

  /// Alias for widget compatibility (same as totalWeeks)
  int get duration => totalWeeks;

  /// Get program duration in weeks
  int get durationWeeks => weeks.length;

  /// Get program duration in days
  int get durationDays => weeks.length * 7;

  /// Get specific week by number
  ProgramWeek? getWeek(int weekNumber) {
    try {
      return weeks.firstWhere((w) => w.weekNumber == weekNumber);
    } catch (_) {
      return null;
    }
  }

  /// Get current week based on start date
  ProgramWeek? get currentWeek {
    if (!isActive) return null;

    final now = DateTime.now();
    final daysSinceStart = now.difference(startDate).inDays;
    final currentWeekNumber = (daysSinceStart / 7).floor() + 1;

    if (currentWeekNumber > totalWeeks) return null;
    return getWeek(currentWeekNumber);
  }

  /// Get current week number
  int? get currentWeekNumber {
    if (!isActive) return null;

    final now = DateTime.now();
    final daysSinceStart = now.difference(startDate).inDays;
    final weekNumber = (daysSinceStart / 7).floor() + 1;

    return weekNumber <= totalWeeks ? weekNumber : null;
  }

  /// Get completion percentage
  double get completionPercentage {
    if (weeks.isEmpty) return 0.0;
    final completedWeeks = weeks.where((w) => w.isCompleted).length;
    return (completedWeeks / weeks.length) * 100;
  }

  /// Get completed weeks
  List<ProgramWeek> get completedWeeks {
    return weeks.where((w) => w.isCompleted).toList();
  }

  /// Get remaining weeks
  List<ProgramWeek> get remainingWeeks {
    return weeks.where((w) => !w.isCompleted).toList();
  }

  /// Check if program is finished
  bool get isFinished {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!) ||
        weeks.every((w) => w.isCompleted);
  }

  /// Calculate total training days
  int get totalTrainingDays {
    return weeks.fold(0, (sum, week) => sum + week.trainingDaysCount);
  }

  /// Calculate total sets in program
  int get totalSets {
    return weeks.fold(0, (sum, week) => sum + week.totalSets);
  }

  /// Activate this program
  WorkoutProgram activate() {
    return copyWith(
      isActive: true,
      startDate: DateTime.now(),
    );
  }

  /// Deactivate this program
  WorkoutProgram deactivate() {
    return copyWith(isActive: false);
  }

  /// Update a specific week
  WorkoutProgram updateWeek(int weekNumber, ProgramWeek updatedWeek) {
    final updatedWeeks = weeks.map((w) {
      return w.weekNumber == weekNumber ? updatedWeek : w;
    }).toList();

    return copyWith(weeks: updatedWeeks);
  }

  /// Get program summary
  String get summary {
    return '$totalWeeks weeks • $totalTrainingDays training days • ${sport.displayName}';
  }

  /// Check if program is valid
  bool get isValid {
    return name.isNotEmpty &&
        description.isNotEmpty &&
        weeks.isNotEmpty &&
        weeks.every((w) => w.isValid) &&
        startDate
            .isBefore(endDate ?? DateTime.now().add(const Duration(days: 365)));
  }

  static String _generateId() {
    return 'prog_${DateTime.now().millisecondsSinceEpoch}';
  }

  // ==========================================
  // JSON SERIALIZATION
  // ==========================================

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport.name,
      'description': description,
      'weeks': weeks.map((w) => w.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'isCustom': isCustom,
      'athleteProfileId': athleteProfileId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory WorkoutProgram.fromJson(Map<String, dynamic> json) {
    return WorkoutProgram(
      id: json['id'] as String,
      name: json['name'] as String,
      sport: Sport.values.byName(json['sport'] as String),
      description: json['description'] as String,
      weeks: (json['weeks'] as List)
          .map((w) => ProgramWeek.fromJson(w as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
      isCustom: json['isCustom'] as bool? ?? false,
      athleteProfileId: json['athleteProfileId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        sport,
        description,
        weeks,
        startDate,
        endDate,
        isActive,
        isCustom,
        athleteProfileId,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'WorkoutProgram(name: $name, sport: ${sport.displayName}, '
        'weeks: $totalWeeks, active: $isActive)';
  }
}
