import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import 'core/enums/sport.dart';

// Data Layer
import 'data/repositories/training_repository_impl.dart';

// Domain Layer
import 'domain/repositories/training_repository.dart';

// Services
import 'services/program_service.dart';
import 'services/rpe_feedback_service.dart';
import 'services/progression_service.dart';
import 'services/workout_session_service.dart';

// Feature screens (keep your existing imports)
import 'features/program_selection/program_selection_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Core
import 'core/enums/sport.dart';

// Data Layer
import 'data/repositories/training_repository_impl.dart';

// Domain Layer
import 'domain/repositories/training_repository.dart';

// Services
import 'services/program_service.dart';
import 'services/rpe_feedback_service.dart';
import 'services/progression_service.dart';
import 'services/workout_session_service.dart';

// Feature screens (keep your existing imports)
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
    );
  }

  Route? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());
      
      case '/program-selection':
        return _createRoute(
          ProgramSelectionScreen(
            programService: programService,
          ),
        );

      // Add more routes here...
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

// Simple splash screen (keep your existing implementation)
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

  // ✅ FIXED: Type-safe route generation
  Route? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());
      case '/onboarding':
        return _createRoute(const OnboardingScreen());
      case '/sport-selection':
        return _createRoute(const SportSelectionScreen());
      case '/goal-setup':
        return _createRoute(GoalSetupScreen(
          selectedSport: settings.arguments as Sport?,
        ));
      case '/auth':
        return _createRoute(AuthScreen(
          userData: settings.arguments as Map<String, dynamic>?,
        ));
      case '/dashboard':
        return _createRoute(const DashboardScreen());
      case '/chat':
        return _createRoute(const ChatScreen());
      case '/form-check':
        return _createRoute(const FormCheckScreen());
      case '/program-selection':
        return _createRoute(const ProgramSelectionScreen());
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

