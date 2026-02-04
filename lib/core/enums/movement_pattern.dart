import 'package:flutter/material.dart';

/// Movement patterns categorizing exercises by their primary motion
/// Used for finding similar exercises and organizing the exercise database
enum MovementPattern {
  /// Squatting movements (quads dominant)
  squat,

  /// Hip hinge movements (posterior chain dominant)
  hinge,

  /// Horizontal pushing (chest, front delts, triceps)
  pushHorizontal,

  /// Vertical pushing (shoulders, triceps)
  pushVertical,

  /// Horizontal pulling (back, biceps)
  pullHorizontal,

  /// Vertical pulling (lats, biceps)
  pullVertical,

  /// Loaded carries (core, grip, full body)
  carry,

  /// Single-joint isolation movements
  isolation,

  /// Olympic lifting movements (snatch, clean, jerk)
  olympic,

  /// Explosive/jumping movements
  plyometric,

  /// Cardio and conditioning work
  conditioning,

  /// Core-specific movements
  core,

  /// Rotational movements
  rotation;

  /// Human-readable display name
  String get displayName {
    switch (this) {
      case MovementPattern.squat:
        return 'Squat';
      case MovementPattern.hinge:
        return 'Hinge';
      case MovementPattern.pushHorizontal:
        return 'Horizontal Push';
      case MovementPattern.pushVertical:
        return 'Vertical Push';
      case MovementPattern.pullHorizontal:
        return 'Horizontal Pull';
      case MovementPattern.pullVertical:
        return 'Vertical Pull';
      case MovementPattern.carry:
        return 'Carry';
      case MovementPattern.isolation:
        return 'Isolation';
      case MovementPattern.olympic:
        return 'Olympic';
      case MovementPattern.plyometric:
        return 'Plyometric';
      case MovementPattern.conditioning:
        return 'Conditioning';
      case MovementPattern.core:
        return 'Core';
      case MovementPattern.rotation:
        return 'Rotation';
    }
  }

  /// Short description of the movement pattern
  String get description {
    switch (this) {
      case MovementPattern.squat:
        return 'Knee-dominant lower body movements';
      case MovementPattern.hinge:
        return 'Hip-dominant posterior chain movements';
      case MovementPattern.pushHorizontal:
        return 'Pushing away from the body horizontally';
      case MovementPattern.pushVertical:
        return 'Pushing overhead vertically';
      case MovementPattern.pullHorizontal:
        return 'Pulling towards the body horizontally';
      case MovementPattern.pullVertical:
        return 'Pulling from overhead vertically';
      case MovementPattern.carry:
        return 'Walking while holding weight';
      case MovementPattern.isolation:
        return 'Single-joint targeted movements';
      case MovementPattern.olympic:
        return 'Explosive barbell movements';
      case MovementPattern.plyometric:
        return 'Explosive jumping movements';
      case MovementPattern.conditioning:
        return 'Cardio and metabolic work';
      case MovementPattern.core:
        return 'Trunk stability and rotation';
      case MovementPattern.rotation:
        return 'Rotational and anti-rotation work';
    }
  }

  /// Material icon representing this pattern
  IconData get icon {
    switch (this) {
      case MovementPattern.squat:
        return Icons.accessibility_new;
      case MovementPattern.hinge:
        return Icons.airline_seat_legroom_extra;
      case MovementPattern.pushHorizontal:
        return Icons.fitness_center;
      case MovementPattern.pushVertical:
        return Icons.upload;
      case MovementPattern.pullHorizontal:
        return Icons.rowing;
      case MovementPattern.pullVertical:
        return Icons.download;
      case MovementPattern.carry:
        return Icons.directions_walk;
      case MovementPattern.isolation:
        return Icons.radio_button_checked;
      case MovementPattern.olympic:
        return Icons.flash_on;
      case MovementPattern.plyometric:
        return Icons.height;
      case MovementPattern.conditioning:
        return Icons.directions_run;
      case MovementPattern.core:
        return Icons.adjust;
      case MovementPattern.rotation:
        return Icons.rotate_right;
    }
  }

  /// Whether this pattern typically involves compound movements
  bool get isCompound {
    switch (this) {
      case MovementPattern.squat:
      case MovementPattern.hinge:
      case MovementPattern.pushHorizontal:
      case MovementPattern.pushVertical:
      case MovementPattern.pullHorizontal:
      case MovementPattern.pullVertical:
      case MovementPattern.carry:
      case MovementPattern.olympic:
        return true;
      case MovementPattern.isolation:
      case MovementPattern.plyometric:
      case MovementPattern.conditioning:
      case MovementPattern.core:
      case MovementPattern.rotation:
        return false;
    }
  }

  /// Related patterns for finding substitutes
  List<MovementPattern> get relatedPatterns {
    switch (this) {
      case MovementPattern.squat:
        return [MovementPattern.hinge, MovementPattern.plyometric];
      case MovementPattern.hinge:
        return [MovementPattern.squat, MovementPattern.pullHorizontal];
      case MovementPattern.pushHorizontal:
        return [MovementPattern.pushVertical, MovementPattern.isolation];
      case MovementPattern.pushVertical:
        return [MovementPattern.pushHorizontal, MovementPattern.isolation];
      case MovementPattern.pullHorizontal:
        return [MovementPattern.pullVertical, MovementPattern.hinge];
      case MovementPattern.pullVertical:
        return [MovementPattern.pullHorizontal, MovementPattern.isolation];
      case MovementPattern.carry:
        return [MovementPattern.core, MovementPattern.conditioning];
      case MovementPattern.isolation:
        return []; // No related patterns for isolation
      case MovementPattern.olympic:
        return [MovementPattern.squat, MovementPattern.hinge, MovementPattern.plyometric];
      case MovementPattern.plyometric:
        return [MovementPattern.squat, MovementPattern.conditioning];
      case MovementPattern.conditioning:
        return [MovementPattern.carry, MovementPattern.plyometric];
      case MovementPattern.core:
        return [MovementPattern.rotation, MovementPattern.carry];
      case MovementPattern.rotation:
        return [MovementPattern.core];
    }
  }
}
