import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/lift_type.dart';

class PowerliftingTemplates {
  /// Beginner Linear Progression - 12 weeks
  /// 3x per week: Squat/Bench/Deadlift focus
  static WorkoutProgram get beginnerLinearProgression {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'pl_beginner_lp',
      name: 'Beginner Linear Progression',
      sport: Sport.powerlifting,
      description:
          'Perfect for beginners. Classic 3x per week full-body program focused on the main lifts with progressive overload.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateBeginnerWeeks(),
    );
  }

  static List<ProgramWeek> _generateBeginnerWeeks() {
    List<ProgramWeek> weeks = [];

    // Weeks 1-4: Foundation (RPE 6-7)
    for (int i = 1; i <= 4; i++) {
      weeks.add(_createBeginnerWeek(i, 6.0, 7.5, Phase.hypertrophy));
    }

    // Week 5: Deload
    weeks.add(_createDeloadWeek(5));

    // Weeks 6-9: Strength building (RPE 7-8.5)
    for (int i = 6; i <= 9; i++) {
      weeks.add(_createBeginnerWeek(i, 7.0, 8.5, Phase.strength));
    }

    // Week 10: Deload
    weeks.add(_createDeloadWeek(10));

    // Weeks 11-12: Peak (RPE 8-9)
    for (int i = 11; i <= 12; i++) {
      weeks.add(_createBeginnerWeek(i, 8.0, 9.0, Phase.peaking));
    }

    return weeks;
  }

  static ProgramWeek _createBeginnerWeek(
    int weekNumber,
    double rpeMin,
    double rpeMax,
    Phase phase,
  ) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: phase,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - SQUAT + BENCH PRIMARY
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Squat & Bench Press Primary',
          exercises: [
            Exercise.mainLift(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'Bar on upper back, chest up',
                'Break at hips and knees together',
                'Depth: hip crease below knee',
                'Drive through heels',
              ],
            ),
            Exercise.mainLift(
              name: 'Bench Press',
              liftType: LiftType.benchPress,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 2,
              formCues: [
                'Feet flat on floor',
                'Retract shoulder blades',
                'Bar touches mid-chest',
                'Elbows 45-degree angle',
              ],
            ),
            Exercise.accessory(
              name: 'Barbell Row',
              liftType: LiftType.bentOverRow,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 120,
              order: 3,
            ),
          ],
        ),

        // TUESDAY - REST
        DailyWorkout.restDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
        ),

        // WEDNESDAY - DEADLIFT + OVERHEAD PRESS PRIMARY
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Deadlift & Overhead Press Primary',
          exercises: [
            Exercise.mainLift(
              name: 'Deadlift',
              liftType: LiftType.deadlift,
              sets: 1,
              reps: 5,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax + 1.0,
              restSeconds: 240,
              order: 1,
              formCues: [
                'Hip-width stance',
                'Grip just outside legs',
                'Chest up, lats engaged',
                'Push floor away',
              ],
            ),
            Exercise.mainLift(
              name: 'Overhead Press',
              liftType: LiftType.overheadPress,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Romanian Deadlift',
              liftType: LiftType.romanianDeadlift,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 120,
              order: 3,
            ),
          ],
        ),

        // THURSDAY - REST
        DailyWorkout.restDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
        ),

        // FRIDAY - SQUAT + BENCH SECONDARY (Volume)
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Volume Day - Squat & Bench Secondary',
          exercises: [
            Exercise.accessory(
              name: 'Back Squat (Volume)',
              liftType: LiftType.squat,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 150,
              order: 1,
              notes: 'Use 70-80% of Monday\'s weight',
            ),
            Exercise.accessory(
              name: 'Bench Press (Volume)',
              liftType: LiftType.benchPress,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 150,
              order: 2,
              notes: 'Use 70-80% of Monday\'s weight',
            ),
            Exercise.accessory(
              name: 'Pull-ups',
              liftType: LiftType.pullUp,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 120,
              order: 3,
            ),
          ],
        ),

        // WEEKEND - REST
        DailyWorkout.restDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
        ),
        DailyWorkout.restDay(
          dayId: 'sun',
          dayName: 'Sunday',
          dayNumber: 7,
        ),
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
          focus: 'Light Technique Work',
          exercises: [
            Exercise.accessory(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 2,
              reps: 5,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: 'Focus on form, 50-60% of max',
            ),
            Exercise.accessory(
              name: 'Bench Press',
              liftType: LiftType.benchPress,
              sets: 2,
              reps: 5,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 2,
              notes: 'Focus on form, 50-60% of max',
            ),
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

  /// Intermediate Block Periodization - 16 weeks
  /// 4x per week: Upper/Lower split with peaking
  static WorkoutProgram get intermediateBlockPeriodization {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'pl_intermediate_block',
      name: 'Intermediate Block Periodization',
      sport: Sport.powerlifting,
      description:
          '16-week program with accumulation, intensification, and peaking phases. Ideal for those with 1-2 years of experience.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateIntermediateWeeks(),
    );
  }

  static List<ProgramWeek> _generateIntermediateWeeks() {
    List<ProgramWeek> weeks = [];

    // Block 1: Accumulation (Weeks 1-6) - Higher volume, RPE 7-8
    for (int i = 1; i <= 6; i++) {
      weeks.add(_createIntermediateWeek(i, 7.0, 8.0, Phase.hypertrophy));
    }

    // Deload
    weeks.add(_createDeloadWeek(7));

    // Block 2: Intensification (Weeks 8-13) - Higher intensity, RPE 8-9
    for (int i = 8; i <= 13; i++) {
      weeks.add(_createIntermediateWeek(i, 8.0, 9.0, Phase.strength));
    }

    // Deload
    weeks.add(_createDeloadWeek(14));

    // Block 3: Peaking (Weeks 15-16) - Max intensity, RPE 9-10
    for (int i = 15; i <= 16; i++) {
      weeks.add(_createIntermediateWeek(i, 9.0, 10.0, Phase.peaking));
    }

    return weeks;
  }

  static ProgramWeek _createIntermediateWeek(
    int weekNumber,
    double rpeMin,
    double rpeMax,
    Phase phase,
  ) {
    // Implementation similar to beginner but with 4-day upper/lower split
    // This is simplified - you'd expand this fully
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: phase,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // Day 1: Lower Power
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Lower Power',
          exercises: [
            Exercise.mainLift(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 4,
              reps: 4,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              order: 1,
            ),
            Exercise.mainLift(
              name: 'Deadlift',
              liftType: LiftType.deadlift,
              sets: 3,
              reps: 4,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              order: 2,
            ),
          ],
        ),
        // Day 2: Upper Power
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Upper Power',
          exercises: [
            Exercise.mainLift(
              name: 'Bench Press',
              liftType: LiftType.benchPress,
              sets: 4,
              reps: 4,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Barbell Row',
              liftType: LiftType.bentOverRow,
              sets: 4,
              reps: 6,
              order: 2,
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),
        // Day 3: Lower Hypertrophy
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Lower Hypertrophy',
          exercises: [
            Exercise.accessory(
              name: 'Front Squat',
              liftType: LiftType.frontSquat,
              sets: 4,
              reps: 8,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Romanian Deadlift',
              liftType: LiftType.romanianDeadlift,
              sets: 3,
              reps: 10,
              order: 2,
            ),
          ],
        ),
        // Day 4: Upper Hypertrophy
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Upper Hypertrophy',
          exercises: [
            Exercise.accessory(
              name: 'Incline Bench Press',
              liftType: LiftType.inclineBench,
              sets: 4,
              reps: 8,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Pull-ups',
              liftType: LiftType.pullUp,
              sets: 4,
              reps: 8,
              order: 2,
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Advanced DUP - 12 weeks
  /// Daily Undulating Periodization
  static WorkoutProgram get advancedDUP {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'pl_advanced_dup',
      name: 'Advanced DUP',
      sport: Sport.powerlifting,
      description:
          'Daily Undulating Periodization for advanced lifters. Varies intensity and volume day-to-day for maximum gains.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateAdvancedDUPWeeks(),
    );
  }

  static List<ProgramWeek> _generateAdvancedDUPWeeks() {
    // Implementation for DUP - varies rep ranges and intensity daily
    // Simplified here
    return [];
  }

  /// Get all powerlifting templates
  static List<WorkoutProgram> getAllTemplates() {
    return [
      beginnerLinearProgression,
      intermediateBlockPeriodization,
      advancedDUP,
    ];
  }
}
