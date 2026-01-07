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

// Feature screens
import 'features/program_selection/program_selection_screen.dart';
import 'features/onboarding/goal_setup_screen.dart';
import 'features/dashboard/week_dashboard_screen.dart';

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
      title: 'AI Fitness Coach',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      initialRoute: '/',
      onGenerateRoute: (settings) => _generateRoute(settings),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF1E1E1E),
      scaffoldBackgroundColor: const Color(0xFF121212),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
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
      // AUTHENTICATION (Future Feature)
      // ============================================================
      case '/auth':
        final userData = settings.arguments as Map<String, dynamic>?;
        return _createRoute(AuthScreen(userData: userData));

      // ============================================================
      // MAIN APP SCREENS
      // ============================================================
      case '/dashboard':
        return _createRoute(const DashboardScreen());

      case '/week-dashboard':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(WeekDashboardScreen(
          program: args?['program'],
          currentWeek: args?['currentWeek'] ?? 1,
        ));

      case '/program-selection':
        final sport = settings.arguments as Sport?;
        return _createRoute(ProgramSelectionScreen(sport: sport));

      // ============================================================
      // WORKOUT FEATURES
      // ============================================================
      case '/workout-logger':
        final args = settings.arguments as Map<String, dynamic>?;
        return _createRoute(WorkoutLoggerScreen(
          program: args?['program'],
          week: args?['week'],
          day: args?['day'],
          workout: args?['workout'],
        ));

      case '/history':
        return _createRoute(const HistoryScreen());

      case '/workout-detail':
        final sessionId = settings.arguments as String?;
        return _createRoute(WorkoutDetailScreen(sessionId: sessionId));

      // ============================================================
      // AI FEATURES
      // ============================================================
      case '/chat':
        return _createRoute(const ChatScreen());

      case '/form-check':
        return _createRoute(const FormCheckScreen());

      // ============================================================
      // SETTINGS & PROFILE
      // ============================================================
      case '/settings':
        return _createRoute(const SettingsScreen());

      case '/profile':
        return _createRoute(const ProfileScreen());

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
// SPLASH SCREEN - First Impression
// ============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF121212),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB4F04D).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: Color(0xFFB4F04D),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'AI Fitness Coach',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Intelligent Training Partner',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ONBOARDING SCREEN - Welcome & Features
// ============================================================================
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.fitness_center,
                size: 80,
                color: Color(0xFFB4F04D),
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to AI Fitness Coach',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Smart training programs powered by RPE-based autoregulation',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              _buildFeatureItem(
                Icons.psychology,
                'AI-Powered',
                'Intelligent program adjustments based on your feedback',
              ),
              const SizedBox(height: 20),
              _buildFeatureItem(
                Icons.trending_up,
                'Progressive',
                'Systematic progression to reach your goals',
              ),
              const SizedBox(height: 20),
              _buildFeatureItem(
                Icons.analytics,
                'Data-Driven',
                'Track progress with detailed analytics',
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sport-selection');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFB4F04D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFB4F04D), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SPORT SELECTION SCREEN - Choose Your Sport
// ============================================================================
class SportSelectionScreen extends StatelessWidget {
  const SportSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Sport'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'What do you train for?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose your primary training focus',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _buildSportCard(
                      context,
                      Sport.powerlifting,
                      Icons.fitness_center,
                      'Powerlifting',
                      'Squat, Bench, Deadlift',
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.bodybuilding,
                      Icons.self_improvement,
                      'Bodybuilding',
                      'Muscle & Aesthetics',
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.crossfit,
                      Icons.directions_run,
                      'CrossFit',
                      'Functional Fitness',
                    ),
                    const SizedBox(height: 16),
                    _buildSportCard(
                      context,
                      Sport.generalFitness,
                      Icons.favorite,
                      'General Fitness',
                      'Health & Wellness',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportCard(
    BuildContext context,
    Sport sport,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/goal-setup',
            arguments: sport,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4F04D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFFB4F04D), size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PLACEHOLDER SCREENS - To be implemented
// ============================================================================

class AuthScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const AuthScreen({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: const Center(child: Text('Auth Screen - To be implemented')),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Main Dashboard - Coming Soon'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/week-dashboard');
              },
              child: const Text('Go to Week Dashboard (Test)'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat')),
      body: const Center(child: Text('Chat Screen - To be implemented')),
    );
  }
}

class FormCheckScreen extends StatelessWidget {
  const FormCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Check')),
      body: const Center(child: Text('Form Check - To be implemented')),
    );
  }
}

class WorkoutLoggerScreen extends StatelessWidget {
  final dynamic program;
  final int? week;
  final int? day;
  final dynamic workout;

  const WorkoutLoggerScreen({
    Key? key,
    this.program,
    this.week,
    this.day,
    this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Logger')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Workout Logger - To be implemented'),
            if (workout != null) Text('Workout: ${workout.toString()}'),
          ],
        ),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('History Screen - To be implemented')),
    );
  }
}

class WorkoutDetailScreen extends StatelessWidget {
  final String? sessionId;
  const WorkoutDetailScreen({Key? key, this.sessionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Detail')),
      body: Center(
        child: Text('Workout Detail - Session: ${sessionId ?? "none"}'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings - To be implemented')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile - To be implemented')),
    );
  }
}

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
            const Text('404 - Page Not Found'),
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
