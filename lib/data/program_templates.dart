import '../models/enums.dart';
import '../models/exercise.dart';
import '../models/daily_workout.dart';
import '../models/program_week.dart';
import '../models/workout_program.dart';

class ProgramTemplates {
  // Generate unique IDs for programs
  static String _generateId(Sport sport) => 'program_${sport.name}_12week';

  // Get all available program templates
  static List<WorkoutProgram> getAllTemplates() {
    return [
      getPowerliftingProgram(),
      getCrossFitProgram(),
      getBodybuildingProgram(),
      getOlympicWeightliftingProgram(),
    ];
  }

  // POWERLIFTING 12-WEEK PROGRAM
  static WorkoutProgram getPowerliftingProgram() {
    return WorkoutProgram(
      id: _generateId(Sport.powerlifting),
      name: 'Powerlifting Strength Block',
      sport: Sport.powerlifting,
      totalWeeks: 12,
      description: 'Progressive overload to increase 1RM in Squat, Bench, Deadlift',
      createdAt: DateTime.now(),
      weeks: [
        // Weeks 1-4: Volume Phase
        ...List.generate(4, (i) => _buildPowerliftingWeek(i + 1, Phase.volume)),
        // Weeks 5-8: Strength Phase
        ...List.generate(4, (i) => _buildPowerliftingWeek(i + 5, Phase.strength)),
        // Weeks 9-11: Peak Phase
        ...List.generate(3, (i) => _buildPowerliftingWeek(i + 9, Phase.peak)),
        // Week 12: Deload
        _buildPowerliftingWeek(12, Phase.deload),
      ],
    );
  }

  static ProgramWeek _buildPowerliftingWeek(int week, Phase phase) {
    final config = _getPowerliftingConfig(phase);

    return ProgramWeek(
      weekNumber: week,
      phase: phase,
      intensityRange: config['intensity']!,
      targetRPEMin: config['rpeMin']!,
      targetRPEMax: config['rpeMax']!,
      dailyWorkouts: [
        DailyWorkout(
          day: TrainingDay.monday,
          focus: 'Squat Day',
          exercises: [
            Exercise(
              name: 'Back Squat',
              sets: 4,
              reps: config['reps']!,
              repsMin: config['repsMinInt'],
              repsMax: config['repsMaxInt'],
              intensityPercent: config['intensityPercent'],
              intensityDisplay: config['intensity']!,
              isMain: true,
            ),
            Exercise(name: 'Front Squat', sets: 4, reps: '8-12', repsMin: 8, repsMax: 12, intensityDisplay: 'Moderate'),
            Exercise(name: 'Leg Press', sets: 3, reps: '10-12', repsMin: 10, repsMax: 12, intensityDisplay: 'Moderate'),
            Exercise(name: 'Hamstring Curls', sets: 3, reps: '12', repsMin: 12, repsMax: 12, intensityDisplay: 'Light'),
            Exercise(name: 'Calf Raises', sets: 4, reps: '15', repsMin: 15, repsMax: 15, intensityDisplay: 'Light'),
          ],
        ),
        DailyWorkout(
          day: TrainingDay.tuesday,
          focus: 'Bench Day',
          exercises: [
            Exercise(
              name: 'Bench Press',
              sets: 4,
              reps: config['reps']!,
              repsMin: config['repsMinInt'],
              repsMax: config['repsMaxInt'],
              intensityPercent: config['intensityPercent'],
              intensityDisplay: config['intensity']!,
              isMain: true,
            ),
            Exercise(name: 'Incline DB Press', sets: 4, reps: '8-12', repsMin: 8, repsMax: 12, intensityDisplay: 'Moderate'),
            Exercise(name: 'Chest Fly', sets: 3, reps: '12', repsMin: 12, repsMax: 12, intensityDisplay: 'Light'),
            Exercise(name: 'Triceps Pushdown', sets: 3, reps: '12', repsMin: 12, repsMax: 12, intensityDisplay: 'Light'),
            Exercise(name: 'Dumbbell Rows', sets: 4, reps: '10', repsMin: 10, repsMax: 10, intensityDisplay: 'Moderate'),
          ],
        ),
        DailyWorkout.rest(TrainingDay.wednesday),
        DailyWorkout(
          day: TrainingDay.thursday,
          focus: 'Deadlift Day',
          exercises: [
            Exercise(
              name: 'Deadlift',
              sets: 4,
              reps: config['reps']!,
              repsMin: config['repsMinInt'],
              repsMax: config['repsMaxInt'],
              intensityPercent: config['intensityPercent'],
              intensityDisplay: config['intensity']!,
              isMain: true,
            ),
            Exercise(name: 'Romanian Deadlift', sets: 4, reps: '8', repsMin: 8, repsMax: 8, intensityDisplay: 'Moderate'),
            Exercise(name: 'Barbell Rows', sets: 4, reps: '10', repsMin: 10, repsMax: 10, intensityDisplay: 'Moderate'),
            Exercise(name: 'Pull-Ups', sets: 4, reps: '8-12', repsMin: 8, repsMax: 12, intensityDisplay: 'Bodyweight'),
            Exercise(name: 'Back Extensions', sets: 3, reps: '12', repsMin: 12, repsMax: 12, intensityDisplay: 'Light'),
          ],
        ),
        DailyWorkout(
          day: TrainingDay.friday,
          focus: 'Bench Accessories',
          exercises: [
            Exercise(name: 'Close-Grip Bench', sets: 4, reps: '6-8', repsMin: 6, repsMax: 8, intensityDisplay: 'Moderate'),
            Exercise(name: 'Overhead Press', sets: 3, reps: '8', repsMin: 8, repsMax: 8, intensityDisplay: 'Moderate'),
            Exercise(name: 'Lateral Raises', sets: 3, reps: '15', repsMin: 15, repsMax: 15, intensityDisplay: 'Light'),
            Exercise(name: 'Bicep Curls', sets: 3, reps: '12', repsMin: 12, repsMax: 12, intensityDisplay: 'Light'),
            Exercise(name: 'Face Pulls', sets: 3, reps: '15', repsMin: 15, repsMax: 15, intensityDisplay: 'Light'),
          ],
        ),
        DailyWorkout.rest(TrainingDay.saturday),
        DailyWorkout.rest(TrainingDay.sunday),
      ],
    );
  }

