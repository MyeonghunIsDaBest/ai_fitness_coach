import '../models/logged_set.dart';

/// Utility class for calculating workout session statistics
/// Handles volume, tonnage, intensity, and completion metrics
class SessionStats {
  // ==========================================
  // VOLUME CALCULATIONS
  // ==========================================

  /// Calculate total volume (sum of weight × reps for all sets)
  static double calculateTotalVolume(List<LoggedSet> sets) {
    if (sets.isEmpty) return 0.0;
    return sets.fold(0.0, (sum, set) => sum + set.volume);
  }

  /// Calculate total tonnage (same as volume, alternate name)
  static double calculateTonnage(List<LoggedSet> sets) {
    return calculateTotalVolume(sets);
  }

  /// Calculate volume per exercise
  static Map<String, double> calculateVolumePerExercise(List<LoggedSet> sets) {
    final Map<String, double> exerciseVolume = {};

    for (final set in sets) {
      exerciseVolume[set.exerciseName] =
          (exerciseVolume[set.exerciseName] ?? 0.0) + set.volume;
    }

    return exerciseVolume;
  }

  /// Calculate total reps
  static int calculateTotalReps(List<LoggedSet> sets) {
    return sets.fold(0, (sum, set) => sum + set.reps);
  }

  // ==========================================
  // SET COMPLETION
  // ==========================================

  /// Calculate number of completed sets
  static int calculateCompletedSets(List<LoggedSet> sets) {
    return sets.where((set) => set.completed).length;
  }

  /// Calculate completion percentage
  static double calculateCompletionPercentage(
    List<LoggedSet> sets,
    int totalPlannedSets,
  ) {
    if (totalPlannedSets == 0) return 0.0;
    final completed = calculateCompletedSets(sets);
    return (completed / totalPlannedSets) * 100;
  }

  /// Check if all sets are completed
  static bool areAllSetsCompleted(List<LoggedSet> sets, int totalPlannedSets) {
    return calculateCompletedSets(sets) >= totalPlannedSets;
  }

  // ==========================================
  // INTENSITY METRICS
  // ==========================================

  /// Calculate average relative intensity (% of 1RM)
  static double calculateAverageIntensity(List<LoggedSet> sets) {
    if (sets.isEmpty) return 0.0;

    final intensities = sets.map((set) => set.relativeIntensity).toList();
    return intensities.reduce((a, b) => a + b) / intensities.length;
  }

  /// Calculate intensity per exercise
  static Map<String, double> calculateIntensityPerExercise(
      List<LoggedSet> sets) {
    final Map<String, List<double>> exerciseIntensities = {};

    for (final set in sets) {
      if (!exerciseIntensities.containsKey(set.exerciseName)) {
        exerciseIntensities[set.exerciseName] = [];
      }
      exerciseIntensities[set.exerciseName]!.add(set.relativeIntensity);
    }

    // Calculate average for each exercise
    final Map<String, double> result = {};
    exerciseIntensities.forEach((exercise, intensities) {
      result[exercise] =
          intensities.reduce((a, b) => a + b) / intensities.length;
    });

    return result;
  }

  // ==========================================
  // ESTIMATED 1RM
  // ==========================================

  /// Find best estimated 1RM across all sets
  static double findBestEstimated1RM(List<LoggedSet> sets) {
    if (sets.isEmpty) return 0.0;
    return sets.map((set) => set.estimated1RM).reduce((a, b) => a > b ? a : b);
  }

  /// Find best estimated 1RM per exercise
  static Map<String, double> findBest1RMPerExercise(List<LoggedSet> sets) {
    final Map<String, double> exercise1RMs = {};

    for (final set in sets) {
      final current = exercise1RMs[set.exerciseName] ?? 0.0;
      final new1RM = set.estimated1RM;

      if (new1RM > current) {
        exercise1RMs[set.exerciseName] = new1RM;
      }
    }

    return exercise1RMs;
  }

  // ==========================================
  // WORKOUT DURATION
  // ==========================================

  /// Calculate workout duration from start to end time
  static Duration calculateWorkoutDuration(DateTime start, DateTime end) {
    return end.difference(start);
  }

  /// Format duration for display (e.g., "1h 23m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Calculate estimated rest time between sets
  static Duration calculateAverageRestTime(List<LoggedSet> sets) {
    if (sets.length < 2) return Duration.zero;

    // Sort by timestamp
    final sortedSets = List<LoggedSet>.from(sets)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    Duration totalRest = Duration.zero;
    int restPeriods = 0;

    for (int i = 1; i < sortedSets.length; i++) {
      final rest =
          sortedSets[i].timestamp.difference(sortedSets[i - 1].timestamp);
      // Only count rest periods under 10 minutes (to exclude long breaks)
      if (rest.inMinutes < 10) {
        totalRest += rest;
        restPeriods++;
      }
    }

    return restPeriods > 0
        ? Duration(seconds: totalRest.inSeconds ~/ restPeriods)
        : Duration.zero;
  }

