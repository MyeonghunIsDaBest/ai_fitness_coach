NEW FOCUSED ROADMAP
Phase 1: MAKE IT WORK (Days 1-15) - 25% → 60%
Goal: Functional app that users can actually use
Week 1: Foundation (Days 1-5)
Critical path to get data flowing
Day 1 - State Management (6-8 hrs) 🔴 BLOCKING

Priority: P0 - Nothing works without this
Tasks:
  Morning:
    - [ ] flutter pub add flutter_riverpod
    - [ ] Create lib/core/providers/providers.dart
    - [ ] Wrap MaterialApp with ProviderScope
    - [ ] Create first provider (programProvider)
  
  Afternoon:
    - [ ] Create athleteProfileProvider
    - [ ] Create selectedProgramProvider
    - [ ] Test hot reload works
    - [ ] Verify state persists in navigation

Deliverable: App runs with working state
Blocker for: Everything else

Day 2 - Data Persistence (6-7 hrs) 🔴 BLOCKING

Priority: P0 - No saving = no app
Tasks:
  Morning:
    - [ ] Initialize Hive in main.dart
    - [ ] Create HiveService wrapper
    - [ ] Open boxes: profiles, programs, workouts
    - [ ] Test basic save/load
  
  Afternoon:
    - [ ] Connect AthleteProfile to Hive
    - [ ] Test Goal Setup saves profile
    - [ ] Kill app, restart, verify profile loads
    - [ ] Fix any serialization issues

Deliverable: Profile persists between sessions
Test: Complete setup → Close app → Reopen → Profile still there

Day 3 - Program Templates (5-6 hrs) 🟡 HIGH VALUE

Priority: P1 - Need content to show
Tasks:
  - [ ] Copy powerlifting template content (from my artifacts)
  - [ ] Copy crossfit template content
  - [ ] Copy bodybuilding template content
  - [ ] Create 1 simple general fitness template
  - [ ] Test templates load in ProgramSelectionScreen
  
Deliverable: 10-12 real program templates
Impact: App now has real content!

Day 4 - Connect Services (6-7 hrs) 🟡 CRITICAL

Priority: P1 - Wire everything together
Tasks:
  Morning:
    - [ ] Update ProgramService to load templates
    - [ ] Connect ProgramSelectionScreen to service
    - [ ] Save selected program to Hive
    - [ ] Test program selection flow
  
  Afternoon:
    - [ ] Create WeekDashboardScreen (basic version)
    - [ ] Load selected program's first week
    - [ ] Display 7 days with workouts
    - [ ] Test navigation: Goal Setup → Program Select → Week View

Deliverable: Can select program and see first week
Test: Complete onboarding → See actual workout schedule

Day 5 - Custom Program Builder 🆕 NEW FEATURE

Priority: P1 - Your requested feature!
Tasks:
  Morning:
    - [ ] Create CustomProgramScreen
    - [ ] Add "Create Custom Program" button in ProgramSelection
    - [ ] Build form: Name, Duration (1-52 weeks), Sport
    - [ ] Add "Quick Program" option (1 day, 4 weeks, 12 weeks)
  
  Afternoon:
    - [ ] Create DayEditorScreen
    - [ ] Add exercises to custom day
    - [ ] Set: Sets, Reps, RPE targets
    - [ ] Save custom program to Hive
    - [ ] Test: Create → Save → Select → View in dashboard

Deliverable: Users can create custom programs
Features:
  - Quick templates (1 day, 4 weeks, 12 weeks)
  - Full custom builder
  - Import coach's program (manual entry)
  - Save/edit/delete custom programs

Files to create:
  - lib/features/programs/custom_program_screen.dart
  - lib/features/programs/day_editor_screen.dart
  - lib/features/programs/widgets/exercise_picker.dart

  Week 2: Core Features (Days 6-10)
Day 6 - Workout Logger (7-8 hrs) 🔴 CORE FEATURE

Priority: P0 - Main app functionality
Tasks:
  Morning:
    - [ ] Create WorkoutLoggerScreen (proper one)
    - [ ] Display exercises from daily workout
    - [ ] Show: Exercise name, sets, reps, RPE target
    - [ ] Build set logging UI
  
  Afternoon:
    - [ ] Add set counter (Set 1/3, Set 2/3, etc.)
    - [ ] RPE slider (6-10 with descriptions)
    - [ ] Weight + Reps input
    - [ ] Save logged sets to Hive
    - [ ] Show previously logged sets

Deliverable: Can log a complete workout
Test: Select workout → Log all exercises → Save → Verify in Hive

Day 7 - RPE Feedback Integration (5-6 hrs) 🧠

