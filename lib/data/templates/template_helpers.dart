// TEMPLATE HELPER - Add this to each template file
// Or create as: lib/data/program_templates/template_helpers.dart

import '../../core/enums/sport.dart';
import 'powerlifting_templates.dart';
import 'crossfit_templates.dart';
import 'bodybuilding_templates.dart';
import 'olympic_lifting_templates.dart';
import 'general_fitness_templates.dart';

/// Helper class to get all templates for each sport
class ProgramTemplateHelpers {
  /// Get all powerlifting templates
  static List<TrainingProgram> getPowerliftingTemplates() {
    return [
      PowerliftingTemplates.startingStrength,
      PowerliftingTemplates.upperLowerSplit,
      // Add more as they're created
    ];
  }

  /// Get all bodybuilding templates
  static List<TrainingProgram> getBodybuildingTemplates() {
    return [
      BodybuildingTemplates.pushPullLegs,
      // Add more as they're created
    ];
  }

  /// Get all CrossFit templates
  static List<TrainingProgram> getCrossFitTemplates() {
    return [
      CrossFitTemplates.beginnerFundamentals,
      // Add more as they're created
    ];
  }

  /// Get all Olympic Lifting templates
  static List<TrainingProgram> getOlympicLiftingTemplates() {
    return [
      OlympicLiftingTemplates.beginnerSnatchProgram,
      // Add more as they're created
    ];
  }

  /// Get all General Fitness templates
  static List<TrainingProgram> getGeneralFitnessTemplates() {
    return [
      GeneralFitnessTemplates.basicStrengthConditioning,
      // Add more as they're created
    ];
  }

  /// Get all templates for a specific sport
  static List<TrainingProgram> getTemplatesForSport(Sport sport) {
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
  static List<TrainingProgram> getAllTemplates() {
    return [
      ...getPowerliftingTemplates(),
      ...getBodybuildingTemplates(),
      ...getCrossFitTemplates(),
      ...getOlympicLiftingTemplates(),
      ...getGeneralFitnessTemplates(),
    ];
  }
}

// ============================================================================
// ADD THESE STATIC METHODS TO EACH TEMPLATE CLASS
// ============================================================================

// In PowerliftingTemplates class:
/*
class PowerliftingTemplates {
  static List<TrainingProgram> getAllTemplates() {
    return [
      startingStrength,
      upperLowerSplit,
    ];
  }
}
*/

// In BodybuildingTemplates class:
/*
class BodybuildingTemplates {
  static List<TrainingProgram> getAllTemplates() {
    return [
      pushPullLegs,
    ];
  }
}
*/

// In CrossFitTemplates class:
/*
class CrossFitTemplates {
  static List<TrainingProgram> getAllTemplates() {
    return [
      beginnerFundamentals,
    ];
  }
}
*/

// In OlympicLiftingTemplates class:
/*
class OlympicLiftingTemplates {
  static List<TrainingProgram> getAllTemplates() {
    return [
      beginnerSnatchProgram,
    ];
  }
}
*/

// In GeneralFitnessTemplates class:
/*
class GeneralFitnessTemplates {
  static List<TrainingProgram> getAllTemplates() {
    return [
      basicStrengthConditioning,
    ];
  }
}
*/