  // ==========================================
  // PERSONAL RECORDS
  // ==========================================

  /// Check if any sets are personal records
  static List<LoggedSet> findPersonalRecords(
    List<LoggedSet> sets,
    Map<String, double> previousBest1RMs,
  ) {
    final List<LoggedSet> prs = [];

    for (final set in sets) {
      final previousBest = previousBest1RMs[set.exerciseName] ?? 0.0;
      if (set.isPR(previousBest)) {
        prs.add(set);
      }
    }

    return prs;
  }

  /// Count number of PRs in session
  static int countPersonalRecords(
    List<LoggedSet> sets,
    Map<String, double> previousBest1RMs,
  ) {
    return findPersonalRecords(sets, previousBest1RMs).length;
  }

  // ==========================================
  // EXERCISE SUMMARY
  // ==========================================

  /// Generate summary stats for each exercise
  static Map<String, ExerciseSummary> generateExerciseSummaries(
    List<LoggedSet> sets,
  ) {
    final Map<String, List<LoggedSet>> exerciseSets = {};

    // Group sets by exercise
    for (final set in sets) {
      if (!exerciseSets.containsKey(set.exerciseName)) {
        exerciseSets[set.exerciseName] = [];
      }
      exerciseSets[set.exerciseName]!.add(set);
    }

    // Generate summary for each exercise
    final Map<String, ExerciseSummary> summaries = {};
    exerciseSets.forEach((exerciseName, exerciseSets) {
      summaries[exerciseName] = ExerciseSummary(
        exerciseName: exerciseName,
        totalSets: exerciseSets.length,
        totalReps: exerciseSets.fold(0, (sum, set) => sum + set.reps),
        totalVolume: exerciseSets.fold(0.0, (sum, set) => sum + set.volume),
        averageRPE: exerciseSets.fold(0.0, (sum, set) => sum + set.rpe) /
            exerciseSets.length,
        best1RM: exerciseSets
            .map((set) => set.estimated1RM)
            .reduce((a, b) => a > b ? a : b),
        heaviestSet: exerciseSets.reduce((a, b) => a.weight > b.weight ? a : b),
      );
    });

    return summaries;
  }

  // ==========================================
  // WORKOUT QUALITY
  // ==========================================

  /// Calculate workout quality score (0-100)
  /// Based on completion rate and RPE adherence
  static double calculateQualityScore({
    required List<LoggedSet> sets,
    required int totalPlannedSets,
    required double targetRPEMin,
    required double targetRPEMax,
  }) {
    if (sets.isEmpty) return 0.0;

    // Completion score (50% weight)
    final completionRate =
        calculateCompletionPercentage(sets, totalPlannedSets);
    final completionScore = completionRate * 0.5;

    // RPE adherence score (50% weight)
    int setsOnTarget = 0;
    for (final set in sets) {
      if (set.isOnTarget(targetRPEMin, targetRPEMax)) {
        setsOnTarget++;
      }
    }
    final adherenceRate = (setsOnTarget / sets.length) * 100;
    final adherenceScore = adherenceRate * 0.5;

    return completionScore + adherenceScore;
  }

  // ==========================================
  // WEIGHT CONVERSIONS
  // ==========================================

  /// Convert all volumes to specified unit
  static double convertVolume(double volume, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return volume;

    if (fromUnit == 'kg' && toUnit == 'lbs') {
      return volume * 2.20462;
    } else if (fromUnit == 'lbs' && toUnit == 'kg') {
      return volume / 2.20462;
    }

    return volume;
  }
}

/// Summary statistics for a single exercise
class ExerciseSummary {
  final String exerciseName;
  final int totalSets;
  final int totalReps;
  final double totalVolume;
  final double averageRPE;
  final double best1RM;
  final LoggedSet heaviestSet;

  const ExerciseSummary({
    required this.exerciseName,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.averageRPE,
    required this.best1RM,
    required this.heaviestSet,
  });

  @override
  String toString() {
    return 'ExerciseSummary($exerciseName: $totalSets sets, '
        'volume: ${totalVolume.toStringAsFixed(1)}, '
        'avg RPE: ${averageRPE.toStringAsFixed(1)})';
  }
}
