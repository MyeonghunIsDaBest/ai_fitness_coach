import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/lift_type.dart';

class CrossFitTemplates {
  /// Beginner CrossFit Fundamentals - 8 weeks
  /// Focus: Olympic lifts, gymnastics, metabolic conditioning
  static WorkoutProgram get beginnerFundamentals {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'cf_beginner_fundamentals',
      name: 'CrossFit Fundamentals',
      sport: Sport.crossfit,
      description:
          '8-week program teaching Olympic lifts, gymnastics movements, and metabolic conditioning. Perfect for CrossFit beginners.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateBeginnerWeeks(),
    );
  }

  static List<ProgramWeek> _generateBeginnerWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 8; i++) {
      weeks.add(_createBeginnerWeek(i));
    }

    return weeks;
  }

  static ProgramWeek _createBeginnerWeek(int weekNumber) {
    final rpeMin = 7.0 + (weekNumber * 0.1); // Progressive RPE
    final rpeMax = 8.0 + (weekNumber * 0.1);

    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.hypertrophy,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - Olympic Lifting + Skill Work
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Olympic Lifting & Gymnastics',
          exercises: [
            Exercise.mainLift(
              name: 'Power Clean',
              liftType: LiftType.clean,
              sets: 5,
              reps: 3,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'Start with bar over midfoot',
                'Explosive hip extension',
                'Catch in quarter squat',
                'Fast elbows',
              ],
            ),
            Exercise.accessory(
              name: 'Pull-ups (Strict)',
              liftType: LiftType.pullUp,
              sets: 4,
              reps: 5,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 120,
              order: 2,
              notes: 'Focus on control, scale with band if needed',
            ),
            Exercise.accessory(
              name: 'Hollow Holds',
              liftType: LiftType.other,
              sets: 3,
              reps: 30, // seconds
              restSeconds: 60,
              order: 3,
              notes: 'Core stability work',
            ),
          ],
        ),

        // TUESDAY - MetCon (Metabolic Conditioning)
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Metabolic Conditioning',
          exercises: [
            // WOD: "Cindy" - 20min AMRAP
            Exercise.accessory(
              name: 'Cindy (AMRAP 20min)',
              liftType: LiftType.other,
              sets: 1,
              reps: 20, // minutes
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax + 1.0,
              restSeconds: 0,
              order: 1,
              notes: '5 Pull-ups, 10 Push-ups, 15 Air Squats per round',
            ),
          ],
        ),

        // WEDNESDAY - Active Recovery
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Active Recovery & Mobility',
          exercises: [
            Exercise.accessory(
              name: 'Rowing',
              liftType: LiftType.rowing,
              sets: 1,
              reps: 2000, // meters
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: 'Easy pace, focus on form',
            ),
            Exercise.accessory(
              name: 'Mobility Work',
              liftType: LiftType.other,
              sets: 1,
              reps: 20, // minutes
              restSeconds: 0,
              order: 2,
              notes: 'Hip, shoulder, and ankle mobility',
            ),
          ],
        ),

        // THURSDAY - Heavy Day (Strength Focus)
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Heavy Squats & Push',
          exercises: [
            Exercise.mainLift(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 5,
              reps: 3,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 180,
              order: 1,
            ),
            Exercise.mainLift(
              name: 'Shoulder Press',
              liftType: LiftType.overheadPress,
              sets: 4,
              reps: 6,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 150,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Dips',
              liftType: LiftType.dip,
              sets: 3,
              reps: 8,
              restSeconds: 120,
              order: 3,
            ),
          ],
        ),

        // FRIDAY - Olympic Lifting + Short MetCon
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Snatch & HIIT',
          exercises: [
            Exercise.mainLift(
              name: 'Power Snatch',
              liftType: LiftType.snatch,
              sets: 5,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'Wide grip (snatch grip)',
                'Explosive triple extension',
                'Punch under the bar',
                'Lock out overhead',
              ],
            ),
            Exercise.accessory(
              name: 'AMRAP 12min',
              liftType: LiftType.other,
              sets: 1,
              reps: 12, // minutes
              targetRPEMin: rpeMin + 1.5,
              targetRPEMax: rpeMax + 1.5,
              restSeconds: 0,
              order: 2,
              notes: '10 Thrusters (95/65), 15 Box Jumps, 20 Wall Balls',
            ),
          ],
        ),

        // SATURDAY - Benchmark WOD
        DailyWorkout.trainingDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
          focus: 'Benchmark WOD',
          exercises: [
            Exercise.accessory(
              name: 'Fran (21-15-9)',
              liftType: LiftType.other,
              sets: 1,
              reps: 1, // for time
              targetRPEMin: rpeMin + 2.0,
              targetRPEMax: 10.0,
              restSeconds: 0,
              order: 1,
              notes: 'Thrusters (95/65) + Pull-ups, for time',
            ),
          ],
        ),

        // SUNDAY - Rest
        DailyWorkout.restDay(
          dayId: 'sun',
          dayName: 'Sunday',
          dayNumber: 7,
        ),
      ],
    );
  }

  /// Intermediate Competition Prep - 12 weeks
  /// Prepares for local CrossFit competitions
  static WorkoutProgram get intermediateCompPrep {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'cf_intermediate_comp',
      name: 'Competition Prep',
      sport: Sport.crossfit,
      description:
          '12-week program preparing you for local CrossFit competitions. Includes all 10 fitness domains.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateCompPrepWeeks(),
    );
  }

  static List<ProgramWeek> _generateCompPrepWeeks() {
    // Implementation similar to beginner but more advanced
    return [];
  }

  /// Hyrox Training Program - 10 weeks
  /// Specific for Hyrox competitions
  static WorkoutProgram get hyroxTraining {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'cf_hyrox',
      name: 'Hyrox Training',
      sport: Sport.crossfit,
      description:
          '10-week program specifically designed for Hyrox competitions. Mix of running and functional fitness stations.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateHyroxWeeks(),
    );
  }

  static List<ProgramWeek> _generateHyroxWeeks() {
    List<ProgramWeek> weeks = [];

    for (int i = 1; i <= 10; i++) {
      weeks.add(_createHyroxWeek(i));
    }

    return weeks;
  }

  static ProgramWeek _createHyroxWeek(int weekNumber) {
    final rpeMin = 7.5;
    final rpeMax = 9.0;

    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.strength,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - Run + Ski Erg
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Running & Ski Erg',
          exercises: [
            Exercise.accessory(
              name: '1km Run Intervals',
              liftType: LiftType.running,
              sets: 4,
              reps: 1000, // meters
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              notes: 'Hyrox pace - 4-5 min/km',
            ),
            Exercise.accessory(
              name: 'Ski Erg',
              liftType: LiftType.rowing,
              sets: 5,
              reps: 500, // meters
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 120,
              order: 2,
              notes: 'Max effort',
            ),
          ],
        ),

        // TUESDAY - Sled Push/Pull + Strength
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Sled Work & Strength',
          exercises: [
            Exercise.accessory(
              name: 'Sled Push',
              liftType: LiftType.other,
              sets: 6,
              reps: 50, // meters
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax + 1.0,
              restSeconds: 120,
              order: 1,
              notes: 'Hyrox weight - Male: 152kg, Female: 103kg',
            ),
            Exercise.mainLift(
              name: 'Squat',
              liftType: LiftType.squat,
              sets: 4,
              reps: 6,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 150,
              order: 2,
            ),
          ],
        ),

        // WEDNESDAY - Active Recovery
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Active Recovery',
          exercises: [
            Exercise.accessory(
              name: 'Easy Run',
              liftType: LiftType.running,
              sets: 1,
              reps: 5000, // meters
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: 'Conversational pace',
            ),
          ],
        ),

        // THURSDAY - Burpee Broad Jump + Rowing
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Burpees & Rowing',
          exercises: [
            Exercise.accessory(
              name: 'Burpee Broad Jumps',
              liftType: LiftType.burpee,
              sets: 5,
              reps: 20,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: rpeMax + 1.0,
              restSeconds: 90,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Rowing Intervals',
              liftType: LiftType.rowing,
              sets: 4,
              reps: 500, // meters
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 2,
            ),
          ],
        ),

        // FRIDAY - Full Hyrox Simulation (scaled)
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Hyrox Simulation',
          exercises: [
            Exercise.accessory(
              name: 'Hyrox Simulation (Half Distance)',
              liftType: LiftType.other,
              sets: 1,
              reps: 1, // full workout
              targetRPEMin: rpeMin + 1.5,
              targetRPEMax: 10.0,
              restSeconds: 0,
              order: 1,
              notes:
                  'Run 500m, Ski 500m, Sled Push 25m, Burpees x10, Row 500m, Lunges 25m',
            ),
          ],
        ),

        // WEEKEND - Rest
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Get all CrossFit templates
  static List<WorkoutProgram> getAllTemplates() {
    return [
      beginnerFundamentals,
      intermediateCompPrep,
      hyroxTraining,
    ];
  }
}
