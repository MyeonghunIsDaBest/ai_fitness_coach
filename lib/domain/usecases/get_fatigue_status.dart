class GetFatigueStatus {
  FatigueStatus call({
    required double avgRPE,
    required int targetMin,
    required int targetMax,
  }) {
    if (RPEMath.isHighFatigue(avgRPE, targetMax)) {
      return FatigueStatus.high;
    } else if (RPEMath.isRecovering(avgRPE, targetMin)) {
      return FatigueStatus.recovering;
    } else if (avgRPE >= targetMin && avgRPE <= targetMax) {
      return FatigueStatus.optimal;
    }
    return FatigueStatus.normal;
  }
}

enum FatigueStatus {
  recovering,
  optimal,
  normal,
  high,
}
