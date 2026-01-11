# NEW FOCUSED ROADMAP - v2.1
## UPDATED: History & State Management Files Added!

**Last Updated:** January 11, 2026  
**New Files Planned:** 5 critical files for state management & history feature

---

## Phase 1: MAKE IT WORK (Days 1-15) - 25% → 60%
Goal: Functional app that users can actually use

### Week 1: Foundation (Days 1-5)
Critical path to get data flowing

#### Day 1 - State Management (6-8 hrs) 🔴 BLOCKING

**Priority:** P0 - Nothing works without this

**Morning Tasks:**
- [ ] flutter pub add flutter_riverpod
- [ ] Create lib/core/providers/providers.dart
- [ ] **🆕 CREATE: lib/core/providers/app_state.dart** (CRITICAL NEW FILE!)
- [ ] Wrap MaterialApp with ProviderScope

**app_state.dart Structure:**
```dart
// Central location for all app-wide state providers
- athleteProfileProvider - User profile data
- programListProvider - All available programs
- selectedProgramProvider - Currently active program
- currentWeekProvider - Active training week
- workoutHistoryProvider - Past workouts (for Day 8) 🆕
- activeWorkoutProvider - Current workout session
```

**Afternoon Tasks:**
- [ ] Implement all providers in app_state.dart
- [ ] Create athleteProfileProvider
- [ ] Create selectedProgramProvider
- [ ] Create programListProvider
- [ ] Test hot reload works
- [ ] Verify state persists in navigation

**Deliverable:** App runs with working state via app_state.dart
**Blocker for:** Everything else

---

#### Day 2 - Data Persistence (6-7 hrs) 🔴 BLOCKING

**Priority:** P0 - No saving = no app

**Morning Tasks:**
- [ ] Initialize Hive in main.dart
- [ ] Create HiveService wrapper
- [ ] Open boxes: profiles, programs, workouts, sessions
- [ ] Test basic save/load

**Afternoon Tasks:**
- [ ] Connect AthleteProfile to Hive
- [ ] Test Goal Setup saves profile
- [ ] Kill app, restart, verify profile loads
- [ ] Fix any serialization issues

**Deliverable:** Profile persists between sessions
**Test:** Complete setup → Close app → Reopen → Profile still there

---

#### Day 3 - Program Templates (5-6 hrs) 🟡 HIGH VALUE

**Priority:** P1 - Need content to show

**Tasks:**
- [ ] Copy powerlifting template content
- [ ] Copy crossfit template content
- [ ] Copy bodybuilding template content
- [ ] Create 1 simple general fitness template
- [ ] Test templates load in ProgramSelectionScreen

**Deliverable:** 10-12 real program templates
**Impact:** App now has real content!

---

#### Day 4 - Connect Services (6-7 hrs) 🟡 CRITICAL

**Priority:** P1 - Wire everything together

**Morning Tasks:**
- [ ] Update ProgramService to load templates
- [ ] Connect ProgramSelectionScreen to service
- [ ] Save selected program to Hive
- [ ] Test program selection flow

**Afternoon Tasks:**
- [ ] Create WeekDashboardScreen (basic version)
- [ ] Load selected program's first week
- [ ] Display 7 days with workouts
- [ ] Test navigation: Goal Setup → Program Select → Week View

**Deliverable:** Can select program and see first week
**Test:** Complete onboarding → See actual workout schedule

---

#### Day 5 - Custom Program Builder 🆕 NEW FEATURE

**Priority:** P1 - Your requested feature!

**Morning Tasks:**
- [ ] Create CustomProgramScreen
- [ ] Add "Create Custom Program" button in ProgramSelection
- [ ] Build form: Name, Duration (1-52 weeks), Sport
- [ ] Add "Quick Program" option (1 day, 4 weeks, 12 weeks)

**Afternoon Tasks:**
- [ ] Create DayEditorScreen
- [ ] Add exercises to custom day
- [ ] Set: Sets, Reps, RPE targets
- [ ] Save custom program to Hive
- [ ] Test: Create → Save → Select → View in dashboard

**Deliverable:** Users can create custom programs

**Features:**
- Quick templates (1 day, 4 weeks, 12 weeks)
- Full custom builder
- Import coach's program (manual entry)
- Save/edit/delete custom programs

**Files to create:**
- lib/features/programs/custom_program_screen.dart
- lib/features/programs/day_editor_screen.dart
- lib/features/programs/widgets/exercise_picker.dart

---

### Week 2: Core Features (Days 6-10)

#### Day 6 - Workout Logger (7-8 hrs) 🔴 CORE FEATURE

