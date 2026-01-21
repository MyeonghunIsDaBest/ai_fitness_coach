// lib/features/analytics/analytics_screen.dart

import 'package:flutter/material.dart';
import '../../domain/models/chart_data.dart';
import '../../services/rpe_analytics_service.dart';
import '../../core/enums/time_range.dart';
import 'widgets/rpe_line_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  final RPEAnalyticsService analyticsService;

  const AnalyticsScreen({
    Key? key,
    required this.analyticsService,
  }) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TimeRange _selectedTimeRange = TimeRange.month;
  RPEChartData? _chartData;
  List<ExerciseStats>? _exerciseStats;
  bool _isLoading = true;
  Set<String> _selectedExercises = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final chartData = await widget.analyticsService.getRPEChartData(
        timeRange: _selectedTimeRange,
        selectedExercises:
            _selectedExercises.isEmpty ? null : _selectedExercises.toList(),
      );

      final stats = await widget.analyticsService.getExerciseStats(
        timeRange: _selectedTimeRange,
      );

      // Initialize selected exercises if empty
      if (_selectedExercises.isEmpty && stats.isNotEmpty) {
        _selectedExercises = stats.take(5).map((s) => s.exerciseName).toSet();
        // Reload with selection
        return _loadData();
      }

      setState(() {
        _chartData = chartData;
        _exerciseStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('RPE Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFB4F04D)),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: const Color(0xFFB4F04D),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeRangeSelector(),
                    _buildChartSection(),
                    _buildLegendSection(),
                    _buildStatsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: TimeRange.values.map((range) {
          final isSelected = range == _selectedTimeRange;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTimeRange = range);
                _loadData();
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFB4F04D) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    range.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.white60,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartSection() {
    if (_chartData == null || _chartData!.seriesData.isEmpty) {
      return Container(
        height: 300,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No data available for this period',
            style: TextStyle(color: Colors.white60),
          ),
        ),
      );
    }

    // Build color map for exercises
    final colorMap = <String, Color>{};
    if (_exerciseStats != null) {
      for (final stat in _exerciseStats!) {
        colorMap[stat.exerciseName] = stat.color;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: RPELineChart(
        data: _chartData!,
        exerciseColors: colorMap,
      ),
    );
  }

  Widget _buildLegendSection() {
    if (_exerciseStats == null || _exerciseStats!.isEmpty) {
      return const SizedBox.shrink();
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
          const Text(
            'Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ..._exerciseStats!.map((stat) {
            final isSelected = _selectedExercises.contains(stat.exerciseName);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedExercises.remove(stat.exerciseName);
                  } else {
                    _selectedExercises.add(stat.exerciseName);
                  }
                });
                _loadData();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? stat.color.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isSelected ? stat.color : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: stat.color,
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        stat.exerciseName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${stat.totalSets} sets',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      stat.averageRPE.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: stat.color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    if (_chartData == null) return const SizedBox.shrink();

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
            'Period Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total Sessions', _calculateTotalSessions().toString()),
          _buildStatRow('Total Sets', _calculateTotalSets().toString()),
          _buildStatRow(
              'Average RPE', _calculateOverallAvgRPE().toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
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

  int _calculateTotalSessions() {
    if (_chartData == null) return 0;
    // Count unique dates
    return _chartData!.allDates.length;
  }

  int _calculateTotalSets() {
    if (_chartData == null) return 0;
    int total = 0;
    _chartData!.seriesData.values.forEach((points) {
      total += points.length;
    });
    return total;
  }

  double _calculateOverallAvgRPE() {
    if (_chartData == null) return 0.0;
    List<double> allRPEs = [];
    _chartData!.seriesData.values.forEach((points) {
      allRPEs.addAll(points.map((p) => p.rpe));
    });
    if (allRPEs.isEmpty) return 0.0;
    return allRPEs.reduce((a, b) => a + b) / allRPEs.length;
  }

  void _showFilterSheet() {
    // Show bottom sheet for additional filtering options
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading:
                  const Icon(Icons.calendar_today, color: Color(0xFFB4F04D)),
              title: const Text('Custom Date Range',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show date picker
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.fitness_center, color: Color(0xFFB4F04D)),
              title: const Text('Select Exercises',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(
                '${_selectedExercises.length} selected',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              onTap: () {
                Navigator.pop(context);
                // Already handled by legend tapping
              },
            ),
          ],
        ),
      ),
    );
  }
}
