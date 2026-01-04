/// Application-wide constants
class AppConstants {
  // Hive box names
  static const String workoutBoxName = 'workouts';
  static const String programBoxName = 'programs';
  static const String profileBoxName = 'profiles';
  static const String sessionBoxName = 'sessions';

  // RPE defaults
  static const double defaultTargetRPE = 8.0;
  static const double minValidRPE = 6.0;
  static const double maxValidRPE = 10.0;

  // Workout limits
  static const int maxSetsPerExercise = 12;
  static const int maxWorkoutDurationMinutes = 180;

  // UI constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
}
