// lib/services/rpe_analytics_service.dart

import 'package:flutter/material.dart';
import '../domain/repositories/training_repository.dart';
import '../domain/models/chart_data.dart';
import '../core/enums/time_range.dart';
import '../core/enums/lift_type.dart';

class RPEAnalyticsService {
  final TrainingRepository _repository;

  RPEAnalyticsService(this._repository);

  /// Get RPE chart data for a specific time range
  Future<RPEChartData> getRPEChartData({
    required TimeRange timeRange,
    List<String>? selectedExercises,
  }) async {
    // Calculate date range
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: timeRange.days));

    // Fetch sessions within date range
    final sessions = await _repository.getSessionsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );

    // Group data by exercise
    final Map<String, List<RPEDataPoint>> seriesData = {};

    for (final session in sessions) {
      for (final set in session.sets) {
        // Filter by selected exercises if provided
        if (selectedExercises != null &&
            !selectedExercises.contains(set.exerciseName)) {
          continue;
        }

        if (!seriesData.containsKey(set.exerciseName)) {
          seriesData[set.exerciseName] = [];
        }

        seriesData[set.exerciseName]!.add(RPEDataPoint(
          date: set.timestamp,
          rpe: set.rpe,
          exerciseName: set.exerciseName,
          setNumber: set.setNumber,
          weight: set.weight,
          reps: set.reps,
        ));
      }
    }

    // Sort data points by date
    seriesData.forEach((exercise, points) {
      points.sort((a, b) => a.date.compareTo(b.date));
    });

    return RPEChartData(
      seriesData: seriesData,
      timeRange: timeRange,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get exercise statistics for the legend
  Future<List<ExerciseStats>> getExerciseStats({
    required TimeRange timeRange,
  }) async {
    final chartData = await getRPEChartData(timeRange: timeRange);
    final List<ExerciseStats> stats = [];

    // Predefined colors for up to 8 exercises (like your image)
    final colors = [
      const Color(0xFFFF6B6B), // Red
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFFFFE66D), // Yellow
      const Color(0xFF95E1D3), // Light teal
      const Color(0xFFB4F04D), // Green
      const Color(0xFFFF9A9E), // Pink
      const Color(0xFF6C5CE7), // Purple
      const Color(0xFFFD79A8), // Rose
    ];

    int colorIndex = 0;
    chartData.seriesData.forEach((exerciseName, points) {
      if (points.isEmpty) return;

      final avgRPE =
          points.map((p) => p.rpe).reduce((a, b) => a + b) / points.length;

      stats.add(ExerciseStats(
        exerciseName: exerciseName,
        averageRPE: avgRPE,
        totalSets: points.length,
        color: colors[colorIndex % colors.length],
      ));

      colorIndex++;
    });

    // Sort by average RPE descending
    stats.sort((a, b) => b.averageRPE.compareTo(a.averageRPE));

    return stats;
  }

  /// Get RPE trend analysis
  Future<RPETrendAnalysis> analyzeTrend({
    required String exerciseName,
    required TimeRange timeRange,
  }) async {
    final chartData = await getRPEChartData(
      timeRange: timeRange,
      selectedExercises: [exerciseName],
    );

    final points = chartData.seriesData[exerciseName] ?? [];
    if (points.length < 3) {
      return RPETrendAnalysis(
        exerciseName: exerciseName,
        trend: 'Insufficient Data',
        slope: 0.0,
        interpretation: 'Need at least 3 data points',
        trendColor: const Color(0xFF9E9E9E), // Grey for insufficient data
      );
    }

    // Simple linear regression to find trend
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    final n = points.length;

    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += points[i].rpe;
      sumXY += i * points[i].rpe;
      sumX2 += i * i;
    }

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);

    String trend;
    String interpretation;

    if (slope > 0.3) {
      trend = 'Increasing';
      interpretation =
          'RPE is trending upward - you may be accumulating fatigue. Consider a deload soon.';
    } else if (slope < -0.3) {
      trend = 'Decreasing';
      interpretation =
          'RPE is trending downward - you\'re recovering well and getting stronger!';
    } else {
      trend = 'Stable';
      interpretation = 'RPE is stable - you\'re maintaining good consistency.';
    }

    // Determine trend color
    Color trendColor;
    if (slope > 0.3) {
      trendColor = const Color(0xFFFF6B6B); // Red for concerning
    } else if (slope < -0.3) {
      trendColor = const Color(0xFF4ECDC4); // Green for positive
    } else {
      trendColor = const Color(0xFFFFE66D); // Yellow for stable
    }

    return RPETrendAnalysis(
      exerciseName: exerciseName,
      trend: trend,
      slope: slope,
      interpretation: interpretation,
      trendColor: trendColor,
    );
  }

  /// Get muscle group RPE breakdown
  Future<Map<MuscleGroup, double>> getRPEByMuscleGroup({
    required TimeRange timeRange,
  }) async {
    final sessions = await _repository.getSessionsByDateRange(
      startDate: DateTime.now().subtract(Duration(days: timeRange.days)),
      endDate: DateTime.now(),
    );

    final Map<MuscleGroup, List<double>> muscleGroupRPEs = {};

    for (final session in sessions) {
      for (final set in session.sets) {
        // Get lift type from exercise name (simplified - you'd need better mapping)
        final liftType = LiftType.fromString(set.exerciseName);
        final muscleGroups = liftType.primaryMuscles;

        for (final muscle in muscleGroups) {
          if (!muscleGroupRPEs.containsKey(muscle)) {
            muscleGroupRPEs[muscle] = [];
          }
          muscleGroupRPEs[muscle]!.add(set.rpe);
        }
      }
    }

    // Calculate averages
    final Map<MuscleGroup, double> result = {};
    muscleGroupRPEs.forEach((muscle, rpes) {
      result[muscle] = rpes.reduce((a, b) => a + b) / rpes.length;
    });

    return result;
  }
}
