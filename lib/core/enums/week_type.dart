/// Enum representing different types of training weeks
enum WeekType {
  normal,
  deload,
  test,
  competition,
  recovery,
  taper;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case WeekType.normal:
        return 'Normal Training';
      case WeekType.deload:
        return 'Deload Week';
      case WeekType.test:
        return 'Testing Week';
      case WeekType.competition:
        return 'Competition Week';
      case WeekType.recovery:
        return 'Recovery Week';
      case WeekType.taper:
        return 'Taper Week';
    }
  }

  /// Description of the week type
  String get description {
    switch (this) {
      case WeekType.normal:
        return 'Regular training with full intensity and volume';
      case WeekType.deload:
        return 'Reduced volume and intensity for recovery';
      case WeekType.test:
        return 'Testing maximal strength and performance';
      case WeekType.competition:
        return 'Competition week - minimal training';
      case WeekType.recovery:
        return 'Active recovery and light movement';
      case WeekType.taper:
        return 'Gradual reduction preparing for peak performance';
    }
  }

  /// Intensity multiplier (1.0 = 100%)
  double get intensityMultiplier {
    switch (this) {
      case WeekType.normal:
        return 1.0;
      case WeekType.deload:
        return 0.6;
      case WeekType.test:
        return 1.0;
      case WeekType.competition:
        return 0.3;
      case WeekType.recovery:
        return 0.5;
      case WeekType.taper:
        return 0.7;
    }
  }

  /// Volume multiplier (1.0 = 100%)
  double get volumeMultiplier {
    switch (this) {
      case WeekType.normal:
        return 1.0;
      case WeekType.deload:
        return 0.5;
      case WeekType.test:
        return 0.4;
      case WeekType.competition:
        return 0.2;
      case WeekType.recovery:
        return 0.4;
      case WeekType.taper:
        return 0.6;
    }
  }

  /// Icon representation
  String get iconName {
    switch (this) {
      case WeekType.normal:
        return 'fitness_center';
      case WeekType.deload:
        return 'battery_charging_full';
      case WeekType.test:
        return 'assignment';
      case WeekType.competition:
        return 'emoji_events';
      case WeekType.recovery:
        return 'spa';
      case WeekType.taper:
        return 'trending_down';
    }
  }

  /// Color associated with the week type
  int get colorValue {
    switch (this) {
      case WeekType.normal:
        return 0xFFB4F04D;
      case WeekType.deload:
        return 0xFF4ECDC4;
      case WeekType.test:
        return 0xFFFFE66D;
      case WeekType.competition:
        return 0xFFFF6B6B;
      case WeekType.recovery:
        return 0xFF95E1D3;
      case WeekType.taper:
        return 0xFFFF9A9E;
    }
  }

  /// Whether this week type is considered "active training"
  bool get isActiveTraining {
    switch (this) {
      case WeekType.normal:
      case WeekType.test:
        return true;
      case WeekType.deload:
      case WeekType.competition:
      case WeekType.recovery:
      case WeekType.taper:
        return false;
    }
  }

  /// Recommended frequency (how often this should occur)
  String get frequency {
    switch (this) {
      case WeekType.normal:
        return 'Most weeks';
      case WeekType.deload:
        return 'Every 3-5 weeks';
      case WeekType.test:
        return 'Every 6-8 weeks';
      case WeekType.competition:
        return 'As scheduled';
      case WeekType.recovery:
        return 'As needed';
      case WeekType.taper:
        return '1-2 weeks before competition';
    }
  }

  /// Convert from string
  static WeekType fromString(String value) {
    return WeekType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => WeekType.normal,
    );
  }
}
