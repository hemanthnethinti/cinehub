import 'user_dto.dart';

/// Parsed auth response from the backend.
///
/// Login and register return:
/// ```json
/// {
///   "status": "success",
///   "data": {
///     "user": { ... },
///     "tokens": { "accessToken": "...", "refreshToken": "..." }
///   }
/// }
/// ```
///
/// Refresh tokens endpoint returns:
/// ```json
/// {
///   "status": "success",
///   "data": { "accessToken": "...", "refreshToken": "..." }
/// }
/// ```
final class AuthResponseDto {
  const AuthResponseDto({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserDto user;
  final String accessToken;
  final String refreshToken;

  /// Parse the login / register response envelope.
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final userJson = data['user'] as Map<String, dynamic>;
    final tokens = data['tokens'] as Map<String, dynamic>;

    return AuthResponseDto(
      user: UserDto.fromJson(userJson),
      accessToken: tokens['accessToken'] as String,
      refreshToken: tokens['refreshToken'] as String,
    );
  }
}

/// Tokens-only response (from `/auth/refresh-tokens`).
final class TokensDto {
  const TokensDto({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory TokensDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return TokensDto(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}

/// Request body for login.
final class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  final String email;
  final String password;
}

/// Request body for register.
final class RegisterRequestDto {
  const RegisterRequestDto({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      };

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;
}
