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
  final programService = ProgramService();
  programService.setRepository(repository);
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
    );
  }

  Route? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());

      case '/onboarding':
        return _createRoute(const OnboardingScreen());

      case '/sport-selection':
        return _createRoute(const SportSelectionScreen());

      case '/goal-setup':
        final sport = settings.arguments as Sport?;
        return _createRoute(GoalSetupScreen(selectedSport: sport));

      case '/auth':
        final userData = settings.arguments as Map<String, dynamic>?;
        return _createRoute(AuthScreen(userData: userData));

      case '/dashboard':
        return _createRoute(const DashboardScreen());

      case '/chat':
        return _createRoute(const ChatScreen());

      case '/form-check':
        return _createRoute(const FormCheckScreen());

      case '/program-selection':
        return _createRoute(
          ProgramSelectionScreen(sport: null),
        );

      case '/week-dashboard':
        return _createRoute(const WeekDashboardScreen());

      case '/workout-logger':
        return _createRoute(const WorkoutLoggerScreen());

      default:
        return null;
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
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
      color: const Color(0xFF1E1E1E),
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

// GoalSetupScreen is now implemented in features/onboarding/goal_setup_screen.dart

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
      body: const Center(child: Text('Dashboard - To be implemented')),
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

class WeekDashboardScreen extends StatelessWidget {
  const WeekDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Week Dashboard')),
      body: const Center(child: Text('Week Dashboard - To be implemented')),
    );
  }
}

class WorkoutLoggerScreen extends StatelessWidget {
  const WorkoutLoggerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Logger')),
      body: const Center(child: Text('Workout Logger - To be implemented')),
    );
  }
}
