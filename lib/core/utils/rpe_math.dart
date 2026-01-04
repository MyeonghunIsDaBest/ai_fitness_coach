import 'dart:math' as math;
import '../enums/rpe_feedback.dart';
import '../constants/rpe_thresholds.dart';

/// Mathematical operations and calculations for RPE data
/// Handles averaging, session calculations, and feedback generation
class RPEMath {
  // ==========================================
  // BASIC CALCULATIONS
  // ==========================================

  /// Calculate average RPE from list of sets
  static double calculateAverageRPE(List<double> rpes) {
    if (rpes.isEmpty) return 0.0;
    
    // Filter out invalid RPEs
    final validRPEs = rpes.where((rpe) => RPEThresholds.isValidRPE(rpe)).toList();
    if (validRPEs.isEmpty) return 0.0;
    
    return validRPEs.reduce((a, b) => a + b) / validRPEs.length;
  }

  /// Calculate weighted average RPE (later sets weighted more heavily)
  static double calculateWeightedAverageRPE(List<double> rpes) {
    if (rpes.isEmpty) return 0.0;
    
    double weightedSum = 0.0;
    double totalWeight = 0.0;
    
    for (int i = 0; i < rpes.length; i++) {
      // Weight increases with set number (later sets matter more)
      final weight = 1.0 + (i * 0.2); // 1.0, 1.2, 1.4, 1.6...
      weightedSum += rpes[i] * weight;
      totalWeight += weight;
    }
    
    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }

  /// Calculate session RPE from exercise-level data
  static double calculateSessionRPE(Map<String, List<double>> exerciseRPEs) {
    if (exerciseRPEs.isEmpty) return 0.0;
    
    final List<double> allRPEs = [];
    exerciseRPEs.values.forEach((rpes) => allRPEs.addAll(rpes));
    
    return calculateAverageRPE(allRPEs);
  }

  /// Calculate weighted session RPE (compound lifts weighted more)
  static double calculateWeightedSessionRPE(
    Map<String, List<double>> exerciseRPEs,
    Map<String, bool> isCompound,
  ) {
    if (exerciseRPEs.isEmpty) return 0.0;
    
    double weightedSum = 0.0;
    double totalWeight = 0.0;
    
    exerciseRPEs.forEach((exercise, rpes) {
      if (rpes.isEmpty) return;
      
      final avgRPE = calculateAverageRPE(rpes);
      // Compound lifts get 1.5x weight, isolation gets 1.0x
      final weight = isCompound[exercise] == true ? 1.5 : 1.0;
      
      weightedSum += avgRPE * weight;
      totalWeight += weight;
    });
    
    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }

  // ==========================================
  // FEEDBACK GENERATION
  // ==========================================

  /// Determine RPE feedback based on target range
  static RPEFeedback getFeedback(
    double rpe,
    double targetMin,
    double targetMax,
  ) {
    // Validate inputs
    if (!RPEThresholds.isValidRPE(rpe)) {
      return RPEFeedback.onTarget; // Default fallback
    }
    
    final targetMid = (targetMin + targetMax) / 2;
    
    if (rpe < targetMin - 1.5) return RPEFeedback.tooEasy;
    if (rpe < targetMin) return RPEFeedback.belowTarget;
    if (rpe >= targetMin && rpe <= targetMax) return RPEFeedback.onTarget;
    if (rpe <= targetMax + 1.5) return RPEFeedback.aboveTarget;
    return RPEFeedback.tooHard;
  }

  /// Get feedback for entire session
  static RPEFeedback getSessionFeedback(
    double sessionRPE,
    double targetRPE,
  ) {
    return getFeedback(
      sessionRPE,
      targetRPE - 0.5,
      targetRPE + 0.5,
    );
  }

  // ==========================================
  // FATIGUE DETECTION
  // ==========================================

  /// Check if high fatigue is detected
  static bool isHighFatigue(double avgRPE, double targetRPE) {
    return avgRPE > targetRPE + RPEThresholds.fatigueThreshold;
  }

  /// Check if athlete is recovering well
  static bool isRecovering(double avgRPE, double targetRPE) {
    return avgRPE < targetRPE + RPEThresholds.recoveryIndicator;
  }

  /// Detect fatigue trend over multiple sessions
  static bool detectFatigueTrend(List<double> recentSessionRPEs, double targetRPE) {
    if (recentSessionRPEs.length < 3) return false;
    
    // Check if RPE is consistently high
    final highRPESessions = recentSessionRPEs
        .where((rpe) => rpe > targetRPE + RPEThresholds.fatigueThreshold)
        .length;
    
    return highRPESessions >= RPEThresholds.fatigueSessionLimit;
  }

