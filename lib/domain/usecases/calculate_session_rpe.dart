class CalculateSessionRPE {
  double call(List<LoggedSet> sets) {
    return RPEMath.calculateAverageRPE(sets.map((s) => s.rpe).toList());
  }
}
