import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

/// Handles 401 responses by refreshing the access token and replaying
/// the original request exactly once.
///
/// If the refresh itself fails, [SecureStorage.clearAll] is called to
/// remove stale credentials, and the error is forwarded so the router's
/// auth guard can redirect the user to the login screen.
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({required this.dio, required this.storage});

  final Dio dio;
  final SecureStorage storage;

  bool _isRefreshing = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized  = err.response?.statusCode == 401;
    final isRefreshPath   = err.requestOptions.path.contains('/auth/refresh');

    if (!isUnauthorized || isRefreshPath || _isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) {
        await storage.clearAll();
        return handler.next(err);
      }

      // Call refresh endpoint with a clean Dio instance to avoid
      // re-triggering this interceptor.
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
      final response = await refreshDio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final accessToken = response.data['data']['accessToken'] as String;
      final newRefresh  = response.data['data']['refreshToken'] as String?;

      await storage.saveAccessToken(accessToken);
      if (newRefresh != null) await storage.saveRefreshToken(newRefresh);

      // Replay the original request with the new token.
      final opts = err.requestOptions
        ..headers['Authorization'] = 'Bearer $accessToken';
      final retryResponse = await dio.fetch(opts);
      return handler.resolve(retryResponse);
    } catch (_) {
      await storage.clearAll();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
