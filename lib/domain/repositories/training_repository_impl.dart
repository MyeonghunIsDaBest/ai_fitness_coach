class TrainingRepositoryImpl implements TrainingRepository {
  final LocalDataSource localDataSource;

  TrainingRepositoryImpl(this.localDataSource);

  @override
  Future<void> logSet(String sessionId, LoggedSet set) async {
    try {
      await localDataSource.saveSet(sessionId, set.toJson());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<WorkoutSession?> getSession(String sessionId) async {
    try {
      final data = await localDataSource.getSession(sessionId);
      if (data == null) return null;
      return WorkoutSession.fromJson(data);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<WorkoutSession>> getWeekSessions(
      String programId, int weekNumber) async {
    try {
      final data = await localDataSource.getWeekSessions(programId, weekNumber);
      return data.map((json) => WorkoutSession.fromJson(json)).toList();
    } catch (e) {
      throw CacheException();
    }
  }
}
