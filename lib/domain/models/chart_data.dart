// lib/domain/models/chart_data.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../core/enums/lift_type.dart';
import '../../core/enums/time_range.dart';

/// Main chart data container for RPE analytics
class RPEChartData extends Equatable {
  final Map<String, List<RPEDataPoint>>
      seriesData; // Exercise name -> data points
  final TimeRange timeRange;
  final DateTime startDate;
  final DateTime endDate;

  const RPEChartData({
    required this.seriesData,
    required this.timeRange,
    required this.startDate,
    required this.endDate,
  });

  /// Get all unique dates across all series
  List<DateTime> get allDates {
    final dates = <DateTime>{};
    seriesData.values.forEach((points) {
      dates.addAll(
          points.map((p) => DateTime(p.date.year, p.date.month, p.date.day)));
    });
    final sorted = dates.toList()..sort();
    return sorted;
  }

  /// Get exercise names for legend
  List<String> get exerciseNames => seriesData.keys.toList();

  /// Check if data is empty
  bool get isEmpty =>
      seriesData.isEmpty || seriesData.values.every((list) => list.isEmpty);

  @override
  List<Object?> get props => [seriesData, timeRange, startDate, endDate];
}

/// Individual data point for RPE tracking
class RPEDataPoint extends Equatable {
  final DateTime date;
  final double rpe;
  final String exerciseName;
  final int setNumber;
  final double? weight;
  final int? reps;
  final String? workoutId;

  const RPEDataPoint({
    required this.date,
    required this.rpe,
    required this.exerciseName,
    required this.setNumber,
    this.weight,
    this.reps,
    this.workoutId,
  });

  /// Format for display
  String get displayText => '${exerciseName}: RPE ${rpe.toStringAsFixed(1)}';

  /// Check if this is a valid data point
  bool get isValid => rpe >= 6.0 && rpe <= 10.0;

  @override
  List<Object?> get props => [date, rpe, exerciseName, setNumber, weight, reps];
}

/// Exercise statistics for legend display
class ExerciseStats extends Equatable {
  final String exerciseName;
  final double averageRPE;
  final int totalSets;
  final Color color;
  final double? totalVolume;
  final DateTime? lastPerformed;

  const ExerciseStats({
    required this.exerciseName,
    required this.averageRPE,
    required this.totalSets,
    required this.color,
    this.totalVolume,
    this.lastPerformed,
  });

  /// Format average RPE for display
  String get formattedAvgRPE => averageRPE.toStringAsFixed(1);

  /// Format total volume for display
  String get formattedVolume =>
      totalVolume != null ? '${totalVolume!.toStringAsFixed(0)}kg' : 'N/A';

  @override
  List<Object?> get props => [exerciseName, averageRPE, totalSets, totalVolume];
}

/// Trend analysis result
class RPETrendAnalysis extends Equatable {
  final String exerciseName;
  final String trend; // 'Increasing', 'Stable', 'Decreasing'
  final double slope;
  final String interpretation;
  final Color trendColor;

  const RPETrendAnalysis({
    required this.exerciseName,
    required this.trend,
    required this.slope,
    required this.interpretation,
    required this.trendColor,
  });

  /// Check if trend is concerning
  bool get isConcerning => trend == 'Increasing' && slope > 0.5;

  /// Check if trend is positive
  bool get isPositive => trend == 'Decreasing' || trend == 'Stable';

  @override
  List<Object?> get props => [exerciseName, trend, slope];
}

/// Comparison between two time periods
class RPEComparison extends Equatable {
  final double period1Avg;
  final double period2Avg;
  final double percentageChange;
  final String interpretation;
  final DateTime period1Start;
  final DateTime period1End;
  final DateTime period2Start;
  final DateTime period2End;

  const RPEComparison({
    required this.period1Avg,
    required this.period2Avg,
    required this.percentageChange,
    required this.interpretation,
    required this.period1Start,
    required this.period1End,
    required this.period2Start,
    required this.period2End,
  });

  /// Check if improvement occurred
  bool get isImprovement => period2Avg < period1Avg;

  /// Format percentage change for display
  String get formattedChange {
    final sign = percentageChange > 0 ? '+' : '';
    return '$sign${percentageChange.toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [
        period1Avg,
        period2Avg,
        percentageChange,
        period1Start,
        period2Start,
      ];
}

/// Muscle group breakdown data
class MuscleGroupData extends Equatable {
  final MuscleGroup muscleGroup;
  final double averageRPE;
  final int totalSets;
  final List<String> exercises;

  const MuscleGroupData({
    required this.muscleGroup,
    required this.averageRPE,
    required this.totalSets,
    required this.exercises,
  });

  /// Get color for this muscle group
  Color get color {
    switch (muscleGroup) {
      case MuscleGroup.chest:
        return const Color(0xFFFF6B6B);
      case MuscleGroup.back:
        return const Color(0xFF4ECDC4);
      case MuscleGroup.shoulders:
        return const Color(0xFFFFE66D);
      case MuscleGroup.biceps:
        return const Color(0xFF95E1D3);
      case MuscleGroup.triceps:
        return const Color(0xFFB4F04D);
      case MuscleGroup.quads:
        return const Color(0xFFFF9A9E);
      case MuscleGroup.hamstrings:
        return const Color(0xFF6C5CE7);
      case MuscleGroup.glutes:
        return const Color(0xFFFD79A8);
      case MuscleGroup.calves:
        return const Color(0xFFA29BFE);
      case MuscleGroup.core:
        return const Color(0xFFFAB1A0);
      case MuscleGroup.fullBody:
        return const Color(0xFF74B9FF);
    }
  }

  @override
  List<Object?> get props => [muscleGroup, averageRPE, totalSets];
}
