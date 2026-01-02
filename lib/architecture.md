# 🧠 Project Architecture Guide

This document explains the purpose and responsibility of every major folder and file in the `lib/` directory.

The goal is to ensure:
- Clear separation of concerns
- Long-term scalability
- Easy onboarding for contributors
- Production-readiness

---

## 📁 lib/core/

**Purpose:**  
Framework-level rules and shared logic used across the entire app.

No Flutter widgets.  
No Firebase.  
No app-specific state.

### `core/enums/`
Defines all fixed states used throughout the app.

Examples:
- Sports types
- Training phases
- RPE feedback states
- Lift categories

Using enums prevents string-based bugs and enables predictable logic.

---

### `core/constants/`
Hard-coded rules and shared UI labels.

- `rpe_thresholds.dart`  
  Defines what is considered:
  - too easy
  - on target
  - too hard

- `ui_strings.dart`  
  Centralized text such as:
  - “Exercise Preview”
  - “Set Tracker”
  - “Session Average RPE”

This makes UI consistent and easier to localize later.

---

### `core/utils/`
Pure functions and calculations.

- `rpe_math.dart`
  - Average RPE
  - Estimated 1RM
  - RPE trend calculations

- `session_stats.dart`
  - Total volume
  - Tonnage
  - Completed sets

These utilities contain **no state** and are easy to test.

---

### `core/errors/`
Unified error handling.

`failures.dart` defines typed failures such as:
- StorageFailure
- NetworkFailure
- ValidationFailure

This avoids raw exceptions leaking into the UI.

---

## 📁 lib/domain/

**Purpose:**  
The heart of the training system.

Contains:
- Business rules
- Training models
- Use cases

No Flutter.  
No database logic.

---

### `domain/models/`
Represents real-world training concepts.

- Exercise
- DailyWorkout
- ProgramWeek
- WorkoutProgram
- AthleteProfile
- LoggedSet

These models are storage-agnostic and reusable.

---

### `domain/repositories/`
Defines contracts (interfaces) for data access.

Example:
- Load program
- Save workout session
- Retrieve history

This allows swapping storage implementations without changing business logic.

---

### `domain/usecases/`
Single-responsibility actions.

Each use case performs one job:
- Log a set
- Calculate session RPE
- Adjust next week’s load

This layer is also where future AI logic will plug in.

---

## 📁 lib/data/

**Purpose:**  
Concrete implementations of repositories and data sources.

---

### `data/templates/`
Contains actual training programs.

Examples:
- Powerlifting 12-week program
- Bodybuilding splits
- CrossFit cycles

These are real, opinionated programs — not placeholders.

---

### `data/repositories/`
Implements domain repositories using:
- Local storage (Hive)
- Cloud storage (Firebase – future)

---

### `data/mappers/`
Transforms raw data formats (JSON, DB) into domain models.

Prevents domain pollution and keeps models clean.

---

## 📁 lib/services/

**Purpose:**  
Higher-level coordination and intelligence.

Examples:
- RPE feedback logic
- Progression adjustments
- Exercise preview mapping

This layer orchestrates domain logic and prepares data for the UI.

---

## 📁 lib/features/

**Purpose:**  
User-facing functionality grouped by feature.

Each feature contains:
- UI
- Controllers
- Feature-specific widgets

---

### Workout Feature
- Workout screen
- Set tracker
- Completion flow

---

### RPE Feature
- RPE slider
- Feedback banners

---

### History Feature
- Past workouts
- Session summaries
- Analytics hooks

---

### Exercise Preview Feature (Future)
Provides animated movement previews to reduce the need for searching external demo videos.

Planned future extension:
- Pose estimation
- Stick-figure form analysis

---

## 📁 lib/main.dart

**Purpose:**  
Application entry point.

Responsibilities:
- App initialization
- Dependency injection
- Theme setup
- Routing
- State provider setup

---

## 🧠 Final Notes

This architecture is intentionally designed to:
- Scale to AI features
- Support multiple sports
- Remain testable
- Avoid refactors later

Execution and wiring are the current priorities.

---

lib/
├── core/                         // App-wide rules & shared logic
│   ├── enums/                    // Fixed states used everywhere
│   │   ├── sport.dart            // Powerlifting, Bodybuilding, CrossFit, Olympic
│   │   ├── phase.dart            // Volume, Strength, Peak, Deload
│   │   ├── week_type.dart        // Normal, Deload, Test
│   │   ├── lift_type.dart        // Squat, Bench, Deadlift, Accessory
│   │   └── rpe_feedback.dart     // TooEasy, OnTarget, TooHard
│   │
│   ├── constants/                // Hard rules & shared UI labels
│   │   ├── rpe_thresholds.dart   // RPE cutoffs & fatigue rules
│   │   └── ui_strings.dart       // "Exercise Preview", "Set Tracker", etc.
│   │
│   ├── utils/                    // Pure functions (no state)
│   │   ├── rpe_math.dart         // Avg RPE, e1RM, trends
│   │   └── session_stats.dart    // Volume, tonnage, completion
│   │
│   └── errors/                   // Unified error handling
│       └── failures.dart         // StorageFailure, NetworkFailure, etc.
│
├── domain/                       // Training logic & business rules
│   ├── models/                   // Core training entities
│   │   ├── exercise.dart         // + previewAsset (future)
│   │   ├── daily_workout.dart
│   │   ├── program_week.dart
│   │   ├── workout_program.dart
│   │   ├── athlete_profile.dart
│   │   └── logged_set.dart       // Set Tracker persistence
│   │
│   ├── repositories/             // Contracts only (interfaces)
│   │   └── training_repository.dart
│   │
│   └── usecases/                 // Single-responsibility actions
│       ├── get_program.dart
│       ├── log_set_rpe.dart
│       ├── calculate_session_rpe.dart
│       ├── calculate_volume.dart
│       └── adjust_next_week_load.dart
│
├── data/                         // Concrete implementations
│   ├── templates/                // Actual training programs
│   │   ├── powerlifting.dart
│   │   ├── bodybuilding.dart
│   │   ├── crossfit.dart
│   │   └── olympic.dart
│   │
│   ├── repositories/             // Implements domain repositories
│   │   └── training_repository_impl.dart
│   │
│   └── mappers/                  // Data ↔ Domain transformers
│       └── program_mapper.dart
│
├── services/                     // Coaching intelligence & orchestration
│   ├── program_service.dart
│   ├── rpe_feedback_service.dart
│   ├── progression_service.dart
│   └── exercise_preview_service.dart   // 🚧 future (animations / pose)
│
├── features/                     // User-facing features (UI)
│   ├── program_selection/
│   │   └── program_selection_screen.dart
│   │
│   ├── workout/                  // Core training experience
│   │   ├── workout_screen.dart
│   │   ├── set_tracker_widget.dart      // Sets & reps UI
│   │   └── workout_controller.dart
│   │
│   ├── rpe/                      // RPE input & feedback
│   │   ├── rpe_slider.dart
│   │   └── rpe_feedback_banner.dart
│   │
│   ├── history/                  // Past workouts & analytics
│   │   └── workout_history_screen.dart
│   │
│   └── exercise_preview/         // 🚧 future feature
│       ├── exercise_preview_widget.dart
│       └── preview_assets.dart
│
└── main.dart                     // App entry point & composition root
