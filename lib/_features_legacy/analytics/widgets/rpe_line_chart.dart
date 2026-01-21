// lib/features/analytics/widgets/rpe_line_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../domain/models/chart_data.dart';
import '../../../core/enums/time_range.dart';

class RPELineChart extends StatelessWidget {
  final RPEChartData data;
  final Map<String, Color> exerciseColors;
  final double minY;
  final double maxY;

  const RPELineChart({
    Key? key,
    required this.data,
    required this.exerciseColors,
    this.minY = 6.0,
    this.maxY = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          _buildChartData(),
          swapAnimationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: _buildBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: _buildLeftTitles,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      minX: 0,
      maxX: _getMaxX(),
      minY: minY,
      maxY: maxY,
      lineBarsData: _buildLineBars(),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: const Color(0xFF2A2A2A),
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final exerciseName = data.exerciseNames[barSpot.barIndex];
              final date = _getDateForIndex(barSpot.x.toInt());
              return LineTooltipItem(
                '$exerciseName\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'RPE ${barSpot.y.toStringAsFixed(1)}\n',
                    style: TextStyle(
                      color: exerciseColors[exerciseName],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat('MMM d').format(date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  List<LineChartBarData> _buildLineBars() {
    final List<LineChartBarData> bars = [];

    data.seriesData.forEach((exerciseName, points) {
      if (points.isEmpty) return;

      final color = exerciseColors[exerciseName] ?? Colors.grey;
      final spots = <FlSpot>[];

      // Convert dates to X coordinates
      for (final point in points) {
        final xValue = _getXValueForDate(point.date);
        spots.add(FlSpot(xValue, point.rpe));
      }

      bars.add(LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 4,
              color: color,
              strokeWidth: 2,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.1),
        ),
      ));
    });

    return bars;
  }

  Widget _buildBottomTitles(double value, TitleMeta meta) {
    if (value == meta.max || value == meta.min) {
      return const SizedBox.shrink();
    }

    final date = _getDateForIndex(value.toInt());
    String text;

    switch (data.timeRange) {
      case TimeRange.week:
        text = DateFormat('E').format(date); // Mon, Tue, Wed
        break;
      case TimeRange.month:
        text = DateFormat('d').format(date); // 1, 2, 3, etc.
        break;
      case TimeRange.year:
        text = DateFormat('MMM').format(date); // Jan, Feb, Mar
        break;
      case TimeRange.all:
        text = DateFormat('MMM yy').format(date); // Jan 24
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildLeftTitles(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: const TextStyle(
        color: Colors.white60,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  double _getMaxX() {
    return data.allDates.length.toDouble() - 1;
  }

  double _getXValueForDate(DateTime date) {
    final index = data.allDates.indexWhere((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
    return index.toDouble();
  }

  DateTime _getDateForIndex(int index) {
    if (index >= 0 && index < data.allDates.length) {
      return data.allDates[index];
    }
    return DateTime.now();
  }
}
