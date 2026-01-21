// lib/features/analytics/exercise_breakdown_tab.dart

import 'package:flutter/material.dart';
import '../../domain/models/chart_data.dart';
import '../../services/rpe_analytics_service.dart';
import '../../core/enums/time_range.dart';
import 'widgets/rpe_bar_chart.dart';

class ExerciseBreakdownTab extends StatefulWidget {
  final RPEAnalyticsService analyticsService;

  const ExerciseBreakdownTab({
    Key? key,
    required this.analyticsService,
  }) : super(key: key);

  @override
  State<ExerciseBreakdownTab> createState() => _ExerciseBreakdownTabState();
}

class _ExerciseBreakdownTabState extends State<ExerciseBreakdownTab> {
  TimeRange _selectedTimeRange = TimeRange.month;
  List<ExerciseStats>? _exerciseStats;
  String? _selectedExercise;
  bool _isLoading = true;
  String _sortBy = 'rpe'; // 'rpe', 'volume', 'sets', 'name'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final stats = await widget.analyticsService.getExerciseStats(
        timeRange: _selectedTimeRange,
      );

      setState(() {
        _exerciseStats = _sortStats(stats);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  List<ExerciseStats> _sortStats(List<ExerciseStats> stats) {
    switch (_sortBy) {
      case 'rpe':
        return stats..sort((a, b) => b.averageRPE.compareTo(a.averageRPE));
      case 'volume':
        return stats
          ..sort((a, b) => (b.totalVolume ?? 0).compareTo(a.totalVolume ?? 0));
      case 'sets':
        return stats..sort((a, b) => b.totalSets.compareTo(a.totalSets));
      case 'name':
        return stats..sort((a, b) => a.exerciseName.compareTo(b.exerciseName));
      default:
        return stats;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildControls(),
        if (_isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFB4F04D)),
            ),
          )
        else if (_exerciseStats == null || _exerciseStats!.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No exercise data for this period',
                style: TextStyle(color: Colors.white60),
              ),
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildChart(),
                  _buildExerciseList(),
                ],
              ),
            ),
          ),
      ],
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
        children: [
          // Time range selector
          Row(
            children: [
              const Text(
                'Period:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: TimeRange.values.map((range) {
                      final isSelected = range == _selectedTimeRange;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(range.shortName),
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Sort options
          Row(
            children: [
              const Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSortChip('RPE', 'rpe'),
                      _buildSortChip('Volume', 'volume'),
                      _buildSortChip('Sets', 'sets'),
                      _buildSortChip('Name', 'name'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected && _exerciseStats != null) {
            setState(() {
              _sortBy = value;
              _exerciseStats = _sortStats(_exerciseStats!);
            });
          }
        },
        selectedColor: const Color(0xFF4ECDC4),
        backgroundColor: const Color(0xFF2A2A2A),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (_exerciseStats == null || _exerciseStats!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show top 10 exercises in chart
    final topExercises = _exerciseStats!.take(10).toList();

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
            'Top Exercises by RPE',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          RPEBarChart(
            stats: topExercises,
            targetRPEMin: 7.0,
            targetRPEMax: 8.5,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'All Exercises',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ..._exerciseStats!.map((stat) => _buildExerciseCard(stat)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseStats stat) {
    final isSelected = _selectedExercise == stat.exerciseName;

    return GestureDetector(
      onTap: () => _showExerciseDetail(stat),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? stat.color : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: stat.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            // Exercise info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.exerciseName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildInfoChip(
                        '${stat.totalSets} sets',
                        Icons.format_list_numbered,
                      ),
                      const SizedBox(width: 8),
                      if (stat.totalVolume != null)
                        _buildInfoChip(
                          stat.formattedVolume,
                          Icons.fitness_center,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // RPE value
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: stat.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: stat.color),
              ),
              child: Column(
                children: [
                  Text(
                    stat.formattedAvgRPE,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: stat.color,
                    ),
                  ),
                  const Text(
                    'RPE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white60),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetail(ExerciseStats stat) {
    setState(() {
      _selectedExercise = stat.exerciseName;
    });

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
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: stat.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    stat.exerciseName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Average RPE', stat.formattedAvgRPE, stat.color),
            _buildDetailRow('Total Sets', '${stat.totalSets}', Colors.white70),
            if (stat.totalVolume != null)
              _buildDetailRow(
                  'Total Volume', stat.formattedVolume, Colors.white70),
            if (stat.lastPerformed != null)
              _buildDetailRow(
                'Last Performed',
                '${stat.lastPerformed!.day}/${stat.lastPerformed!.month}/${stat.lastPerformed!.year}',
                Colors.white70,
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4F04D),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
