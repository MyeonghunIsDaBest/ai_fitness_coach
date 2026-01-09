// lib/data/local/hive_service.dart

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box<Map<dynamic, dynamic>> _profileBox;
  late Box<Map<dynamic, dynamic>> _programBox;
  late Box<Map<dynamic, dynamic>> _sessionBox;
  late Box<Map<dynamic, dynamic>> _workoutBox;

  static const String profileBoxName = 'profiles';
  static const String programBoxName = 'programs';
  static const String sessionBoxName = 'sessions';
  static const String workoutBoxName = 'workouts';

  Future<void> init() async {
    await Hive.initFlutter();

    _profileBox = await Hive.openBox<Map<dynamic, dynamic>>(profileBoxName);
    _programBox = await Hive.openBox<Map<dynamic, dynamic>>(programBoxName);
    _sessionBox = await Hive.openBox<Map<dynamic, dynamic>>(sessionBoxName);
    _workoutBox = await Hive.openBox<Map<dynamic, dynamic>>(workoutBoxName);
  }

  // ==========================================
  // PROFILE OPERATIONS
  // ==========================================

  Future<void> saveProfile(String id, Map<String, dynamic> data) async {
    try {
      await _profileBox.put(id, data);
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  Map<String, dynamic>? getProfile(String id) {
    try {
      final data = _profileBox.get(id);
      return data != null ? Map<String, dynamic>.from(data) : null;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      await _profileBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  Future<void> setCurrentProfile(String id) async {
    await _profileBox.put('_current', {'id': id});
  }

  String? getCurrentProfileId() {
    final data = _profileBox.get('_current');
    return data?['id'] as String?;
  }

  // ==========================================
  // PROGRAM OPERATIONS
  // ==========================================

  Future<void> saveProgram(String id, Map<String, dynamic> data) async {
    try {
      await _programBox.put(id, data);
    } catch (e) {
      throw Exception('Failed to save program: $e');
    }
  }

  Map<String, dynamic>? getProgram(String id) {
    try {
      final data = _programBox.get(id);
      return data != null ? Map<String, dynamic>.from(data) : null;
    } catch (e) {
      throw Exception('Failed to get program: $e');
    }
  }

  List<Map<String, dynamic>> getAllPrograms() {
    try {
      return _programBox.values
          .where((v) => v['id'] != null)
          .map((v) => Map<String, dynamic>.from(v))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all programs: $e');
    }
  }

  Future<void> deleteProgram(String id) async {
    try {
      await _programBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete program: $e');
    }
  }

  Future<void> setActiveProgram(String id) async {
    await _programBox.put(
        '_active', {'id': id, 'startDate': DateTime.now().toIso8601String()});
  }

  String? getActiveProgramId() {
    final data = _programBox.get('_active');
    return data?['id'] as String?;
  }

  // ==========================================
  // SESSION OPERATIONS
  // ==========================================

  Future<void> saveSession(String id, Map<String, dynamic> data) async {
    try {
      await _sessionBox.put(id, data);
    } catch (e) {
      throw Exception('Failed to save session: $e');
    }
  }

  Map<String, dynamic>? getSession(String id) {
    try {
      final data = _sessionBox.get(id);
      return data != null ? Map<String, dynamic>.from(data) : null;
    } catch (e) {
      throw Exception('Failed to get session: $e');
    }
  }

  List<Map<String, dynamic>> getAllSessions() {
    try {
      return _sessionBox.values
          .where((v) => v['id'] != null)
          .map((v) => Map<String, dynamic>.from(v))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all sessions: $e');
    }
  }

  List<Map<String, dynamic>> getSessionsByProgram(String programId) {
    try {
      return _sessionBox.values
          .where((v) => v['programId'] == programId)
          .map((v) => Map<String, dynamic>.from(v))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sessions by program: $e');
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      await _sessionBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete session: $e');
    }
  }

  // ==========================================
  // WORKOUT OPERATIONS
  // ==========================================

  Future<void> saveWorkout(String id, Map<String, dynamic> data) async {
    try {
      await _workoutBox.put(id, data);
    } catch (e) {
      throw Exception('Failed to save workout: $e');
    }
  }

  Map<String, dynamic>? getWorkout(String id) {
    try {
      final data = _workoutBox.get(id);
      return data != null ? Map<String, dynamic>.from(data) : null;
    } catch (e) {
      throw Exception('Failed to get workout: $e');
    }
  }

  List<Map<String, dynamic>> getAllWorkouts() {
    try {
      return _workoutBox.values
          .where((v) => v['id'] != null)
          .map((v) => Map<String, dynamic>.from(v))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all workouts: $e');
    }
  }

  // ==========================================
  // PROGRESS TRACKING
  // ==========================================

  Future<void> markWeekCompleted(String programId, int weekNumber) async {
    final key = '${programId}_week_$weekNumber';
    await _programBox.put(key, {
      'completed': true,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }

  bool isWeekCompleted(String programId, int weekNumber) {
    final key = '${programId}_week_$weekNumber';
    final data = _programBox.get(key);
    return data?['completed'] == true;
  }

  List<int> getCompletedWeeks(String programId) {
    final completed = <int>[];
    for (var key in _programBox.keys) {
      if (key.toString().startsWith('${programId}_week_')) {
        final data = _programBox.get(key);
        if (data?['completed'] == true) {
          final weekStr = key.toString().split('_').last;
          completed.add(int.parse(weekStr));
        }
      }
    }
    return completed..sort();
  }

  // ==========================================
  // STATISTICS
  // ==========================================

  int getTotalWorkouts() {
    return _sessionBox.values.where((v) => v['isCompleted'] == true).length;
  }

  double getTotalVolume() {
    double total = 0.0;
    for (var session in _sessionBox.values) {
      final sets = session['sets'] as List?;
      if (sets != null) {
        for (var set in sets) {
          if (set is Map) {
            final weight = (set['weight'] as num?)?.toDouble() ?? 0.0;
            final reps = (set['reps'] as num?)?.toInt() ?? 0;
            total += weight * reps;
          }
        }
      }
    }
    return total;
  }

  Map<String, double> getPersonalRecords() {
    final prs = <String, double>{};

    for (var session in _sessionBox.values) {
      final sets = session['sets'] as List?;
      if (sets != null) {
        for (var set in sets) {
          if (set is Map) {
            final exercise = set['exerciseName'] as String?;
            final weight = (set['weight'] as num?)?.toDouble() ?? 0.0;
            final reps = (set['reps'] as num?)?.toInt() ?? 0;

            if (exercise != null && weight > 0) {
              final estimated1RM = weight * (1 + reps / 30);
              final current = prs[exercise] ?? 0.0;
              if (estimated1RM > current) {
                prs[exercise] = estimated1RM;
              }
            }
          }
        }
      }
    }

    return prs;
  }

  // ==========================================
  // UTILITY
  // ==========================================

  Future<void> clearAll() async {
    await _profileBox.clear();
    await _programBox.clear();
    await _sessionBox.clear();
    await _workoutBox.clear();
  }

  Future<void> clearPrograms() async {
    await _programBox.clear();
  }

  Future<void> clearSessions() async {
    await _sessionBox.clear();
  }

  Future<void> close() async {
    await _profileBox.close();
    await _programBox.close();
    await _sessionBox.close();
    await _workoutBox.close();
  }

  Map<String, int> getBoxSizes() {
    return {
      'profiles': _profileBox.length,
      'programs': _programBox.length,
      'sessions': _sessionBox.length,
      'workouts': _workoutBox.length,
    };
  }
}
