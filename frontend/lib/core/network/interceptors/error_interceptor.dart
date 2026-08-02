import 'package:dio/dio.dart';
import '../../error/app_error.dart';

/// Maps [DioException] to a typed [AppError].
///
/// This interceptor runs last on the error path. By the time it runs,
/// [RefreshInterceptor] has already attempted a token refresh.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appError = _map(err);
    // Re-throw as a DioException with the AppError in `extra` so callers
    // can extract it without depending on Dio directly.
    handler.next(
      err.copyWith(
        error: appError,
        message: appError.userMessage,
      ),
    );
  }

  AppError _map(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return const AppError.network(message: 'Request timed out.', code: 'NET_002');
    }

    if (err.type == DioExceptionType.connectionError) {
      return const AppError.network(message: 'No internet connection.', code: 'NET_001');
    }

    final status = err.response?.statusCode;
    final data   = err.response?.data;
    final msg    = _extractMessage(data) ?? err.message ?? 'Something went wrong.';
    final code   = _extractCode(data);

    if (status == 401) {
      return AppError.auth(message: msg);
    }

    if (status != null) {
      return AppError.server(message: msg, statusCode: status, errorCode: code);
    }

    return AppError.unknown(message: msg);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return (data['error'] as Map?)?.cast<String, dynamic>()['message'] as String?
          ?? data['message'] as String?;
    }
    return null;
  }

  String? _extractCode(dynamic data) {
    if (data is Map) {
      return (data['error'] as Map?)?.cast<String, dynamic>()['code'] as String?;
    }
    return null;
  }
}