  static Map<String, dynamic> _getPowerliftingConfig(Phase phase) {
    switch (phase) {
      case Phase.volume:
        return {
          'intensity': '65-75%',
          'intensityPercent': 0.70,
          'reps': '8-12',
          'repsMinInt': 8,
          'repsMaxInt': 12,
          'rpeMin': 6,
          'rpeMax': 7,
        };
      case Phase.strength:
        return {
          'intensity': '75-85%',
          'intensityPercent': 0.80,
          'reps': '4-6',
          'repsMinInt': 4,
          'repsMaxInt': 6,
          'rpeMin': 7,
          'rpeMax': 8,
        };
      case Phase.peak:
        return {
          'intensity': '85-95%',
          'intensityPercent': 0.90,
          'reps': '2-4',
          'repsMinInt': 2,
          'repsMaxInt': 4,
          'rpeMin': 8,
          'rpeMax': 9,
        };
      case Phase.deload:
        return {
          'intensity': '60-70%',
          'intensityPercent': 0.65,
          'reps': '3-5',
          'repsMinInt': 3,
          'repsMaxInt': 5,
          'rpeMin': 5,
          'rpeMax': 6,
        };
      default:
        return _getPowerliftingConfig(Phase.volume);
    }
  }

  // CROSSFIT - Simplified for brevity
  static WorkoutProgram getCrossFitProgram() {
    return WorkoutProgram(
      id: _generateId(Sport.crossfit),
      name: 'CrossFit Performance Block',
      sport: Sport.crossfit,
      totalWeeks: 12,
      description: 'Strength, conditioning, and skill development',
      createdAt: DateTime.now(),
      weeks: List.generate(12, (i) => _buildCrossFitWeek(i + 1)),
    );
  }

