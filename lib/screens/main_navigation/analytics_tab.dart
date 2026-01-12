import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Analytics tab - Visualize progress and training stats
class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({Key? key}) : super(key: key);

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  String _selectedTimeRange = '4W';
  String _selectedMetric = 'volume';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildTimeRangeSelector(),
                  const SizedBox(height: 24),
                  _buildMetricSelector(),
                  const SizedBox(height: 24),
                  _buildMainChart(),
                  const SizedBox(height: 24),
                  _buildProgressCards(),
                  const SizedBox(height: 24),
                  _buildExerciseProgress(),
                  const SizedBox(height: 24),
                  _buildRPETrends(),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      title: const Text(
        'Analytics',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Share analytics - Coming soon'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          tooltip: 'Share',
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    final ranges = ['1W', '4W', '3M', '6M', '1Y', 'ALL'];

    return Row(
      children: ranges.map((range) {
        final isSelected = _selectedTimeRange == range;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeRange = range;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB4F04D)
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                range,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.black : Colors.white60,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricSelector() {
    final metrics = [
      {'key': 'volume', 'label': 'Volume', 'icon': Icons.fitness_center},
      {'key': 'rpe', 'label': 'RPE', 'icon': Icons.speed},
      {'key': 'strength', 'label': 'Strength', 'icon': Icons.trending_up},
    ];

    return Row(
      children: metrics.map((metric) {
        final isSelected = _selectedMetric == metric['key'];
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedMetric = metric['key'] as String;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB4F04D).withOpacity(0.2)
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFB4F04D) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    metric['icon'] as IconData,
                    color:
                        isSelected ? const Color(0xFFB4F04D) : Colors.white60,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.white60,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMainChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getChartTitle(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _getChartValue(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB4F04D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(_buildLineChartData()),
            ),
          ],
        ),
      ),
    );
  }

  String _getChartTitle() {
    switch (_selectedMetric) {
      case 'volume':
        return 'Total Volume';
      case 'rpe':
        return 'Average RPE';
      case 'strength':
        return 'Estimated 1RM';
      default:
        return 'Metric';
    }
  }

  String _getChartValue() {
    switch (_selectedMetric) {
      case 'volume':
        return '48,250 kg';
      case 'rpe':
        return '7.8';
      case 'strength':
        return '+12%';
      default:
        return 'N/A';
    }
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Colors.white60,
                fontSize: 12,
              );
              final weeks = ['W1', 'W2', 'W3', 'W4'];
              if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(weeks[value.toInt()], style: style),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
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
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 3,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: _getChartSpots(),
          isCurved: true,
          color: const Color(0xFFB4F04D),
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: const Color(0xFFB4F04D),
                strokeWidth: 2,
                strokeColor: const Color(0xFF1E1E1E),
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFFB4F04D).withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getChartSpots() {
    switch (_selectedMetric) {
      case 'volume':
        return [
          const FlSpot(0, 6.5),
          const FlSpot(1, 7.2),
          const FlSpot(2, 7.8),
          const FlSpot(3, 8.5),
        ];
      case 'rpe':
        return [
          const FlSpot(0, 7.0),
          const FlSpot(1, 7.5),
          const FlSpot(2, 7.8),
          const FlSpot(3, 8.0),
        ];
      default:
        return [
          const FlSpot(0, 5),
          const FlSpot(1, 6),
          const FlSpot(2, 7),
          const FlSpot(3, 8),
        ];
    }
  }

  Widget _buildProgressCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildProgressCard(
                'Workouts',
                '12',
                '+3 this week',
                Icons.check_circle_outline,
                Colors.green,
                0.75,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProgressCard(
                'Consistency',
                '85%',
                '↑ 5%',
                Icons.calendar_today,
                Colors.blue,
                0.85,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    double progress,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Lifts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _buildExerciseCard('Squat', '140 kg', '+5 kg', 0.85),
        const SizedBox(height: 8),
        _buildExerciseCard('Bench Press', '100 kg', '+2.5 kg', 0.70),
        const SizedBox(height: 8),
        _buildExerciseCard('Deadlift', '180 kg', '+7.5 kg', 0.92),
      ],
    );
  }

  Widget _buildExerciseCard(
    String exercise,
    String weight,
    String improvement,
    double progress,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  exercise,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      weight,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB4F04D),
                      ),
                    ),
                    Text(
                      improvement,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFB4F04D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRPETrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RPE Trends',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRPEBar('Upper Body', 7.5, 8.0),
                const SizedBox(height: 16),
                _buildRPEBar('Lower Body', 8.2, 8.5),
                const SizedBox(height: 16),
                _buildRPEBar('Accessories', 7.0, 7.5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRPEBar(String label, double actual, double target) {
    final percentage = (actual / 10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              '${actual.toStringAsFixed(1)} / ${target.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: _getRPEColor(actual),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getRPEColor(double rpe) {
    if (rpe >= 9.0) return Colors.red;
    if (rpe >= 8.0) return Colors.orange;
    if (rpe >= 7.0) return const Color(0xFFB4F04D);
    return Colors.green;
  }
}
