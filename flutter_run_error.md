lib/main.dart:65:9: Error: Type 'ProgramService' not found.
  final ProgramService programService;
        ^^^^^^^^^^^^^^
lib/main.dart:15:1: Error: 'WorkoutSessionService' is imported from both 'package:ai_fitness_coach/services/progression_service.dart' and 'package:ai_fitness_coach/services/workout_session_service.dart'.
import 'services/workout_session_service.dart';
^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:49:26: Error: Method not found: 'ProgramService'.
  final programService = ProgramService(repository);
                         ^^^^^^^^^^^^^^
lib/main.dart:52:26: Error: 'WorkoutSessionService' is imported from both 'package:ai_fitness_coach/services/progression_service.dart' and 'package:ai_fitness_coach/services/workout_session_service.dart'.
  final sessionService = WorkoutSessionService(repository);
                         ^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:65:9: Error: 'ProgramService' isn't a type.
  final ProgramService programService;
        ^^^^^^^^^^^^^^
lib/services/program_service.dart:69:27: Error: 'LoggedSet' isn't a type.
    final exerciseSets = <LoggedSet>[];
                          ^^^^^^^^^
lib/services/program_service.dart:80:47: Error: The getter 'weight' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'weight'.
    final weights = exerciseSets.map((s) => s.weight).toList();
                                              ^^^^^^
lib/services/program_service.dart:82:69: Error: The getter 'weight' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'weight'.
    final recentWeights = exerciseSets.skip(halfPoint).map((s) => s.weight);
                                                                    ^^^^^^
lib/services/program_service.dart:83:70: Error: The getter 'weight' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'weight'.
    final earlierWeights = exerciseSets.take(halfPoint).map((s) => s.weight);
                                                                     ^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
