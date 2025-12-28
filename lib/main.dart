import 'package:flutter/material.dart';

// ============================================
// MAIN APP ENTRY POINT
// ============================================
void main() {
  runApp(AIFitnessCoachApp());
}

class AIFitnessCoachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Fitness Coach',
      debugShowCheckedModeBanner: false,
      // ADJUST: Change theme colors here
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF1E1E1E), // Dark background
        scaffoldBackgroundColor: Color(0xFF121212),
        // ADJUST: Main accent color for buttons, highlights
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFB4F04D), // Bright green (like the designs)
          secondary: Color(0xFF00D9FF), // Cyan blue
        ),
        // ADJUST: Text styles throughout app
        textTheme: TextTheme(
          headlineLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge:
              TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
          bodyMedium:
              TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
        ),
      ),
      // ADJUST: Change initial route if you want to skip onboarding during testing
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/sport-selection': (context) => SportSelectionScreen(),
        '/auth': (context) => AuthScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/chat': (context) => ChatScreen(),
        '/form-check': (context) => FormCheckScreen(),
      },
    );
  }
}

// ============================================
// SPLASH SCREEN
// ============================================
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ADJUST: Change delay duration (currently 2 seconds)
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/sport-selection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ADJUST: Add gradient background or image here
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ADJUST: Replace with your logo
              Icon(Icons.fitness_center, size: 100, color: Color(0xFFB4F04D)),
              SizedBox(height: 20),
              // ADJUST: Change app name
              Text(
                'AI Fitness Coach',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              Text(
                'Your Personal Training Assistant',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(color: Color(0xFFB4F04D)),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// SPORT SELECTION SCREEN
// ============================================
class SportSelectionScreen extends StatefulWidget {
  @override
  _SportSelectionScreenState createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  String? selectedSport;

  // ADJUST: Add or remove sports here
  final List<Map<String, dynamic>> sports = [
    {
      'name': 'Powerlifting',
      'icon': Icons.fitness_center,
      'color': Color(0xFFFF6B6B)
    },
    {
      'name': 'Bodybuilding',
      'icon': Icons.accessibility_new,
      'color': Color(0xFF4ECDC4)
    },
    {
      'name': 'Olympic Weightlifting',
      'icon': Icons.sports_gymnastics,
      'color': Color(0xFFFFE66D)
    },
    {
      'name': 'CrossFit',
      'icon': Icons.sports_kabaddi,
      'color': Color(0xFF95E1D3)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ADJUST: Change header text
              Text('Select Your Training',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 8),
              Text('Choose your primary focus',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 40),

              // Sport cards
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: sports.length,
                  itemBuilder: (context, index) {
                    final sport = sports[index];
                    final isSelected = selectedSport == sport['name'];

                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedSport = sport['name']),
                      child: Container(
                        decoration: BoxDecoration(
                          // ADJUST: Card styling
                          color: isSelected
                              ? sport['color'].withOpacity(0.3)
                              : Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? sport['color']
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(sport['icon'],
                                size: 60, color: sport['color']),
                            SizedBox(height: 12),
                            Text(
                              sport['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedSport != null
                      ? () => Navigator.pushNamed(context, '/auth')
                      : null,
                  // ADJUST: Button styling
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB4F04D),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
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
// AUTH SCREEN (Login/Signup)
// ============================================
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  // ADJUST: Add Firebase Auth logic here
  void handleAuth() {
    // TODO: Implement Firebase authentication
    // For now, just navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void handleGuestMode() {
    // ADJUST: Define what features guests can access
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              // ADJUST: Header text
              Text(
                isLogin ? 'Welcome Back' : 'Create Account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 8),
              Text(
                isLogin
                    ? 'Log in to continue your training'
                    : 'Sign up to start your journey',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 40),

              // Name field (only for signup)
              if (!isLogin) ...[
                TextField(
                  controller: nameController,
                  // ADJUST: Input styling
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // Email field
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password field
              TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // Forgot password (only for login)
              if (isLogin) ...[
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // ADJUST: Add forgot password logic
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(color: Color(0xFFB4F04D))),
                  ),
                ),
              ],

              SizedBox(height: 24),

              // Auth button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB4F04D),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isLogin ? 'Log In' : 'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Guest mode button
              // ADJUST: Remove this if you don't want guest access
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: handleGuestMode,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Continue as Guest',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Toggle login/signup
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
                      style: TextStyle(
                          color: Color(0xFFB4F04D),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// DASHBOARD (Main Home Screen)
// ============================================
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                      // ADJUST: Get user name from database
                      Text('Rose Mario',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  // ADJUST: Add profile photo or notification icon
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF1E1E1E),
                    child: Icon(Icons.person, color: Color(0xFFB4F04D)),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Search bar (optional feature)
              // ADJUST: Remove if not needed initially
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'What do you want to train?',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.white.withOpacity(0.4)),
                  filled: true,
                  fillColor: Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Main feature cards
              Text('AI Features',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 16),

              // Chat with AI Coach card
              _buildFeatureCard(
                context,
                title: 'Chat with AI Coach',
                subtitle: 'Get personalized training advice',
                icon: Icons.chat_bubble_outline,
                color: Color(0xFF4ECDC4),
                onTap: () => Navigator.pushNamed(context, '/chat'),
              ),

              SizedBox(height: 16),

              // Form Check card
              _buildFeatureCard(
                context,
                title: 'Form Check',
                subtitle: 'Upload video for AI analysis',
                icon: Icons.videocam_outlined,
                color: Color(0xFFFF6B6B),
                onTap: () => Navigator.pushNamed(context, '/form-check'),
              ),

              SizedBox(height: 32),

              // Quick Tools section
              Text('Quick Tools',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 16),

              // ADJUST: Add or remove tools
              Row(
                children: [
                  Expanded(
                    child: _buildToolCard(
                      context,
                      title: 'Plate\nCalculator',
                      icon: Icons.calculate,
                      color: Color(0xFFFFE66D),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildToolCard(
                      context,
                      title: '1RM\nCalculator',
                      icon: Icons.trending_up,
                      color: Color(0xFF95E1D3),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildToolCard(
                      context,
                      title: 'Workout\nLog',
                      icon: Icons.fitness_center,
                      color: Color(0xFFB4F04D),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildToolCard(
                      context,
                      title: 'Injury\nRecovery',
                      icon: Icons.healing,
                      color: Color(0xFFFF9A9E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      // ADJUST: Customize navigation items
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xFFB4F04D),
          unselectedItemColor: Colors.white.withOpacity(0.38),
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Progress'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
          onTap: (index) {
            // ADJUST: Add navigation logic for each tab
            if (index == 1) Navigator.pushNamed(context, '/chat');
          },
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ADJUST: Card styling
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6), fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.38), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ============================================
// CHAT SCREEN (AI Coach)
// ============================================
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  // ADJUST: Messages stored in memory, add database persistence later
  List<Map<String, dynamic>> messages = [
    {
      'text': 'Hi! I\'m your AI fitness coach. How can I help you today?',
      'isUser': false,
      'timestamp': DateTime.now(),
    }
  ];

  // ADJUST: Add GPT API call here
  void sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final userMessage = messageController.text.trim();
    setState(() {
      messages.add({
        'text': userMessage,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    messageController.clear();

    // TODO: Call GPT API here
    // For now, just a mock response
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      messages.add({
        'text': 'Great question! For powerlifting, I recommend...',
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    });

    // Auto-scroll to bottom
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFB4F04D),
              child: Icon(Icons.smart_toy, color: Colors.black),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Coach', style: TextStyle(fontSize: 16)),
                Text('Online',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ],
        ),
        // ADJUST: Add menu for clearing chat, settings, etc.
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['isUser'];

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      // ADJUST: Message bubble styling
                      color: isUser ? Color(0xFFB4F04D) : Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                // ADJUST: Add attachment button for images/videos
                IconButton(
                  icon: Icon(Icons.add_circle_outline,
                      color: Colors.white.withOpacity(0.6)),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4)),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFB4F04D),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.black),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// FORM CHECK SCREEN (Video Upload & Analysis)
// ============================================
class FormCheckScreen extends StatefulWidget {
  @override
  _FormCheckScreenState createState() => _FormCheckScreenState();
}

class _FormCheckScreenState extends State<FormCheckScreen> {
  String? selectedExercise;
  bool isAnalyzing = false;
  Map<String, dynamic>? analysisResult;

  // ADJUST: Add or change exercises
  final exercises = ['Squat', 'Deadlift', 'Bench Press', 'Overhead Press'];

  // ADJUST: Implement actual file picker
  void pickVideo() async {
    // TODO: Use image_picker package to select video
    // For now, just simulate upload
    setState(() => isAnalyzing = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isAnalyzing = false;
      analysisResult = {
        'exercise': selectedExercise,
        'overall': 'Good form with minor adjustments needed',
        'positives': [
          'Good depth achieved',
          'Bar path is straight',
          'Proper bracing',
        ],
        'improvements': [
          'Slight knee valgus at bottom',
          'Could improve hip drive',
        ],
        'risk': 'Low',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text('Form Check'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Your Lift',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            Text('Get instant AI feedback on your form',
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 32),

            // Exercise selection
            Text('Select Exercise',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: exercises.map((exercise) {
                final isSelected = selectedExercise == exercise;
                return ChoiceChip(
                  label: Text(exercise),
                  selected: isSelected,
                  // ADJUST: Chip styling
                  selectedColor: Color(0xFFB4F04D),
                  backgroundColor: Color(0xFF1E1E1E),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() => selectedExercise = exercise);
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 32),

            // Upload area
            GestureDetector(
              onTap: selectedExercise != null ? pickVideo : null,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selectedExercise != null
                        ? Color(0xFFB4F04D).withOpacity(0.5)
                        : Colors.white24,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: selectedExercise != null
                          ? Color(0xFFB4F04D)
                          : Colors.white24,
                    ),
                    SizedBox(height: 16),
                    Text(
                      selectedExercise != null
                          ? 'Tap to Upload Video'
                          : 'Select an exercise first',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedExercise != null
                            ? Colors.white
                            : Colors.white38,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'MP4, MOV • Max 30 seconds',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(0.38)),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),

            // Analysis loading
            if (isAnalyzing)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFFB4F04D)),
                    SizedBox(height: 16),
                    Text('Analyzing your form...',
                        style: TextStyle(color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ),

            // Analysis results
            if (analysisResult != null) ...[
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFFB4F04D), size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Analysis Complete',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Overall assessment
                    Text(analysisResult!['overall'],
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),

                    // What's good
                    Text('✓ What\'s Good:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB4F04D))),
                    SizedBox(height: 8),
                    ...List.generate(
                      analysisResult!['positives'].length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text('• ${analysisResult!['positives'][index]}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7))),
                      ),
                    ),

                    SizedBox(height: 16),

                    // What to improve
                    Text('⚠ Areas to Improve:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFE66D))),
                    SizedBox(height: 8),
                    ...List.generate(
                      analysisResult!['improvements'].length,
                      (index) => Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                            '• ${analysisResult!['improvements'][index]}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7))),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Risk level
                    Row(
                      children: [
                        Text('Injury Risk: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: analysisResult!['risk'] == 'Low'
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            analysisResult!['risk'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/chat'),
                      icon: Icon(Icons.chat_bubble_outline),
                      label: Text('Ask Coach'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFFB4F04D),
                        side: BorderSide(color: Color(0xFFB4F04D)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          analysisResult = null;
                          selectedExercise = null;
                        });
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('New Check'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB4F04D),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
}

// ============================================
// NOTES FOR IMPLEMENTATION
// ============================================

/*
NEXT STEPS TO MAKE THIS PRODUCTION-READY:

1. FIREBASE SETUP:
   - Add firebase_core, firebase_auth, cloud_firestore to pubspec.yaml
   - Initialize Firebase in main()
   - Implement actual auth logic in AuthScreen
   - Store user data and chat history in Firestore

2. GPT API INTEGRATION:
   - Add http package to pubspec.yaml
   - Create OpenAI service class
   - Add API key to .env file (use flutter_dotenv)
   - Implement actual API calls in ChatScreen
   - Add GPT-4 Vision for form check analysis

3. FILE HANDLING:
   - Add image_picker package for video/photo selection
   - Add firebase_storage for file uploads
   - Implement video frame extraction (use ffmpeg or video_player)
   - Send frames to GPT-4 Vision API

4. STATE MANAGEMENT (Optional but recommended):
   - Add provider or riverpod for app-wide state
   - Manage user session, chat history, settings

5. LOCAL STORAGE:
   - Add shared_preferences for offline data
   - Cache chat messages
   - Store user preferences

6. NAVIGATION IMPROVEMENTS:
   - Use named routes with arguments
   - Add proper back button handling
   - Implement bottom navigation state persistence

7. ERROR HANDLING:
   - Add try-catch blocks for API calls
   - Show user-friendly error messages
   - Implement retry logic

8. LOADING STATES:
   - Add shimmer effects for loading
   - Show progress indicators during uploads
   - Implement optimistic UI updates

9. TESTING:
   - Test on real Android device
   - Check different screen sizes
   - Test API rate limits

10. DEPLOYMENT:
   - Build release APK
   - Set up Firebase hosting for web
   - Create privacy policy
   - Add terms of service

PACKAGES YOU'LL NEED (add to pubspec.yaml):
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  
  # API & Network
  http: ^1.1.0
  
  # Media
  image_picker: ^1.0.7
  video_player: ^2.8.2
  
  # Storage
  shared_preferences: ^2.2.2
  flutter_dotenv: ^5.1.0
  
  # UI
  flutter_svg: ^2.0.9
  shimmer: ^3.0.0

*/