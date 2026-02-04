import 'package:flutter/material.dart';

/// Difficulty levels for exercises
/// Used to filter exercises appropriate for user's experience level
enum DifficultyLevel {
  /// Basic exercises suitable for complete beginners
  /// Little to no coordination required
  beginner,

  /// Standard exercises requiring some training experience
  /// Moderate coordination and technique
  intermediate,

  /// Complex exercises requiring significant experience
  /// High coordination and technique demands
  advanced,

  /// Elite-level exercises requiring years of training
  /// Maximum coordination, strength, and technique
  expert;

  /// Human-readable display name
  String get displayName {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  /// Short description of this difficulty level
  String get description {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'New to training, learning basics';
      case DifficultyLevel.intermediate:
        return '6+ months experience';
      case DifficultyLevel.advanced:
        return '2+ years consistent training';
      case DifficultyLevel.expert:
        return '5+ years, competitive level';
    }
  }

  /// Numeric value for sorting (1-4)
  int get sortOrder {
    switch (this) {
      case DifficultyLevel.beginner:
        return 1;
      case DifficultyLevel.intermediate:
        return 2;
      case DifficultyLevel.advanced:
        return 3;
      case DifficultyLevel.expert:
        return 4;
    }
  }

  /// Color associated with this difficulty
  Color get color {
    switch (this) {
      case DifficultyLevel.beginner:
        return const Color(0xFF4CAF50); // Green
      case DifficultyLevel.intermediate:
        return const Color(0xFFFF9800); // Orange
      case DifficultyLevel.advanced:
        return const Color(0xFFE91E63); // Pink
      case DifficultyLevel.expert:
        return const Color(0xFF9C27B0); // Purple
    }
  }

  /// Icon representing this difficulty
  IconData get icon {
    switch (this) {
      case DifficultyLevel.beginner:
        return Icons.star_border;
      case DifficultyLevel.intermediate:
        return Icons.star_half;
      case DifficultyLevel.advanced:
        return Icons.star;
      case DifficultyLevel.expert:
        return Icons.stars;
    }
  }

  /// Check if this level is at or below another level
  bool isAtOrBelow(DifficultyLevel other) {
    return sortOrder <= other.sortOrder;
  }

  /// Check if this level is at or above another level
  bool isAtOrAbove(DifficultyLevel other) {
    return sortOrder >= other.sortOrder;
  }

  /// Get all levels at or below this level
  List<DifficultyLevel> get levelsAtOrBelow {
    return DifficultyLevel.values
        .where((level) => level.sortOrder <= sortOrder)
        .toList();
  }
}
