import '../domain/repositories/training_repository.dart';
import '../domain/models/program_week.dart';
import '../core/utils/rpe_math.dart';

class ProgressionService {
  final TrainingRepository _repository;

  ProgressionService(this._repository);

  /// Check if deload is needed based on RPE trends
  Future<bool> shouldDeload({
    required List<WorkoutSession> sessions,
    required ProgramWeek weekData,
  }) async {
    final allRPEs = <double>[];
    for (final session in sessions) {
      allRPEs.addAll(session.sets.map((s) => s.rpe));
    }

    final weekAvgRPE = RPEMath.calculateAverageRPE(allRPEs);

    // If consistently hitting high RPE, suggest deload
    if (RPEMath.isHighFatigue(weekAvgRPE, weekData.targetRPEMax)) {
      return true;
    }

    // If recovering well, continue progression
    if (RPEMath.isRecovering(weekAvgRPE, weekData.targetRPEMin)) {
      return false;
    }

    return false;
  }
}
