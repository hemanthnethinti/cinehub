import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/refresh_interceptor.dart';

/// The single Dio HTTP client for the entire application.
///
/// Never instantiate [Dio] directly anywhere else.
/// All requests go through this client and its interceptor chain.
///
/// Interceptor order (request):
///   1. [AuthInterceptor]    — attaches Bearer token
///   2. [LogInterceptor]     — dev-only request/response logging
///
/// Interceptor order (error):
///   1. [RefreshInterceptor] — retries on 401 with refreshed token
///   2. [ErrorInterceptor]   — maps DioException → AppError
class ApiClient {
  ApiClient({required SecureStorage storage}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBase,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(storage),
      RefreshInterceptor(dio: _dio, storage: storage),
      ErrorInterceptor(),
      if (kDebugMode) LogInterceptor(responseBody: true, requestBody: true),
    ]);
  }

  late final Dio _dio;

  // ── CRUD helpers ──────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.delete<T>(path, data: data, options: options);

  /// Multipart upload. Use [FormData] as [data].
  Future<Response<T>> upload<T>(
    String path, {
    required FormData data,
    ProgressCallback? onSendProgress,
  }) =>
      _dio.post<T>(
        path,
        data: data,
        onSendProgress: onSendProgress,
        options: Options(contentType: 'multipart/form-data'),
      );
}
