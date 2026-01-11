Your project is configured to compile against Android SDK 34, but the following plugin(s) require to be compiled against a higher Android SDK version:
- flutter_plugin_android_lifecycle compiles against Android SDK 35
Fix this issue by compiling against the highest Android SDK version (they are backward compatible).
Add the following to C:\Users\footlong\ai_fitness_coach\android\app\build.gradle:

    android {
        compileSdk = 35
        ...
    }

Warning: SDK processing. This version only understands SDK XML versions up to 3 but an SDK XML file of version 4 was encountered. This can happen if you use versions of Android Studio and the command-line tools that were released at different times.
lib/main.dart:49:40: Error: Too many positional arguments: 0 allowed, but 1 found.
Try removing the extra positional arguments.
  final programService = ProgramService(repository);
                                       ^
lib/services/program_service.dart:7:11: Context: Found this candidate, but the arguments don't match.
  factory ProgramService() => _instance;
          ^
lib/services/workout_session_service.dart:143:26: Error: The getter 'totalSets' isn't defined for the class 'WorkoutSession'.
 - 'WorkoutSession' is from 'package:ai_fitness_coach/domain/repositories/training_repository.dart' ('lib/domain/repositories/training_repository.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'totalSets'.
      totalSets: session.totalSets,
                         ^^^^^^^^^
lib/services/workout_session_service.dart:147:35: Error: The getter 'exercisesPerformed' isn't defined for the class 'WorkoutSession'.
 - 'WorkoutSession' is from 'package:ai_fitness_coach/domain/repositories/training_repository.dart' ('lib/domain/repositories/training_repository.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'exercisesPerformed'.
      completedExercises: session.exercisesPerformed.length,
                                  ^^^^^^^^^^^^^^^^^^
lib/services/workout_session_service.dart:155:25: Error: The getter 'isInProgress' isn't defined for the class 'WorkoutSession'.
 - 'WorkoutSession' is from 'package:ai_fitness_coach/domain/repositories/training_repository.dart' ('lib/domain/repositories/training_repository.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isInProgress'.
    return recent.first.isInProgress;
                        ^^^^^^^^^^^^
lib/services/workout_session_service.dart:162:22: Error: The getter 'isInProgress' isn't defined for the class 'WorkoutSession'.
 - 'WorkoutSession' is from 'package:ai_fitness_coach/domain/repositories/training_repository.dart' ('lib/domain/repositories/training_repository.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isInProgress'.
    if (recent.first.isInProgress) {
                     ^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
