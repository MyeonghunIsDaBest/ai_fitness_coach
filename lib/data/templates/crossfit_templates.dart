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
    List<ProgramWeek> weeks = [];

    // Phase 1: Base Building (Weeks 1-4)
    for (int i = 1; i <= 4; i++) {
      weeks.add(_createCompPrepWeek(i, Phase.hypertrophy, 7.0, 8.5));
    }

    // Phase 2: Intensity (Weeks 5-8)
    for (int i = 5; i <= 8; i++) {
      weeks.add(_createCompPrepWeek(i, Phase.strength, 8.0, 9.0));
    }

    // Phase 3: Peaking (Weeks 9-11)
    for (int i = 9; i <= 11; i++) {
      weeks.add(_createCompPrepWeek(i, Phase.peaking, 8.5, 9.5));
    }

    // Week 12: Taper
    weeks.add(_createTaperWeek(12));

    return weeks;
  }

  static ProgramWeek _createCompPrepWeek(
    int weekNumber,
    Phase phase,
    double rpeMin,
    double rpeMax,
  ) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: phase,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - Olympic Lifting Focus
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Olympic Lifting & Strength',
          exercises: [
            Exercise.mainLift(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 5,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'Full depth catch',
                'Fast turnover',
                'Aggressive hip extension',
              ],
            ),
            Exercise.mainLift(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 5,
              reps: 3,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Strict Pull-ups',
              liftType: LiftType.pullUp,
              sets: 4,
              reps: 8,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 3,
              notes: 'Weighted if possible',
            ),
          ],
        ),

        // TUESDAY - MetCon Heavy
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Heavy MetCon',
          exercises: [
            Exercise.accessory(
              name: 'AMRAP 20 min',
              liftType: LiftType.other,
              sets: 1,
              reps: 20,
              targetRPEMin: rpeMin + 1.0,
              targetRPEMax: 10.0,
              restSeconds: 0,
              order: 1,
              notes: '5 Deadlifts (225/155), 10 Box Jumps (24/20), 15 Wall Balls (20/14)',
            ),
            Exercise.accessory(
              name: 'Core Finisher',
              liftType: LiftType.other,
              sets: 3,
              reps: 15,
              restSeconds: 60,
              order: 2,
              notes: 'Toes-to-bar or GHD Sit-ups',
            ),
          ],
        ),

        // WEDNESDAY - Active Recovery + Skills
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Skills & Recovery',
          exercises: [
            Exercise.accessory(
              name: 'Rowing',
              liftType: LiftType.rowing,
              sets: 1,
              reps: 3000,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: 'Easy pace, work on technique',
            ),
            Exercise.accessory(
              name: 'Gymnastics Skills',
              liftType: LiftType.other,
              sets: 4,
              reps: 10,
              restSeconds: 90,
              order: 2,
              notes: 'Handstand practice, muscle-up progressions',
            ),
            Exercise.accessory(
              name: 'Mobility Work',
              liftType: LiftType.other,
              sets: 1,
              reps: 15,
              restSeconds: 0,
              order: 3,
              notes: 'Hip, shoulder, and ankle mobility',
            ),
          ],
        ),

        // THURSDAY - Clean & Jerk + Push
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Clean & Jerk Focus',
          exercises: [
            Exercise.mainLift(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 5,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'Full squat clean',
                'Strong dip and drive',
                'Aggressive lockout',
              ],
            ),
            Exercise.mainLift(
              name: 'Push Press',
              liftType: LiftType.overheadPress,
              sets: 4,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 150,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Ring Dips',
              liftType: LiftType.dip,
              sets: 4,
              reps: 10,
              restSeconds: 90,
              order: 3,
              notes: 'Strict, full ROM',
            ),
          ],
        ),

        // FRIDAY - Competition Simulation
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Competition Simulation',
          exercises: [
            Exercise.accessory(
              name: 'Workout 1: For Time',
              liftType: LiftType.other,
              sets: 1,
              reps: 1,
              targetRPEMin: rpeMin + 1.5,
              targetRPEMax: 10.0,
              restSeconds: 0,
              order: 1,
              notes: '21-15-9: Thrusters (95/65) + Pull-ups',
            ),
            Exercise.accessory(
              name: 'Rest 10 min',
              liftType: LiftType.other,
              sets: 1,
              reps: 10,
              restSeconds: 0,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Workout 2: AMRAP 12',
              liftType: LiftType.other,
              sets: 1,
              reps: 12,
              targetRPEMin: rpeMin + 1.5,
              targetRPEMax: 10.0,
              restSeconds: 0,
              order: 3,
              notes: '6 Power Cleans (135/95), 12 Push-ups, 24 Double Unders',
            ),
          ],
        ),

        // SATURDAY - Long Chipper
        DailyWorkout.trainingDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
          focus: 'Endurance Chipper',
          exercises: [
            Exercise.accessory(
              name: 'Long Chipper (30-40 min)',
              liftType: LiftType.other,
              sets: 1,
              reps: 1,
              targetRPEMin: rpeMin,
              targetRPEMax: 9.0,
              restSeconds: 0,
              order: 1,
              notes: '50 Cal Row, 40 Box Jumps, 30 KB Swings, 20 Burpees, 10 Muscle-ups',
            ),
          ],
        ),

        // SUNDAY - Rest
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createTaperWeek(int weekNumber) {
    return ProgramWeek.deload(
      weekNumber: weekNumber,
      phase: Phase.peaking,
      dailyWorkouts: [
        // Light movement, competition prep
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Light Movement',
          exercises: [
            Exercise.accessory(
              name: 'Light Snatch',
              liftType: LiftType.snatch,
              sets: 3,
              reps: 2,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: '60% of max, focus on speed',
            ),
            Exercise.accessory(
              name: 'Light Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 3,
              reps: 2,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 2,
              notes: '60% of max, focus on speed',
            ),
          ],
        ),
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Short MetCon',
          exercises: [
            Exercise.accessory(
              name: 'AMRAP 8 min (Light)',
              liftType: LiftType.other,
              sets: 1,
              reps: 8,
              targetRPEMin: 6.0,
              targetRPEMax: 7.0,
              order: 1,
              notes: '10 Air Squats, 10 Push-ups, 10 Sit-ups - stay fresh',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
        // COMPETITION DAY
        DailyWorkout.trainingDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
          focus: 'COMPETITION DAY',
          exercises: [
            Exercise.accessory(
              name: 'Competition',
              liftType: LiftType.other,
              sets: 1,
              reps: 1,
              targetRPEMin: 10.0,
              targetRPEMax: 10.0,
              order: 1,
              notes: 'Give it your all!',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
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
