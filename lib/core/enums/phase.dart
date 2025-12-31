/// Enum representing different training phases in a periodized program
enum Phase {
  hypertrophy,
  strength,
  power,
  peaking,
  deload,
  maintenance;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case Phase.hypertrophy:
        return 'Hypertrophy';
      case Phase.strength:
        return 'Strength';
      case Phase.power:
        return 'Power';
      case Phase.peaking:
        return 'Peaking';
      case Phase.deload:
        return 'Deload';
      case Phase.maintenance:
        return 'Maintenance';
    }
  }

  /// Description of the phase's purpose
  String get description {
    switch (this) {
      case Phase.hypertrophy:
        return 'Build muscle mass with higher volume';
      case Phase.strength:
        return 'Increase maximal strength with heavier loads';
      case Phase.power:
        return 'Develop explosive power and speed';
      case Phase.peaking:
        return 'Maximize strength for competition';
      case Phase.deload:
        return 'Active recovery and adaptation';
      case Phase.maintenance:
        return 'Maintain current fitness levels';
    }
  }

  /// Typical rep range for this phase
  String get repRange {
    switch (this) {
      case Phase.hypertrophy:
        return '8-12 reps';
      case Phase.strength:
        return '3-6 reps';
      case Phase.power:
        return '1-5 reps (explosive)';
      case Phase.peaking:
        return '1-3 reps';
      case Phase.deload:
        return '6-10 reps (reduced intensity)';
      case Phase.maintenance:
        return '6-10 reps';
    }
  }

  /// Typical intensity percentage for this phase
  String get intensityRange {
    switch (this) {
      case Phase.hypertrophy:
        return '65-80% 1RM';
      case Phase.strength:
        return '80-90% 1RM';
      case Phase.power:
        return '70-85% 1RM';
      case Phase.peaking:
        return '90-100% 1RM';
      case Phase.deload:
        return '50-70% 1RM';
      case Phase.maintenance:
        return '70-80% 1RM';
    }
  }

  /// Duration recommendation in weeks
  int get typicalDurationWeeks {
    switch (this) {
      case Phase.hypertrophy:
        return 4;
      case Phase.strength:
        return 4;
      case Phase.power:
        return 3;
      case Phase.peaking:
        return 2;
      case Phase.deload:
        return 1;
      case Phase.maintenance:
        return 4;
    }
  }

  /// Color associated with the phase
  int get colorValue {
    switch (this) {
      case Phase.hypertrophy:
        return 0xFF4ECDC4;
      case Phase.strength:
        return 0xFFFF6B6B;
      case Phase.power:
        return 0xFFFFE66D;
      case Phase.peaking:
        return 0xFFB4F04D;
      case Phase.deload:
        return 0xFF95E1D3;
      case Phase.maintenance:
        return 0xFFAAAAAA;
    }
  }

  /// Convert from string
  static Phase fromString(String value) {
    return Phase.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Phase.hypertrophy,
    );
  }
}
