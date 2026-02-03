import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

/// Root application widget with ProviderScope for Riverpod state management
class FitCoachApp extends ConsumerWidget {
  const FitCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider for navigation
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'FitCoach AI',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, // Default to dark theme

      // Router configuration
      routerConfig: router,
    );
  }
}
