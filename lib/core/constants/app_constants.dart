/// Application-wide constants - Single source of truth
/// Consolidated from multiple files, organized by category
class AppConstants {
  // ==========================================
  // APP METADATA
  // ==========================================
  static const String appName = 'AI Fitness Coach';
  static const String appVersion = '1.0.0';
  static const String appBuild = '1';

  // ==========================================
  // HIVE BOX NAMES (Data Persistence)
  // ==========================================
  static const String workoutBoxName = 'workouts';
  static const String programBoxName = 'programs';
  static const String profileBoxName = 'profiles';
  static const String sessionBoxName = 'sessions';
  static const String settingsBoxName = 'settings';

  // ==========================================
  // RPE SYSTEM DEFAULTS
  // ==========================================
  static const double defaultTargetRPE = 8.0;
  static const double minValidRPE = 6.0;
  static const double maxValidRPE = 10.0;
  static const double defaultRPETolerance = 0.5;

  // RPE Thresholds for feedback
  static const double rpeVeryLight = 4.0;
  static const double rpeLight = 6.0;
  static const double rpeModerate = 7.0;
  static const double rpeHard = 8.0;
  static const double rpeVeryHard = 9.0;
  static const double rpeMaximal = 10.0;

  // ==========================================
  // WORKOUT LIMITS & DEFAULTS
  // ==========================================
  static const int maxSetsPerExercise = 12;
  static const int maxExercisesPerWorkout = 15;
  static const int maxWorkoutDurationMinutes = 180;
  static const int minRestSeconds = 30;
  static const int maxRestSeconds = 600;
  static const int defaultRestSeconds = 120;

  // ==========================================
  // PROGRAM CONSTRAINTS
  // ==========================================
  static const int minWeeksInProgram = 4;
  static const int maxWeeksInProgram = 52;
  static const int defaultProgramWeeks = 12;
  static const int deloadFrequencyWeeks = 4;
  static const int minWorkoutDaysPerWeek = 2;
  static const int maxWorkoutDaysPerWeek = 7;
  static const int defaultWorkoutDaysPerWeek = 4;

  // ==========================================
  // WEIGHT INCREMENTS (Progressive Overload)
  // ==========================================
  // Imperial (lbs)
  static const double smallWeightIncrementLbs = 2.5;
  static const double mediumWeightIncrementLbs = 5.0;
  static const double largeWeightIncrementLbs = 10.0;

  // Metric (kg)
  static const double smallWeightIncrementKg = 1.25;
  static const double mediumWeightIncrementKg = 2.5;
  static const double largeWeightIncrementKg = 5.0;

  // ==========================================
  // UI CONSTANTS (Design System)
  // ==========================================
  // Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration splashDuration = Duration(seconds: 2);

  // Spacing
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double tinyPadding = 4.0;

  // Sizes
  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double smallIconSize = 16.0;
  static const double defaultButtonHeight = 56.0;
  static const double compactButtonHeight = 48.0;

  // ==========================================
  // ANALYTICS & TRACKING
  // ==========================================
  static const int maxRecentSessions = 10;
  static const int maxHistoryDays = 90;
  static const int minSessionsForTrend = 3;
  static const int maxChartDataPoints = 100;
  static const int defaultHistoryLimit = 20;

  // ==========================================
  // API CONFIGURATION (Future Use)
  // ==========================================
  static const String apiBaseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // ==========================================
  // VALIDATION RULES
  // ==========================================
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxNotesLength = 500;
  static const int maxExerciseNameLength = 100;

  // ==========================================
  // FEATURE FLAGS
  // ==========================================
  static const bool enableAIChat = true;
  static const bool enableFormCheck = true;
  static const bool enableNutritionTracking = false;
  static const bool enableSocialFeatures = false;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = false;
  static const bool enableBetaFeatures = false;

  // ==========================================
  // TRAINING DEFAULTS
  // ==========================================
  static const double defaultBodyweightKg = 70.0;
  static const double defaultBodyweightLbs = 154.0;
  static const double minBodyweight = 30.0; // kg
  static const double maxBodyweight = 300.0; // kg

  // ==========================================
  // DATA LIMITS
  // ==========================================
  static const int maxCustomPrograms = 50;
  static const int maxWorkoutHistory = 1000;
  static const int maxNotifications = 100;
  static const int databaseVersion = 1;

  // ==========================================
  // HELPER METHODS
  // ==========================================

  /// Get weight increment based on current weight
  static double getWeightIncrement(double currentWeight, String unit) {
    if (unit.toLowerCase() == 'kg') {
      if (currentWeight < 60) return smallWeightIncrementKg;
      if (currentWeight < 100) return mediumWeightIncrementKg;
      return largeWeightIncrementKg;
    } else {
      if (currentWeight < 135) return smallWeightIncrementLbs;
      if (currentWeight < 225) return mediumWeightIncrementLbs;
      return largeWeightIncrementLbs;
    }
  }

  /// Get appropriate rest time based on exercise type
  static int getRestTime({required bool isMainLift, required int reps}) {
    if (isMainLift && reps <= 5) return 180; // Heavy compound
    if (isMainLift) return 150; // Moderate compound
    if (reps <= 8) return 120; // Accessory strength
    return 90; // Accessory hypertrophy
  }

  /// Check if a feature is enabled
  static bool isFeatureEnabled(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'ai_chat':
      case 'chat':
        return enableAIChat;
      case 'form_check':
      case 'formcheck':
        return enableFormCheck;
      case 'nutrition':
        return enableNutritionTracking;
      case 'social':
        return enableSocialFeatures;
      case 'offline':
        return enableOfflineMode;
      case 'analytics':
        return enableAnalytics;
      default:
        return false;
    }
  }

  /// Prevent instantiation
  AppConstants._();
}
