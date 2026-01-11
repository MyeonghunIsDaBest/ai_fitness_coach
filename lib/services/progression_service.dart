import '../domain/repositories/training_repository.dart';
import '../domain/models/logged_set.dart';
import '../core/utils/rpe_math.dart';

/// Service for managing progression and deload recommendations
class ProgressionService {
  final TrainingRepository _repository;

  ProgressionService(this._repository);

  /// Check if deload is needed based on RPE trends
  Future<bool> shouldDeload({
    required List<WorkoutSession> sessions,
    double targetRPEMax = 8.5,
  }) async {
    if (sessions.isEmpty) return false;

    final allRPEs = <double>[];
    for (final session in sessions) {
      allRPEs.addAll(session.sets.map((s) => s.rpe));
    }

    if (allRPEs.isEmpty) return false;

    final weekAvgRPE = RPEMath.calculateAverageRPE(allRPEs);

    if (RPEMath.isHighFatigue(weekAvgRPE, targetRPEMax)) {
      return true;
    }

    if (RPEMath.isRecovering(weekAvgRPE, 7.0)) {
      return false;
    }

    return false;
  }

  /// Calculate recommended weight adjustment
  Future<double> calculateWeightAdjustment({
    required double actualRPE,
    required double targetRPE,
    required double currentWeight,
  }) async {
    final rpeDifference = actualRPE - targetRPE;

    if (rpeDifference.abs() < 0.5) {
      return 0.0;
    }

    if (rpeDifference < -1.0) {
      return 0.025;
    } else if (rpeDifference < -0.5) {
      return 0.0125;
    }

    if (rpeDifference > 1.5) {
      return -0.05;
    } else if (rpeDifference > 1.0) {
      return -0.025;
    }

    return 0.0;
  }

  /// Analyze progression trend for an exercise
  Future<ProgressionTrend> analyzeExerciseProgression({
    required String exerciseId,
    required List<WorkoutSession> sessions,
  }) async {
    final exerciseSets = <LoggedSet>[];

    for (final session in sessions) {
      final sets = session.sets.where((s) => s.exerciseId == exerciseId);
      exerciseSets.addAll(sets);
    }

    if (exerciseSets.isEmpty) {
      return ProgressionTrend.noData;
    }

    final weights = exerciseSets.map((s) => s.weight).toList();
    final halfPoint = (exerciseSets.length / 2).floor();
    final recentWeights = exerciseSets.skip(halfPoint).map((s) => s.weight);
    final earlierWeights = exerciseSets.take(halfPoint).map((s) => s.weight);

    if (recentWeights.isEmpty || earlierWeights.isEmpty) {
      return ProgressionTrend.stable;
    }

    final recentAvg =
        recentWeights.reduce((a, b) => a + b) / recentWeights.length;
    final earlierAvg =
        earlierWeights.reduce((a, b) => a + b) / earlierWeights.length;

    final improvement = ((recentAvg - earlierAvg) / earlierAvg) * 100;

    if (improvement > 5) {
      return ProgressionTrend.improving;
    } else if (improvement < -5) {
      return ProgressionTrend.declining;
    } else {
      return ProgressionTrend.stable;
    }
  }

  /// Get progression recommendations
  Future<String> getProgressionRecommendation({
    required List<WorkoutSession> recentSessions,
    required double targetRPE,
  }) async {
    if (recentSessions.isEmpty) {
      return 'Complete more workouts to get recommendations';
    }

    final shouldDeloadNow = await shouldDeload(
      sessions: recentSessions,
      targetRPEMax: targetRPE + 0.5,
    );

    if (shouldDeloadNow) {
      return 'Consider taking a deload week. Your RPE has been consistently high.';
    }

    final allRPEs = <double>[];
    for (final session in recentSessions) {
      allRPEs.addAll(session.sets.map((s) => s.rpe));
    }

    if (allRPEs.isEmpty) {
      return 'No RPE data available';
    }

    final avgRPE = RPEMath.calculateAverageRPE(allRPEs);

    if (avgRPE < targetRPE - 1.0) {
      return 'You\'re recovering well. Consider increasing weights by 2.5-5%.';
    } else if (avgRPE > targetRPE + 1.0) {
      return 'Training is quite demanding. Maintain current weights or reduce slightly.';
    } else {
      return 'Good progress! Continue with current progression plan.';
    }
  }
}

enum ProgressionTrend {
  improving,
  stable,
  declining,
  noData,
}
