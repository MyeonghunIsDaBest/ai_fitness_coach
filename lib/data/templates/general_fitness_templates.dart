// lib/data/templates/general_fitness_templates.dart

import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/lift_type.dart';

class GeneralFitnessTemplates {
  static WorkoutProgram get beginnerFullBody {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'gf_beginner_fullbody',
      name: 'Beginner Full Body',
      sport: Sport.generalFitness,
      description:
          '3x per week full body program. Perfect for building foundational strength and fitness.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateBeginnerWeeks(),
    );
  }

  static List<ProgramWeek> _generateBeginnerWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 8; i++) {
      if (i == 4 || i == 8) {
        weeks.add(_createDeloadWeek(i));
      } else {
        weeks.add(_createBeginnerWeek(i));
      }
    }

    return weeks;
  }

  static ProgramWeek _createBeginnerWeek(int weekNumber) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.hypertrophy,
      targetRPEMin: 6.5,
      targetRPEMax: 8.0,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Full Body A',
          exercises: [
            Exercise.mainLift(
                name: 'Goblet Squat',
                liftType: LiftType.squat,
                sets: 3,
                reps: 10,
                targetRPEMin: 6.5,
                targetRPEMax: 7.5,
                order: 1),
            Exercise.mainLift(
                name: 'Push-ups',
                liftType: LiftType.benchPress,
                sets: 3,
                reps: 10,
                targetRPEMin: 6.5,
                targetRPEMax: 7.5,
                order: 2),
            Exercise.accessory(
                name: 'Dumbbell Row',
                liftType: LiftType.bentOverRow,
                sets: 3,
                reps: 12,
                order: 3),
            Exercise.accessory(
                name: 'Plank',
                liftType: LiftType.other,
                sets: 3,
                reps: 30,
                order: 4),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Full Body B',
          exercises: [
            Exercise.mainLift(
                name: 'Romanian Deadlift',
                liftType: LiftType.romanianDeadlift,
                sets: 3,
                reps: 10,
                targetRPEMin: 6.5,
                targetRPEMax: 7.5,
                order: 1),
            Exercise.mainLift(
                name: 'Dumbbell Press',
                liftType: LiftType.benchPress,
                sets: 3,
                reps: 10,
                targetRPEMin: 6.5,
                targetRPEMax: 7.5,
                order: 2),
            Exercise.accessory(
                name: 'Lat Pulldown',
                liftType: LiftType.other,
                sets: 3,
                reps: 12,
                order: 3),
            Exercise.accessory(
                name: 'Bicycle Crunches',
                liftType: LiftType.other,
                sets: 3,
                reps: 15,
                order: 4),
          ],
        ),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Full Body C',
          exercises: [
            Exercise.mainLift(
                name: 'Lunges',
                liftType: LiftType.other,
                sets: 3,
                reps: 10,
                targetRPEMin: 6.5,
                targetRPEMax: 7.5,
                order: 1),
            Exercise.mainLift(
                name: 'Incline Push-ups',
                liftType: LiftType.inclineBench,
                sets: 3,
                reps: 12,
                targetRPEMin: 6.5,
                targetRPEMax: 7.5,
                order: 2),
            Exercise.accessory(
                name: 'Face Pulls',
                liftType: LiftType.other,
                sets: 3,
                reps: 15,
                order: 3),
            Exercise.accessory(
                name: 'Dead Bug',
                liftType: LiftType.other,
                sets: 3,
                reps: 12,
                order: 4),
          ],
        ),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static WorkoutProgram get intermediateUpperLower {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'gf_intermediate_ul',
      name: 'Upper/Lower Split',
      sport: Sport.generalFitness,
      description: '4x per week upper/lower split for balanced development.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateIntermediateWeeks(),
    );
  }

  static List<ProgramWeek> _generateIntermediateWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 12; i++) {
      if (i % 4 == 0) {
        weeks.add(_createDeloadWeek(i));
      } else {
        weeks.add(_createIntermediateWeek(i));
      }
    }

    return weeks;
  }

  static ProgramWeek _createIntermediateWeek(int weekNumber) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.strength,
      targetRPEMin: 7.0,
      targetRPEMax: 8.5,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Upper Body',
          exercises: [
            Exercise.mainLift(
                name: 'Bench Press',
                liftType: LiftType.benchPress,
                sets: 4,
                reps: 8,
                targetRPEMin: 7.5,
                targetRPEMax: 8.5,
                order: 1),
            Exercise.mainLift(
                name: 'Barbell Row',
                liftType: LiftType.bentOverRow,
                sets: 4,
                reps: 8,
                targetRPEMin: 7.5,
                targetRPEMax: 8.5,
                order: 2),
            Exercise.accessory(
                name: 'Overhead Press',
                liftType: LiftType.overheadPress,
                sets: 3,
                reps: 10,
                order: 3),
            Exercise.accessory(
                name: 'Dumbbell Curl',
                liftType: LiftType.bicepCurl,
                sets: 3,
                reps: 12,
                order: 4),
            Exercise.accessory(
                name: 'Tricep Pushdown',
                liftType: LiftType.tricepExtension,
                sets: 3,
                reps: 12,
                order: 5),
          ],
        ),
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Lower Body',
          exercises: [
            Exercise.mainLift(
                name: 'Back Squat',
                liftType: LiftType.squat,
                sets: 4,
                reps: 8,
                targetRPEMin: 7.5,
                targetRPEMax: 8.5,
                order: 1),
            Exercise.mainLift(
                name: 'Romanian Deadlift',
                liftType: LiftType.romanianDeadlift,
                sets: 4,
                reps: 8,
                targetRPEMin: 7.5,
                targetRPEMax: 8.5,
                order: 2),
            Exercise.accessory(
                name: 'Leg Press',
                liftType: LiftType.other,
                sets: 3,
                reps: 12,
                order: 3),
            Exercise.accessory(
                name: 'Leg Curl',
                liftType: LiftType.legCurl,
                sets: 3,
                reps: 12,
                order: 4),
            Exercise.accessory(
                name: 'Calf Raise',
                liftType: LiftType.calfRaise,
                sets: 3,
                reps: 15,
                order: 5),
          ],
        ),
        DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Upper Body',
          exercises: [
            Exercise.mainLift(
                name: 'Incline Bench',
                liftType: LiftType.inclineBench,
                sets: 4,
                reps: 10,
                targetRPEMin: 7.0,
                targetRPEMax: 8.0,
                order: 1),
            Exercise.mainLift(
                name: 'Pull-ups',
                liftType: LiftType.pullUp,
                sets: 4,
                reps: 8,
                targetRPEMin: 7.0,
                targetRPEMax: 8.0,
                order: 2),
            Exercise.accessory(
                name: 'Lateral Raise',
                liftType: LiftType.lateralRaise,
                sets: 3,
                reps: 12,
                order: 3),
            Exercise.accessory(
                name: 'Hammer Curl',
                liftType: LiftType.bicepCurl,
                sets: 3,
                reps: 12,
                order: 4),
            Exercise.accessory(
                name: 'Overhead Extension',
                liftType: LiftType.tricepExtension,
                sets: 3,
                reps: 12,
                order: 5),
          ],
        ),
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Lower Body',
          exercises: [
            Exercise.mainLift(
                name: 'Front Squat',
                liftType: LiftType.frontSquat,
                sets: 4,
                reps: 10,
                targetRPEMin: 7.0,
                targetRPEMax: 8.0,
                order: 1),
            Exercise.mainLift(
                name: 'Deadlift',
                liftType: LiftType.deadlift,
                sets: 3,
                reps: 6,
                targetRPEMin: 7.5,
                targetRPEMax: 8.5,
                order: 2),
            Exercise.accessory(
                name: 'Walking Lunges',
                liftType: LiftType.other,
                sets: 3,
                reps: 12,
                order: 3),
            Exercise.accessory(
                name: 'Leg Extension',
                liftType: LiftType.legExtension,
                sets: 3,
                reps: 12,
                order: 4),
            Exercise.accessory(
                name: 'Ab Wheel',
                liftType: LiftType.other,
                sets: 3,
                reps: 10,
                order: 5),
          ],
        ),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createDeloadWeek(int weekNumber) {
    return ProgramWeek.deload(
      weekNumber: weekNumber,
      phase: Phase.deload,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Light Movement',
          exercises: [
            Exercise.accessory(
                name: 'Bodyweight Squats',
                liftType: LiftType.squat,
                sets: 2,
                reps: 15,
                order: 1),
            Exercise.accessory(
                name: 'Push-ups',
                liftType: LiftType.benchPress,
                sets: 2,
                reps: 10,
                order: 2),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static List<WorkoutProgram> getAllTemplates() {
    return [
      beginnerFullBody,
      intermediateUpperLower,
    ];
  }
}
