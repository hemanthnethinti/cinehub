import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:cinehubapp/features/auth/presentation/screens/login_screen.dart';
import 'package:cinehubapp/features/auth/presentation/screens/register_screen.dart';
import 'package:cinehubapp/features/auth/presentation/screens/splash_screen.dart';
import 'routes.dart';


// ═══════════════════════════════════════════════════════════════
//  PLACEHOLDER SHELL SCREENS (Phase 2 → replaced per phase)
// ═══════════════════════════════════════════════════════════════

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Home — Phase 4', style: AppTypography.headlineMedium)),
      );
}

class _DiscoverScreen extends StatelessWidget {
  const _DiscoverScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Discover — Phase 6', style: AppTypography.headlineMedium)),
      );
}

class _ProjectsScreen extends StatelessWidget {
  const _ProjectsScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Projects — Phase 5', style: AppTypography.headlineMedium)),
      );
}

class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Text('Messages — Phase 7', style: AppTypography.headlineMedium)),
      );
}

class _ProfileScreen extends ConsumerWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = (ref.watch(authNotifierProvider) as AuthAuthenticated?)?.user;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Profile — Phase 3', style: AppTypography.headlineMedium),
            if (user != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(user.fullName, style: AppTypography.bodyLarge),
              Text(user.email, style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.xl),
              TextButton.icon(
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Logout'),
                onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  APP SHELL
// ═══════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════
//  ROUTER PROVIDER
// ═══════════════════════════════════════════════════════════════

/// The application router, now wired to [authNotifierProvider].
///
/// Auth redirect strategy (Phase 3):
/// - [AuthInitial] / [AuthLoading] → stay on splash (no redirect)
/// - [AuthAuthenticated]            → redirect away from auth screens
/// - [AuthUnauthenticated]          → redirect to login from protected routes
///
/// Protected routes are everything EXCEPT /splash, /login, /register,
/// /forgot-password.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    refreshListenable: _AuthChangeNotifier(ref),
    redirect: (context, state) async {
      final authState = ref.read(authNotifierProvider);
      final location = state.matchedLocation;

      final isAuthRoute = location == Routes.login ||
          location == Routes.register ||
          location == Routes.forgotPassword ||
          location == Routes.splash;

      // While checking session — stay on splash.
      if (authState is AuthInitial || authState is AuthLoading) {
        return location == Routes.splash ? null : Routes.splash;
      }

      // Authenticated — push away from auth screens.
      if (authState is AuthAuthenticated) {
        if (isAuthRoute) return Routes.home;
        return null;
      }

      // Unauthenticated — protect app routes.
      if (authState is AuthUnauthenticated || authState is AuthFailure) {
        if (!isAuthRoute) return Routes.login;
        return null;
      }

      return null;
    },
    routes: [
      // ── Splash ─────────────────────────────────────────────
      GoRoute(
        path: Routes.splash,
        builder: (_, __) => const SplashScreen(),
      ),

      // ── Auth ───────────────────────────────────────────────
      GoRoute(
        path: Routes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      // ── Shell (bottom nav) ─────────────────────────────────
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
            Text(state.matchedLocation, style: AppTypography.bodySmall),
          ],
        ),
      ),
    ),
  );
});

/// [ChangeNotifier] that triggers router refresh when auth state changes.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen<AuthState>(authNotifierProvider, (_, __) => notifyListeners());
  }
}
