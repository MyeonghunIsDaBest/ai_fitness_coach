import '../../domain/models/workout_program.dart';
import '../../domain/models/program_week.dart';
import '../../domain/models/daily_workout.dart';
import '../../domain/models/exercise.dart';
import '../../core/enums/sport.dart';
import '../../core/enums/phase.dart';
import '../../core/enums/lift_type.dart';

class OlympicLiftingTemplates {
  /// Beginner Technique Program - 8 weeks
  /// Focus on learning the snatch and clean & jerk with light weights
  static WorkoutProgram get beginnerTechnique {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'oly_beginner_technique',
      name: 'Beginner Technique',
      sport: Sport.olympicLifting,
      description:
          '8-week program for learning Olympic lift technique. Light weights, high reps, focus on positions and timing.',
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
    // Progressive RPE through the program
    final rpeMin = 5.0 + (weekNumber * 0.25);
    final rpeMax = 6.5 + (weekNumber * 0.25);

    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.hypertrophy,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        // MONDAY - Snatch Technique
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Snatch Technique',
          exercises: [
            Exercise.accessory(
              name: 'Snatch Grip Deadlift',
              liftType: LiftType.deadlift,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 1,
              notes: 'Focus on back angle and bar path',
            ),
            Exercise.accessory(
              name: 'Hang Snatch High Pull',
              liftType: LiftType.snatch,
              sets: 4,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 2,
              notes: 'Elbows high, bar close to body',
            ),
            Exercise.accessory(
              name: 'Power Snatch from Hang',
              liftType: LiftType.snatch,
              sets: 5,
              reps: 3,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 3,
              notes: 'Light weight, focus on speed under bar',
            ),
            Exercise.accessory(
              name: 'Overhead Squat',
              liftType: LiftType.squat,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 4,
              notes: 'Build overhead stability',
            ),
          ],
        ),

