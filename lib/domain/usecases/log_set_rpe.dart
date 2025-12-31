class LogSetRPE {
  final TrainingRepository repository;

  LogSetRPE(this.repository);

  Future<void> call({
    required String sessionId,
    required LoggedSet set,
  }) async {
    // Validate RPE range
    if (set.rpe < 1 || set.rpe > 10) {
      throw ValidationException('RPE must be between 1 and 10');
    }

    await repository.logSet(sessionId, set);
  }
}
