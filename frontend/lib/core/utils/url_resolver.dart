import 'package:cinehubapp/core/config/app_config.dart';

/// Resolves backend-relative media URLs to absolute URLs.
///
/// The backend stores and returns media URLs as relative paths:
///   url: '/uploads/filename.jpg'
///
/// These must be prefixed with the backend base URL so that
/// [CachedNetworkImage] can fetch them from the correct host.
abstract final class UrlResolver {
  /// If [url] starts with 'http', returns it as-is.
  /// Otherwise prepends [AppConfig.baseUrl].
  static String? resolve(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    final base = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;
    return '$base$url';
  }

  static String resolveRequired(String url) => resolve(url) ?? url;
}