Priority: P1 - Smart coaching
Tasks:
  Morning:
    - [ ] Connect RPEFeedbackService to logger
    - [ ] Show real-time RPE feedback
    - [ ] Display: "Too Easy", "On Target", "Too Hard"
    - [ ] Add weight recommendations
  
  Afternoon:
    - [ ] Calculate session average RPE
    - [ ] Show running average during workout
    - [ ] Add fatigue warnings
    - [ ] Test feedback accuracy

Deliverable: Smart RPE coaching during workouts
Impact: App feels intelligent!

Day 8 - History Screen (5-6 hrs) 📊

Priority: P1 - See progress
Tasks:
  Morning:
    - [ ] Create HistoryScreen
    - [ ] List all completed workouts
    - [ ] Show: Date, program, exercises, sets
    - [ ] Add filters (by date, by exercise)
  
  Afternoon:
    - [ ] Create WorkoutDetailScreen
    - [ ] Show all logged sets for that workout
    - [ ] Display RPE data
    - [ ] Add notes section
    - [ ] Test navigation

Deliverable: Complete workout history

Day 9 - Analytics Foundation (6-7 hrs) 📈

Priority: P1 - Your requested feature!
Tasks:
  Morning:
    - [ ] Install fl_chart package
    - [ ] Create missing analytics files:
      ✅ rpe_analytics_service.dart (you have)
      ✅ analytics_screen.dart (you have)
      ✅ rpe_line_chart.dart (you have)
      - [ ] rpe_bar_chart.dart
      - [ ] exercise_breakdown_tab.dart
      - [ ] muscle_group_heatmap.dart
  
  Afternoon:
    - [ ] Create chart_data.dart models
    - [ ] Create time_range.dart enum
    - [ ] Connect analytics_screen to data
    - [ ] Test with mock data

Deliverable: Basic RPE charts working
Files needed: I'll create 6 missing files for you below

Day 10 - Week Progress Tracking (4-5 hrs) ✅

Priority: P2 - Polish
Tasks:
  - [ ] Add week completion tracking
  - [ ] Show progress bars
  - [ ] Mark completed workouts
  - [ ] Calculate weekly stats
  - [ ] Test week transitions

Deliverable: Can track weekly progress

Week 3: Polish & Testing (Days 11-15)
Day 11 - UI Polish Pass (5-6 hrs)

Tasks:
  - [ ] Add loading states everywhere
  - [ ] Improve error messages
  - [ ] Add haptic feedback
  - [ ] Smooth animations
  - [ ] Test all navigation flows

Day 12 - Bug Fixing Sprint (6-8 hrs)

Tasks:
  - [ ] Test complete user journey
  - [ ] Fix all P0 bugs
  - [ ] Fix P1 bugs
  - [ ] Document P2 bugs for later

Day 13 - Basic Unit Tests (5-6 hrs)

Tasks:
  - [ ] Test RPEMath
  - [ ] Test domain models
  - [ ] Test key use cases
  - [ ] Target: 40% coverage

Day 14 - Widget Tests (5-6 hrs)

Tasks:
  - [ ] Test 3-5 critical screens
  - [ ] Test form validation
  - [ ] Test navigation

Day 15 - Integration Testing (5-6 hrs)

Tasks:
  - [ ] Test complete flows
  - [ ] Test data persistence
  - [ ] Test edge cases
  - [ ] Performance check

Progress After Week 3: 25% → 60% ✅

Phase 2: MAKE IT GOOD (Days 16-30) - 60% → 85%
Goal: Production-quality experience
Week 4: Advanced Features (Days 16-20)
Day 16 - Program Management (5-6 hrs)

Tasks:
  - [ ] Edit custom programs
  - [ ] Duplicate programs
  - [ ] Share programs (export JSON)
  - [ ] Import programs (from JSON)

Day 17 - Enhanced Workout Logger (5-6 hrs)

Tasks:
  - [ ] Add rest timer
  - [ ] Add workout timer
  - [ ] Add notes per exercise
  - [ ] Add supersets support

Day 18 - Progress Analytics (6-7 hrs)

Tasks:
  - [ ] Volume over time charts
  - [ ] Strength progression graphs
  - [ ] PR tracking
  - [ ] Body measurements

Day 19 - Profile & Settings (5-6 hrs)

Tasks:
  - [ ] Profile screen
  - [ ] Edit profile
  - [ ] Settings screen
  - [ ] App preferences

Day 20 - Export & Sharing (4-5 hrs)

Tasks:
  - [ ] Export workout data (CSV)
  - [ ] Export programs (JSON)
  - [ ] Share progress images
  - [ ] Backup/restore data

Week 5: Polish & Optimization (Days 21-25)
Day 21 - Performance Optimization (5-6 hrs)

Tasks:
  - [ ] Profile app performance
  - [ ] Optimize Hive queries
  - [ ] Reduce build times
  - [ ] Test on old devices

