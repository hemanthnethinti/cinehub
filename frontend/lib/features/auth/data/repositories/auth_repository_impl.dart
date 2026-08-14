import 'package:dio/dio.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/storage/secure_storage.dart';
import 'package:cinehubapp/features/auth/domain/entities/user.dart';
import 'package:cinehubapp/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository].
///
/// Responsibilities:
/// 1. Calls [AuthRemoteDataSource] for HTTP operations.
/// 2. Persists / clears tokens via [SecureStorage].
/// 3. Maps [DioException] → [AppError] → [Result.failure].
/// 4. Maps DTOs → domain entities.
///
/// No business logic lives here — that belongs in use cases.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource dataSource,
    required SecureStorage storage,
  })  : _dataSource = dataSource,
        _storage = storage;

  final AuthRemoteDataSource _dataSource;
  final SecureStorage _storage;

  // ── Login ──────────────────────────────────────────────────────

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    return _execute(() async {
      final dto = await _dataSource.login(email: email, password: password);
      await _storage.saveAccessToken(dto.accessToken);
      await _storage.saveRefreshToken(dto.refreshToken);
      return dto.user.toDomain();
    });
  }

  // ── Register ───────────────────────────────────────────────────

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    return _execute(() async {
      final dto = await _dataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );
      await _storage.saveAccessToken(dto.accessToken);
      await _storage.saveRefreshToken(dto.refreshToken);
      return dto.user.toDomain();
    });
  }

  // ── Forgot Password ────────────────────────────────────────────

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    return _executeVoid(() => _dataSource.forgotPassword(email: email));
  }

  // ── Logout ────────────────────────────────────────────────────

  @override
  Future<Result<void>> logout() async {
    // Keep the access token long enough for the authenticated logout request.
    // Local credentials are still cleared when the server is unavailable.
    try {
      await _dataSource.logout();
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    } finally {
      await _storage.clearAll();
    }
  }

  // ── Get Me ────────────────────────────────────────────────────

  @override
  Future<Result<User>> getMe() async {
    return _execute(() async {
      final dto = await _dataSource.getMe();
      return dto.toDomain();
    });
  }

  // ── Local Session ─────────────────────────────────────────────

  @override
  Future<bool> hasStoredSession() => _storage.hasSession();

  // ── Private helpers ───────────────────────────────────────────

  /// Wraps a datasource call in try/catch and returns [Result<T>].
  Future<Result<T>> _execute<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Result.success(data);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  Future<Result<void>> _executeVoid(Future<void> Function() call) async {
    try {
      await call();
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  AppError _mapDioError(DioException e) {
    // The ErrorInterceptor already attached an AppError to e.error.
    if (e.error is AppError) return e.error as AppError;

    final status = e.response?.statusCode;
    final message = _extractMessage(e.response?.data) ?? e.message ?? 'Request failed.';

    if (status == 401) return AppError.auth(message: message);
    if (status != null) {
      return AppError.server(message: message, statusCode: status);
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const AppError.network(message: 'No internet connection.');
    }
    return AppError.unknown(message: message);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return (data['error'] as Map?)?.cast<String, dynamic>()['message'] as String? ??
          data['message'] as String?;
    }
    return null;
  }
}
