import 'package:flutter/material.dart';

class RPEThresholds {
  // ==========================================
  // RPE COLOR RANGES
  // ==========================================
  static const double veryLight = 4.0;
  static const double light = 6.0;
  static const double moderate = 7.0;
  static const double hard = 8.0;
  static const double veryHard = 9.0;

  // ==========================================
  // FATIGUE DETECTION
  // ==========================================
  static const double fatigueThreshold = 1.5;
  static const double recoveryIndicator = -1.0;
  static const int fatigueSessionLimit = 2;

  // ==========================================
  // SESSION QUALITY
  // ==========================================
  static const double excellentSession = 0.5;
  static const double goodSession = 1.0;

  // ==========================================
  // VALIDATION
  // ==========================================
  static const double minValidRPE = 6.0;
  static const double maxValidRPE = 10.0;

  // ==========================================
  // COLOR MAPPING
  // ==========================================
  static Color getRPEColor(double rpe) {
    if (rpe <= veryLight) return Colors.blue;
    if (rpe <= light) return Colors.green;
    if (rpe <= moderate) return const Color(0xFFB4F04D);
    if (rpe <= hard) return Colors.orange;
    return Colors.red;
  }

  // ==========================================
  // RPE DESCRIPTIONS
  // ==========================================
  static String getRPEDescription(double rpe) {
    if (rpe <= 2) return 'Very light - barely any effort';
    if (rpe <= 4) return 'Light - could do many more reps';
    if (rpe <= 6) return 'Moderate - 4+ reps in reserve';
    if (rpe <= 7) return 'Challenging - 2-3 reps in reserve';
    if (rpe <= 8) return 'Hard - 1-2 reps in reserve';
    if (rpe <= 9) return 'Very hard - 1 rep in reserve';
    return 'Maximum - couldn\'t do another rep';
  }

  // ==========================================
  // VALIDATION METHODS
  // ==========================================

  /// Check if RPE value is valid (6-10 range)
  static bool isValidRPE(double rpe) {
    return rpe >= minValidRPE && rpe <= maxValidRPE;
  }

  /// Validate and clamp RPE to valid range
  static double clampRPE(double rpe) {
    return rpe.clamp(minValidRPE, maxValidRPE);
  }

  // ==========================================
  // LOAD ADJUSTMENT CALCULATIONS
  // ==========================================

  /// Calculate recommended load adjustment based on RPE delta
  /// Returns percentage adjustment (-0.1 to +0.1)
  static double getLoadAdjustment(double avgRPE, double targetRPE) {
    final delta = avgRPE - targetRPE;

    // Too hard - reduce load
    if (delta > 1.5) return -0.10; // Reduce 10%
    if (delta > 1.0) return -0.075; // Reduce 7.5%
    if (delta > 0.5) return -0.05; // Reduce 5%
    if (delta > 0.25) return -0.025; // Reduce 2.5%

    // On target - no change
    if (delta >= -0.25 && delta <= 0.25) return 0.0;

    // Too easy - increase load
    if (delta < -1.5) return 0.10; // Increase 10%
    if (delta < -1.0) return 0.075; // Increase 7.5%
    if (delta < -0.5) return 0.05; // Increase 5%
    if (delta < -0.25) return 0.025; // Increase 2.5%

    return 0.0;
  }

  /// Get load adjustment in pounds
  static double getLoadAdjustmentLbs(
      double currentWeight, double avgRPE, double targetRPE) {
    final percentage = getLoadAdjustment(avgRPE, targetRPE);
    return currentWeight * percentage;
  }

  /// Get load adjustment in kg
  static double getLoadAdjustmentKg(
      double currentWeight, double avgRPE, double targetRPE) {
    final percentage = getLoadAdjustment(avgRPE, targetRPE);
    return currentWeight * percentage;
  }

  // ==========================================
  // FEEDBACK MESSAGES
  // ==========================================

  /// Get coaching feedback based on RPE delta
  static String getFeedbackMessage(double avgRPE, double targetRPE) {
    final delta = avgRPE - targetRPE;

    if (delta > 1.5) {
      return 'RPE too high! Reduce weight significantly and prioritize recovery.';
    } else if (delta > 0.5) {
      return 'RPE above target. Consider reducing weight slightly next session.';
    } else if (delta >= -0.5 && delta <= 0.5) {
      return 'Perfect! RPE on target. Maintain current progression.';
    } else if (delta < -1.0) {
      return 'RPE well below target. Add weight next session for better stimulus.';
    } else {
      return 'RPE slightly below target. Consider small weight increase.';
    }
  }

  // ==========================================
  // INTENSITY ZONES
  // ==========================================

  /// Get intensity zone description
  static String getIntensityZone(double rpe) {
    if (rpe < 7.0) return 'Low Intensity';
    if (rpe < 8.0) return 'Moderate Intensity';
    if (rpe < 9.0) return 'High Intensity';
    return 'Maximum Intensity';
  }

  /// Check if in target RPE range
  static bool isInTargetRange(double rpe, double targetMin, double targetMax) {
    return rpe >= targetMin && rpe <= targetMax;
  }
}