Day 22 - UI/UX Polish (6-7 hrs)

Tasks:
  - [ ] Consistent spacing
  - [ ] Typography review
  - [ ] Color consistency
  - [ ] Animation polish

Day 23 - Error Handling (4-5 hrs)

Tasks:
  - [ ] Graceful error states
  - [ ] Offline support
  - [ ] Data validation
  - [ ] Edge case handling

Day 24 - Accessibility (4-5 hrs)

Tasks:
  - [ ] Screen reader support
  - [ ] Color contrast check
  - [ ] Text size scaling
  - [ ] Touch target sizes

Day 25 - Content & Copy (3-4 hrs)

Tasks:
  - [ ] Review all UI text
  - [ ] Add helpful tips
  - [ ] Onboarding copy
  - [ ] Error messages

Week 6: Launch Preparation (Days 26-30)
Day 26 - Store Assets (5-6 hrs)

Tasks:
  - [ ] Screenshots (10+)
  - [ ] App icons
  - [ ] Store descriptions
  - [ ] Feature graphics

Day 27 - Analytics & Monitoring (4-5 hrs)

Tasks:
  - [ ] Firebase Analytics
  - [ ] Crashlytics
  - [ ] Error tracking
  - [ ] Usage dashboards

Day 28 - Beta Testing (4-5 hrs)

Tasks:
  - [ ] TestFlight setup
  - [ ] Play Console setup
  - [ ] Recruit 10-20 testers
  - [ ] Feedback surveys

Day 29 - Final Testing (6-8 hrs)

Tasks:
  - [ ] Complete test pass
  - [ ] Fix critical bugs
  - [ ] Verify all features
  - [ ] Performance check

Day 30 - Submission Prep (4-5 hrs)

Tasks:
  - [ ] Final build
  - [ ] Store listings
  - [ ] Privacy policy
  - [ ] Terms of service

Progress After Week 6: 60% → 85% ✅

Phase 3: LAUNCH (Days 31-35) - 85% → 100%
Day 31 - App Store Submission
Day 32 - Play Store Submission
Day 33 - Beta Monitoring
Day 34 - Final Fixes
Day 35 - PUBLIC LAUNCH 

### **Development Order**:
```
Week 1: Fix current issues + Create dashboard
Week 2: Implement workout logger enhancements
Week 3: Add history screen
Week 4: Implement RPE analytics (what you want!)
Week 5: Polish + testing

CRITICAL (Must implement before production)
1. Authentication Screens (User can't login/signup)
lib/features/auth/
├── login_screen.dart
├── signup_screen.dart
├── forgot_password_screen.dart
└── email_verification_screen.dart

2. Main Navigation (No way to navigate app)
lib/features/dashboard/
├── main_dashboard_screen.dart  # Home screen with today's workout
└── navigation_controller.dart   # Bottom nav bar

3. Workout Execution (Can't actually do workouts)
lib/features/workout/
├── active_workout_screen.dart   # During workout
└── workout_complete_screen.dart # After finishing

4. History & Progress (Can't see past workouts)
lib/features/history/
├── history_screen.dart
├── workout_detail_screen.dart
└── widgets/
    ├── workout_card.dart
    └── calendar_view.dart

5. Template Files Missing
lib/data/program_templates/
├── general_fitness_templates.dart  # You're missing this
└── olympic_lifting_templates.dart  # Optional but good to have

HIGH PRIORITY (Needed for RPE feature you want)

6. Analytics Implementation
lib/features/analytics/
├── analytics_screen.dart        
├── rpe_trends_tab.dart
├── exercise_breakdown_tab.dart
└── widgets/
    ├── rpe_line_chart.dart      
    ├── rpe_bar_chart.dart
    └── muscle_group_heatmap.dart

lib/services/
└── rpe_analytics_service.dart   

lib/domain/models/
└── chart_data.dart              

lib/core/enums/
└── time_range.dart              

MEDIUM PRIORITY (Incomplete)

7. Profile & Settings
lib/features/profile/
├── profile_screen.dart
├── edit_profile_screen.dart
└── settings_screen.dart

8. AI Features
lib/features/ai/
├── chat_screen.dart
├── form_check_screen.dart
└── widgets/
    ├── chat_bubble.dart
    └── video_upload_widget.dart

LOW PRIORITY (Need future enhancement)

9. Additional Utilities
lib/core/utils/
├── date_helpers.dart
├── validators.dart
├── formatters.dart
├── export_helpers.dart
└── notification_service.dart

10. Testing
test/
├── services/
│   ├── rpe_analytics_service_test.dart
│   └── program_service_test.dart
├── utils/
│   └── rpe_math_test.dart
└── widgets/
    └── rpe_chart_test.dart