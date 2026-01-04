import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Data Layer
import 'data/repositories/training_repository_impl.dart';

// Services
import 'services/program_service.dart';
import 'services/rpe_feedback_service.dart';
import 'services/progression_service.dart';
import 'services/workout_session_service.dart';

// Feature screens
import 'features/program_selection/program_selection_screen.dart';

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

      case '/program-selection':
        return _createRoute(
          ProgramSelectionScreen(
    sport: null,
  ),

      // Add more routes here as needed
      // case '/workout-logger':
      //   return _createRoute(
      //     WorkoutLoggerScreen(
      //       sessionService: sessionService,
      //       rpeService: rpeService,
      //     ),
      //   );

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

// ============================================
// SPLASH SCREEN - First Impression
// ============================================
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
        Navigator.pushReplacementNamed(context, '/program-selection');
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
