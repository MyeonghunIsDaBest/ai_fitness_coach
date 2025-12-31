/// Enum representing different types of lifts/exercises
enum LiftType {
  // Main Compound Lifts
  squat,
  benchPress,
  deadlift,
  overheadPress,

  // Olympic Lifts
  snatch,
  cleanAndJerk,
  clean,
  jerk,

  // Accessory Compound
  frontSquat,
  inclineBench,
  romanianDeadlift,
  bentOverRow,
  pullUp,
  dip,

  // Isolation
  bicepCurl,
  tricepExtension,
  lateralRaise,
  legCurl,
  legExtension,
  calfRaise,

  // Functional/CrossFit
  thruster,
  wallBall,
  boxJump,
  burpee,
  kettlebellSwing,

  // Cardio
  running,
  rowing,
  cycling,
  swimming,

  // Other
  other;

  /// Display name for UI
  String get displayName {
    switch (this) {
      // Main Compound
      case LiftType.squat:
        return 'Squat';
      case LiftType.benchPress:
        return 'Bench Press';
      case LiftType.deadlift:
        return 'Deadlift';
      case LiftType.overheadPress:
        return 'Overhead Press';

      // Olympic
      case LiftType.snatch:
        return 'Snatch';
      case LiftType.cleanAndJerk:
        return 'Clean & Jerk';
      case LiftType.clean:
        return 'Clean';
      case LiftType.jerk:
        return 'Jerk';

      // Accessory Compound
      case LiftType.frontSquat:
        return 'Front Squat';
      case LiftType.inclineBench:
        return 'Incline Bench Press';
      case LiftType.romanianDeadlift:
        return 'Romanian Deadlift';
      case LiftType.bentOverRow:
        return 'Bent Over Row';
      case LiftType.pullUp:
        return 'Pull-up';
      case LiftType.dip:
        return 'Dip';

      // Isolation
      case LiftType.bicepCurl:
        return 'Bicep Curl';
      case LiftType.tricepExtension:
        return 'Tricep Extension';
      case LiftType.lateralRaise:
        return 'Lateral Raise';
      case LiftType.legCurl:
        return 'Leg Curl';
      case LiftType.legExtension:
        return 'Leg Extension';
      case LiftType.calfRaise:
        return 'Calf Raise';

      // Functional
      case LiftType.thruster:
        return 'Thruster';
      case LiftType.wallBall:
        return 'Wall Ball';
      case LiftType.boxJump:
        return 'Box Jump';
      case LiftType.burpee:
        return 'Burpee';
      case LiftType.kettlebellSwing:
        return 'Kettlebell Swing';

      // Cardio
      case LiftType.running:
        return 'Running';
      case LiftType.rowing:
        return 'Rowing';
      case LiftType.cycling:
        return 'Cycling';
      case LiftType.swimming:
        return 'Swimming';

      case LiftType.other:
        return 'Other';
    }
  }

  /// Category of the lift
  LiftCategory get category {
    switch (this) {
      case LiftType.squat:
      case LiftType.benchPress:
      case LiftType.deadlift:
      case LiftType.overheadPress:
        return LiftCategory.mainCompound;

      case LiftType.snatch:
      case LiftType.cleanAndJerk:
      case LiftType.clean:
      case LiftType.jerk:
        return LiftCategory.olympic;

      case LiftType.frontSquat:
      case LiftType.inclineBench:
      case LiftType.romanianDeadlift:
      case LiftType.bentOverRow:
      case LiftType.pullUp:
      case LiftType.dip:
        return LiftCategory.accessoryCompound;

      case LiftType.bicepCurl:
      case LiftType.tricepExtension:
      case LiftType.lateralRaise:
      case LiftType.legCurl:
      case LiftType.legExtension:
      case LiftType.calfRaise:
        return LiftCategory.isolation;

      case LiftType.thruster:
      case LiftType.wallBall:
      case LiftType.boxJump:
      case LiftType.burpee:
      case LiftType.kettlebellSwing:
        return LiftCategory.functional;

      case LiftType.running:
      case LiftType.rowing:
      case LiftType.cycling:
      case LiftType.swimming:
        return LiftCategory.cardio;

      case LiftType.other:
        return LiftCategory.other;
    }
  }

  /// Primary muscle groups targeted
  List<MuscleGroup> get primaryMuscles {
    switch (this) {
      case LiftType.squat:
      case LiftType.frontSquat:
        return [MuscleGroup.quads, MuscleGroup.glutes];
      case LiftType.benchPress:
      case LiftType.inclineBench:
        return [MuscleGroup.chest, MuscleGroup.triceps];
      case LiftType.deadlift:
      case LiftType.romanianDeadlift:
        return [MuscleGroup.back, MuscleGroup.hamstrings, MuscleGroup.glutes];
      case LiftType.overheadPress:
        return [MuscleGroup.shoulders, MuscleGroup.triceps];
      case LiftType.pullUp:
      case LiftType.bentOverRow:
        return [MuscleGroup.back, MuscleGroup.biceps];
      case LiftType.bicepCurl:
        return [MuscleGroup.biceps];
      case LiftType.tricepExtension:
      case LiftType.dip:
        return [MuscleGroup.triceps];
      case LiftType.lateralRaise:
        return [MuscleGroup.shoulders];
      case LiftType.legCurl:
        return [MuscleGroup.hamstrings];
      case LiftType.legExtension:
        return [MuscleGroup.quads];
      case LiftType.calfRaise:
        return [MuscleGroup.calves];
      default:
        return [MuscleGroup.fullBody];
    }
  }

  /// Whether this is a barbell exercise
  bool get isBarbell {
    return [
      LiftType.squat,
      LiftType.benchPress,
      LiftType.deadlift,
      LiftType.overheadPress,
      LiftType.frontSquat,
      LiftType.inclineBench,
      LiftType.romanianDeadlift,
      LiftType.bentOverRow,
      LiftType.snatch,
      LiftType.cleanAndJerk,
      LiftType.clean,
    ].contains(this);
  }

  /// Convert from string
  static LiftType fromString(String value) {
    return LiftType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase().replaceAll(' ', ''),
      orElse: () => LiftType.other,
    );
  }
}

/// Categories for grouping lifts
enum LiftCategory {
  mainCompound,
  olympic,
  accessoryCompound,
  isolation,
  functional,
  cardio,
  other;

  String get displayName {
    switch (this) {
      case LiftCategory.mainCompound:
        return 'Main Lifts';
      case LiftCategory.olympic:
        return 'Olympic Lifts';
      case LiftCategory.accessoryCompound:
        return 'Accessory Compound';
      case LiftCategory.isolation:
        return 'Isolation';
      case LiftCategory.functional:
        return 'Functional';
      case LiftCategory.cardio:
        return 'Cardio';
      case LiftCategory.other:
        return 'Other';
    }
  }
}

/// Muscle groups for exercise classification
enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  quads,
  hamstrings,
  glutes,
  calves,
  core,
  fullBody;

  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.quads:
        return 'Quadriceps';
      case MuscleGroup.hamstrings:
        return 'Hamstrings';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.calves:
        return 'Calves';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }
}