**Priority:** P0 - Main app functionality

**Morning Tasks:**
- [ ] Create WorkoutLoggerScreen (proper one)
- [ ] Display exercises from daily workout
- [ ] Show: Exercise name, sets, reps, RPE target
- [ ] Build set logging UI

**Afternoon Tasks:**
- [ ] Add set counter (Set 1/3, Set 2/3, etc.)
- [ ] RPE slider (6-10 with descriptions)
- [ ] Weight + Reps input
- [ ] Save logged sets to Hive
- [ ] Show previously logged sets

**Deliverable:** Can log a complete workout
**Test:** Select workout → Log all exercises → Save → Verify in Hive

---

#### Day 7 - RPE Feedback Integration (5-6 hrs) 🧠

**Priority:** P1 - Smart coaching

**Morning Tasks:**
- [ ] Connect RPEFeedbackService to logger
- [ ] Show real-time RPE feedback
- [ ] Display: "Too Easy", "On Target", "Too Hard"
- [ ] Add weight recommendations

**Afternoon Tasks:**
- [ ] Calculate session average RPE
- [ ] Show running average during workout
- [ ] Add fatigue warnings
- [ ] Test feedback accuracy

**Deliverable:** Smart RPE coaching during workouts
**Impact:** App feels intelligent!

---

#### Day 8 - History Feature (6-7 hrs) 📊 🆕 COMPLETE REBUILD!

**Priority:** P1 - See progress & track workouts

**Morning Tasks (3-4 hours):**
- [ ] **🆕 CREATE: lib/features/history/history_screen.dart** (MAIN HISTORY VIEW!)
- [ ] **🆕 CREATE: lib/features/history/workout_detail_screen.dart** (DETAIL VIEW!)
- [ ] Build workout history list UI
- [ ] Add date range filter
- [ ] Add program filter
- [ ] Add search by exercise

**Afternoon Tasks (3-4 hours):**
- [ ] **🆕 CREATE: lib/features/history/widgets/workout_card.dart** (LIST ITEM!)
- [ ] **🆕 CREATE: lib/features/history/widgets/calendar_view.dart** (CALENDAR UI!)
- [ ] Wire up to Hive workout data
- [ ] Test workout detail navigation
- [ ] Test calendar view
- [ ] Add workout stats summary

---

### **🆕 DETAILED FILE SPECIFICATIONS FOR DAY 8:**

#### **File 1: history_screen.dart** 📋
```dart
Location: lib/features/history/history_screen.dart
Purpose: Main history screen with workout list

Features to implement:
- AppBar with "History" title
- Toggle between List view and Calendar view
- Date range filter (Last 7 days, Month, Quarter, Year, All)
- Program filter dropdown
- Search bar for exercise names
- InfiniteScroll workout list using workout_card.dart
- Empty state ("No workouts yet")
- Floating action button to filter/search
- Total stats at top (Total Workouts, Volume, Average RPE)
- Pull to refresh
- Navigate to workout_detail_screen on card tap

Dependencies:
- Riverpod for state (workoutHistoryProvider from app_state.dart)
- Hive for data loading
- workout_card.dart widget
- calendar_view.dart widget
```

#### **File 2: workout_detail_screen.dart** 📝
```dart
Location: lib/features/history/workout_detail_screen.dart
Purpose: Show complete workout details

Features to implement:
- AppBar with workout date and program name
- Workout summary card (duration, total sets, volume, avg RPE)
- Exercise list with expandable sections
- For each exercise show:
  * All logged sets (Set #, Weight, Reps, RPE)
  * Set-by-set RPE chart (mini bar chart)
  * Exercise notes
- Workout-level notes section
- Action buttons:
  * Share workout (export as text/image)
  * Edit workout (if recent)
  * Delete workout
- Bottom stats: Total volume, Time under tension
- Compare with previous workout of same type

Dependencies:
- RPE visualization (reuse rpe_bar_chart.dart)
- Share functionality
- Edit/Delete with confirmation dialogs
```

#### **File 3: workout_card.dart** 🎴
```dart
Location: lib/features/history/widgets/workout_card.dart
Purpose: Reusable workout summary card for lists

Features to implement:
- Card with elevation and rounded corners
- Top row: Date (large) | Program badge
- Middle: Exercise count ("5 exercises")
- Stats row:
  * Total sets
  * Total volume (e.g., "2,450 kg")
  * Average RPE (color-coded indicator)
- Bottom: Duration (e.g., "45 min")
- Completion status badge (100% complete)
- Tap to navigate to workout_detail_screen
- Long press for quick actions (share, delete)
- Visual RPE indicator (colored left border)

Styling:
- Green border for RPE < 7
- Yellow border for RPE 7-8
- Red border for RPE > 8
- Subtle gradient background
```

