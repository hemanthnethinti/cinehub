import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'screens/main_screen.dart';

/// Root application widget.
///
/// Watches [authProvider] and routes to the appropriate screen:
/// - [MainScreen]  — when the user is authenticated.
/// - [LoginScreen] — when the user is unauthenticated / initial.
///
/// [ProviderScope] is set up in main.dart.
/// Navigation (GoRouter) will replace this once all features are migrated.
class CineHubApp extends ConsumerWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Poppins'),
      home: authState.maybeWhen(
        authenticated: (_) => const MainScreen(),
        orElse: () => const LoginScreen(),
      ),
    );
  }
}

