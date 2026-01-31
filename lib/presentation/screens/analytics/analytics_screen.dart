import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Semi-dark theme colors
const _backgroundColor = Color(0xFF0F172A);
const _cardColor = Color(0xFF1E293B);
const _cardBorder = Color(0xFF334155);
const _accentBlue = Color(0xFF3B82F6);
const _accentGreen = Color(0xFFB4F04D);
const _accentCyan = Color(0xFF00D9FF);
const _textPrimary = Color(0xFFE2E8F0);
const _textSecondary = Color(0xFF94A3B8);

/// AnalyticsScreen - RPE trends, exercise stats, and workout analytics
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String _selectedTimeRange = 'Month';
  final List<String> _timeRanges = ['Week', 'Month', '3 Months', 'Year'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Analytics',
          style: textTheme.titleLarge?.copyWith(
            color: _textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: _textPrimary),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh analytics data
        },
        color: _accentBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeRangeSelector(),
              _buildOverviewStats(textTheme),
              _buildRPEChart(textTheme),
              _buildExerciseBreakdown(textTheme),
              _buildRecentPRs(textTheme),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 52,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: _timeRanges.map((range) {
          final isSelected = range == _selectedTimeRange;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTimeRange = range),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(colors: [_accentBlue, Color(0xFF8B5CF6)])
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    range,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : _textSecondary,
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

  Widget _buildOverviewStats(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: textTheme.titleMedium?.copyWith(
              color: _textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.fitness_center,
                  value: '24',
                  label: 'Workouts',
                  color: _accentBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.format_list_numbered,
                  value: '312',
                  label: 'Total Sets',
                  color: _accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.speed,
                  value: '7.2',
                  label: 'Avg RPE',
                  color: _accentCyan,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.monitor_weight_outlined,
                  value: '48.5k',
                  label: 'Volume (kg)',
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRPEChart(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RPE Trend',
                  style: textTheme.titleMedium?.copyWith(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, size: 14, color: _accentGreen),
                      const SizedBox(width: 4),
                      Text(
                        '+0.3',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _accentGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Simplified chart visualization
            SizedBox(
              height: 180,
              child: CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _RPEChartPainter(),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChartLegend(color: _accentBlue, label: 'Average RPE'),
                const SizedBox(width: 24),
                _ChartLegend(color: _accentGreen.withOpacity(0.5), label: 'Target Zone'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseBreakdown(TextTheme textTheme) {
    final exercises = [
      _ExerciseData('Squat', 48, 7.5, _accentBlue),
      _ExerciseData('Bench Press', 42, 7.2, const Color(0xFF8B5CF6)),
      _ExerciseData('Deadlift', 36, 8.1, const Color(0xFFEF4444)),
      _ExerciseData('Overhead Press', 28, 6.8, _accentGreen),
      _ExerciseData('Barbell Row', 24, 7.0, _accentCyan),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise Breakdown',
            style: textTheme.titleMedium?.copyWith(
              color: _textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: exercises.map((exercise) {
                return _ExerciseRow(exercise: exercise);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPRs(TextTheme textTheme) {
    final prs = [
      _PRData('Squat', '140 kg', '3 days ago', Icons.trending_up),
      _PRData('Bench Press', '100 kg', '1 week ago', Icons.trending_up),
      _PRData('Deadlift', '180 kg', '2 weeks ago', Icons.trending_up),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent PRs',
            style: textTheme.titleMedium?.copyWith(
              color: _textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...prs.map((pr) => _PRCard(pr: pr)),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: _accentBlue),
              title: const Text('Custom Date Range', style: TextStyle(color: _textPrimary)),
              trailing: const Icon(Icons.chevron_right, color: _textSecondary),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show date picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: _accentBlue),
              title: const Text('Select Exercises', style: TextStyle(color: _textPrimary)),
              trailing: const Icon(Icons.chevron_right, color: _textSecondary),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show exercise picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_gymnastics, color: _accentBlue),
              title: const Text('Filter by Sport', style: TextStyle(color: _textPrimary)),
              trailing: const Icon(Icons.chevron_right, color: _textSecondary),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: _textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
      ],
    );
  }
}

class _ExerciseData {
  final String name;
  final int sets;
  final double avgRPE;
  final Color color;

  _ExerciseData(this.name, this.sets, this.avgRPE, this.color);
}

class _ExerciseRow extends StatelessWidget {
  final _ExerciseData exercise;

  const _ExerciseRow({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: exercise.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              exercise.name,
              style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '${exercise.sets} sets',
            style: const TextStyle(fontSize: 13, color: _textSecondary),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: exercise.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              exercise.avgRPE.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: exercise.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PRData {
  final String exercise;
  final String weight;
  final String date;
  final IconData icon;

  _PRData(this.exercise, this.weight, this.date, this.icon);
}

class _PRCard extends StatelessWidget {
  final _PRData pr;

  const _PRCard({required this.pr});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pr.exercise,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  pr.date,
                  style: const TextStyle(fontSize: 12, color: _textSecondary),
                ),
              ],
            ),
          ),
          Text(
            pr.weight,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _RPEChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _accentBlue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw target zone (7-8 RPE)
    final zonePaint = Paint()
      ..color = _accentGreen.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final zoneTop = size.height * 0.3;
    final zoneBottom = size.height * 0.5;
    canvas.drawRect(
      Rect.fromLTRB(0, zoneTop, size.width, zoneBottom),
      zonePaint,
    );

    // Draw grid lines
    final gridPaint = Paint()
      ..color = _cardBorder.withOpacity(0.5)
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw sample RPE line
    final path = Path();
    final points = [
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.15, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.35),
      Offset(size.width, size.height * 0.25),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = _accentBlue
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
