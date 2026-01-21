import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/local/hive_service.dart';
import 'presentation/providers/provider_observer.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for now)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize HiveService (handles Hive.initFlutter and opens all boxes)
  await HiveService().init();

  // Run the app with ProviderScope for Riverpod state management
  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      child: const FitCoachApp(),
    ),
  );
}
