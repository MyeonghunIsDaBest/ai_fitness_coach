Warning: SDK processing. This version only understands SDK XML versions up to 3 but an SDK XML file of version 4 was encountered. This can happen if you use versions of Android Studio and the command-line tools that were released at different times.
lib/main.dart:135:18: Error: The method 'CardThemeData' isn't defined for the class 'AIFitnessCoachApp'.
 - 'AIFitnessCoachApp' is from 'package:ai_fitness_coach/main.dart' ('lib/main.dart').
Try correcting the name to the name of an existing method, or defining a method named 'CardThemeData'.
      cardTheme: CardThemeData(
                 ^^^^^^^^^^^^^
lib/features/dashboard/week_dashboard_screen.dart:81:39: Error: The getter 'scheduledWorkouts' isn't defined for the class 'ProgramWeek'.
 - 'ProgramWeek' is from 'package:ai_fitness_coach/domain/models/program_week.dart' ('lib/domain/models/program_week.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'scheduledWorkouts'.
                  totalWorkouts: week.scheduledWorkouts,
                                      ^^^^^^^^^^^^^^^^^
lib/features/dashboard/week_dashboard_screen.dart:139:55: Error: The getter 'duration' isn't defined for the class 'WorkoutProgram'.
 - 'WorkoutProgram' is from 'package:ai_fitness_coach/domain/models/workout_program.dart' ('lib/domain/models/workout_program.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'duration'.
            'Week $_selectedWeek of ${widget.program!.duration}',
                                                      ^^^^^^^^
lib/features/dashboard/week_dashboard_screen.dart:225:33: Error: The getter 'uniqueExercises' isn't defined for the class 'ProgramWeek'.
 - 'ProgramWeek' is from 'package:ai_fitness_coach/domain/models/program_week.dart' ('lib/domain/models/program_week.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'uniqueExercises'.
    final totalExercises = week.uniqueExercises.length;
                                ^^^^^^^^^^^^^^^
lib/features/dashboard/week_dashboard_screen.dart:226:25: Error: The getter 'averageTargetRPE' isn't defined for the class 'ProgramWeek'.
 - 'ProgramWeek' is from 'package:ai_fitness_coach/domain/models/program_week.dart' ('lib/domain/models/program_week.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'averageTargetRPE'.
    final avgRPE = week.averageTargetRPE;
                        ^^^^^^^^^^^^^^^^
lib/features/dashboard/week_dashboard_screen.dart:370:19: Error: The getter 'workouts' isn't defined for the class 'ProgramWeek'.
 - 'ProgramWeek' is from 'package:ai_fitness_coach/domain/models/program_week.dart' ('lib/domain/models/program_week.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'workouts'.
      return week.workouts.firstWhere(
                  ^^^^^^^^
lib/features/dashboard/widgets/day_card.dart:141:20: Error: The getter 'name' isn't defined for the class 'DailyWorkout'.
 - 'DailyWorkout' is from 'package:ai_fitness_coach/domain/models/daily_workout.dart' ('lib/domain/models/daily_workout.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'name'.
          workout!.name,
                   ^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
