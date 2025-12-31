class RPEThresholds {
  // RPE Color Ranges
  static const double veryLight = 4.0;
  static const double light = 6.0;
  static const double moderate = 7.0;
  static const double hard = 8.0;
  static const double veryHard = 9.0;

  // Fatigue Detection
  static const double fatigueThreshold = 1.5;
  static const double recoveryIndicator = -1.0;

  // Session Quality
  static const double excellentSession = 0.5;
  static const double goodSession = 1.0;

  static Color getRPEColor(double rpe) {
    if (rpe <= veryLight) return Colors.blue;
    if (rpe <= light) return Colors.green;
    if (rpe <= moderate) return Color(0xFFB4F04D);
    if (rpe <= hard) return Colors.orange;
    return Colors.red;
  }

  static String getRPEDescription(double rpe) {
    if (rpe <= 2) return 'Very light - barely any effort';
    if (rpe <= 4) return 'Light - could do many more reps';
    if (rpe <= 6) return 'Moderate - 4+ reps in reserve';
    if (rpe <= 7) return 'Challenging - 2-3 reps in reserve';
    if (rpe <= 8) return 'Hard - 1-2 reps in reserve';
    if (rpe <= 9) return 'Very hard - 1 rep in reserve';
    return 'Maximum - couldn\'t do another rep';
  }
}
