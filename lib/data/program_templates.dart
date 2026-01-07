// Save this as: lib/data/program_templates.dart

import '../domain/models/workout_program.dart';
import '../domain/models/program_week.dart';
import '../domain/models/daily_workout.dart';
import '../domain/models/exercise.dart';
import '../core/enums/sport.dart';
import '../core/enums/phase.dart';
import '../core/enums/lift_type.dart';
import '../data/templates/powerlifting_templates.dart';
import '../data/templates/crossfit_templates.dart';
import '../data/templates/bodybuilding_templates.dart';

/// Pre-built workout program templates
class ProgramTemplates {
  // ============================================================================
  // POWERLIFTING PROGRAMS
  // ============================================================================

  /// Starting Strength - Beginner 12-week program
  static WorkoutProgram get startingStrength {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'template_starting_strength',
      name: 'Starting Strength',
      sport: Sport.powerlifting,
      description:
          'Classic beginner program focusing on the main lifts with linear progression',
      startDate: now,
      updatedAt: now,
      createdAt: now,
      weeks: _generateStartingStrengthWeeks(),
    );
  }

  static List<ProgramWeek> _generateStartingStrengthWeeks() {
    List<ProgramWeek> weeks = [];

    // Week 1-4: Foundation Phase
    for (int i = 1; i <= 4; i++) {
      weeks.add(
        ProgramWeek.normal(
          weekNumber: i,
          phase: Phase.strength,
          targetRPEMin: 7.0,
          targetRPEMax: 8.0,
          dailyWorkouts: [
            // Monday
            DailyWorkout.trainingDay(
              dayId: 'mon',
              dayName: 'Monday',
              dayNumber: 1,
              focus: 'Squat & Press',
              exercises: [
                Exercise.mainLift(
                  name: 'Squat',
                  liftType: LiftType.squat,
                  sets: 3,
                  reps: 5,
                  targetRPEMin: 7.0,
                  targetRPEMax: 8.0,
                  order: 1,
                ),
                Exercise.mainLift(
                  name: 'Overhead Press',
                  liftType: LiftType.overheadPress,
                  sets: 3,
                  reps: 5,
                  targetRPEMin: 7.0,
                  targetRPEMax: 8.0,
                  order: 2,
                ),
                Exercise.accessory(
                  name: 'Chin-ups',
                  liftType: LiftType.pullUp,
                  sets: 3,
                  reps: 8,
                  order: 3,
                ),
              ],
            ),
            // Tuesday - Rest
            DailyWorkout.restDay(
                dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
            // Wednesday
            DailyWorkout.trainingDay(
              dayId: 'wed',
              dayName: 'Wednesday',
              dayNumber: 3,
              focus: 'Deadlift & Bench',
              exercises: [
                Exercise.mainLift(
                  name: 'Squat',
                  liftType: LiftType.squat,
                  sets: 3,
                  reps: 5,
                  targetRPEMin: 7.0,
                  targetRPEMax: 8.0,
                  order: 1,
                ),
                Exercise.mainLift(
                  name: 'Bench Press',
                  liftType: LiftType.benchPress,
                  sets: 3,
                  reps: 5,
                  targetRPEMin: 7.0,
                  targetRPEMax: 8.0,
                  order: 2,
                ),
                Exercise.mainLift(
                  name: 'Deadlift',
                  liftType: LiftType.deadlift,
                  sets: 1,
                  reps: 5,
                  targetRPEMin: 8.0,
                  targetRPEMax: 9.0,
                  order: 3,
                ),
              ],
            ),
            // Thursday - Rest
            DailyWorkout.restDay(
                dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
            // Friday
            DailyWorkout.trainingDay(
              dayId: 'fri',
              dayName: 'Friday',
              dayNumber: 5,
              focus: 'Squat & Press Variation',
              exercises: [
                Exercise.mainLift(
                  name: 'Squat',
                  liftType: LiftType.squat,
                  sets: 3,
                  reps: 5,
                  targetRPEMin: 7.0,
                  targetRPEMax: 8.0,
                  order: 1,
                ),
                Exercise.mainLift(
                  name: 'Overhead Press',
                  liftType: LiftType.overheadPress,
                  sets: 3,
                  reps: 5,
                  targetRPEMin: 7.0,
                  targetRPEMax: 8.0,
                  order: 2,
                ),
                Exercise.accessory(
                  name: 'Barbell Row',
                  liftType: LiftType.bentOverRow,
                  sets: 3,
                  reps: 8,
                  order: 3,
                ),
              ],
            ),
            // Weekend - Rest
            DailyWorkout.restDay(
                dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
            DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
          ],
        ),
      );
    }

    // Week 5: Deload
    weeks.add(
      ProgramWeek.deload(
        weekNumber: 5,
        phase: Phase.deload,
        dailyWorkouts: _generateDeloadWeek(),
      ),
    );

    // Week 6-8: Intermediate progression
    for (int i = 6; i <= 8; i++) {
      weeks.add(
        ProgramWeek.normal(
          weekNumber: i,
          phase: Phase.strength,
          targetRPEMin: 8.0,
          targetRPEMax: 9.0,
          dailyWorkouts: _generateIntermediateWeek(),
        ),
      );
    }

    return weeks;
  }

  static List<DailyWorkout> _generateDeloadWeek() {
    return [
      DailyWorkout.trainingDay(
        dayId: 'mon',
        dayName: 'Monday',
        dayNumber: 1,
        focus: 'Light Squat & Press',
        exercises: [
          Exercise.mainLift(
            name: 'Squat',
            liftType: LiftType.squat,
            sets: 2,
            reps: 5,
            targetRPEMin: 5.0,
            targetRPEMax: 6.0,
            order: 1,
          ),
          Exercise.mainLift(
            name: 'Overhead Press',
            liftType: LiftType.overheadPress,
            sets: 2,
            reps: 5,
            targetRPEMin: 5.0,
            targetRPEMax: 6.0,
            order: 2,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
      DailyWorkout.trainingDay(
        dayId: 'wed',
        dayName: 'Wednesday',
        dayNumber: 3,
        focus: 'Light Bench',
        exercises: [
          Exercise.mainLift(
            name: 'Bench Press',
            liftType: LiftType.benchPress,
            sets: 2,
            reps: 5,
            targetRPEMin: 5.0,
            targetRPEMax: 6.0,
            order: 1,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
      DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
      DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
      DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
    ];
  }

  static List<DailyWorkout> _generateIntermediateWeek() {
    return [
      DailyWorkout.trainingDay(
        dayId: 'mon',
        dayName: 'Monday',
        dayNumber: 1,
        focus: 'Heavy Squat',
        exercises: [
          Exercise.mainLift(
            name: 'Squat',
            liftType: LiftType.squat,
            sets: 4,
            reps: 5,
            targetRPEMin: 8.0,
            targetRPEMax: 9.0,
            order: 1,
          ),
          Exercise.mainLift(
            name: 'Bench Press',
            liftType: LiftType.benchPress,
            sets: 3,
            reps: 5,
            targetRPEMin: 7.5,
            targetRPEMax: 8.5,
            order: 2,
          ),
          Exercise.accessory(
            name: 'Barbell Row',
            liftType: LiftType.bentOverRow,
            sets: 3,
            reps: 8,
            order: 3,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
      DailyWorkout.trainingDay(
        dayId: 'wed',
        dayName: 'Wednesday',
        dayNumber: 3,
        focus: 'Deadlift Day',
        exercises: [
          Exercise.mainLift(
            name: 'Deadlift',
            liftType: LiftType.deadlift,
            sets: 3,
            reps: 5,
            targetRPEMin: 8.0,
            targetRPEMax: 9.0,
            order: 1,
          ),
          Exercise.accessory(
            name: 'Romanian Deadlift',
            liftType: LiftType.romanianDeadlift,
            sets: 3,
            reps: 8,
            order: 2,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
      DailyWorkout.trainingDay(
        dayId: 'fri',
        dayName: 'Friday',
        dayNumber: 5,
        focus: 'Press Day',
        exercises: [
          Exercise.mainLift(
            name: 'Overhead Press',
            liftType: LiftType.overheadPress,
            sets: 3,
            reps: 5,
            targetRPEMin: 8.0,
            targetRPEMax: 9.0,
            order: 1,
          ),
          Exercise.accessory(
            name: 'Incline Bench',
            liftType: LiftType.inclineBench,
            sets: 3,
            reps: 8,
            order: 2,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
      DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
    ];
  }

  // ============================================================================
  // BODYBUILDING PROGRAMS
  // ============================================================================

  /// Upper/Lower Split - 4 days per week
  static WorkoutProgram get upperLowerSplit {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'template_upper_lower',
      name: 'Upper/Lower Split',
      sport: Sport.bodybuilding,
      description: '4-day upper/lower split focused on hypertrophy',
      startDate: now,
      updatedAt: now,
      createdAt: now,
      weeks: _generateUpperLowerWeeks(),
    );
  }

  static List<ProgramWeek> _generateUpperLowerWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 8; i++) {
      // Every 4th week is deload
      if (i % 4 == 0) {
        weeks.add(
          ProgramWeek.deload(
            weekNumber: i,
            phase: Phase.hypertrophy,
            dailyWorkouts: _generateDeloadWeek(),
          ),
        );
      } else {
        weeks.add(
          ProgramWeek.normal(
            weekNumber: i,
            phase: Phase.hypertrophy,
            targetRPEMin: 7.5,
            targetRPEMax: 9.0,
            dailyWorkouts: _generateUpperLowerDays(),
          ),
        );
      }
    }

    return weeks;
  }

  static List<DailyWorkout> _generateUpperLowerDays() {
    return [
      // Monday - Upper Power
      DailyWorkout.trainingDay(
        dayId: 'mon',
        dayName: 'Monday',
        dayNumber: 1,
        focus: 'Upper Power',
        exercises: [
          Exercise.mainLift(
            name: 'Bench Press',
            liftType: LiftType.benchPress,
            sets: 4,
            reps: 5,
            targetRPEMin: 8.0,
            targetRPEMax: 9.0,
            order: 1,
          ),
          Exercise.accessory(
            name: 'Barbell Row',
            liftType: LiftType.bentOverRow,
            sets: 4,
            reps: 6,
            targetRPEMin: 7.5,
            targetRPEMax: 8.5,
            order: 2,
          ),
          Exercise.accessory(
            name: 'Overhead Press',
            liftType: LiftType.overheadPress,
            sets: 3,
            reps: 8,
            order: 3,
          ),
        ],
      ),
      // Tuesday - Lower Power
      DailyWorkout.trainingDay(
        dayId: 'tue',
        dayName: 'Tuesday',
        dayNumber: 2,
        focus: 'Lower Power',
        exercises: [
          Exercise.mainLift(
            name: 'Squat',
            liftType: LiftType.squat,
            sets: 4,
            reps: 5,
            targetRPEMin: 8.0,
            targetRPEMax: 9.0,
            order: 1,
          ),
          Exercise.mainLift(
            name: 'Deadlift',
            liftType: LiftType.deadlift,
            sets: 3,
            reps: 5,
            targetRPEMin: 8.0,
            targetRPEMax: 9.0,
            order: 2,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),
      // Thursday - Upper Hypertrophy
      DailyWorkout.trainingDay(
        dayId: 'thu',
        dayName: 'Thursday',
        dayNumber: 4,
        focus: 'Upper Hypertrophy',
        exercises: [
          Exercise.accessory(
            name: 'Incline Bench',
            liftType: LiftType.inclineBench,
            sets: 4,
            reps: 10,
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
            name: 'Lateral Raises',
            liftType: LiftType.lateralRaise,
            sets: 3,
            reps: 12,
            order: 3,
          ),
        ],
      ),
      // Friday - Lower Hypertrophy
      DailyWorkout.trainingDay(
        dayId: 'fri',
        dayName: 'Friday',
        dayNumber: 5,
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
            sets: 4,
            reps: 10,
            order: 2,
          ),
          Exercise.accessory(
            name: 'Leg Curls',
            liftType: LiftType.legCurl,
            sets: 3,
            reps: 12,
            order: 3,
          ),
        ],
      ),
      DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
      DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
    ];
  }

  // ============================================================================
  // HELPER METHOD
  // ============================================================================

  /// Get all available templates
  static List<WorkoutProgram> getAllTemplates() {
    return [
      startingStrength,
      upperLowerSplit,
    ];
  }
}
