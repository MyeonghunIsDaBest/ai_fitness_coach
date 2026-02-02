// lib/data/templates/template_helpers.dart

import '../../core/enums/sport.dart';
import '../../domain/models/workout_program.dart';
import 'powerlifting_templates.dart';
import 'crossfit_templates.dart';
import 'bodybuilding_templates.dart';
import 'general_fitness_templates.dart';
import 'olympic_lifting_templates.dart';

/// Helper class to get all templates for each sport
class ProgramTemplateHelpers {
  /// Get all powerlifting templates
  static List<WorkoutProgram> getPowerliftingTemplates() {
    return [
      PowerliftingTemplates.beginnerLinearProgression,
      PowerliftingTemplates.intermediateBlockPeriodization,
      PowerliftingTemplates.advancedDUP,
    ];
  }

  /// Get all bodybuilding templates
  static List<WorkoutProgram> getBodybuildingTemplates() {
    return [
      BodybuildingTemplates.classicBroSplit,
      BodybuildingTemplates.pushPullLegs,
    ];
  }

  /// Get all CrossFit templates
  static List<WorkoutProgram> getCrossFitTemplates() {
    return [
      CrossFitTemplates.beginnerFundamentals,
      CrossFitTemplates.intermediateCompPrep,
      CrossFitTemplates.hyroxTraining,
    ];
  }

  /// Get all Olympic Lifting templates
  static List<WorkoutProgram> getOlympicLiftingTemplates() {
    return [
      OlympicLiftingTemplates.beginnerTechnique,
      OlympicLiftingTemplates.intermediateStrength,
      OlympicLiftingTemplates.competitionPeaking,
    ];
  }

  /// Get all General Fitness templates
  static List<WorkoutProgram> getGeneralFitnessTemplates() {
    return [
      GeneralFitnessTemplates.beginnerFullBody,
      GeneralFitnessTemplates.intermediateUpperLower,
    ];
  }

  /// Get all templates for a specific sport
  static List<WorkoutProgram> getTemplatesForSport(Sport sport) {
    switch (sport) {
      case Sport.powerlifting:
        return getPowerliftingTemplates();
      case Sport.bodybuilding:
        return getBodybuildingTemplates();
      case Sport.crossfit:
        return getCrossFitTemplates();
      case Sport.olympicLifting:
        return getOlympicLiftingTemplates();
      case Sport.generalFitness:
        return getGeneralFitnessTemplates();
    }
  }

  /// Get all templates across all sports
  static List<WorkoutProgram> getAllTemplates() {
    return [
      ...getPowerliftingTemplates(),
      ...getBodybuildingTemplates(),
      ...getCrossFitTemplates(),
      ...getOlympicLiftingTemplates(),
      ...getGeneralFitnessTemplates(),
    ];
  }
}
