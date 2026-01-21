# AI Fitness Coach - Complete Documentation

## Overview

AI Fitness Coach is a Flutter mobile application designed to help athletes track their workouts, follow structured training programs, and monitor their progress over time. The app uses RPE (Rate of Perceived Exertion) as a core metric to adjust training intensity based on how the athlete feels.

---

## Table of Contents

1. [App Architecture](#app-architecture)
2. [Phase 1: Foundation](#phase-1-foundation)
3. [Phase 2: Design System](#phase-2-design-system)
4. [Phase 3: Core Features](#phase-3-core-features)
5. [Phase 4: Navigation & Additional Screens](#phase-4-navigation--additional-screens)
6. [Data Flow](#data-flow)
7. [Key Features Summary](#key-features-summary)
8. [Improvement Opportunities](#improvement-opportunities)

---

## App Architecture

### Folder Structure (Simplified)

```
lib/
├── core/           # App-wide utilities, themes, routing, providers
├── data/           # Data layer (repositories, templates, local storage)
├── domain/         # Business logic (models, repository interfaces)
├── presentation/   # UI layer (screens, widgets)
└── services/       # Business services (program logic, analytics)
```

### Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| UI Framework | Flutter | Cross-platform mobile development |
| State Management | Riverpod | Reactive state management |
| Local Storage | Hive | Fast, lightweight database |
| Navigation | GoRouter | Declarative routing |
| Architecture | Clean Architecture | Separation of concerns |

---

## Phase 1: Foundation

### What Was Built

Phase 1 established the foundational architecture - think of it as building the "skeleton" of the app.

### 1.1 Domain Models (The Data Blueprints)

These are the "shapes" of data in our app:

#### AthleteProfile
**What it is:** Stores information about the user
```
- Name, bodyweight, experience level
- Sport preference (Powerlifting, Bodybuilding, CrossFit, etc.)
- Training goals and workout day preferences
- Max lift records (1RM values)
```
**Real-world analogy:** Like a membership card at a gym that stores your personal info and fitness goals.

#### WorkoutProgram
**What it is:** A complete training plan
```
- Program name and description
- Sport category
- Multiple weeks of training
- Each week has a phase (Hypertrophy, Strength, Peaking, Deload)
```
**Real-world analogy:** Like a training book from a coach that outlines what to do each week for 8-12 weeks.

#### WorkoutWeek
**What it is:** One week of training within a program
```
- Week number
- Training phase (what type of training this week)
- Daily workouts for each day
```
**Real-world analogy:** One page in your training book showing Monday-Sunday workouts.

#### DailyWorkout
**What it is:** A single day's workout
```
- Day name (e.g., "Upper Body A")
- Focus area
- List of exercises to perform
- Estimated duration
```
**Real-world analogy:** Your workout card for today at the gym.

#### Exercise
**What it is:** A single exercise within a workout
```
- Exercise name (Squat, Bench Press, etc.)
- Sets and reps
- Target RPE range (how hard it should feel)
- Rest time between sets
- Whether it's a main lift or accessory
```
**Real-world analogy:** One line on your workout card: "Bench Press: 4x8 @ RPE 7-8"

#### LoggedSet
**What it is:** A single set that was actually performed
```
- Exercise name
- Weight used
- Reps completed
- Actual RPE (how hard it felt)
- Timestamp
```
**Real-world analogy:** What you write in your training log after completing a set.

#### WorkoutSession
**What it is:** A complete workout that was performed
```
- Which workout it was
- Start and end time
- All the sets logged during the session
- Whether it was completed
```
**Real-world analogy:** One page in your training diary showing everything you did in a workout.

### 1.2 Enums (Categories)

Simple categorizations used throughout the app:

| Enum | Values | Purpose |
|------|--------|---------|
| Sport | Powerlifting, Bodybuilding, CrossFit, Olympic Lifting, General Fitness | What type of training |
| ExperienceLevel | Beginner, Intermediate, Advanced, Elite | User's training background |
| LiftType | Squat, Bench, Deadlift, OHP, Row, etc. | Categories of exercises |
| TrainingPhase | Hypertrophy, Strength, Peaking, Deload | What the focus of training is |
| TimeRange | Week, Month, Quarter, Year | For viewing analytics |

### 1.3 Repository Pattern

**What it is:** A "middleman" between the app and the database

```
App Screen → Repository → Hive Database
```

**Why it matters:**
- The screens don't need to know HOW data is stored
- We can change the database later without changing screens
- Makes testing easier

**TrainingRepository handles:**
- Saving/loading athlete profiles
- Saving/loading programs
- Recording workout sessions
- Fetching workout history
- Getting statistics (total workouts, streaks, PRs)

### 1.4 Local Storage (Hive)

**What it is:** A fast local database that stores data on the device

**Boxes (like filing cabinets):**
| Box Name | What It Stores |
|----------|---------------|
| profiles | User profile data |
| programs | Training programs |
| sessions | Completed workout sessions |
| workouts | Individual workout templates |
| settings | App preferences |

---

## Phase 2: Design System

### What Was Built

Phase 2 created a consistent visual language using "Atomic Design" - building complex UI from simple pieces.

### 2.1 Design Philosophy

```
Atoms → Molecules → Organisms → Screens
```

**Atoms:** Smallest UI pieces (buttons, badges, text)
**Molecules:** Combinations of atoms (search bars, stat displays)
**Organisms:** Complex components (workout cards, program cards)
**Screens:** Full pages made of organisms

### 2.2 Atoms (Basic Building Blocks)

#### AppButton
**What it is:** Styled buttons throughout the app
```
Variants:
- Primary (filled, main action)
- Secondary (outlined, secondary action)
- Tertiary (text only, minor action)
- Icon (just an icon)
- Destructive (red, for delete actions)

Sizes: Small, Medium, Large
```

#### AppBadge
**What it is:** Small status indicators
```
Examples:
- "Active" badge on current program
- "Completed" badge on finished workout
- Notification dot on icons
```

#### AppCard
**What it is:** Container for content
```
Variants:
- Filled (solid background)
- Outlined (border only)
- Elevated (with shadow)
```

#### AppChip
**What it is:** Small selectable tags
```
Used for:
- Filtering by sport type
- Selecting muscle groups
- RPE selection
```

### 2.3 Molecules (Combined Components)

#### AppSearchBar
**What it is:** Search input with optional filter button
**Used in:** Program browsing, exercise search

#### StatDisplay
**What it is:** Shows a number with a label
**Used in:** Profile stats, workout summaries
```
Example: "127" with label "Total Workouts"
```

#### SectionHeader
**What it is:** Title with optional action button
**Used in:** Screen sections like "Today's Workout", "Recent Activity"

#### WorkoutDaySelector
**What it is:** Horizontal day picker (Mon-Sun)
**Used in:** Selecting which day to view in a program

#### RPESelector
**What it is:** Visual picker for RPE values (1-10)
**Used in:** Logging sets during workout

### 2.4 Organisms (Complex Components)

#### WorkoutCard
**What it is:** Card showing a workout preview
```
Shows:
- Workout name and focus
- Exercise count
- Estimated duration
- Start button
- Completion status
```

#### ProgramCard
**What it is:** Card showing a training program
```
Shows:
- Program name
- Sport type (with color coding)
- Description
- Week progress (e.g., "Week 4 of 12")
- Start/Continue button
```

#### ActionCard
**What it is:** Card prompting user to take action
**Used for:** "Create Custom Program", "Start Workout"

### 2.5 Theme System

#### Color Scheme
```
Light Mode:
- Surface colors (backgrounds)
- Primary color (main brand color)
- Semantic colors (success=green, error=red, warning=yellow)

Dark Mode:
- Inverted for comfortable viewing
- Same semantic meaning
```

#### Sport Colors
Each sport has a unique color:
- Powerlifting: Purple
- Bodybuilding: Blue
- CrossFit: Orange
- Olympic Lifting: Teal
- General Fitness: Green

---

## Phase 3: Core Features

### What Was Built

Phase 3 connected the UI to real data, making the app functional.

### 3.1 State Management (Riverpod Providers)

**What it is:** The "brain" of the app that manages data flow

Think of providers as "smart containers" that:
- Hold data
- Update automatically when data changes
- Share data between screens

#### Key Providers

| Provider | What It Does |
|----------|--------------|
| `currentAthleteProfileProvider` | Holds the logged-in user's profile |
| `activeProgramProvider` | Holds the currently selected training program |
| `currentWeekWorkoutsProvider` | Holds this week's workouts |
| `loggedSetsProvider` | Holds sets logged in current workout |
| `workoutHistoryProvider` | Holds past workout sessions |
| `totalWorkoutsProvider` | Counts total completed workouts |
| `currentStreakProvider` | Calculates current training streak |

### 3.2 Main Screens

#### HomeScreen (Dashboard)
**What it shows:**
- Greeting with user's name
- Today's scheduled workout
- Quick stats (total workouts, current streak)
- Recent workout history

**Data connections:**
```
Profile → Shows name in greeting
Active Program → Shows today's workout
Workout History → Shows recent sessions
```

#### ProgramsScreen (Training Programs)
**What it shows:**
- Three tabs: Active, Browse, My Programs
- Current program progress
- Available programs to choose
- Week overview with day selector

**Data connections:**
```
Active Program → Shows progress
Available Programs → Shows options to start
Current Week → Shows daily workouts
```

#### WorkoutScreen (Active Workout)
**What it shows:**
- Current exercise with target sets/reps/RPE
- Set logging interface
- Rest timer
- Progress through workout

**Data connections:**
```
Today's Workout → Shows exercises to do
Logged Sets → Tracks completed sets
Session → Saves workout progress
```

#### ProgressScreen (Analytics)
**What it shows:**
- RPE trends over time (chart)
- Exercise statistics
- Volume progression
- Performance insights

**Data connections:**
```
Workout History → Calculates trends
RPE Analytics → Generates insights
```

#### ProfileScreen (User Settings)
**What it shows:**
- User avatar and info
- Lifetime statistics
- Menu for settings, history, preferences
- Edit profile options

**Data connections:**
```
Profile → Shows user info
Total Workouts → Shows lifetime stats
Workout History → Calculates volume
```

### 3.3 Program Templates

Pre-built training programs ready to use:

**Powerlifting Programs:**
- 5/3/1 style programs
- Periodized strength blocks

**Bodybuilding Programs:**
- PPL (Push/Pull/Legs)
- Upper/Lower splits

**CrossFit Programs:**
- Varied functional fitness
- Strength + conditioning mix

**General Fitness:**
- Full body routines
- Beginner-friendly options

---

## Phase 4: Navigation & Additional Screens

### What Was Built

Phase 4 added navigation between screens and additional detail screens.

### 4.1 Navigation System (GoRouter)

**Routes configured:**
| Path | Screen | Purpose |
|------|--------|---------|
| `/` | MainShell | Home with bottom nav |
| `/workout` | WorkoutScreen | Active workout |
| `/workout/summary` | WorkoutSummaryScreen | Post-workout stats |
| `/program/:id` | ProgramDetailScreen | Full program view |
| `/history` | WorkoutHistoryScreen | All past workouts |
| `/settings` | SettingsScreen | App preferences |
| `/exercise/:id` | ExerciseDetail | Exercise info (placeholder) |

### 4.2 New Screens

#### WorkoutSummaryScreen
**What it is:** Post-workout celebration and summary
**Shows:**
- Success animation
- Workout statistics (sets, reps, volume)
- Exercise breakdown with best sets
- Average RPE with interpretation
- Share option (coming soon)

#### ProgramDetailScreen
**What it is:** Full view of a training program
**Shows:**
- Collapsing header with program name
- Program stats (weeks, days per week)
- Week-by-week breakdown
- Weekly schedule preview
- Start/Continue button

#### WorkoutHistoryScreen
**What it is:** View all past workouts
**Shows:**
- Workouts grouped by month
- Each workout card shows:
  - Workout name and date
  - Number of sets
  - Total volume
  - Average RPE
  - Duration
- Tap to see full exercise breakdown

#### SettingsScreen
**What it is:** App configuration
**Sections:**
- Training Settings (weight units, rest timer)
- Appearance (dark mode toggle)
- Notifications (workout reminders)
- Data Management (export, clear data)
- About (version info, support links)

### 4.3 Navigation Connections

**From HomeScreen:**
- Tap workout card → `/workout`
- Tap "See All" on recent workouts → `/history`

**From ProgramsScreen:**
- Tap program card → `/program/:id`
- Tap workout card → `/workout`

**From ProfileScreen:**
- Tap "Training Preferences" → `/settings`
- Tap "Workout History" → `/history`
- Tap "Settings" → `/settings`

**From WorkoutScreen:**
- Complete workout → `/workout/summary`

**From WorkoutSummaryScreen:**
- Tap "Done" → `/` (home)

---

## Data Flow

### How Data Moves Through the App

```
User Action
    ↓
Screen Widget (UI)
    ↓
Riverpod Provider (State)
    ↓
Repository (Data Access)
    ↓
Hive Database (Storage)
```

### Example: Logging a Set

1. **User taps "Log Set" button**
2. **WorkoutScreen** calls `addLoggedSetProvider`
3. **Provider** adds set to `loggedSetsProvider` list
4. **UI automatically updates** to show new set
5. **When workout completes**, session is saved via Repository
6. **Repository** writes to Hive database
7. **Data persists** even after app closes

### Example: Viewing Workout History

1. **User navigates to History screen**
2. **WorkoutHistoryScreen** watches `workoutHistoryProvider(50)`
3. **Provider** calls `repository.getWorkoutHistory(limit: 50)`
4. **Repository** queries Hive database
5. **Data flows back** through provider to screen
6. **UI renders** list of past workouts

---

## Key Features Summary

### Currently Working

| Feature | Status | Description |
|---------|--------|-------------|
| User Profile | Complete | Create and edit athlete profile |
| Program Selection | Complete | Browse and start training programs |
| Program Templates | Complete | Pre-built powerlifting, bodybuilding, CrossFit programs |
| Workout Display | Complete | View today's workout with exercises |
| Set Logging | Complete | Log weight, reps, RPE for each set |
| RPE Feedback | Complete | Get coaching tips based on RPE |
| Workout Summary | Complete | See stats after completing workout |
| Workout History | Complete | View all past workouts |
| Basic Analytics | Complete | View RPE trends and stats |
| Settings | Complete | Configure app preferences |
| Dark Mode | Complete | Toggle dark/light theme |
| Navigation | Complete | Smooth transitions between screens |

### Placeholder/TODO

| Feature | Status | Description |
|---------|--------|-------------|
| Share Workout | Placeholder | Share workout summary to social |
| Exercise Detail | Placeholder | View exercise form cues, history |
| Custom Programs | Placeholder | Build your own training program |
| Personal Records | Placeholder | Track and celebrate PRs |
| Notifications | Placeholder | Workout reminders |
| Data Export | Placeholder | Export training data |
| Cloud Sync | Placeholder | Backup to cloud |

---

## Improvement Opportunities

### UI/UX Enhancements

#### 1. Onboarding Flow
**Current:** No guided setup
**Improvement:** Add a welcoming onboarding that:
- Asks about training experience
- Helps set realistic goals
- Recommends appropriate programs
- Sets up initial profile

#### 2. Exercise Library
**Current:** Exercises are just names
**Improvement:** Rich exercise database with:
- Video demonstrations
- Form cues and tips
- Muscle group visualization
- Exercise variations
- History of that exercise for the user

#### 3. Rest Timer Enhancement
**Current:** Basic timer
**Improvement:**
- Auto-start after logging set
- Customizable per exercise type
- Haptic/sound notifications
- "Skip" or "Add 30 seconds" options

#### 4. Visual Progress Charts
**Current:** Basic stats display
**Improvement:**
- Interactive line charts for strength progress
- Body part volume distribution (pie chart)
- Week-over-week comparison
- Goal tracking visualization

#### 5. Personal Records Celebration
**Current:** PRs not tracked
**Improvement:**
- Automatic PR detection
- Celebration animation
- PR history wall
- Social sharing of PRs

### System Enhancements

#### 1. Smart Recommendations
**Improvement:** AI-powered features:
- Weight suggestions based on RPE history
- Deload recommendations when RPE consistently high
- Exercise substitution suggestions
- Program adjustments based on progress

#### 2. Fatigue Management
**Improvement:** Track and manage fatigue:
- Weekly volume tracking per muscle group
- Accumulated fatigue score
- Recovery recommendations
- Deload week suggestions

#### 3. Social Features
**Improvement:** Community aspects:
- Share workouts with friends
- Workout partners/accountability
- Leaderboards (optional)
- Program reviews and ratings

#### 4. Integration Options
**Improvement:** Connect with other services:
- Apple Health / Google Fit sync
- Calendar integration for workout scheduling
- Export to spreadsheet (CSV/Excel)
- Import from other apps

#### 5. Offline-First Enhancement
**Improvement:** Better offline support:
- Queue changes when offline
- Sync when connection restored
- Clear offline/online indicators
- Conflict resolution for edits

#### 6. Accessibility
**Improvement:** Make app usable for everyone:
- Voice commands for set logging
- Screen reader support
- High contrast mode
- Larger text options

### Technical Improvements

#### 1. Testing
**Current:** No tests
**Improvement:**
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows
- Automated CI/CD pipeline

#### 2. Error Handling
**Current:** Basic error display
**Improvement:**
- Graceful degradation
- Retry mechanisms
- Offline error queuing
- User-friendly error messages

#### 3. Performance
**Improvement:**
- Lazy loading for long lists
- Image caching
- Pagination for history
- Background data sync

#### 4. Analytics
**Improvement:**
- Usage analytics (with consent)
- Crash reporting
- Feature usage tracking
- A/B testing capability

---

## Quick Reference

### File Locations

| What | Where |
|------|-------|
| Main app entry | `lib/main.dart` |
| App configuration | `lib/app.dart` |
| All providers | `lib/core/providers/providers.dart` |
| Router config | `lib/core/routing/app_router.dart` |
| Theme colors | `lib/core/theme/color_schemes.dart` |
| Data models | `lib/domain/models/` |
| Repository | `lib/data/repositories/training_repository_impl.dart` |
| Program templates | `lib/data/templates/` |
| Screens | `lib/presentation/screens/` |
| Widgets | `lib/presentation/widgets/design_system/` |

### Common Tasks

**To add a new screen:**
1. Create file in `lib/presentation/screens/[category]/`
2. Add route in `lib/core/routing/app_router.dart`
3. Connect navigation from other screens

**To add a new provider:**
1. Add to `lib/core/providers/providers.dart`
2. Use `ref.watch()` in screens to consume

**To add a new model:**
1. Create in `lib/domain/models/`
2. Add JSON serialization methods
3. Update repository if needs persistence

**To add a new widget:**
1. Determine if it's atom/molecule/organism
2. Create in appropriate folder under `lib/presentation/widgets/design_system/`
3. Export in the category's barrel file (e.g., `atoms.dart`)

---

## Conclusion

The AI Fitness Coach app has a solid foundation with clean architecture, consistent design system, and working core features. The modular structure makes it easy to add new features without breaking existing functionality.

**Key strengths:**
- Clean separation of concerns
- Consistent UI components
- Reactive state management
- Extensible data layer

**Areas for growth:**
- Enhanced analytics and insights
- Social and sharing features
- AI-powered recommendations
- Broader exercise library

This documentation should help anyone understand the codebase and identify opportunities for improvement.
