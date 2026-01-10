// lib/core/enums/time_range.dart

/// Enum representing different time ranges for analytics and data filtering
enum TimeRange {
  week,
  month,
  quarter,
  year,
  all;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case TimeRange.week:
        return 'Week';
      case TimeRange.month:
        return 'Month';
      case TimeRange.quarter:
        return '3 Months';
      case TimeRange.year:
        return 'Year';
      case TimeRange.all:
        return 'All Time';
    }
  }

  /// Short name for compact UI elements
  String get shortName {
    switch (this) {
      case TimeRange.week:
        return '7D';
      case TimeRange.month:
        return '30D';
      case TimeRange.quarter:
        return '90D';
      case TimeRange.year:
        return '1Y';
      case TimeRange.all:
        return 'All';
    }
  }

  /// Number of days in this range
  int get days {
    switch (this) {
      case TimeRange.week:
        return 7;
      case TimeRange.month:
        return 30;
      case TimeRange.quarter:
        return 90;
      case TimeRange.year:
        return 365;
      case TimeRange.all:
        return 9999; // Effectively unlimited
    }
  }

  /// Get start date for this range
  DateTime get startDate {
    final now = DateTime.now();
    if (this == TimeRange.all) {
      return DateTime(2020, 1, 1); // Arbitrary old date
    }
    return now.subtract(Duration(days: days));
  }

  /// Get end date (always now)
  DateTime get endDate => DateTime.now();

  /// Description for tooltips/help text
  String get description {
    switch (this) {
      case TimeRange.week:
        return 'Last 7 days of training data';
      case TimeRange.month:
        return 'Last 30 days of training data';
      case TimeRange.quarter:
        return 'Last 90 days of training data';
      case TimeRange.year:
        return 'Last 365 days of training data';
      case TimeRange.all:
        return 'All available training data';
    }
  }

  /// Icon representation
  String get iconName {
    switch (this) {
      case TimeRange.week:
        return 'calendar_view_week';
      case TimeRange.month:
        return 'calendar_view_month';
      case TimeRange.quarter:
        return 'date_range';
      case TimeRange.year:
        return 'calendar_today';
      case TimeRange.all:
        return 'all_inclusive';
    }
  }

  /// Convert from string (for storage/API)
  static TimeRange fromString(String value) {
    return TimeRange.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TimeRange.month,
    );
  }

  /// Get appropriate data point interval for charting
  String get dataPointInterval {
    switch (this) {
      case TimeRange.week:
        return 'daily';
      case TimeRange.month:
        return 'daily';
      case TimeRange.quarter:
        return 'weekly';
      case TimeRange.year:
        return 'monthly';
      case TimeRange.all:
        return 'monthly';
    }
  }

  /// Recommended number of data points to show
  int get recommendedDataPoints {
    switch (this) {
      case TimeRange.week:
        return 7;
      case TimeRange.month:
        return 30;
      case TimeRange.quarter:
        return 12; // Weekly points
      case TimeRange.year:
        return 12; // Monthly points
      case TimeRange.all:
        return 24; // Bi-monthly or monthly
    }
  }
}
