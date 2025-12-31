class ProgressionService {
  Future<void> analyzeWeekCompletion({
    required List<WorkoutSession> sessions,
    required ProgramWeek weekData,
  }) async {
    // Calculate average RPE for the week
    List<double> allRPEs = [];
    sessions.forEach((session) {
      allRPEs.addAll(session.sets.map((s) => s.rpe));
    });

    final weekAvgRPE = RPEMath.calculateAverageRPE(allRPEs);

    // Determine if adjustments needed for next week
    if (RPEMath.isHighFatigue(weekAvgRPE, weekData.targetRPEMax)) {
      // Flag for deload recommendation
      return;
    }

    if (RPEMath.isRecovering(weekAvgRPE, weekData.targetRPEMin)) {
      // Flag for load increase
      return;
    }
  }
}