#### **File 4: calendar_view.dart** 📅
```dart
Location: lib/features/history/widgets/calendar_view.dart
Purpose: Monthly calendar with workout visualization

Features to implement:
- Monthly calendar grid (7 columns x 5-6 rows)
- Month/Year header with navigation arrows
- Mark days with workouts (colored dots)
- Color coding by intensity:
  * Green dot = Light (RPE < 7)
  * Yellow dot = Moderate (RPE 7-8)
  * Red dot = Hard (RPE > 8)
- Tap day to see workouts on that date
- Swipe to change months
- Show workout count per day (e.g., "2" badge)
- Highlight today's date
- Streak visualization (consecutive workout days)
- Legend at bottom showing color meanings

Dependencies:
- table_calendar package (or custom implementation)
- Date utilities
- Workout data from Hive
```

---

**Day 8 Deliverable:**
✅ **COMPLETE HISTORY FEATURE with 4 new files!**
- Can view all past workouts
- Calendar and list views
- Detailed workout breakdown
- Share and export functionality

**Test Scenarios for Day 8:**
1. View history list → See all workouts
2. Switch to calendar view → See workout days marked
3. Tap workout card → See full details
4. Filter by program → See filtered results
5. Search exercise → Find specific workouts
6. Share workout → Export as text/image

---

#### Day 9 - Analytics Foundation (6-7 hrs) 📈

**Priority:** P1 - Your requested feature!

**Morning Tasks:**
- [ ] Install fl_chart package
- [ ] Create missing analytics files:
  ✅ rpe_analytics_service.dart (you have)
  ✅ analytics_screen.dart (you have)
  ✅ rpe_line_chart.dart (you have)
  - [ ] rpe_bar_chart.dart
  - [ ] exercise_breakdown_tab.dart
  - [ ] muscle_group_heatmap.dart

**Afternoon Tasks:**
- [ ] Create chart_data.dart models
- [ ] Create time_range.dart enum
- [ ] Connect analytics_screen to data
- [ ] Test with mock data

**Deliverable:** Basic RPE charts working

---

#### Day 10 - Week Progress Tracking (4-5 hrs) ✅

**Priority:** P2 - Polish

**Tasks:**
- [ ] Add week completion tracking
- [ ] Show progress bars
- [ ] Mark completed workouts
- [ ] Calculate weekly stats
- [ ] Test week transitions

**Deliverable:** Can track weekly progress

---

### Week 3: Polish & Testing (Days 11-15)

#### Day 11 - UI Polish Pass (5-6 hrs)

**Tasks:**
- [ ] Add loading states everywhere
- [ ] Improve error messages
- [ ] Add haptic feedback
- [ ] Smooth animations
- [ ] Test all navigation flows

#### Day 12 - Bug Fixing Sprint (6-8 hrs)

**Tasks:**
- [ ] Test complete user journey
- [ ] Fix all P0 bugs
- [ ] Fix P1 bugs
- [ ] Document P2 bugs for later

#### Day 13 - Basic Unit Tests (5-6 hrs)

**Tasks:**
- [ ] Test RPEMath
- [ ] Test domain models
- [ ] Test key use cases
- [ ] Target: 40% coverage

#### Day 14 - Widget Tests (5-6 hrs)

**Tasks:**
- [ ] Test 3-5 critical screens
- [ ] Test form validation
- [ ] Test navigation
- [ ] **🆕 Test history widgets** (workout_card, calendar_view)

#### Day 15 - Integration Testing (5-6 hrs)

**Tasks:**
- [ ] Test complete flows
- [ ] Test data persistence
- [ ] Test edge cases
- [ ] Performance check
- [ ] **🆕 Test history workflows** (view, filter, detail)

**Progress After Week 3:** 25% → 60% ✅

---

## Phase 2: MAKE IT GOOD (Days 16-30) - 60% → 85%
Goal: Production-quality experience

### Week 4: Advanced Features (Days 16-20)

#### Day 16 - Program Management (5-6 hrs)

**Tasks:**
- [ ] Edit custom programs
- [ ] Duplicate programs
- [ ] Share programs (export JSON)
- [ ] Import programs (from JSON)

#### Day 17 - Enhanced Workout Logger (5-6 hrs)

