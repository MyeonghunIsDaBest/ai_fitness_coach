import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/lift_type.dart';

class BodybuildingTemplates {
  /// Classic 5-Day Bro Split - 12 weeks
  /// Monday: Chest, Tuesday: Back, Wednesday: Shoulders, Thursday: Arms, Friday: Legs
  static WorkoutProgram get classicBroSplit {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'bb_bro_split',
      name: 'Classic Bro Split',
      sport: Sport.bodybuilding,
      description:
          '5-day bodybuilding split focusing on one muscle group per day. Classic bodybuilding approach for muscle growth.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateBroSplitWeeks(),
    );
  }

  static List<ProgramWeek> _generateBroSplitWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 12; i++) {
      // Every 4th week is deload
      if (i % 4 == 0) {
        weeks.add(_createDeloadWeek(i));
      } else {
        weeks.add(_createBroSplitWeek(i));
      }
    }

    return weeks;
  }

  static ProgramWeek _createBroSplitWeek(int weekNumber) {
    final rpeMin = 7.0;
    final rpeMax = 9.0;

    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.hypertrophy,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - CHEST DAY
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Chest',
          exercises: [
            Exercise.mainLift(
              name: 'Barbell Bench Press',
              liftType: LiftType.benchPress,
              sets: 4,
              reps: 8,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Incline Dumbbell Press',
              liftType: LiftType.inclineBench,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Cable Flyes',
              liftType: LiftType.other,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 3,
              notes: 'Focus on stretch and contraction',
            ),
            Exercise.accessory(
              name: 'Dips (Chest Focus)',
              liftType: LiftType.dip,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 60,
              order: 4,
              notes: 'Lean forward, wide grip',
            ),
          ],
        ),

        // TUESDAY - BACK DAY
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Back',
          exercises: [
            Exercise.mainLift(
              name: 'Deadlift',
              liftType: LiftType.deadlift,
              sets: 4,
              reps: 6,
              targetRPEMin: rpeMin + 1.5,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Pull-ups (Wide Grip)',
              liftType: LiftType.pullUp,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 2,
              notes: 'Weighted if possible',
            ),
            Exercise.accessory(
              name: 'Barbell Row',
              liftType: LiftType.bentOverRow,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Face Pulls',
              liftType: LiftType.other,
              sets: 3,
              reps: 15,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.5,
              restSeconds: 60,
              order: 4,
              notes: 'Rear delts + upper back',
            ),
            Exercise.accessory(
              name: 'Lat Pulldown',
              liftType: LiftType.other,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 5,
            ),
          ],
        ),

        // WEDNESDAY - SHOULDERS DAY
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Shoulders',
          exercises: [
            Exercise.mainLift(
              name: 'Overhead Press',
              liftType: LiftType.overheadPress,
              sets: 4,
              reps: 8,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Dumbbell Lateral Raise',
              liftType: LiftType.lateralRaise,
              sets: 4,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 2,
              notes: 'Focus on medial delts',
            ),
            Exercise.accessory(
              name: 'Rear Delt Flyes',
              liftType: LiftType.other,
              sets: 4,
              reps: 15,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Arnold Press',
              liftType: LiftType.other,
              sets: 3,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 4,
            ),
          ],
        ),

        // THURSDAY - ARMS DAY
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Arms',
          exercises: [
            // BICEPS
            Exercise.accessory(
              name: 'Barbell Curl',
              liftType: LiftType.bicepCurl,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Hammer Curls',
              liftType: LiftType.bicepCurl,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Preacher Curl',
              liftType: LiftType.bicepCurl,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 3,
            ),
            // TRICEPS
            Exercise.accessory(
              name: 'Close-Grip Bench Press',
              liftType: LiftType.benchPress,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Overhead Tricep Extension',
              liftType: LiftType.tricepExtension,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 5,
            ),
            Exercise.accessory(
              name: 'Cable Pushdowns',
              liftType: LiftType.tricepExtension,
              sets: 3,
              reps: 15,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.5,
              restSeconds: 60,
              order: 6,
            ),
          ],
        ),

        // FRIDAY - LEGS DAY
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Legs',
          exercises: [
            Exercise.mainLift(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 4,
              reps: 8,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Romanian Deadlift',
              liftType: LiftType.romanianDeadlift,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 120,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Leg Press',
              liftType: LiftType.other,
              sets: 4,
              reps: 12,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Leg Curl',
              liftType: LiftType.legCurl,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Calf Raises',
              liftType: LiftType.calfRaise,
              sets: 4,
              reps: 15,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 5,
            ),
          ],
        ),

        // WEEKEND - Rest
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Push/Pull/Legs (PPL) - 12 weeks
  /// More frequent training, 6 days per week
  static WorkoutProgram get pushPullLegs {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'bb_ppl',
      name: 'Push/Pull/Legs',
      sport: Sport.bodybuilding,
      description:
          '6-day PPL split. Train each muscle group twice per week. Excellent for intermediate bodybuilders.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generatePPLWeeks(),
    );
  }

  static List<ProgramWeek> _generatePPLWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 12; i++) {
      if (i % 4 == 0) {
        weeks.add(_createDeloadWeek(i));
      } else {
        weeks.add(_createPPLWeek(i));
      }
    }

    return weeks;
  }

  static ProgramWeek _createPPLWeek(int weekNumber) {
    final rpeMin = 7.5;
    final rpeMax = 9.0;

    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.hypertrophy,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - PUSH (Chest, Shoulders, Triceps)
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Push (Chest, Shoulders, Triceps)',
          exercises: [
            Exercise.mainLift(
              name: 'Bench Press',
              liftType: LiftType.benchPress,
              sets: 4,
              reps: 8,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Overhead Press',
              liftType: LiftType.overheadPress,
              sets: 3,
              reps: 10,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Incline Dumbbell Press',
              liftType: LiftType.inclineBench,
              sets: 3,
              reps: 12,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Lateral Raises',
              liftType: LiftType.lateralRaise,
              sets: 3,
              reps: 15,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Tricep Dips',
              liftType: LiftType.dip,
              sets: 3,
              reps: 12,
              order: 5,
            ),
          ],
        ),

        // TUESDAY - PULL (Back, Biceps)
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Pull (Back, Biceps)',
          exercises: [
            Exercise.mainLift(
              name: 'Deadlift',
              liftType: LiftType.deadlift,
              sets: 3,
              reps: 6,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Pull-ups',
              liftType: LiftType.pullUp,
              sets: 4,
              reps: 10,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Barbell Row',
              liftType: LiftType.bentOverRow,
              sets: 4,
              reps: 10,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Barbell Curl',
              liftType: LiftType.bicepCurl,
              sets: 3,
              reps: 12,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Face Pulls',
              liftType: LiftType.other,
              sets: 3,
              reps: 15,
              order: 5,
            ),
          ],
        ),

        // WEDNESDAY - LEGS
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Legs',
          exercises: [
            Exercise.mainLift(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 4,
              reps: 8,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Romanian Deadlift',
              liftType: LiftType.romanianDeadlift,
              sets: 3,
              reps: 10,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Leg Press',
              liftType: LiftType.other,
              sets: 3,
              reps: 12,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Leg Curl',
              liftType: LiftType.legCurl,
              sets: 3,
              reps: 12,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Calf Raises',
              liftType: LiftType.calfRaise,
              sets: 4,
              reps: 15,
              order: 5,
            ),
          ],
        ),

        // THURSDAY - PUSH (repeat with variations)
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Push (Volume Focus)',
          exercises: [
            Exercise.accessory(
              name: 'Incline Barbell Press',
              liftType: LiftType.inclineBench,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Dumbbell Shoulder Press',
              liftType: LiftType.overheadPress,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Cable Flyes',
              liftType: LiftType.other,
              sets: 3,
              reps: 15,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 3,
              notes: 'Squeeze at peak contraction',
            ),
            Exercise.accessory(
              name: 'Lateral Raises',
              liftType: LiftType.lateralRaise,
              sets: 4,
              reps: 15,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 45,
              order: 4,
              notes: 'Controlled tempo',
            ),
            Exercise.accessory(
              name: 'Tricep Rope Pushdowns',
              liftType: LiftType.tricepExtension,
              sets: 3,
              reps: 15,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 60,
              order: 5,
            ),
            Exercise.accessory(
              name: 'Overhead Tricep Extension',
              liftType: LiftType.tricepExtension,
              sets: 3,
              reps: 12,
              restSeconds: 60,
              order: 6,
            ),
          ],
        ),

        // FRIDAY - PULL (repeat with variations)
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Pull (Volume Focus)',
          exercises: [
            Exercise.accessory(
              name: 'Lat Pulldown',
              liftType: LiftType.other,
              sets: 4,
              reps: 12,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Seated Cable Row',
              liftType: LiftType.bentOverRow,
              sets: 4,
              reps: 12,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Dumbbell Rows',
              liftType: LiftType.bentOverRow,
              sets: 3,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 3,
              notes: 'Each arm',
            ),
            Exercise.accessory(
              name: 'Face Pulls',
              liftType: LiftType.other,
              sets: 4,
              reps: 15,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 60,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Hammer Curls',
              liftType: LiftType.bicepCurl,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 60,
              order: 5,
            ),
            Exercise.accessory(
              name: 'Incline Dumbbell Curls',
              liftType: LiftType.bicepCurl,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 60,
              order: 6,
              notes: 'Full stretch at bottom',
            ),
          ],
        ),

        // SATURDAY - LEGS (repeat with variations)
        DailyWorkout.trainingDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
          focus: 'Legs (Volume Focus)',
          exercises: [
            Exercise.accessory(
              name: 'Front Squat',
              liftType: LiftType.frontSquat,
              sets: 4,
              reps: 10,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Hack Squat',
              liftType: LiftType.squat,
              sets: 3,
              reps: 12,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Walking Lunges',
              liftType: LiftType.other,
              sets: 3,
              reps: 20,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 3,
              notes: '10 steps each leg',
            ),
            Exercise.accessory(
              name: 'Leg Extension',
              liftType: LiftType.legExtension,
              sets: 4,
              reps: 15,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 60,
              order: 4,
            ),
            Exercise.accessory(
              name: 'Lying Leg Curl',
              liftType: LiftType.legCurl,
              sets: 4,
              reps: 12,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 60,
              order: 5,
            ),
            Exercise.accessory(
              name: 'Seated Calf Raises',
              liftType: LiftType.calfRaise,
              sets: 4,
              reps: 15,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 45,
              order: 6,
              notes: 'Pause at stretch',
            ),
          ],
        ),

        // SUNDAY - Rest
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createDeloadWeek(int weekNumber) {
    return ProgramWeek.deload(
      weekNumber: weekNumber,
      phase: Phase.deload,
      dailyWorkouts: [
        DailyWorkout.restDay(dayId: 'mon', dayName: 'Monday', dayNumber: 1),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Get all bodybuilding templates
  static List<WorkoutProgram> getAllTemplates() {
    return [
      classicBroSplit,
      pushPullLegs,
    ];
  }
}
