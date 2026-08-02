/// All route path constants for the CineHub app.
///
/// Always use these constants with [GoRouter] — never hardcode path strings.
abstract final class Routes {
  // ── Auth ──────────────────────────────────────────────────────
  static const String splash          = '/splash';
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

  // ── Top-level feature routes ──────────────────────────────────
  static const String projectDetail = '/projects/:id';
  static const String createProject = '/projects/new';
  static const String chat          = '/messages/:id';
  static const String creatorProfile = '/discover/:userId';
  static const String aiHub         = '/ai';
  static const String aiScript      = '/ai/script';
  static const String aiBudget      = '/ai/budget';
  static const String aiTrailer     = '/ai/trailer';
  static const String portfolio     = '/portfolio/:userId';
  static const String notifications = '/notifications';
  static const String settings      = '/settings';

  // ── Helpers ───────────────────────────────────────────────────
  static String projectDetailPath(String id) => '/projects/$id';
  static String chatPath(String id)           => '/messages/$id';
  static String creatorProfilePath(String id) => '/discover/$id';
  static String portfolioPath(String id)      => '/portfolio/$id';
}