// ============================================
// SPLASH SCREEN - First Impression
// ============================================
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
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // ✅ FIXED: Check mounted before navigation
    Future.delayed(const Duration(seconds: 3), () {
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
                  Text(
                    'AI Fitness Coach',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your Intelligent Training Partner',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 50),
                  const CircularProgressIndicator(
                    color: Color(0xFFB4F04D),
                    strokeWidth: 2,
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

// ============================================
// ONBOARDING - Build Trust & Set Expectations
// ============================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.psychology_outlined,
      'title': 'AI-Powered Coaching',
      'description':
          'Get personalized guidance powered by advanced AI that understands your goals and adapts to your progress.',
      'color': const Color(0xFFB4F04D),
    },
    {
      'icon': Icons.videocam_outlined,
      'title': 'Real-Time Form Analysis',
      'description':
          'Upload your lifts and receive instant, detailed feedback on your form to prevent injuries and maximize gains.',
      'color': const Color(0xFFFF6B6B),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Track Every Victory',
      'description':
          'Monitor your progress with detailed analytics. Every rep, every meal, every improvement - all in one place.',
      'color': const Color(0xFF4ECDC4),
    },
    {
      'icon': Icons.people_outline,
      'title': 'Built by Athletes',
      'description':
          'Created with input from professional coaches and athletes. Real expertise meets cutting-edge technology.',
      'color': const Color(0xFFFFE66D),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sport-selection'),
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: (page['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 100,
                            color: page['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          page['title'] as String,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page['description'] as String,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFFB4F04D)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                          context, '/sport-selection');
                    }
                  },
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================
// SPORT SELECTION - Personalization Start
// ✅ FIXED: Using Sport enum instead of String
// ============================================
class SportSelectionScreen extends StatefulWidget {
  const SportSelectionScreen({Key? key}) : super(key: key);

  @override
  State<SportSelectionScreen> createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  Sport? selectedSport; // ✅ FIXED: Using Sport enum

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Step 1 of 3',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.33,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFB4F04D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'What drives you?',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your training focus. You can change this later.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: Sport.values.length, // ✅ FIXED: Use enum values
                  itemBuilder: (context, index) {
                    final sport = Sport.values[index];
                    final isSelected = selectedSport == sport;

                    return GestureDetector(
                      onTap: () => setState(() => selectedSport = sport),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(sport.colorValue).withOpacity(0.15)
                              : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Color(sport.colorValue)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(sport.colorValue)
                                    : Color(sport.colorValue).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                sport.icon,
                                color: isSelected
                                    ? Colors.black
                                    : Color(sport.colorValue),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sport
                                        .displayName, // ✅ FIXED: Use enum property
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    sport
                                        .description, // ✅ FIXED: Use enum property
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Color(sport.colorValue),
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedSport != null
                      ? () => Navigator.pushNamed(
                            context,
                            '/goal-setup',
                            arguments: selectedSport, // ✅ FIXED: Pass enum
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.white.withOpacity(0.1),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// GOAL SETUP - Deep Personalization
// ✅ FIXED: Accept Sport enum as parameter
// ============================================
class GoalSetupScreen extends StatefulWidget {
  final Sport? selectedSport; // ✅ FIXED: Accept Sport enum

  const GoalSetupScreen({Key? key, this.selectedSport}) : super(key: key);

  @override
  State<GoalSetupScreen> createState() => _GoalSetupScreenState();
}

class _GoalSetupScreenState extends State<GoalSetupScreen> {
  String? experienceLevel;
  String? primaryGoal;
  int workoutDays = 3;

  final experiences = [
    {
      'level': 'Beginner',
      'desc': 'New to training',
      'icon': Icons.emoji_people
    },
    {'level': 'Intermediate', 'desc': '1-3 years', 'icon': Icons.trending_up},
    {'level': 'Advanced', 'desc': '3+ years', 'icon': Icons.military_tech},
  ];

  final goals = [
    'Build Strength',
    'Gain Muscle',
    'Lose Fat',
    'Improve Performance',
    'General Fitness',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Step 2 of 3',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.66,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFB4F04D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us create your perfect program',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              const Text(
                'Experience Level',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...experiences.map((exp) {
                final isSelected = experienceLevel == exp['level'];
                return GestureDetector(
                  onTap: () =>
                      setState(() => experienceLevel = exp['level'] as String?),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB4F04D).withOpacity(0.15)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFB4F04D)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          exp['icon'] as IconData?,
                          color: isSelected
                              ? const Color(0xFFB4F04D)
                              : Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp['level'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                exp['desc'] as String,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFFB4F04D),
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),
              const Text(
                'Primary Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: goals.map((goal) {
                  final isSelected = primaryGoal == goal;
                  return GestureDetector(
                    onTap: () => setState(() => primaryGoal = goal),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFB4F04D)
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        goal,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              const Text(
                'Workouts per week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$workoutDays days',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Recommended: 3-5',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: workoutDays.toDouble(),
                      min: 2,
                      max: 7,
                      divisions: 5,
                      activeColor: const Color(0xFFB4F04D),
                      inactiveColor: Colors.white.withOpacity(0.1),
                      onChanged: (value) =>
                          setState(() => workoutDays = value.round()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: experienceLevel != null && primaryGoal != null
                      ? () => Navigator.pushNamed(
                            context,
                            '/auth',
                            arguments: {
                              'sport': widget
                                  .selectedSport, // ✅ FIXED: Use widget.selectedSport
                              'experience': experienceLevel,
                              'goal': primaryGoal,
                              'days': workoutDays,
                            },
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.white.withOpacity(0.1),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// AUTH SCREEN - Simplified & Trustworthy
// ✅ FIXED: Accept userData as parameter
// ============================================
class AuthScreen extends StatefulWidget {
  final Map<String, dynamic>? userData; // ✅ FIXED: Accept userData

  const AuthScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> handleAuth() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => isLoading = false);
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void handleGuestMode() {
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Step 3 of 3',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFB4F04D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                isLogin ? 'Welcome Back' : 'Almost There!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                isLogin
                    ? 'Log in to access your personalized program'
                    : 'Create your account to save your progress',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              if (!isLogin) ...[
                _buildTextField(
                  controller: nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
              ],
              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              if (isLogin) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFFB4F04D)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleAuth,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        )
                      : Text(
                          isLogin ? 'Log In' : 'Create Account',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: handleGuestMode,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility_off_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Continue as Guest',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Don't have an account? "
                        : "Already have an account? ",
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin ? 'Sign Up' : 'Log In',
                      style: const TextStyle(
                        color: Color(0xFFB4F04D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFB4F04D),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your data is encrypted and secure. We never share your information.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.6)),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB4F04D), width: 2),
        ),
      ),
    );
  }
}

// ============================================
// DASHBOARD - Personalized Home Hub
// ============================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String userName = 'Champion';
  int currentStreak = 5;
  int totalWorkouts = 47;

  @override
  void initState() {
    super.initState();
    _showWelcomeDialog();
  }

  void _showWelcomeDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4F04D).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Color(0xFFB4F04D),
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Your Journey!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your personalized program is ready. Let\'s build something great together!',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Let\'s Go!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getGreeting()},',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFB4F04D),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF1E1E1E),
                        child: Icon(Icons.person, color: Color(0xFFB4F04D)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFB4F04D).withOpacity(0.3),
                      const Color(0xFFB4F04D).withOpacity(0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB4F04D).withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Color(0xFFFF6B6B),
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$currentStreak Day Streak!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keep it up! You\'re on fire 🔥',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$totalWorkouts',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Workouts',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today\'s Focus',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View Full Program',
                      style: TextStyle(color: Color(0xFFB4F04D)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4ECDC4).withOpacity(0.3),
                      const Color(0xFF4ECDC4).withOpacity(0.1)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4ECDC4).withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upper Body Power',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '6 exercises • 45-60 min',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.fitness_center, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/workout-logger'),
                      child: const Text(
                        'Start Workout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'AI Tools',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                title: 'Chat with AI Coach',
                subtitle: 'Get instant answers to your questions',
                icon: Icons.chat_bubble_outline,
                color: const Color(0xFF4ECDC4),
                badge: 'New tips!',
                onTap: () => Navigator.pushNamed(context, '/chat'),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                title: 'Form Check',
                subtitle: 'Upload video for AI analysis',
                icon: Icons.videocam_outlined,
                color: const Color(0xFFFF6B6B),
                onTap: () => Navigator.pushNamed(context, '/form-check'),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                title: 'Nutrition Tracker',
                subtitle: 'Log meals and track macros',
                icon: Icons.restaurant_menu,
                color: const Color(0xFFFFE66D),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FoodLogScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Quick Tools',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                children: [
                  _buildToolCard(
                    title: 'Plate\nCalculator',
                    icon: Icons.calculate,
                    color: const Color(0xFFFFE66D),
                  ),
                  _buildToolCard(
                    title: '1RM\nCalculator',
                    icon: Icons.trending_up,
                    color: const Color(0xFF95E1D3),
                  ),
                  _buildToolCard(
                    title: 'Progress\nPhotos',
                    icon: Icons.photo_camera,
                    color: const Color(0xFFFF9A9E),
                  ),
                  _buildToolCard(
                    title: 'Injury\nRecovery',
                    icon: Icons.healing,
                    color: const Color(0xFFB4F04D),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.25), color.withOpacity(0.08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB4F04D),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 1) Navigator.pushNamed(context, '/chat');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFFB4F04D),
        unselectedItemColor: Colors.white.withOpacity(0.38),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Coach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================
// CHAT SCREEN - AI Coaching Interface
// ============================================
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  bool isTyping = false;

  List<Map<String, dynamic>> messages = [
    {
      'text':
          'Hi! I\'m your AI fitness coach. I\'m here to help with training advice, form tips, nutrition guidance, and motivation. What would you like to know?',
      'isUser': false,
      'timestamp': DateTime.now(),
      'suggestions': [
        'How do I improve my squat?',
        'Should I train today?',
        'What should I eat pre-workout?',
      ]
    }
  ];

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final userMessage = messageController.text.trim();
    setState(() {
      messages.add({
        'text': userMessage,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      isTyping = true;
    });

    messageController.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        isTyping = false;
        messages.add({
          'text': _generateSmartResponse(userMessage),
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });

      _scrollToBottom();
    }
  }

  String _generateSmartResponse(String question) {
    if (question.toLowerCase().contains('squat')) {
      return 'Great question! For better squats:\n\n1. Keep your chest up and core braced\n2. Push your knees out as you descend\n3. Aim for depth where your hip crease goes below your knee\n4. Drive through your heels\n\nWant me to analyze your form in a video?';
    }
    return 'That\'s a great question! Based on your goals and current program, I recommend focusing on progressive overload while maintaining proper form. Would you like more specific guidance?';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFB4F04D).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFFB4F04D),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Coach', style: TextStyle(fontSize: 16)),
                Text(
                  'Always ready to help',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB4F04D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'Chat History',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == messages.length) {
                  return _buildTypingIndicator();
                }

                final message = messages[index];
                final isUser = message['isUser'] as bool;

                return Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFFB4F04D)
                              : const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message['text'] as String,
                          style: TextStyle(
                            color: isUser ? Colors.black : Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    if (message['suggestions'] != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (message['suggestions'] as List<String>)
                              .map((suggestion) => GestureDetector(
                                    onTap: () {
                                      messageController.text = suggestion;
                                      sendMessage();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E1E1E),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        suggestion,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFB4F04D),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFB4F04D),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.black),
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// FORM CHECK SCREEN - Enhanced UI
// ============================================
class FormCheckScreen extends StatefulWidget {
  const FormCheckScreen({Key? key}) : super(key: key);

  @override
  State<FormCheckScreen> createState() => _FormCheckScreenState();
}

class _FormCheckScreenState extends State<FormCheckScreen> {
  String? selectedExercise;
  bool isAnalyzing = false;
  Map<String, dynamic>? analysisResult;

  final exercises = [
    'Squat',
    'Deadlift',
    'Bench Press',
    'Overhead Press',
    'Row',
    'Pull-up'
  ];

  void pickVideo() async {
    setState(() => isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        isAnalyzing = false;
        analysisResult = {
          'exercise': selectedExercise,
          'score': 8.5,
          'overall':
              'Great form overall! Your bar path is solid and you\'re hitting good depth.',
          'positives': [
            'Excellent depth - hip crease below knee',
            'Straight bar path throughout the lift',
            'Good bracing and core engagement',
            'Controlled descent and explosive drive',
          ],
          'improvements': [
            'Minor knee valgus at the bottom - focus on pushing knees out',
            'Could engage lats more at the start for better stability',
          ],
          'risk': 'Low',
          'tips': [
            'Try paused squats to work on that bottom position',
            'Record from the side next time for better angle analysis',
          ],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Form Check'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
            tooltip: 'Previous Analyses',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Your Lift',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Get AI-powered feedback in seconds',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Exercise',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: exercises.map((exercise) {
                final isSelected = selectedExercise == exercise;
                return GestureDetector(
                  onTap: () => setState(() => selectedExercise = exercise),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB4F04D)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFB4F04D)
                            : Colors.white.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      exercise,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: selectedExercise != null ? pickVideo : null,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selectedExercise != null
                        ? const Color(0xFFB4F04D).withOpacity(0.5)
                        : Colors.white24,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: selectedExercise != null
                          ? const Color(0xFFB4F04D)
                          : Colors.white24,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      selectedExercise != null
                          ? 'Tap to Upload Video'
                          : 'Select an exercise first',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedExercise != null
                            ? Colors.white
                            : Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'MP4, MOV • Max 30 seconds • Side angle recommended',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.38),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (isAnalyzing)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Color(0xFFB4F04D)),
                    const SizedBox(height: 16),
                    Text(
                      'Analyzing your form...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This usually takes 2-5 seconds',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            if (analysisResult != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFB4F04D).withOpacity(0.2),
                      const Color(0xFFB4F04D).withOpacity(0.05)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB4F04D).withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB4F04D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Form Score',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${analysisResult!['score']}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB4F04D),
                                    ),
                                  ),
                                  Text(
                                    '/10',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      analysisResult!['overall'] as String,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _buildAnalysisSection(
                      title: 'What\'s Good',
                      icon: Icons.check_circle,
                      color: const Color(0xFFB4F04D),
                      items: analysisResult!['positives'] as List<dynamic>,
                    ),
                    const SizedBox(height: 20),
                    _buildAnalysisSection(
                      title: 'Areas to Improve',
                      icon: Icons.info_outline,
                      color: const Color(0xFFFFE66D),
                      items: analysisResult!['improvements'] as List<dynamic>,
                    ),
                    const SizedBox(height: 20),
                    _buildAnalysisSection(
                      title: 'Pro Tips',
                      icon: Icons.lightbulb_outline,
                      color: const Color(0xFF4ECDC4),
                      items: analysisResult!['tips'] as List<dynamic>,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: analysisResult!['risk'] == 'Low'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: analysisResult!['risk'] == 'Low'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: analysisResult!['risk'] == 'Low'
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Injury Risk Assessment',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  '${analysisResult!['risk']} Risk',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/chat'),
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      label: const Text('Discuss Results'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFB4F04D),
                        side: const BorderSide(
                          color: Color(0xFFB4F04D),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          analysisResult = null;
                          selectedExercise = null;
                        });
                      },
                      icon: const Icon(Icons.refresh, size: 20),
                      label: const Text('New Analysis'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<dynamic> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ============================================
// PLACEHOLDER SCREENS
// ============================================
class ProgramSelectionScreen extends StatelessWidget {
  const ProgramSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Program'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: const Center(
        child: Text('Program Selection - Coming Soon'),
      ),
    );
  }
}

class WeekDashboardScreen extends StatelessWidget {
  const WeekDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week Dashboard'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: const Center(
        child: Text('Week Dashboard - Coming Soon'),
      ),
    );
  }
}

class WorkoutLoggerScreen extends StatelessWidget {
  const WorkoutLoggerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Logger'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: const Center(
        child: Text('Workout Logger - Coming Soon'),
      ),
    );
  }
}
