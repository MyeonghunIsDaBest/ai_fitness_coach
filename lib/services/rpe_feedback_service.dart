class RPEFeedbackService {
  String getFatigueMessage(double avgRPE, int targetMin, int targetMax) {
    if (avgRPE == 0) return 'Ready to start your session!';

    if (avgRPE < targetMin - 1) {
      return '💪 You\'re feeling strong today! Consider adding weight.';
    } else if (avgRPE > targetMax + 1) {
      return '😅 High RPE detected. Listen to your body - it\'s okay to reduce volume.';
    } else if (avgRPE >= targetMin && avgRPE <= targetMax) {
      return '🎯 Perfect! You\'re in the sweet spot.';
    } else {
      return '📊 Keep monitoring your RPE as you progress.';
    }
  }

  String getSessionSummary({
    required double avgRPE,
    required int targetMin,
    required int targetMax,
    required bool allCompleted,
  }) {
    if (!allCompleted) {
      return 'Progress saved. Rest up and come back stronger!';
    }

    if (avgRPE >= targetMin && avgRPE <= targetMax) {
      return '🎉 Outstanding Work! Your RPE was right on target. Perfect execution!';
    } else if (avgRPE < targetMin) {
      return 'Good session! Your RPE was lower than target. Consider adding weight next time.';
    } else {
      return 'Great effort! Your RPE was higher than target. Listen to your body and adjust as needed.';
    }
  }
}
