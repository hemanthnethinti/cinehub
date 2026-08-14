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
import 'package:cinehubapp/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:cinehubapp/features/profile/presentation/screens/followers_screen.dart';
import 'package:cinehubapp/features/profile/presentation/screens/following_screen.dart';
import 'package:cinehubapp/features/profile/presentation/screens/profile_screen.dart';
import 'package:cinehubapp/features/home/presentation/screens/home_screen.dart';
import 'package:cinehubapp/features/discover/presentation/screens/discover_screen.dart';
import 'package:cinehubapp/features/projects/presentation/screens/projects_screen.dart';
import 'package:cinehubapp/features/projects/presentation/screens/project_detail_screen.dart';
import 'package:cinehubapp/features/projects/presentation/screens/project_form_screen.dart';
import 'package:cinehubapp/features/teams/presentation/screens/team_screen.dart';
import 'package:cinehubapp/features/messaging/presentation/screens/conversations_screen.dart';
import 'package:cinehubapp/features/messaging/presentation/screens/chat_screen.dart';
import 'package:cinehubapp/features/messaging/presentation/screens/new_conversation_screen.dart';
import 'package:cinehubapp/features/teams/presentation/screens/invite_member_screen.dart';
import 'package:cinehubapp/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:cinehubapp/features/settings/presentation/screens/settings_screen.dart';
import 'package:cinehubapp/features/settings/presentation/screens/account_screen.dart';
import 'package:cinehubapp/features/settings/presentation/screens/privacy_screen.dart';
import 'package:cinehubapp/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:cinehubapp/features/settings/presentation/screens/appearance_screen.dart';
import 'package:cinehubapp/features/settings/presentation/screens/about_screen.dart';
import 'package:cinehubapp/features/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:cinehubapp/features/portfolio/presentation/screens/portfolio_detail_screen.dart';
import 'package:cinehubapp/features/portfolio/presentation/screens/portfolio_editor_screen.dart';
import 'package:cinehubapp/features/search/presentation/screens/search_screen.dart';
import 'package:cinehubapp/features/search/presentation/screens/search_results_screen.dart';
import 'package:cinehubapp/features/ai/presentation/screens/ai_studio_screen.dart';
import 'package:cinehubapp/features/ai/presentation/screens/ai_history_screen.dart';
import 'package:cinehubapp/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:cinehubapp/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:cinehubapp/features/admin/presentation/screens/admin_projects_screen.dart';
import 'package:cinehubapp/features/admin/presentation/screens/admin_moderation_screen.dart';
import 'package:cinehubapp/features/admin/presentation/screens/admin_reports_screen.dart';
import 'package:cinehubapp/features/admin/presentation/screens/admin_analytics_screen.dart';
import 'routes.dart';

// ═══════════════════════════════════════════════════════════════
//  PLACEHOLDER SHELL SCREENS (Phase 2 → replaced per phase)
// ═══════════════════════════════════════════════════════════════

// _HomeScreen placeholder removed in Phase 3.1

// _DiscoverScreen placeholder removed in Phase 3.3

// _ProjectsScreen placeholder removed in Phase 4.1

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
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(Routes.aiStudio),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          child: const Icon(Icons.auto_awesome_rounded),
        ),
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
      // ── Top Level ───────────────────────────
      GoRoute(
        path: Routes.createProject,
        builder: (context, state) => const ProjectFormScreen(),
      ),
      GoRoute(
        path: Routes.editProject,
        builder: (context, state) => ProjectFormScreen(
          projectId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.projectDetail,
        builder: (context, state) => ProjectDetailScreen(
          projectId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.projectTeam,
        builder: (context, state) => TeamScreen(
          projectId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.inviteMember,
        builder: (context, state) => InviteMemberScreen(
          projectId: state.pathParameters['id']!,
        ),
      ),
      // Keep the static path before `/messages/:id` so "new" is not
      // interpreted as a conversation ID by GoRouter.
      GoRoute(
        path: Routes.newConversation,
        builder: (context, state) => const NewConversationScreen(),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) => ChatScreen(
          conversationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.portfolio,
        builder: (context, state) => PortfolioScreen(
          // we could pass userId if we were filtering by user, for now it's featured
        ),
      ),
      GoRoute(
        path: Routes.portfolioDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PortfolioDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: Routes.portfolioEditor,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return PortfolioEditorScreen(id: id);
        },
      ),
      GoRoute(
        path: Routes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: Routes.searchResults,
        builder: (context, state) {
          final query = state.pathParameters['query']!;
          return SearchResultsScreen(query: query);
        },
      ),
      GoRoute(
        path: Routes.aiStudio,
        builder: (context, state) => const AiStudioScreen(),
      ),
      GoRoute(
        path: Routes.aiHistory,
        builder: (context, state) => const AiHistoryScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'account',
            name: Routes.accountSettings,
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: 'privacy',
            name: Routes.privacySettings,
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: Routes.notificationSettings,
            builder: (context, state) => const NotificationSettingsScreen(),
          ),
          GoRoute(
            path: 'appearance',
            name: Routes.appearanceSettings,
            builder: (context, state) => const AppearanceScreen(),
          ),
          GoRoute(
            path: 'about',
            name: Routes.aboutSettings,
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
      // ── Admin ───────────────────────────────────────────────
      GoRoute(
        path: Routes.admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: Routes.adminUsers,
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: Routes.adminProjects,
        builder: (context, state) => const AdminProjectsScreen(),
      ),
      GoRoute(
        path: Routes.adminModeration,
        builder: (context, state) => const AdminModerationScreen(),
      ),
      GoRoute(
        path: Routes.adminReports,
        builder: (context, state) => const AdminReportsScreen(),
      ),
      GoRoute(
        path: Routes.adminAnalytics,
        builder: (context, state) => const AdminAnalyticsScreen(),
      ),
      // ── Sub-routes ─────────────────────────────────────────────
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
            GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.discover, builder: (_, __) => const DiscoverScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.projects, builder: (_, __) => const ProjectsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.messages, builder: (_, __) => const ConversationsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.profile,
              builder: (_, __) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.userProfile,
        builder: (context, state) => ProfileScreen(userId: state.pathParameters['id']),
      ),
      GoRoute(
        path: Routes.followers,
        builder: (context, state) => FollowersScreen(userId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.following,
        builder: (context, state) => FollowingScreen(userId: state.pathParameters['id']!),
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