        // TUESDAY - Rest
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),

        // WEDNESDAY - Clean Technique
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Clean Technique',
          exercises: [
            Exercise.accessory(
              name: 'Clean Grip Deadlift',
              liftType: LiftType.deadlift,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 1,
              notes: 'Maintain vertical torso on pull',
            ),
            Exercise.accessory(
              name: 'Hang Clean High Pull',
              liftType: LiftType.clean,
              sets: 4,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 2,
              notes: 'Explosive hip extension',
            ),
            Exercise.accessory(
              name: 'Power Clean from Hang',
              liftType: LiftType.clean,
              sets: 5,
              reps: 3,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 3,
              notes: 'Fast elbows, strong rack position',
            ),
            Exercise.accessory(
              name: 'Front Squat',
              liftType: LiftType.frontSquat,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 4,
              notes: 'Build leg strength for clean',
            ),
          ],
        ),

        // THURSDAY - Rest
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),

        // FRIDAY - Jerk + Full Lifts
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Jerk & Full Lifts',
          exercises: [
            Exercise.accessory(
              name: 'Push Press',
              liftType: LiftType.overheadPress,
              sets: 4,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 1,
              notes: 'Build dip and drive pattern',
            ),
            Exercise.accessory(
              name: 'Push Jerk',
              liftType: LiftType.jerk,
              sets: 4,
              reps: 3,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 2,
              notes: 'Quick feet, strong lockout',
            ),
            Exercise.accessory(
              name: 'Power Snatch',
              liftType: LiftType.snatch,
              sets: 4,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 3,
              notes: 'Full lift from floor',
            ),
            Exercise.accessory(
              name: 'Power Clean & Push Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 4,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 150,
              order: 4,
              notes: 'Connect the movements',
            ),
          ],
        ),

        // SATURDAY - Accessory & Mobility
        DailyWorkout.trainingDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
          focus: 'Accessory & Mobility',
          exercises: [
            Exercise.accessory(
              name: 'Snatch Balance',
              liftType: LiftType.snatch,
              sets: 3,
              reps: 5,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 90,
              order: 1,
              notes: 'Build speed under bar',
            ),
            Exercise.accessory(
              name: 'Romanian Deadlift',
              liftType: LiftType.romanianDeadlift,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Strict Press',
              liftType: LiftType.overheadPress,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Hip & Ankle Mobility',
              liftType: LiftType.other,
              sets: 1,
              reps: 15,
              restSeconds: 0,
              order: 4,
              notes: 'Deep squat holds, ankle stretches',
            ),
          ],
        ),

        // SUNDAY - Rest
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Intermediate Strength Program - 12 weeks
  /// Build strength in the classic lifts with periodized intensity
  static WorkoutProgram get intermediateStrength {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'oly_intermediate_strength',
      name: 'Intermediate Strength',
      sport: Sport.olympicLifting,
      description:
          '12-week program for intermediate lifters. Build strength in snatch and clean & jerk with periodized training.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateIntermediateWeeks(),
    );
  }

  static List<ProgramWeek> _generateIntermediateWeeks() {
    List<ProgramWeek> weeks = [];

    // Accumulation Phase (Weeks 1-4)
    for (int i = 1; i <= 4; i++) {
      weeks.add(_createIntermediateWeek(i, Phase.hypertrophy, 7.0, 8.0));
    }

    // Intensification Phase (Weeks 5-8)
    for (int i = 5; i <= 8; i++) {
      weeks.add(_createIntermediateWeek(i, Phase.strength, 8.0, 9.0));
    }

    // Peaking Phase (Weeks 9-11)
    for (int i = 9; i <= 11; i++) {
      weeks.add(_createIntermediateWeek(i, Phase.peaking, 9.0, 9.5));
    }

    // Deload (Week 12)
    weeks.add(_createOlyDeloadWeek(12));

    return weeks;
  }

  static ProgramWeek _createIntermediateWeek(
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
        // MONDAY - Snatch Day
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Snatch Focus',
          exercises: [
            Exercise.mainLift(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 6,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'First pull: maintain back angle',
                'Second pull: explosive extension',
                'Third pull: fast turnover',
              ],
            ),
            Exercise.accessory(
              name: 'Snatch Pull',
              liftType: LiftType.snatch,
              sets: 4,
              reps: 3,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 150,
              order: 2,
              notes: '100-110% of snatch max',
            ),
            Exercise.accessory(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 4,
              reps: 4,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 3,
            ),
          ],
        ),

        // TUESDAY - Clean & Jerk Day
        DailyWorkout.trainingDay(
          dayId: 'tue',
          dayName: 'Tuesday',
          dayNumber: 2,
          focus: 'Clean & Jerk Focus',
          exercises: [
            Exercise.mainLift(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 6,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
              formCues: [
                'Clean: fast elbows, solid rack',
                'Jerk: aggressive dip and drive',
                'Split: front shin vertical',
              ],
            ),
            Exercise.accessory(
              name: 'Clean Pull',
              liftType: LiftType.clean,
              sets: 4,
              reps: 3,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 150,
              order: 2,
              notes: '100-110% of clean max',
            ),
            Exercise.accessory(
              name: 'Front Squat',
              liftType: LiftType.frontSquat,
              sets: 4,
              reps: 3,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 3,
            ),
          ],
        ),

        // WEDNESDAY - Rest
        DailyWorkout.restDay(dayId: 'wed', dayName: 'Wednesday', dayNumber: 3),

        // THURSDAY - Power Variants
        DailyWorkout.trainingDay(
          dayId: 'thu',
          dayName: 'Thursday',
          dayNumber: 4,
          focus: 'Power Variants & Accessories',
          exercises: [
            Exercise.accessory(
              name: 'Power Snatch',
              liftType: LiftType.snatch,
              sets: 5,
              reps: 2,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 150,
              order: 1,
              notes: 'Work on speed and timing',
            ),
            Exercise.accessory(
              name: 'Power Clean',
              liftType: LiftType.clean,
              sets: 5,
              reps: 2,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 150,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Push Press',
              liftType: LiftType.overheadPress,
              sets: 4,
              reps: 5,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 120,
              order: 3,
            ),
            Exercise.accessory(
              name: 'Pull-ups',
              liftType: LiftType.pullUp,
              sets: 3,
              reps: 8,
              restSeconds: 90,
              order: 4,
            ),
          ],
        ),

        // FRIDAY - Heavy Singles/Doubles
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Heavy Day',
          exercises: [
            Exercise.mainLift(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 5,
              reps: 1,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 210,
              order: 1,
              formCues: ['Build to heavy single'],
            ),
            Exercise.mainLift(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 5,
              reps: 1,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 210,
              order: 2,
              formCues: ['Build to heavy single'],
            ),
            Exercise.accessory(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 3,
              reps: 2,
              targetRPEMin: rpeMin + 0.5,
              targetRPEMax: rpeMax + 0.5,
              restSeconds: 210,
              order: 3,
            ),
          ],
        ),

        // SATURDAY - Accessory
        DailyWorkout.trainingDay(
          dayId: 'sat',
          dayName: 'Saturday',
          dayNumber: 6,
          focus: 'Accessory Work',
          exercises: [
            Exercise.accessory(
              name: 'Snatch High Pull',
              liftType: LiftType.snatch,
              sets: 4,
              reps: 4,
              targetRPEMin: rpeMin - 0.5,
              targetRPEMax: rpeMax - 0.5,
              restSeconds: 90,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Romanian Deadlift',
              liftType: LiftType.romanianDeadlift,
              sets: 3,
              reps: 8,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 90,
              order: 2,
            ),
            Exercise.accessory(
              name: 'Good Mornings',
              liftType: LiftType.other,
              sets: 3,
              reps: 10,
              restSeconds: 90,
              order: 3,
              notes: 'Posterior chain strength',
            ),
            Exercise.accessory(
              name: 'Core Work',
              liftType: LiftType.other,
              sets: 3,
              reps: 15,
              restSeconds: 60,
              order: 4,
              notes: 'Planks, ab wheel, hanging leg raises',
            ),
          ],
        ),

        // SUNDAY - Rest
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createOlyDeloadWeek(int weekNumber) {
    return ProgramWeek.deload(
      weekNumber: weekNumber,
      phase: Phase.deload,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Light Technique',
          exercises: [
            Exercise.accessory(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 3,
              reps: 2,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: '60% of max',
            ),
            Exercise.accessory(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 3,
              reps: 2,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 2,
              notes: '60% of max',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Light Squats',
          exercises: [
            Exercise.accessory(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 3,
              reps: 5,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: '60% of max',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Competition Peaking Program - 6 weeks
  /// Final preparation for a weightlifting competition
  static WorkoutProgram get competitionPeaking {
    final now = DateTime.now();

    return WorkoutProgram(
      id: 'oly_competition_peaking',
      name: 'Competition Peaking',
      sport: Sport.olympicLifting,
      description:
          '6-week peaking program for weightlifting competition. Builds to heavy singles with strategic deload.',
      startDate: now,
      createdAt: now,
      updatedAt: now,
      weeks: _generateCompetitionWeeks(),
    );
  }

  static List<ProgramWeek> _generateCompetitionWeeks() {
    List<ProgramWeek> weeks = [];

    // Weeks 1-2: Build intensity
    weeks.add(_createCompWeek(1, 8.5, 9.0));
    weeks.add(_createCompWeek(2, 9.0, 9.5));

    // Week 3: Max out week
    weeks.add(_createMaxWeek(3));

    // Week 4: Back off
    weeks.add(_createCompWeek(4, 8.0, 8.5));

    // Week 5: Opener practice
    weeks.add(_createOpenerWeek(5));

    // Week 6: Competition week
    weeks.add(_createCompetitionWeek(6));

    return weeks;
  }

  static ProgramWeek _createCompWeek(int weekNumber, double rpeMin, double rpeMax) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.peaking,
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Snatch',
          exercises: [
            Exercise.mainLift(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 6,
              reps: 1,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Back Squat',
              liftType: LiftType.squat,
              sets: 3,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 2,
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Clean & Jerk',
          exercises: [
            Exercise.mainLift(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 6,
              reps: 1,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 1,
            ),
            Exercise.accessory(
              name: 'Front Squat',
              liftType: LiftType.frontSquat,
              sets: 3,
              reps: 2,
              targetRPEMin: rpeMin,
              targetRPEMax: rpeMax,
              restSeconds: 180,
              order: 2,
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.trainingDay(
          dayId: 'fri',
          dayName: 'Friday',
          dayNumber: 5,
          focus: 'Both Lifts Light',
          exercises: [
            Exercise.accessory(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 4,
              reps: 1,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 150,
              order: 1,
              notes: 'Speed focus',
            ),
            Exercise.accessory(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 4,
              reps: 1,
              targetRPEMin: rpeMin - 1.0,
              targetRPEMax: rpeMax - 1.0,
              restSeconds: 150,
              order: 2,
              notes: 'Speed focus',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createMaxWeek(int weekNumber) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.peaking,
      targetRPEMin: 9.5,
      targetRPEMax: 10.0,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Max Snatch',
          exercises: [
            Exercise.mainLift(
              name: 'Snatch - Max Attempt',
              liftType: LiftType.snatch,
              sets: 8,
              reps: 1,
              targetRPEMin: 9.5,
              targetRPEMax: 10.0,
              restSeconds: 240,
              order: 1,
              formCues: ['Build to max, 3 attempts at PR weight'],
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Max Clean & Jerk',
          exercises: [
            Exercise.mainLift(
              name: 'Clean & Jerk - Max Attempt',
              liftType: LiftType.cleanAndJerk,
              sets: 8,
              reps: 1,
              targetRPEMin: 9.5,
              targetRPEMax: 10.0,
              restSeconds: 240,
              order: 1,
              formCues: ['Build to max, 3 attempts at PR weight'],
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createOpenerWeek(int weekNumber) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.peaking,
      targetRPEMin: 8.0,
      targetRPEMax: 8.5,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Opener Practice',
          exercises: [
            Exercise.accessory(
              name: 'Snatch to Opener',
              liftType: LiftType.snatch,
              sets: 5,
              reps: 1,
              targetRPEMin: 8.0,
              targetRPEMax: 8.5,
              restSeconds: 180,
              order: 1,
              notes: 'Practice your planned opener',
            ),
            Exercise.accessory(
              name: 'Clean & Jerk to Opener',
              liftType: LiftType.cleanAndJerk,
              sets: 5,
              reps: 1,
              targetRPEMin: 8.0,
              targetRPEMax: 8.5,
              restSeconds: 180,
              order: 2,
              notes: 'Practice your planned opener',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
        DailyWorkout.trainingDay(
          dayId: 'wed',
          dayName: 'Wednesday',
          dayNumber: 3,
          focus: 'Light Touch',
          exercises: [
            Exercise.accessory(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 3,
              reps: 1,
              targetRPEMin: 6.0,
              targetRPEMax: 7.0,
              restSeconds: 120,
              order: 1,
              notes: '70% - stay sharp',
            ),
            Exercise.accessory(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 3,
              reps: 1,
              targetRPEMin: 6.0,
              targetRPEMax: 7.0,
              restSeconds: 120,
              order: 2,
              notes: '70% - stay sharp',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'thu', dayName: 'Thursday', dayNumber: 4),
        DailyWorkout.restDay(dayId: 'fri', dayName: 'Friday', dayNumber: 5),
        DailyWorkout.restDay(dayId: 'sat', dayName: 'Saturday', dayNumber: 6),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  static ProgramWeek _createCompetitionWeek(int weekNumber) {
    return ProgramWeek.normal(
      weekNumber: weekNumber,
      phase: Phase.peaking,
      targetRPEMin: 10.0,
      targetRPEMax: 10.0,
      dailyWorkouts: [
        DailyWorkout.trainingDay(
          dayId: 'mon',
          dayName: 'Monday',
          dayNumber: 1,
          focus: 'Final Touch',
          exercises: [
            Exercise.accessory(
              name: 'Snatch',
              liftType: LiftType.snatch,
              sets: 3,
              reps: 1,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 1,
              notes: '60% - just movement',
            ),
            Exercise.accessory(
              name: 'Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 3,
              reps: 1,
              targetRPEMin: 5.0,
              targetRPEMax: 6.0,
              order: 2,
              notes: '60% - just movement',
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'tue', dayName: 'Tuesday', dayNumber: 2),
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
            Exercise.mainLift(
              name: 'Competition - Snatch',
              liftType: LiftType.snatch,
              sets: 3,
              reps: 1,
              targetRPEMin: 10.0,
              targetRPEMax: 10.0,
              order: 1,
              formCues: ['Make your openers, execute the plan'],
            ),
            Exercise.mainLift(
              name: 'Competition - Clean & Jerk',
              liftType: LiftType.cleanAndJerk,
              sets: 3,
              reps: 1,
              targetRPEMin: 10.0,
              targetRPEMax: 10.0,
              order: 2,
              formCues: ['Make your openers, execute the plan'],
            ),
          ],
        ),
        DailyWorkout.restDay(dayId: 'sun', dayName: 'Sunday', dayNumber: 7),
      ],
    );
  }

  /// Get all Olympic lifting templates
  static List<WorkoutProgram> getAllTemplates() {
    return [
      beginnerTechnique,
      intermediateStrength,
      competitionPeaking,
    ];
  }
}
