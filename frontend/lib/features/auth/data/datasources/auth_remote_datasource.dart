import 'package:cinehubapp/core/network/api_client.dart';
import '../models/auth_response_dto.dart';
import '../models/user_dto.dart';

/// Auth remote datasource — all HTTP calls for auth live here.
///
/// Returns raw DTOs. Never maps to domain objects.
/// Never handles [AppError] — let exceptions propagate to the repository.
///
/// Endpoints (base: `/auth`):
/// - POST `/login`
/// - POST `/register`
/// - POST `/logout`
/// - POST `/forgot-password`
/// - POST `/refresh-tokens`
/// - GET  `/me`
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);
  final ApiClient _client;

  static const _base = '/auth';

  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_base/login',
      data: LoginRequestDto(email: email, password: password).toJson(),
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  Future<AuthResponseDto> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '$_base/register',
      data: RegisterRequestDto(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
      ).toJson(),
    );
    return AuthResponseDto.fromJson(response.data!);
  }

  Future<void> logout() async {
    await _client.post<void>('$_base/logout');
  }

  Future<void> forgotPassword({required String email}) async {
    await _client.post<void>(
      '$_base/forgot-password',
      data: {'email': email},
    );
  }

  Future<UserDto> getMe() async {
    final response = await _client.get<Map<String, dynamic>>('$_base/me');
    final data = response.data!['data'] as Map<String, dynamic>;
    return UserDto.fromJson(data);
  }
}
