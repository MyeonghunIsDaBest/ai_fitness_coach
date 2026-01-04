lib/main.dart:331:1: Error: Expected a declaration, but got '}'.
}
^
lib/main.dart:336:7: Error: 'SplashScreen' is already declared in this scope.
class SplashScreen extends StatefulWidget {
      ^^^^^^^^^^^^
lib/main.dart:206:7: Context: Previous declaration of 'SplashScreen'.
class SplashScreen extends StatefulWidget {
      ^^^^^^^^^^^^
lib/main.dart:343:7: Error: '_SplashScreenState' is already declared in this scope.
class _SplashScreenState extends State<SplashScreen>
      ^^^^^^^^^^^^^^^^^^
lib/main.dart:213:7: Context: Previous declaration of '_SplashScreenState'.
class _SplashScreenState extends State<SplashScreen> {
      ^^^^^^^^^^^^^^^^^^
lib/main.dart:9:8: Error: Error when reading 'lib/data/repositories/training_repository_impl.dart': The system cannot find the file specified.      

import 'data/repositories/training_repository_impl.dart';
       ^
lib/main.dart:31:8: Error: Error when reading 'lib/data/repositories/training_repository_impl.dart': The system cannot find the file specified.     

import 'data/repositories/training_repository_impl.dart';
       ^
lib/main.dart:12:8: Error: Error when reading 'lib/domain/repositories/training_repository.dart': The system cannot find the file specified.        

import 'domain/repositories/training_repository.dart';
       ^
lib/main.dart:34:8: Error: Error when reading 'lib/domain/repositories/training_repository.dart': The system cannot find the file specified.        

import 'domain/repositories/training_repository.dart';
       ^
lib/main.dart:15:8: Error: Error when reading 'lib/services/program_service.dart': The system cannot find the file specified.

import 'services/program_service.dart';
       ^
lib/main.dart:37:8: Error: Error when reading 'lib/services/program_service.dart': The system cannot find the file specified.

import 'services/program_service.dart';
       ^
lib/main.dart:18:8: Error: Error when reading 'lib/services/workout_session_service.dart': The system cannot find the file specified.

import 'services/workout_session_service.dart';
       ^
lib/main.dart:40:8: Error: Error when reading 'lib/services/workout_session_service.dart': The system cannot find the file specified.

import 'services/workout_session_service.dart';
       ^
lib/features/program_selection/program_selection_screen.dart:5:8: Error: Error when reading 'lib/domain/models/program_week.dart': The system cannot find the file specified.

import '../../domain/models/program_week.dart';
       ^
lib/domain/models/workout_program.dart:3:8: Error: Error when reading 'lib/domain/models/program_week.dart': The system cannot find the file specified.

import 'program_week.dart';
       ^
lib/features/program_selection/program_selection_screen.dart:6:8: Error: Error when reading 'lib/domain/models/daily_workout.dart': The system cannot find the file specified.

import '../../domain/models/daily_workout.dart';
       ^
lib/features/program_selection/program_selection_screen.dart:7:8: Error: Error when reading 'lib/domain/models/exercise.dart': The system cannot find the file specified.

import '../../domain/models/exercise.dart';
       ^
lib/main.dart:88:9: Error: Type 'ProgramService' not found.
  final ProgramService programService;
        ^^^^^^^^^^^^^^
lib/main.dart:91:9: Error: Type 'WorkoutSessionService' not found.
  final WorkoutSessionService sessionService;
        ^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:210:9: Error: 'SplashScreen' isn't a type.
  State<SplashScreen> createState() => _SplashScreenState();
        ^^^^^^^^^^^^
lib/main.dart:210:9: Context: This isn't a type.
  State<SplashScreen> createState() => _SplashScreenState();
        ^^^^^^^^^^^^
lib/main.dart:213:40: Error: 'SplashScreen' isn't a type.
class _SplashScreenState extends State<SplashScreen> {
                                       ^^^^^^^^^^^^
lib/main.dart:213:40: Context: This isn't a type.
class _SplashScreenState extends State<SplashScreen> {
                                       ^^^^^^^^^^^^
lib/main.dart:340:9: Error: 'SplashScreen' isn't a type.
  State<SplashScreen> createState() => _SplashScreenState();
        ^^^^^^^^^^^^
lib/main.dart:340:9: Context: This isn't a type.
  State<SplashScreen> createState() => _SplashScreenState();
        ^^^^^^^^^^^^
lib/main.dart:343:40: Error: 'SplashScreen' isn't a type.
class _SplashScreenState extends State<SplashScreen>
                                       ^^^^^^^^^^^^
lib/main.dart:343:40: Context: This isn't a type.
class _SplashScreenState extends State<SplashScreen>
                                       ^^^^^^^^^^^^
lib/services/progression_service.dart:3:19: Error: Type 'WorkoutSession' not found.
    required List<WorkoutSession> sessions,
                  ^^^^^^^^^^^^^^
lib/services/progression_service.dart:4:14: Error: Type 'ProgramWeek' not found.
    required ProgramWeek weekData,
             ^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:86:8: Error: Type 'ProgramWeek' not found.
  List<ProgramWeek> _generateSampleWeeks(int weekCount,
       ^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:122:8: Error: Type 'DailyWorkout' not found.
  List<DailyWorkout> _generateSampleDays() {
       ^^^^^^^^^^^^
lib/domain/models/workout_program.dart:12:14: Error: Type 'ProgramWeek' not found.
  final List<ProgramWeek> weeks;
             ^^^^^^^^^^^
lib/domain/models/workout_program.dart:41:19: Error: Type 'ProgramWeek' not found.
    required List<ProgramWeek> weeks,
                  ^^^^^^^^^^^
lib/domain/models/workout_program.dart:72:10: Error: Type 'ProgramWeek' not found.
    List<ProgramWeek>? weeks,
         ^^^^^^^^^^^
lib/domain/models/workout_program.dart:101:3: Error: Type 'ProgramWeek' not found.
  ProgramWeek? getWeek(int weekNumber) {
  ^^^^^^^^^^^
lib/domain/models/workout_program.dart:110:3: Error: Type 'ProgramWeek' not found.
  ProgramWeek? get currentWeek {
  ^^^^^^^^^^^
lib/domain/models/workout_program.dart:140:8: Error: Type 'ProgramWeek' not found.
  List<ProgramWeek> get completedWeeks {
       ^^^^^^^^^^^
lib/domain/models/workout_program.dart:145:8: Error: Type 'ProgramWeek' not found.
  List<ProgramWeek> get remainingWeeks {
       ^^^^^^^^^^^
lib/domain/models/workout_program.dart:186:45: Error: Type 'ProgramWeek' not found.
  WorkoutProgram updateWeek(int weekNumber, ProgramWeek updatedWeek) {
                                            ^^^^^^^^^^^
lib/main.dart:64:22: Error: Method not found: 'TrainingRepositoryImpl'.
  final repository = TrainingRepositoryImpl(
                     ^^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:72:26: Error: Method not found: 'ProgramService'.
  final programService = ProgramService(repository);
                         ^^^^^^^^^^^^^^
lib/main.dart:74:48: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  final progressionService = ProgressionService(repository);
                                               ^
lib/services/progression_service.dart:1:7: Context: The class 'ProgressionService' has a constructor that takes no arguments.
class ProgressionService {
      ^
lib/main.dart:75:26: Error: Method not found: 'WorkoutSessionService'.
  final sessionService = WorkoutSessionService(repository);
                         ^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:88:9: Error: 'ProgramService' isn't a type.
  final ProgramService programService;
        ^^^^^^^^^^^^^^
lib/main.dart:91:9: Error: 'WorkoutSessionService' isn't a type.
  final WorkoutSessionService sessionService;
        ^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:163:35: Error: Couldn't find constructor 'SplashScreen'.
        return _createRoute(const SplashScreen());
                                  ^^^^^^^^^^^^
lib/main.dart:168:13: Error: No named parameter with the name 'programService'.
            programService: programService,
            ^^^^^^^^^^^^^^
lib/main.dart:2609:9: Context: Found this candidate, but the arguments don't match.
  const ProgramSelectionScreen({Key? key}) : super(key: key);
        ^^^^^^^^^^^^^^^^^^^^^^
lib/main.dart:210:40: Error: Can't use '_SplashScreenState' because it is declared more than once.
  State<SplashScreen> createState() => _SplashScreenState();
                                       ^
lib/main.dart:284:35: Error: Couldn't find constructor 'SplashScreen'.
        return _createRoute(const SplashScreen());
                                  ^^^^^^^^^^^^
lib/main.dart:340:40: Error: Can't use '_SplashScreenState' because it is declared more than once.
  State<SplashScreen> createState() => _SplashScreenState();
                                       ^
lib/main.dart:695:39: Error: The getter 'icon' isn't defined for the class 'Sport'.
 - 'Sport' is from 'package:ai_fitness_coach/core/enums/sport.dart' ('lib/core/enums/sport.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'icon'.
                                sport.icon,
                                      ^^^^
lib/main.dart:1594:49: Error: Couldn't find constructor 'FoodLogScreen'.
                    builder: (context) => const FoodLogScreen(),
                                                ^^^^^^^^^^^^^
lib/services/progression_service.dart:3:19: Error: 'WorkoutSession' isn't a type.
    required List<WorkoutSession> sessions,
                  ^^^^^^^^^^^^^^
lib/services/progression_service.dart:4:14: Error: 'ProgramWeek' isn't a type.
    required ProgramWeek weekData,
             ^^^^^^^^^^^
lib/services/progression_service.dart:9:30: Error: The getter 'sets' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'sets'.
      allRPEs.addAll(session.sets.map((s) => s.rpe));
                             ^^^^
lib/services/progression_service.dart:12:24: Error: The getter 'RPEMath' isn't defined for the class 'ProgressionService'.
 - 'ProgressionService' is from 'package:ai_fitness_coach/services/progression_service.dart' ('lib/services/progression_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'RPEMath'.
    final weekAvgRPE = RPEMath.calculateAverageRPE(allRPEs);
                       ^^^^^^^
lib/services/progression_service.dart:15:9: Error: The getter 'RPEMath' isn't defined for the class 'ProgressionService'.
 - 'ProgressionService' is from 'package:ai_fitness_coach/services/progression_service.dart' ('lib/services/progression_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'RPEMath'.
    if (RPEMath.isHighFatigue(weekAvgRPE, weekData.targetRPEMax)) {
        ^^^^^^^
lib/services/progression_service.dart:20:9: Error: The getter 'RPEMath' isn't defined for the class 'ProgressionService'.
 - 'ProgressionService' is from 'package:ai_fitness_coach/services/progression_service.dart' ('lib/services/progression_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'RPEMath'.
    if (RPEMath.isRecovering(weekAvgRPE, weekData.targetRPEMin)) {
        ^^^^^^^
lib/features/program_selection/program_selection_screen.dart:88:20: Error: 'ProgramWeek' isn't a type.
    final weeks = <ProgramWeek>[];
                   ^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:96:15: Error: The getter 'ProgramWeek' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'ProgramWeek'.
            ? ProgramWeek.deload(
              ^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:102:15: Error: The getter 'ProgramWeek' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'ProgramWeek'.
            : ProgramWeek.normal(
              ^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:124:7: Error: The getter 'DailyWorkout' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'DailyWorkout'.
      DailyWorkout.trainingDay(
      ^^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:130:11: Error: The getter 'Exercise' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'Exercise'.
          Exercise.mainLift(
          ^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:139:11: Error: The getter 'Exercise' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'Exercise'.
          Exercise.accessory(
          ^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:150:7: Error: The getter 'DailyWorkout' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'DailyWorkout'.
      DailyWorkout.restDay(
      ^^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:155:7: Error: The getter 'DailyWorkout' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'DailyWorkout'.
      DailyWorkout.trainingDay(
      ^^^^^^^^^^^^
lib/features/program_selection/program_selection_screen.dart:161:11: Error: The getter 'Exercise' isn't defined for the class '_ProgramSelectionScreenState'.
 - '_ProgramSelectionScreenState' is from 'package:ai_fitness_coach/features/program_selection/program_selection_screen.dart' ('lib/features/program_selection/program_selection_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'Exercise'.
          Exercise.mainLift(
          ^^^^^^^^
lib/domain/models/workout_program.dart:12:14: Error: 'ProgramWeek' isn't a type.
  final List<ProgramWeek> weeks;
             ^^^^^^^^^^^
lib/domain/models/workout_program.dart:41:19: Error: 'ProgramWeek' isn't a type.
    required List<ProgramWeek> weeks,
                  ^^^^^^^^^^^
lib/domain/models/workout_program.dart:72:10: Error: 'ProgramWeek' isn't a type.
    List<ProgramWeek>? weeks,
         ^^^^^^^^^^^
lib/domain/models/workout_program.dart:103:40: Error: The getter 'weekNumber' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'weekNumber'.
      return weeks.firstWhere((w) => w.weekNumber == weekNumber);
                                       ^^^^^^^^^^
lib/domain/models/workout_program.dart:135:49: Error: The getter 'isCompleted' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isCompleted'.
    final completedWeeks = weeks.where((w) => w.isCompleted).length;
                                                ^^^^^^^^^^^
lib/domain/models/workout_program.dart:141:33: Error: The getter 'isCompleted' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isCompleted'.
    return weeks.where((w) => w.isCompleted).toList();
                                ^^^^^^^^^^^
lib/domain/models/workout_program.dart:146:34: Error: The getter 'isCompleted' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isCompleted'.
    return weeks.where((w) => !w.isCompleted).toList();
                                 ^^^^^^^^^^^
lib/domain/models/workout_program.dart:153:30: Error: The getter 'isCompleted' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isCompleted'.
        weeks.every((w) => w.isCompleted);
                             ^^^^^^^^^^^
lib/domain/models/workout_program.dart:158:52: Error: The getter 'trainingDaysCount' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'trainingDaysCount'.
    return weeks.fold(0, (sum, week) => sum + week.trainingDaysCount);
                                                   ^^^^^^^^^^^^^^^^^
lib/domain/models/workout_program.dart:158:45: Error: A value of type 'num' can't be returned from a function with return type 'int'.
    return weeks.fold(0, (sum, week) => sum + week.trainingDaysCount);
                                            ^
lib/domain/models/workout_program.dart:163:52: Error: The getter 'totalSets' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'totalSets'.
    return weeks.fold(0, (sum, week) => sum + week.totalSets);
                                                   ^^^^^^^^^
lib/domain/models/workout_program.dart:163:45: Error: A value of type 'num' can't be returned from a function with return type 'int'.
    return weeks.fold(0, (sum, week) => sum + week.totalSets);
                                            ^
lib/domain/models/workout_program.dart:186:45: Error: 'ProgramWeek' isn't a type.
  WorkoutProgram updateWeek(int weekNumber, ProgramWeek updatedWeek) {
                                            ^^^^^^^^^^^
lib/domain/models/workout_program.dart:188:16: Error: The getter 'weekNumber' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'weekNumber'.
      return w.weekNumber == weekNumber ? updatedWeek : w;
               ^^^^^^^^^^
lib/domain/models/workout_program.dart:204:30: Error: The getter 'isValid' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isValid'.
        weeks.every((w) => w.isValid) &&
                             ^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
