lib/features/dashboard/week_dashboard_screen.dart:371:30: Error: The getter 'dayOfWeek' isn't defined for the class 'DailyWorkout'.
 - 'DailyWorkout' is from 'package:ai_fitness_coach/domain/models/daily_workout.dart' ('lib/domain/models/daily_workout.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dayOfWeek'.
        (workout) => workout.dayOfWeek == dayOfWeek,
                             ^^^^^^^^^
lib/domain/models/program_week.dart:199:30: Error: The getter 'targetRPE' isn't defined for the class 'Exercise'.
 - 'Exercise' is from 'package:ai_fitness_coach/domain/models/exercise.dart' ('lib/domain/models/exercise.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'targetRPE'.
        totalRPE += exercise.targetRPE;
                             ^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
