// lib/features/analytics/rpe_trends_tab.dart

import 'package:flutter/material.dart';
import '../../domain/models/chart_data.dart';
import '../../services/rpe_analytics_service.dart';
import '../../core/enums/time_range.dart';
import 'widgets/rpe_line_chart.dart';

/// Tab showing RPE trends over time with analysis and insights
/// Helps users understand if they're recovering, overtraining, etc.
class RPETrendsTab extends StatefulWidget {
  final RPEAnalyticsService analyticsService;

  const RPETrendsTab({
    Key? key,
    required this.analyticsService,
  }) : super(key: key);

  @override
  State<RPETrendsTab> createState() => _RPETrendsTabState();
}

class _RPETrendsTabState extends State<RPETrendsTab> {
  TimeRange _selectedTimeRange = TimeRange.month;
  String? _selectedExercise;
  RPEChartData? _chartData;
  List<ExerciseStats>? _exerciseStats;
  RPETrendAnalysis? _trendAnalysis;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Load chart data
      final chartData = await widget.analyticsService.getRPEChartData(
        timeRange: _selectedTimeRange,
        selectedExercises:
            _selectedExercise != null ? [_selectedExercise!] : null,
      );

      // Load exercise stats for selector
      final stats = await widget.analyticsService.getExerciseStats(
        timeRange: _selectedTimeRange,
      );

      // Load trend analysis if exercise selected
      RPETrendAnalysis? analysis;
      if (_selectedExercise != null) {
        analysis = await widget.analyticsService.analyzeTrend(
          exerciseName: _selectedExercise!,
          timeRange: _selectedTimeRange,
        );
      }

      setState(() {
        _chartData = chartData;
        _exerciseStats = stats;
        _trendAnalysis = analysis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFFB4F04D),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB4F04D)),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildControls(),
                  if (_chartData != null && !_chartData!.isEmpty) ...[
                    _buildChart(),
                    if (_trendAnalysis != null) _buildTrendAnalysis(),
                    _buildInsights(),
                  ] else
                    _buildEmptyState(),
                ],
              ),
            ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time range selector
          const Text(
            'Time Period',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TimeRange.values.map((range) {
                final isSelected = range == _selectedTimeRange;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(range.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedTimeRange = range);
                        _loadData();
                      }
                    },
                    selectedColor: const Color(0xFFB4F04D),
                    backgroundColor: const Color(0xFF2A2A2A),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Exercise selector
          const Text(
            'Exercise Focus',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedExercise,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text(
              'All Exercises',
              style: TextStyle(color: Colors.white60),
            ),
            dropdownColor: const Color(0xFF2A2A2A),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'All Exercises',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_exerciseStats != null)
                ..._exerciseStats!.map((stat) {
                  return DropdownMenuItem<String>(
                    value: stat.exerciseName,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: stat.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stat.exerciseName,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
            onChanged: (value) {
              setState(() => _selectedExercise = value);
              _loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final colorMap = <String, Color>{};
    if (_exerciseStats != null) {
      for (final stat in _exerciseStats!) {
        colorMap[stat.exerciseName] = stat.color;
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedExercise != null
                ? 'RPE Trend - $_selectedExercise'
                : 'Overall RPE Trend',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          RPELineChart(
            data: _chartData!,
            exerciseColors: colorMap,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis() {
    if (_trendAnalysis == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _trendAnalysis!.trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _trendAnalysis!.trendColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getTrendIcon(),
                color: _trendAnalysis!.trendColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _trendAnalysis!.trend,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _trendAnalysis!.trendColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _trendAnalysis!.interpretation,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon() {
    if (_trendAnalysis == null) return Icons.trending_flat;

    if (_trendAnalysis!.trend.toLowerCase().contains('increasing')) {
      return Icons.trending_up;
    } else if (_trendAnalysis!.trend.toLowerCase().contains('decreasing')) {
      return Icons.trending_down;
    }
    return Icons.trending_flat;
  }

  Widget _buildInsights() {
    if (_chartData == null || _chartData!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate overall stats
    final allRPEs = <double>[];
    _chartData!.seriesData.values.forEach((points) {
      allRPEs.addAll(points.map((p) => p.rpe));
    });

    if (allRPEs.isEmpty) return const SizedBox.shrink();

    final avgRPE = allRPEs.reduce((a, b) => a + b) / allRPEs.length;
    final minRPE = allRPEs.reduce((a, b) => a < b ? a : b);
    final maxRPE = allRPEs.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Period Insights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightRow('Average RPE', avgRPE.toStringAsFixed(1)),
          _buildInsightRow('Lowest RPE', minRPE.toStringAsFixed(1)),
          _buildInsightRow('Highest RPE', maxRPE.toStringAsFixed(1)),
          _buildInsightRow('Total Sets', allRPEs.length.toString()),
          const SizedBox(height: 12),
          _buildRecommendation(avgRPE),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB4F04D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(double avgRPE) {
    String title;
    String message;
    IconData icon;
    Color color;

    if (avgRPE < 7.0) {
      title = 'Room to Push Harder';
      message = 'Your average RPE is low. Consider increasing intensity.';
      icon = Icons.trending_up;
      color = Colors.blue;
    } else if (avgRPE <= 8.5) {
      title = 'Perfect Training Zone';
      message = 'You\'re training at an optimal intensity. Keep it up!';
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (avgRPE <= 9.0) {
      title = 'Watch Your Recovery';
      message = 'High average RPE. Ensure you\'re recovering adequately.';
      icon = Icons.warning;
      color = Colors.orange;
    } else {
      title = 'Consider a Deload';
      message = 'Very high average RPE. A deload week might be beneficial.';
      icon = Icons.error;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No RPE data for this period',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete some workouts to see trends',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
