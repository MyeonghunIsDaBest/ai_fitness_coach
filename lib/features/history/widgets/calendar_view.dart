// lib/features/history/widgets/calendar_view.dart

import 'package:flutter/material.dart';
import '../../../domain/repositories/training_repository.dart';

/// Calendar widget showing workout frequency and activity
/// Color-coded by RPE for quick visual feedback
class CalendarView extends StatefulWidget {
  final List<WorkoutSession> sessions;
  final Function(DateTime)? onDayTapped;
  final DateTime? selectedDate;

  const CalendarView({
    Key? key,
    required this.sessions,
    this.onDayTapped,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMonthHeader(),
        const SizedBox(height: 16),
        _buildWeekdayLabels(),
        const SizedBox(height: 8),
        _buildCalendarGrid(),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
        ),
        Text(
          _formatMonthYear(_currentMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentMonth.month == DateTime.now().month &&
                  _currentMonth.year == DateTime.now().year
              ? null
              : () {
                  setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month + 1,
                    );
                  });
                },
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final List<Widget> dayWidgets = [];

    // Add empty cells for days before month starts
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Add cells for each day in month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final sessionsOnDay = _getSessionsForDate(date);
    final isToday = _isToday(date);
    final isSelected =
        widget.selectedDate != null && _isSameDay(date, widget.selectedDate!);
    final isFuture = date.isAfter(DateTime.now());

    // Calculate average RPE for the day
    double? avgRPE;
    if (sessionsOnDay.isNotEmpty) {
      avgRPE = sessionsOnDay.fold<double>(
            0.0,
            (sum, session) => sum + session.averageRPE,
          ) /
          sessionsOnDay.length;
    }

    return GestureDetector(
      onTap: isFuture ? null : () => widget.onDayTapped?.call(date),
      child: Container(
        decoration: BoxDecoration(
          color: _getDayColor(avgRPE, isToday, isSelected, isFuture),
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(color: const Color(0xFFB4F04D), width: 2)
              : isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
        ),
        child: Stack(
          children: [
            // Day number
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color:
                        isFuture ? Colors.white.withOpacity(0.3) : Colors.white,
                  ),
                ),
              ),
            ),

            // Workout indicator
            if (sessionsOnDay.isNotEmpty && !isFuture)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      sessionsOnDay.length.clamp(0, 3),
                      (index) => Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RPE Intensity',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Low', Colors.blue, '6-7'),
              _buildLegendItem('Moderate', Colors.green, '7-8'),
              _buildLegendItem('High', const Color(0xFFB4F04D), '8-9'),
              _buildLegendItem('Max', Colors.orange, '9-10'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 9,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  // Helper methods
  List<WorkoutSession> _getSessionsForDate(DateTime date) {
    return widget.sessions.where((session) {
      return _isSameDay(session.startTime, date);
    }).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  Color _getDayColor(
      double? avgRPE, bool isToday, bool isSelected, bool isFuture) {
    if (isFuture) {
      return Colors.white.withOpacity(0.02);
    }

    if (isSelected) {
      return const Color(0xFFB4F04D).withOpacity(0.3);
    }

    if (avgRPE == null) {
      return isToday
          ? Colors.white.withOpacity(0.1)
          : Colors.white.withOpacity(0.05);
    }

    // Color code by RPE
    Color baseColor;
    if (avgRPE <= 7.0) {
      baseColor = Colors.blue;
    } else if (avgRPE <= 8.0) {
      baseColor = Colors.green;
    } else if (avgRPE <= 9.0) {
      baseColor = const Color(0xFFB4F04D);
    } else {
      baseColor = Colors.orange;
    }

    return baseColor.withOpacity(0.3);
  }

  String _formatMonthYear(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${monthNames[date.month - 1]} ${date.year}';
  }
}

/// Compact calendar view for smaller spaces
class CompactCalendarView extends StatelessWidget {
  final List<WorkoutSession> sessions;
  final int daysToShow;

  const CompactCalendarView({
    Key? key,
    required this.sessions,
    this.daysToShow = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(
      daysToShow,
      (index) => now.subtract(Duration(days: daysToShow - 1 - index)),
    );

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final sessionsOnDay = sessions.where((s) {
            return s.startTime.year == date.year &&
                s.startTime.month == date.month &&
                s.startTime.day == date.day;
          }).toList();

          double? avgRPE;
          if (sessionsOnDay.isNotEmpty) {
            avgRPE = sessionsOnDay.fold<double>(
                  0.0,
                  (sum, s) => sum + s.averageRPE,
                ) /
                sessionsOnDay.length;
          }

          return Container(
            width: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _getColor(avgRPE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getDayName(date),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (sessionsOnDay.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getColor(double? avgRPE) {
    if (avgRPE == null) {
      return Colors.white.withOpacity(0.05);
    }

    if (avgRPE <= 7.0) return Colors.blue.withOpacity(0.3);
    if (avgRPE <= 8.0) return Colors.green.withOpacity(0.3);
    if (avgRPE <= 9.0) return const Color(0xFFB4F04D).withOpacity(0.3);
    return Colors.orange.withOpacity(0.3);
  }

  String _getDayName(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }
}
