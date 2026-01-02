/// Centralized UI strings for consistency and future localization
/// All user-facing text should be defined here
class UIStrings {
  // ==========================================
  // APP-WIDE
  // ==========================================
  static const String appName = 'AI Fitness Coach';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String continue_ = 'Continue';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String finish = 'Finish';
  static const String skip = 'Skip';

  // ==========================================
  // ONBOARDING
  // ==========================================
  static const String getStarted = 'Get Started';
  static const String welcomeTitle = 'Welcome to AI Fitness Coach';
  static const String welcomeSubtitle = 'Your Intelligent Training Partner';

  // ==========================================
  // SPORT SELECTION
  // ==========================================
  static const String selectSport = 'What drives you?';
  static const String selectSportSubtitle =
      'Choose your training focus. You can change this later.';
  static const String sportSelectionStep = 'Step 1 of 3';

  // ==========================================
  // GOAL SETUP
  // ==========================================
  static const String goalSetupTitle = 'Tell us about yourself';
  static const String goalSetupSubtitle =
      'This helps us create your perfect program';
  static const String goalSetupStep = 'Step 2 of 3';
  static const String experienceLevel = 'Experience Level';
  static const String primaryGoal = 'Primary Goal';
  static const String workoutsPerWeek = 'Workouts per week';
  static const String recommendedDays = 'Recommended: 3-5';

  // ==========================================
  // PROGRAM SELECTION
  // ==========================================
  static const String programSelection = 'Select Your Program';
  static const String chooseProgram = 'Choose Your Program';
  static const String startProgram = 'Start This Program';
  static const String programWeeks = 'weeks';
  static const String programDays = 'training days';
  static const String noProgramsAvailable = 'No programs available';
  static const String noProgramsMessage = 'Check back soon for new programs!';

  // ==========================================
  // WEEK DASHBOARD
  // ==========================================
  static const String weekDashboard = 'Week Dashboard';
  static const String currentWeek = 'Current Week';
  static const String weekOf = 'Week';
  static const String weekProgress = 'Week Progress';
  static const String complete = 'Complete';
  static const String thisWeeksWorkouts = 'This Week\'s Workouts';
  static const String targetRPE = 'Target RPE';
  static const String yourAvg = 'Your Avg';
  static const String onTrack = 'On Track';
  static const String offTrack = 'Off Track';
  static const String restDay = 'Rest Day';
  static const String trainingDays = 'Training Days';
  static const String totalSets = 'Total Sets';
  static const String restDays = 'Rest Days';
  static const String viewFullProgram = 'View Full Program';
  static const String unlocked = 'All Unlocked';

  // ==========================================
  // WORKOUT LOGGER
  // ==========================================
  static const String workoutLogger = 'Workout Logger';
  static const String setTracker = 'Set Tracker';
  static const String exercisePreview = 'Exercise Preview';
  static const String logSet = 'Log Set';
  static const String logFirstSet = 'Log First Set';
  static const String logSetNumber = 'Log Set';
  static const String markComplete = 'Mark Complete';
  static const String completeWorkout = 'Finish Workout';
  static const String keepLogging = 'Keep Logging';
  static const String workoutComplete = 'Workout Complete! 🎉';
  static const String noWorkoutSelected = 'No workout selected';
  static const String selectWorkoutMessage =
      'Select a workout from the week dashboard';
  static const String sets = 'Sets';
  static const String avgRPE = 'Avg RPE';
  static const String time = 'Time';
  static const String exercises = 'exercises';
  static const String todaysExercises = 'Today\'s Exercises';

  // ==========================================
  // RPE TRACKING
  // ==========================================
  static const String rpe = 'RPE';
  static const String rpeFullName = 'Rate of Perceived Exertion';
  static const String sessionAverageRPE = 'Session Average RPE';
  static const String targetRPERange = 'Target RPE';
  static const String currentRPE = 'Current RPE';
  static const String easy = 'Easy';
  static const String max = 'Max';
  static const String belowTarget = 'Below target - add weight next set';
  static const String onTarget = '🎯 Perfect! You\'re in the sweet spot.';
  static const String aboveTarget = 'Above target! Reduce weight.';
  static const String perfectRPE = 'Perfect! On target RPE.';

  // ==========================================
  // SET LOGGING
  // ==========================================
  static const String weight = 'Weight';
  static const String reps = 'Reps';
  static const String notes = 'Notes';
  static const String addNotes = 'Add notes (optional)';
  static const String loggedSets = 'Logged Sets';
  static const String saveSet = 'Save Set';
  static const String deleteSet = 'Delete Set';
  static const String setLogged = 'Set logged! 💪';
  static const String enterValidWeight = 'Please enter a valid weight';
  static const String enterValidReps = 'Please enter valid reps';

  // ==========================================
  // FEEDBACK MESSAGES
  // ==========================================
  static const String greatWork = 'Great work!';
  static const String excellentSession =
      '🎉 Outstanding Work! Your RPE was right on target. Perfect execution!';
  static const String goodSession =
      'Good session! Your RPE was lower than target. Consider adding weight next time.';
  static const String hardSession =
      'Great effort! Your RPE was higher than target. Listen to your body and adjust as needed.';
  static const String progressSaved =
      'Progress saved. Rest up and come back stronger!';
  static const String readyToStart = 'Ready to start your session!';
  static const String feelingStrong =
      '💪 You\'re feeling strong today! Consider adding weight.';
  static const String highRPE =
      '😅 High RPE detected. Listen to your body - it\'s okay to reduce volume.';
  static const String logAtLeastOneSet =
      'Log at least one set before finishing!';

