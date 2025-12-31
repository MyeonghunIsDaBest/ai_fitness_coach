/// Enum representing different sports/training focuses available in the app
enum Sport {
  powerlifting,
  bodybuilding,
  olympicLifting,
  crossfit,
  generalFitness;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case Sport.powerlifting:
        return 'Powerlifting';
      case Sport.bodybuilding:
        return 'Bodybuilding';
      case Sport.olympicLifting:
        return 'Olympic Lifting';
      case Sport.crossfit:
        return 'CrossFit';
      case Sport.generalFitness:
        return 'General Fitness';
    }
  }

  /// Description for each sport
  String get description {
    switch (this) {
      case Sport.powerlifting:
        return 'Build raw strength';
      case Sport.bodybuilding:
        return 'Sculpt your physique';
      case Sport.olympicLifting:
        return 'Master technique';
      case Sport.crossfit:
        return 'All-around fitness';
      case Sport.generalFitness:
        return 'Stay healthy & strong';
    }
  }

  /// Primary color associated with the sport
  int get colorValue {
    switch (this) {
      case Sport.powerlifting:
        return 0xFFFF6B6B;
      case Sport.bodybuilding:
        return 0xFF4ECDC4;
      case Sport.olympicLifting:
        return 0xFFFFE66D;
      case Sport.crossfit:
        return 0xFF95E1D3;
      case Sport.generalFitness:
        return 0xFFB4F04D;
    }
  }

  /// Convert from string (for storage/API)
  static Sport fromString(String value) {
    return Sport.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Sport.generalFitness,
    );
  }
}
