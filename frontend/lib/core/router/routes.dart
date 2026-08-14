/// All route path constants for the CineHub app.
///
/// Always use these constants with [GoRouter] — never hardcode path strings.
abstract final class Routes {
  // ── Auth ──────────────────────────────────────────────────────
  static const String splash          = '/splash';
  static const String search        = '/search';
  static const String searchResults = '/search/results/:query';
  static const String aiStudio      = '/ai-studio';
  static const String aiHistory     = '/ai-studio/history';
  static const String login           = '/login';
  static const String register        = '/register';
  static const String forgotPassword  = '/forgot-password';


  // ── Shell (bottom nav tabs) ───────────────────────────────────
  static const String shell    = '/shell';
  static const String home     = '/shell/home';
  static const String discover = '/shell/discover';
  static const String projects = '/shell/projects';
  static const String messages = '/shell/messages';
  static const String profile  = '/shell/profile';
  static const String editProfile = '/profile/edit';
  static const String userProfile = '/profile/user/:id';
  static const String followers = '/profile/user/:id/followers';
  static const String following = '/profile/user/:id/following';

  static String userProfilePath(String id) => '/profile/user/$id';
  static String followersPath(String id) => '/profile/user/$id/followers';
  static String followingPath(String id) => '/profile/user/$id/following';

  // ── Top-level feature routes ──────────────────────────────────
  static const String projectDetail = '/projects/:id';
  static const String createProject = '/project/new';
  static const String editProject   = '/projects/:id/edit';
  static const String projectTeam   = '/projects/:id/team';
  static const String inviteMember  = '/projects/:id/team/invite';
  static String editProjectPath(String id)    => '/projects/$id/edit';
  static String projectTeamPath(String id)    => '/projects/$id/team';
  static String inviteMemberPath(String id)   => '/projects/$id/team/invite';
  static const String chat          = '/messages/:id';
  static const String newConversation = '/messages/new';
  static const String creatorProfile = '/discover/:userId';
  static const String aiHub         = '/ai';
  static const String aiScript      = '/ai/script';
  static const String scripts       = '/scripts';
  static const String scriptDetail  = '/scripts/:id';
  static const String aiBudget      = '/ai/budget';
  static const String aiTrailer     = '/ai/trailer';
  static const String portfolio     = '/portfolio/:userId';
  static const String portfolioDetail = '/portfolio/detail/:id';
  static const String portfolioEditor = '/portfolio/edit/:id';
  static const String notifications = '/notifications';
  static const String settings      = '/settings';
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String appearanceSettings = '/settings/appearance';
  static const String aboutSettings = '/settings/about';
  
  // ── Admin ─────────────────────────────────────────────────────
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminProjects = '/admin/projects';
  static const String adminModeration = '/admin/moderation';
  static const String adminReports = '/admin/reports';
  static const String adminAnalytics = '/admin/analytics';

  // ── Helpers ───────────────────────────────────────────────────
  static String projectDetailPath(String id) => '/projects/$id';
  static String chatPath(String id)           => '/messages/$id';
  static String creatorProfilePath(String id) => '/discover/$id';
  static String portfolioPath(String id) => '/portfolio/$id';
  static String portfolioDetailPath(String id) => '/portfolio/detail/$id';
  static String portfolioEditorPath(String id) => '/portfolio/edit/$id';
}