  // ==========================================
  // DASHBOARD
  // ==========================================
  static const String goodMorning = 'Good Morning';
  static const String goodAfternoon = 'Good Afternoon';
  static const String goodEvening = 'Good Evening';
  static const String dayStreak = 'Day Streak!';
  static const String keepItUp = 'Keep it up! You\'re on fire 🔥';
  static const String workouts = 'Workouts';
  static const String todaysFocus = 'Today\'s Focus';
  static const String startWorkout = 'Start Workout';
  static const String aiTools = 'AI Tools';
  static const String quickTools = 'Quick Tools';

  // ==========================================
  // AI FEATURES
  // ==========================================
  static const String chatWithAI = 'Chat with AI Coach';
  static const String chatSubtitle = 'Get instant answers to your questions';
  static const String formCheck = 'Form Check';
  static const String formCheckSubtitle = 'Upload video for AI analysis';
  static const String nutritionTracker = 'Nutrition Tracker';
  static const String nutritionSubtitle = 'Log meals and track macros';
  static const String aiCoach = 'AI Coach';
  static const String alwaysReady = 'Always ready to help';
  static const String askAnything = 'Ask anything...';
  static const String uploadVideo = 'Upload Your Lift';
  static const String tapToUpload = 'Tap to Upload Video';
  static const String selectExerciseFirst = 'Select an exercise first';
  static const String analyzingForm = 'Analyzing your form...';
  static const String formScore = 'Form Score';
  static const String whatsGood = 'What\'s Good';
  static const String areasToImprove = 'Areas to Improve';
  static const String proTips = 'Pro Tips';
  static const String injuryRisk = 'Injury Risk Assessment';
  static const String discussResults = 'Discuss Results';
  static const String newAnalysis = 'New Analysis';

  // ==========================================
  // HISTORY
  // ==========================================
  static const String history = 'History';
  static const String workoutHistory = 'Workout History';
  static const String previousWorkouts = 'Previous Workouts';
  static const String noWorkoutsYet = 'No workouts logged yet';
  static const String startTraining = 'Start training to see your history';
  static const String viewDetails = 'View Details';
  static const String sessionSummary = 'Session Summary';
  static const String duration = 'Duration';
  static const String volume = 'Volume';
  static const String tonnage = 'Tonnage';
  static const String completionRate = 'Completion Rate';

  // ==========================================
  // PROGRESS
  // ==========================================
  static const String progress = 'Progress';
  static const String myProgress = 'My Progress';
  static const String progressPhotos = 'Progress Photos';
  static const String personalRecords = 'Personal Records';
  static const String strengthGains = 'Strength Gains';
  static const String volumeTracking = 'Volume Tracking';
  static const String rpeAnalysis = 'RPE Analysis';

  // ==========================================
  // PROFILE
  // ==========================================
  static const String profile = 'Profile';
  static const String myProfile = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String settings = 'Settings';
  static const String preferences = 'Preferences';
  static const String logout = 'Logout';
  static const String deleteAccount = 'Delete Account';

  // ==========================================
  // AUTH
  // ==========================================
  static const String login = 'Log In';
  static const String signup = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String fullName = 'Full Name';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = 'Don\'t have an account? ';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String continueAsGuest = 'Continue as Guest';
  static const String createAccount = 'Create Account';
  static const String welcomeBack = 'Welcome Back';
  static const String almostThere = 'Almost There!';
  static const String authStep = 'Step 3 of 3';
  static const String dataSecure =
      'Your data is encrypted and secure. We never share your information.';

  // ==========================================
  // ERRORS
  // ==========================================
  static const String errorOccurred = 'An error occurred';
  static const String tryAgain = 'Try Again';
  static const String retry = 'Retry';
  static const String noConnection = 'No internet connection';
  static const String loadFailed = 'Failed to load data';
  static const String saveFailed = 'Failed to save';
  static const String invalidInput = 'Invalid input';
  static const String required = 'Required';

  // ==========================================
  // TOOLS
  // ==========================================
  static const String plateCalculator = 'Plate\nCalculator';
  static const String oneRMCalculator = '1RM\nCalculator';
  static const String injuryRecovery = 'Injury\nRecovery';

  // ==========================================
  // PHASE NAMES
  // ==========================================
  static const String hypertrophy = 'Hypertrophy';
  static const String strength = 'Strength';
  static const String power = 'Power';
  static const String peaking = 'Peaking';
  static const String deload = 'Deload';
  static const String maintenance = 'Maintenance';

  // ==========================================
  // WORKOUT TYPES
  // ==========================================
  static const String restAndRecovery = 'Rest & Recovery';
  static const String activeRecovery =
      'Active recovery: light stretching, walking, or mobility work';
  static const String mainLift = 'MAIN';
  static const String accessory = 'ACCESSORY';

  // ==========================================
  // DELOAD & RECOVERY
  // ==========================================
  static const String deloadWeek = 'Deload Week';
  static const String recoveryWeek =
      'Recovery week: focus on technique and feel good';
  static const String prioritizeRecovery = 'Prioritize recovery.';
  static const String listenToBody = 'Listen to your body';

  // ==========================================
  // MISCELLANEOUS
  // ==========================================
  static const String comingSoon = 'Coming Soon';
  static const String underConstruction = 'This feature is under construction';
  static const String betaFeature = 'Beta Feature';
  static const String testMode = 'TEST MODE';
  static const String close = 'Close';
  static const String info = 'Info';
  static const String help = 'Help';
  static const String tutorial = 'Tutorial';
  static const String whatsNew = 'What\'s New';
  static const String feedback = 'Feedback';
  static const String reportBug = 'Report Bug';
  static const String rateApp = 'Rate App';
  static const String shareApp = 'Share App';
  static const String version = 'Version';
}
