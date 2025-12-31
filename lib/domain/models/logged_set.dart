
import 'package:equatable/equatable.dart';
import '../../core/utils/rpe_thresholds.dart';

/// Domain model representing a single logged set during a workout
class LoggedSet extends Equatable {
  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final String exerciseName;
  final int setNumber;
  final double weight;
  final String weightUnit; // kg or lbs
  final int reps;
  final double rpe;
  final bool completed;
  final DateTime timestamp;
  final String? notes;
  final double? targetRPE;

  const LoggedSet({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    