**Tasks:**
- [ ] Add rest timer
- [ ] Add workout timer
- [ ] Add notes per exercise
- [ ] Add supersets support

#### Day 18 - Progress Analytics (6-7 hrs)

**Tasks:**
- [ ] Volume over time charts
- [ ] Strength progression graphs
- [ ] PR tracking
- [ ] Body measurements
- [ ] **🆕 Connect to history data for trends**

#### Day 19 - Profile & Settings (5-6 hrs)

**Tasks:**
- [ ] Profile screen
- [ ] Edit profile
- [ ] Settings screen
- [ ] App preferences

#### Day 20 - Export & Sharing (4-5 hrs)

**Tasks:**
- [ ] Export workout data (CSV)
- [ ] Export programs (JSON)
- [ ] Share progress images
- [ ] Backup/restore data
- [ ] **🆕 Share from history feature**

---

### Week 5: Polish & Optimization (Days 21-25)

#### Day 21 - Performance Optimization (5-6 hrs)

**Tasks:**
- [ ] Profile app performance
- [ ] Optimize Hive queries
- [ ] Reduce build times
- [ ] Test on old devices
- [ ] **🆕 Optimize history list rendering**

#### Day 22 - UI/UX Polish (6-7 hrs)

**Tasks:**
- [ ] Consistent spacing
- [ ] Typography review
- [ ] Color consistency
- [ ] Animation polish
- [ ] **🆕 Calendar view polish**

#### Day 23 - Error Handling (4-5 hrs)

**Tasks:**
- [ ] Graceful error states
- [ ] Offline support
- [ ] Data validation
- [ ] Edge case handling

#### Day 24 - Accessibility (4-5 hrs)

**Tasks:**
- [ ] Screen reader support
- [ ] Color contrast check
- [ ] Text size scaling
- [ ] Touch target sizes

#### Day 25 - Content & Copy (3-4 hrs)

**Tasks:**
- [ ] Review all UI text
- [ ] Add helpful tips
- [ ] Onboarding copy
- [ ] Error messages

---

### Week 6: Launch Preparation (Days 26-30)

#### Day 26 - Store Assets (5-6 hrs)

**Tasks:**
- [ ] Screenshots (10+, **include history feature!** 🆕)
- [ ] App icons
- [ ] Store descriptions
- [ ] Feature graphics

#### Day 27 - Analytics & Monitoring (4-5 hrs)

**Tasks:**
- [ ] Firebase Analytics
- [ ] Crashlytics
- [ ] Error tracking
- [ ] Usage dashboards

#### Day 28 - Beta Testing (4-5 hrs)

**Tasks:**
- [ ] TestFlight setup
- [ ] Play Console setup
- [ ] Recruit 10-20 testers
- [ ] Feedback surveys

#### Day 29 - Final Testing (6-8 hrs)

**Tasks:**
- [ ] Complete test pass
- [ ] Fix critical bugs
- [ ] Verify all features
- [ ] Performance check
- [ ] **🆕 Test history data migration**

#### Day 30 - Submission Prep (4-5 hrs)

**Tasks:**
- [ ] Final build
- [ ] Store listings
- [ ] Privacy policy
- [ ] Terms of service

**Progress After Week 6:** 60% → 85% ✅

---

## Phase 3: LAUNCH (Days 31-35) - 85% → 100%

#### Day 31 - App Store Submission
#### Day 32 - Play Store Submission
#### Day 33 - Beta Monitoring
#### Day 34 - Final Fixes
#### Day 35 - PUBLIC LAUNCH 🚀

---

## 🆕 UPDATED: CRITICAL FILES CHECKLIST

### **COMPLETED (Must implement before production)**

#### 1. ✅ Authentication Screens (Future Phase)
- login_screen.dart
- signup_screen.dart
- forgot_password_screen.dart
- email_verification_screen.dart

#### 2. ✅ Main Navigation (Existing)
- main_dashboard_screen.dart
- navigation_controller.dart

#### 3. ✅ Workout Execution (Existing)
- active_workout_screen.dart
- workout_complete_screen.dart

---

### **🆕 NEW FILES ADDED TO ROADMAP**

#### 4. **State Management (Day 1 - CRITICAL!)** 🔴
```
lib/core/providers/
└── app_state.dart                    # 🆕 ADDED - Central state management
```
**Purpose:** Single source of truth for all app-wide providers
**Contains:** All Riverpod providers in one organized file
**Priority:** P0 - BLOCKING

---