  /// Calculate fatigue score (0-100, higher = more fatigued)
  static double calculateFatigueScore(
    List<double> recentSessionRPEs,
    double targetRPE,
  ) {
    if (recentSessionRPEs.isEmpty) return 0.0;
    
    double fatigueScore = 0.0;
    
    for (int i = 0; i < recentSessionRPEs.length; i++) {
      final rpe = recentSessionRPEs[i];
      final delta = rpe - targetRPE;
      
      if (delta > 0) {
        // Recent sessions weighted more heavily
        final recencyWeight = 1.0 + (i * 0.1);
        fatigueScore += delta * recencyWeight * 10;
      }
    }
    
    return fatigueScore.clamp(0.0, 100.0);
  }

  // ==========================================
  // PROGRESSION & LOAD ADJUSTMENT
  // ==========================================

  /// Calculate recommended load adjustment percentage
  static double calculateLoadAdjustment(double avgRPE, double targetRPE) {
    return RPEThresholds.getLoadAdjustment(avgRPE, targetRPE);
  }

  /// Determine if deload is needed
  static bool shouldDeload(
    List<double> recentSessionRPEs,
    double targetRPE,
    int consecutiveWeeks,
  ) {
    // Deload if:
    // 1. Fatigue trend detected
    // 2. Average RPE significantly above target
    // 3. Training for 3+ weeks without deload
    
    if (consecutiveWeeks >= 4) return true;
    
    if (detectFatigueTrend(recentSessionRPEs, targetRPE)) return true;
    
    if (recentSessionRPEs.isNotEmpty) {
      final avgRPE = calculateAverageRPE(recentSessionRPEs);
      if (avgRPE > targetRPE + 2.0) return true;
    }
    
    return false;
  }

  /// Calculate readiness score (0-100, higher = more ready to train)
  static double calculateReadinessScore(
    double currentRPE,
    double targetRPE,
    double restDaysSinceLastWorkout,
  ) {
    // Base score from RPE
    double score = 50.0;
    
    // Adjust based on RPE
    final rpeDelta = targetRPE - currentRPE;
    score += rpeDelta * 10; // Each RPE point below target adds 10 points
    
    // Adjust based on rest
    if (restDaysSinceLastWorkout >= 2) {
      score += 10;
    } else if (restDaysSinceLastWorkout < 1) {
      score -= 15;
    }
    
    return score.clamp(0.0, 100.0);
  }

  // ==========================================
  // STATISTICAL ANALYSIS
  // ==========================================

  /// Calculate standard deviation of RPEs
  static double calculateStandardDeviation(List<double> rpes) {
    if (rpes.length < 2) return 0.0;
    
    final mean = calculateAverageRPE(rpes);
    final squaredDifferences = rpes.map((rpe) => (rpe - mean) * (rpe - mean));
    final variance = squaredDifferences.reduce((a, b) => a + b) / rpes.length;
    
    return variance.isFinite ? math.sqrt(variance) : 0.0;
  }

  /// Check consistency of RPE (low std dev = consistent)
  static bool isConsistentRPE(List<double> rpes) {
    if (rpes.length < 3) return true; // Not enough data
    
    final stdDev = calculateStandardDeviation(rpes);
    return stdDev <= 1.0; // Consistent if within 1 RPE point
  }

  /// Find RPE trend (increasing, stable, or decreasing)
  static String analyzeTrend(List<double> rpes) {
    if (rpes.length < 3) return 'Insufficient Data';
    
    // Simple linear regression slope
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    final n = rpes.length;
    
    for (int i = 0; i < n; i++) {
      sumX += i;
      sumY += rpes[i];
      sumXY += i * rpes[i];
      sumX2 += i * i;
    }
    
    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    
    if (slope > 0.3) return 'Increasing Fatigue';
    if (slope < -0.3) return 'Improving Recovery';
    return 'Stable';
  }

  // ==========================================
  // VOLUME & INTENSITY METRICS
  // ==========================================

  /// Calculate total stress (RPE × sets)
  static double calculateTotalStress(List<double> rpes) {
    return rpes.fold(0.0, (sum, rpe) => sum + rpe);
  }

  /// Calculate average intensity relative to max
  static double calculateRelativeIntensity(double avgRPE) {
    // Convert RPE to percentage of max effort
    return (avgRPE / 10.0) * 100;
  }

  /// Calculate session difficulty score
  static double calculateDifficultyScore(
    List<double> rpes,
    int totalVolume, // Total reps × sets
  ) {
    if (rpes.isEmpty || totalVolume == 0) return 0.0;
    
    final avgRPE = calculateAverageRPE(rpes);
    final totalStress = calculateTotalStress(rpes);
    
    // Difficulty = (Average RPE × Total Stress × Volume factor) / 100
    return (avgRPE * totalStress * (totalVolume / 100)) / 100;
  }
}



