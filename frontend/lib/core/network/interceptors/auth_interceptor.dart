import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

/// Attaches the stored JWT access token to every outgoing request.
///
/// Skipped automatically for auth endpoints (login, register, refresh)
/// because those routes do not require a token.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorage _storage;

  static const _skipPaths = ['auth/login', 'auth/register', 'auth/refresh-tokens', 'auth/forgot-password'];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final skip = _skipPaths.any((p) => options.path.contains(p));
    if (!skip) {
      final token = await _storage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
