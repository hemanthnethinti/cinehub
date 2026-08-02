import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'routes.dart';

// ── Placeholder screens (Phase 2 only) ───────────────────────────────────
// These will be replaced in Phase 3 (Auth) and subsequent phases.
// They are minimal scaffolds to confirm routing works end-to-end.

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Login — Phase 3', style: AppTypography.headlineMedium),
        ),
      );
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Home — Phase 4', style: AppTypography.headlineMedium),
        ),
      );
}

class _DiscoverScreen extends StatelessWidget {
  const _DiscoverScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Discover — Phase 6', style: AppTypography.headlineMedium),
        ),
      );
}

class _ProjectsScreen extends StatelessWidget {
  const _ProjectsScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Projects — Phase 5', style: AppTypography.headlineMedium),
        ),
      );
}

class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Messages — Phase 7', style: AppTypography.headlineMedium),
        ),
      );
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Profile — Phase 3', style: AppTypography.headlineMedium),
        ),
      );
}

// ── App Shell ─────────────────────────────────────────────────────────────

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'Discover'),
    NavigationDestination(icon: Icon(Icons.movie_outlined), selectedIcon: Icon(Icons.movie_rounded), label: 'Projects'),
    NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
    NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
          destinations: _tabs,
        ),
      );
}

// ── Router Provider ───────────────────────────────────────────────────────

/// Provides the configured [GoRouter] instance.
///
/// The router is a [Provider] (not [FutureProvider]) because all async
/// initialization (SharedPreferences, SecureStorage) is done in [main]
/// before [runApp] is called.
///
/// Auth guard: if no stored session exists → redirect to [Routes.login].
/// In Phase 3, this will read from [authNotifierProvider] instead.
final appRouterProvider = Provider<GoRouter>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // Phase 2: minimal guard — checks stored token only.
      // Phase 3: will replace this with authNotifierProvider.
      final hasSession  = await storage.hasSession();
      final onAuthRoute = state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.register ||
          state.matchedLocation == Routes.splash;

      if (!hasSession && !onAuthRoute) return Routes.login;
      if (hasSession && state.matchedLocation == Routes.splash) return Routes.home;
      return null;
    },
    routes: [
      // ── Splash ───────────────────────────────────────────────
      GoRoute(
        path: Routes.splash,
        builder: (_, __) => const _SplashScreen(),
      ),

      // ── Auth ─────────────────────────────────────────────────
      GoRoute(
        path: Routes.login,
        builder: (_, __) => const _LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (_, __) => const _LoginScreen(), // Placeholder — Phase 3
      ),

      // ── Shell (bottom nav) ───────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => _AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (_, __) => const _HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.discover, builder: (_, __) => const _DiscoverScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.projects, builder: (_, __) => const _ProjectsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.messages, builder: (_, __) => const _MessagesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.profile, builder: (_, __) => const _ProfileScreen()),
          ]),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.lg),
            Text('Page not found', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              state.matchedLocation,
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
});
