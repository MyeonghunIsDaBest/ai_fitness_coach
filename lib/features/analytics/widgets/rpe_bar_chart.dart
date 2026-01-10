// lib/features/analytics/widgets/rpe_bar_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/models/chart_data.dart';

/// Bar chart showing RPE comparison across exercises
/// Perfect for seeing which exercises are hardest/easiest
class RPEBarChart extends StatelessWidget {
  final List<ExerciseStats> stats;
  final double targetRPEMin;
  final double targetRPEMax;
  final bool showTargetLine;

  const RPEBarChart({
    Key? key,
    required this.stats,
    required this.targetRPEMin,
    required this.targetRPEMax,
    this.showTargetLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No exercise data available',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          _buildBarChartData(),
          swapAnimationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  BarChartData _buildBarChartData() {
    final targetRPE = (targetRPEMin + targetRPEMax) / 2;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 10.0,
      minY: 6.0,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: const Color(0xFF2A2A2A),
          tooltipRoundedRadius: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final exercise = stats[groupIndex];
            return BarTooltipItem(
              '${exercise.exerciseName}\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: 'RPE: ${exercise.averageRPE.toStringAsFixed(1)}\n',
                  style: TextStyle(
                    color: exercise.color,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: '${exercise.totalSets} sets',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => _buildBottomTitles(value.toInt()),
            reservedSize: 60,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: _buildLeftTitles,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          // Highlight target RPE line
          if (showTargetLine && (value - targetRPE).abs() < 0.1) {
            return FlLine(
              color: const Color(0xFFB4F04D).withOpacity(0.5),
              strokeWidth: 2,
              dashArray: [5, 5],
            );
          }
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      barGroups: _buildBarGroups(),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return stats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stat.averageRPE,
            color: stat.color,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 10.0,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitles(int index) {
    if (index < 0 || index >= stats.length) {
      return const SizedBox.shrink();
    }

    final exercise = stats[index];
    final words = exercise.exerciseName.split(' ');

    // For exercises with multiple words, show first letter of each
    // For single words, try to abbreviate
    String label;
    if (words.length > 1) {
      label = words.map((w) => w[0].toUpperCase()).join('');
      if (label.length > 4) {
        label = label.substring(0, 4);
      }
    } else {
      final name = exercise.exerciseName;
      if (name.length <= 4) {
        label = name;
      } else {
        // Take first 4 letters
        label = name.substring(0, 4);
      }
    }

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: exercise.color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: exercise.color,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftTitles(double value, TitleMeta meta) {
    if (value == meta.max || value == meta.min) {
      return const SizedBox.shrink();
    }

    return Text(
      value.toInt().toString(),
      style: const TextStyle(
        color: Colors.white60,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}

/// Horizontal bar chart variant for showing RPE comparison
/// Better for long exercise names
class RPEHorizontalBarChart extends StatelessWidget {
  final List<ExerciseStats> stats;
  final double targetRPEMin;
  final double targetRPEMax;

  const RPEHorizontalBarChart({
    Key? key,
    required this.stats,
    required this.targetRPEMin,
    required this.targetRPEMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'No exercise data available',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          _buildHorizontalBarChartData(),
          swapAnimationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  BarChartData _buildHorizontalBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 10.0,
      minY: 6.0,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: const Color(0xFF2A2A2A),
          tooltipRoundedRadius: 8,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= stats.length) {
                return const SizedBox.shrink();
              }
              return Text(
                stats[index].exerciseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            },
            reservedSize: 100,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
      ),
      barGroups: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: stat.averageRPE,
              color: stat.color,
              width: 20,
            ),
          ],
        );
      }).toList(),
    );
  }
}