#### 5. **History & Progress (Day 8 - HIGH PRIORITY!)** 📊
```
lib/features/history/
├── history_screen.dart               # 🆕 ADDED - Workout history list
├── workout_detail_screen.dart        # 🆕 ADDED - Individual workout view
└── widgets/
    ├── workout_card.dart             # 🆕 ADDED - History card widget
    └── calendar_view.dart            # 🆕 ADDED - Calendar visualization
```
**Purpose:** Complete workout history and progress tracking
**Contains:** 4 new files for full history feature
**Priority:** P1 - HIGH VALUE

---

#### 6. Template Files (Day 3-5)
```
lib/data/program_templates/
├── general_fitness_templates.dart    # Day 3
└── olympic_lifting_templates.dart    # Optional
```

#### 7. Analytics Implementation (Day 9)
```
lib/features/analytics/
├── analytics_screen.dart             ✅ EXISTS
├── rpe_trends_tab.dart              ✅ EXISTS
├── exercise_breakdown_tab.dart       # Day 9
└── widgets/
    ├── rpe_line_chart.dart          ✅ EXISTS
    ├── rpe_bar_chart.dart           ✅ EXISTS
    └── muscle_group_heatmap.dart     # Day 9

lib/services/
└── rpe_analytics_service.dart       ✅ EXISTS

lib/domain/models/
└── chart_data.dart                  # Day 9

lib/core/enums/
└── time_range.dart                  ✅ EXISTS
```

---

## 🎯 DEVELOPMENT ORDER (UPDATED)

### **Week 1: Foundation**
1. **Day 1:** State Management + app_state.dart 🆕
2. **Day 2:** Data Persistence (Hive)
3. **Day 3:** Program Templates
4. **Day 4:** Connect Services
5. **Day 5:** Custom Program Builder

### **Week 2: Core Features**
6. **Day 6:** Workout Logger
7. **Day 7:** RPE Integration
8. **🆕 Day 8:** **Complete History Feature (4 new files!)** 📊
9. **Day 9:** Analytics Foundation
10. **Day 10:** Week Progress Tracking

### **Week 3: Polish & Testing**
11. **Day 11:** UI Polish
12. **Day 12:** Bug Fixing
13. **Day 13:** Unit Tests (+ history tests 🆕)
14. **Day 14:** Widget Tests (+ history widgets 🆕)
15. **Day 15:** Integration Testing

---

## 📊 FILE STATUS SUMMARY

### ✅ **State Management Files (Day 1)**
- 🆕 `app_state.dart` - PLANNED, READY TO BUILD

### ✅ **History Files (Day 8)**
- 🆕 `history_screen.dart` - PLANNED, SPECS COMPLETE
- 🆕 `workout_detail_screen.dart` - PLANNED, SPECS COMPLETE
- 🆕 `workout_card.dart` - PLANNED, SPECS COMPLETE
- 🆕 `calendar_view.dart` - PLANNED, SPECS COMPLETE

### ✅ **Analytics Files**
- ✅ All core widgets exist
- ⚠️ Need data connection (Day 9)

### ⚠️ **Template Files**
- ⚠️ Structure exists, need content (Day 3)

---

## 🚀 QUICK WINS UPDATED

### **This Week (Days 1-5)**
1. ✅ Day 1: app_state.dart (6-8 hrs) - MASSIVE IMPACT
2. ✅ Day 3: Templates (4-6 hrs) - HIGH IMPACT
3. ✅ Day 5: Custom Builder (6-7 hrs) - USER REQUEST

### **Next Week (Days 6-10)**
4. 🆕 Day 8: Complete History (6-7 hrs) - 4 NEW FILES!
5. ✅ Day 9: Analytics Connect (4-6 hrs) - FEATURE COMPLETE

---

## 🎉 SUMMARY OF CHANGES

### **Files Added to Plan: 5**
1. ✅ `lib/core/providers/app_state.dart` (Day 1)
2. ✅ `lib/features/history/history_screen.dart` (Day 8)
3. ✅ `lib/features/history/workout_detail_screen.dart` (Day 8)
4. ✅ `lib/features/history/widgets/workout_card.dart` (Day 8)
5. ✅ `lib/features/history/widgets/calendar_view.dart` (Day 8)

### **Impact:**
- ✅ Zero critical files missing
- ✅ Complete history feature planned
- ✅ State management structure defined
- ✅ Clear implementation path for Day 1 & Day 8
- ✅ All specifications documented

---

**Remember:** You now have a complete plan for state management AND the full history feature! 🎊

*Last Updated: January 11, 2026*
*Version: 2.1 (History & State Edition)*
*Next: Execute Day 1 - Create app_state.dart!*