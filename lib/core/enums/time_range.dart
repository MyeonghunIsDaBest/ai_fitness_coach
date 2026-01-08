/// Enum representing time ranges for analytics and data filtering
enum TimeRange {
  week(7, 'Week', '1W'),
  twoWeeks(14, '2 Weeks', '2W'),
  month(30, 'Month', '1M'),
  threeMonths(90, '3 Months', '3M'),
  sixMonths(180, '6 Months', '6M'),
  year(365, 'Year', '1Y'),
  all(null, 'All Time', 'All');

  final int? days;
  final String displayName;
  final String shortName;

  const TimeRange(this.days, this.displayName, this.shortName);

  /// Get start date for this time range
  DateTime get startDate {
    if (days == null) {
      // For "All Time", return a date far in the past
      return DateTime(2020, 1, 1);
    }
    return DateTime.now().subtract(Duration(days: days!));
  }

  /// Get end date (always now)
  DateTime get endDate => DateTime.now();

  /// Get the date range as a formatted string
  String get dateRangeDisplay {
    final now = DateTime.now();
    final start = startDate;

    if (days == null) return 'All Time';

    if (days! <= 7) {
      return 'Last $days days';
    } else if (days! == 30) {
      return 'Last month';
    } else if (days! == 90) {
      return 'Last 3 months';
    } else if (days! == 365) {
      return 'Last year';
    }

    return displayName;
  }

  /// Check if this time range includes a given date
  bool includes(DateTime date) {
    if (days == null) return true; // All Time includes everything
    return date.isAfter(startDate) && date.isBefore(endDate);
  }

  /// Get recommended data point interval for charting
  /// (how often to show data points on a chart)
  Duration get dataInterval {
    switch (this) {
      case TimeRange.week:
      case TimeRange.twoWeeks:
        return const Duration(days: 1); // Daily
      case TimeRange.month:
        return const Duration(days: 2); // Every 2 days
      case TimeRange.threeMonths:
        return const Duration(days: 7); // Weekly
      case TimeRange.sixMonths:
        return const Duration(days: 14); // Bi-weekly
      case TimeRange.year:
        return const Duration(days: 30); // Monthly
      case TimeRange.all:
        return const Duration(days: 30); // Monthly
    }
  }

  /// Get number of expected data points for this range
  int get expectedDataPoints {
    if (days == null) return 50; // Reasonable default for "All Time"

    final intervalDays = dataInterval.inDays;
    return (days! / intervalDays).ceil();
  }

  /// Convert from string (for storage/API)
  static TimeRange fromString(String value) {
    return TimeRange.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TimeRange.month, // Default to month
    );
  }

  /// Get appropriate time range based on data span
  static TimeRange suggestForDateRange(DateTime start, DateTime end) {
    final daysDiff = end.difference(start).inDays;

    if (daysDiff <= 7) return TimeRange.week;
    if (daysDiff <= 14) return TimeRange.twoWeeks;
    if (daysDiff <= 30) return TimeRange.month;
    if (daysDiff <= 90) return TimeRange.threeMonths;
    if (daysDiff <= 180) return TimeRange.sixMonths;
    if (daysDiff <= 365) return TimeRange.year;
    return TimeRange.all;
  }

  /// Get all time ranges suitable for a given data span
  static List<TimeRange> availableRanges(DateTime earliestDate) {
    final daysSinceEarliest = DateTime.now().difference(earliestDate).inDays;

    return TimeRange.values.where((range) {
      if (range.days == null) return true; // Always show "All Time"
      return daysSinceEarliest >= range.days!;
    }).toList();
  }
}