  static ProgramWeek _buildCrossFitWeek(int week) {
    Phase phase = week <= 4 ? Phase.foundation : week <= 8 ? Phase.strength : Phase.performance;
    int rpeMin = week <= 4 ? 6 : week <= 8 ? 7 : 8;
    int rpeMax = week <= 4 ? 7 : week <= 8 ? 8 : 9;
    
    return ProgramWeek(
      weekNumber: week,
      phase: phase,
      intensityRange: week <= 4 ? '65-75%' : week <= 8 ? '75-85%' : '85-90%',
      targetRPEMin: rpeMin,
      targetRPEMax: rpeMax,
      dailyWorkouts: [
        DailyWorkout(
          day: TrainingDay.monday,
          focus: 'Strength + Short WOD',
          exercises: [
            Exercise(name: 'Back Squat', sets: 4, reps: '5-8', repsMin: 5, repsMax: 8, intensityDisplay: '65-85%', isMain: true),
            Exercise(name: 'Push Press', sets: 4, reps: '5-8', repsMin: 5, repsMax: 8, intensityDisplay: '65-80%', isMain: true),
            Exercise(name: 'WOD: 8-12 min AMRAP', sets: 1, reps: 'Max rounds', intensityDisplay: 'High'),
          ],
        ),
        DailyWorkout(
          day: TrainingDay.tuesday,
          focus: 'Olympic + Medium WOD',
          exercises: [
            Exercise(name: 'Snatch', sets: 5, reps: '3-5', repsMin: 3, repsMax: 5, intensityDisplay: '60-85%', isMain: true),
            Exercise(name: 'Clean & Jerk', sets: 5, reps: '3-5', repsMin: 3, repsMax: 5, intensityDisplay: '60-85%', isMain: true),
          ],
        ),
        DailyWorkout(
          day: TrainingDay.wednesday,
          focus: 'Gymnastics / Skill',
          exercises: [
            Exercise(name: 'Pull-Up Variations', sets: 5, reps: '5-10', repsMin: 5, repsMax: 10, intensityDisplay: 'Bodyweight'),
            Exercise(name: 'Handstand Work', sets: 4, reps: '30-60s', intensityDisplay: 'Skill'),
          ],
        ),
        DailyWorkout(
          day: TrainingDay.thursday,
          focus: 'Strength + Sprints',
          exercises: [
            Exercise(name: 'Deadlift', sets: 4, reps: '4-6', repsMin: 4, repsMax: 6, intensityDisplay: '65-85%', isMain: true),
            Exercise(name: '200m Sprints', sets: 6, reps: '200m', intensityDisplay: 'High'),
          ],
        ),
        DailyWorkout(
          day: TrainingDay.friday,
          focus: 'WOD / Benchmark',
          exercises: [
            Exercise(name: 'Hero WOD or Benchmark', sets: 1, reps: 'For Time', intensityDisplay: 'Max Effort'),
          ],
        ),
        DailyWorkout.rest(TrainingDay.saturday),
        DailyWorkout.rest(TrainingDay.sunday),
      ],
    );
  }

  static WorkoutProgram getBodybuildingProgram() {
    return WorkoutProgram(
      id: _generateId(Sport.bodybuilding),
      name: 'Bodybuilding Hypertrophy',
      sport: Sport.bodybuilding,
      totalWeeks: 12,
      description: 'Muscle growth through progressive volume',
      createdAt: DateTime.now(),
      weeks: List.generate(12, (i) => _buildBodybuildingWeek(i + 1)),
    );
  }

  static ProgramWeek _buildBodybuildingWeek(int week) {
    Phase phase = week <= 6 ? Phase.bulk : Phase.cut;
    return ProgramWeek(
      weekNumber: week,
      phase: phase,
      intensityRange: phase == Phase.bulk ? '65-75%' : 'High Reps',
      targetRPEMin: 7,
      targetRPEMax: week <= 6 ? 8 : 9,
      dailyWorkouts: [
        DailyWorkout(
          day: TrainingDay.monday,
          focus: 'Chest + Triceps',
          exercises: [
            Exercise(name: 'Bench Press', sets: 4, reps: '8-12', repsMin: 8, repsMax: 12, intensityDisplay: '65-75%', isMain: true),
            Exercise(name: 'Incline DB Press', sets: 4, reps: '10', repsMin: 10, repsMax: 10, intensityDisplay: 'Moderate'),
            Exercise(name: 'Cable Fly', sets: 3, reps: '12', repsMin: 12, repsMax: 12, intensityDisplay: 'Light'),
          ],
        ),
        DailyWorkout.rest(TrainingDay.sunday),
      ],
    );
  }

  static WorkoutProgram getOlympicWeightliftingProgram() {
    return WorkoutProgram(
      id: _generateId(Sport.olympicWeightlifting),
      name: 'Olympic Weightlifting',
      sport: Sport.olympicWeightlifting,
      totalWeeks: 12,
      description: 'Improve Snatch & Clean & Jerk technique and strength',
      createdAt: DateTime.now(),
      weeks: List.generate(12, (i) => _buildOlyWeek(i + 1)),
    );
  }

  static ProgramWeek _buildOlyWeek(int week) {
    Phase phase = week <= 4 ? Phase.technique : week <= 8 ? Phase.strength : Phase.peak;
    return ProgramWeek(
      weekNumber: week,
      phase: phase,
      intensityRange: week <= 4 ? '60-70%' : week <= 8 ? '70-85%' : '85-95%',
      targetRPEMin: week <= 4 ? 6 : week <= 8 ? 7 : 8,
      targetRPEMax: week <= 4 ? 7 : week <= 8 ? 8 : 9,
      dailyWorkouts: [
        DailyWorkout(
          day: TrainingDay.monday,
          focus: 'Snatch Day',
          exercises: [
            Exercise(name: 'Snatch', sets: 5, reps: '3-5', repsMin: 3, repsMax: 5, intensityDisplay: '60-85%', isMain: true),
            Exercise(name: 'Snatch Pull', sets: 4, reps: '5', repsMin: 5, repsMax: 5, intensityDisplay: 'Moderate'),
          ],
        ),
        DailyWorkout.rest(TrainingDay.sunday),
      ],
    );
  }
}
