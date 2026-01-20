import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import 'core/enums/sport.dart';

// Data Layer
import 'data/repositories/training_repository_impl.dart';

// Services
import 'services/program_service.dart';
import 'services/rpe_feedback_service.dart';
import 'services/progression_service.dart';
import 'services/workout_session_service.dart';

// Feature screens - ACTUAL implementations from features/ folder
import 'features/onboarding/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/sport_selection_screen.dart';
import 'features/onboarding/goal_setup_screen.dart';
import 'features/program_selection/program_selection_screen.dart';
import 'features/dashboard/week_dashboard_screen.dart';

// NEW: Main navigation with bottom nav
import 'screens/main_navigation/main_navigation_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open Hive boxes for different data types
  final workoutBox = await Hive.openBox<Map>('workouts');
  final programBox = await Hive.openBox<Map>('programs');
  final profileBox = await Hive.openBox<Map>('profiles');
  final sessionBox = await Hive.openBox<Map>('sessions');

  // Initialize repository with Hive boxes
  final repository = TrainingRepositoryImpl(
    workoutBox: workoutBox,
    programBox: programBox,
    profileBox: profileBox,
    sessionBox: sessionBox,
  );

  // Initialize services
  final programService = ProgramService(repository);
  final rpeService = RPEFeedbackService();
  final progressionService = ProgressionService(repository);
  final sessionService = WorkoutSessionService(repository);

  runApp(
    AIFitnessCoachApp(
      programService: programService,
      rpeService: rpeService,
      progressionService: progressionService,
      sessionService: sessionService,
    ),
  );
}

class AIFitnessCoachApp extends StatelessWidget {
  final ProgramService programService;
  final RPEFeedbackService rpeService;
  final ProgressionService progressionService;
  final WorkoutSessionService sessionService;

  const AIFitnessCoachApp({
    Key? key,
    required this.programService,
    required this.rpeService,
    required this.progressionService,
    required this.sessionService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitCoach AI',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),

      // ============================================================
      // IMPORTANT: Start with your existing onboarding flow
      // ============================================================
      home: const SplashScreen(),

      // ============================================================
      // OPTION FOR TESTING: Skip onboarding, go straight to main app
      // Uncomment line below and comment out line above
      // ============================================================
      // home: const MainNavigationScreen(),

      // Define named routes
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/sport-selection': (context) => const SportSelectionScreen(),
        '/goal-setup': (context) => const GoalSetupScreen(),
        '/program-selection': (context) => const ProgramSelectionScreen(),
        '/main': (context) => const MainNavigationScreen(),
        '/week-dashboard': (context) => WeekDashboardScreen(
              program: null,
              currentWeek: 1,
            ),
      },

      // Advanced routing with custom transitions
      onGenerateRoute: _generateRoute,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF1E1E1E),
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFB4F04D),
        secondary: Color(0xFF00D9FF),
        surface: Color(0xFF1E1E1E),
        error: Color(0xFFFF6B6B),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white60,
          height: 1.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB4F04D),
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFFB4F04D),
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  Route? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ============================================================
      // ONBOARDING FLOW
      // ============================================================
      case '/':
        return _createRoute(const SplashScreen());

      case '/onboarding':
        return _createRoute(const OnboardingScreen());

      case '/sport-selection':
        return _createRoute(const SportSelectionScreen());

      case '/goal-setup':
        final sport = settings.arguments as Sport?;
        return _createRoute(GoalSetupScreen(selectedSport: sport));

      // ============================================================
      // MAIN APP SCREENS
      // ============================================================
      case '/main':
        return _createRoute(const MainNavigationScreen());

      case '/week-dashboard':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(WeekDashboardScreen(
          program: args?['program'],
          currentWeek: args?['currentWeek'] ?? 1,
        ));

      case '/program-selection':
        final sport = settings.arguments as Sport?;
        return _createRoute(ProgramSelectionScreen(sport: sport));

      default:
        return _createRoute(const NotFoundScreen());
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

// ============================================================================
// PLACEHOLDER SCREENS
// These are simple placeholders for routes that don't have implementations yet
// ============================================================================

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
