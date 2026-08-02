import 'package:cinehubapp/features/auth/domain/entities/user.dart';

/// All possible auth states.
///
/// Used by [AuthNotifier] to drive the entire auth flow:
/// - Splash screen routing
/// - Login / register form feedback
/// - Session expiry handling
sealed class AuthState {
  const AuthState();
}

/// Initial state — shown while [CheckSessionUseCase] runs.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// A valid session was found and the user is authenticated.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final User user;
}

/// No session — user needs to log in.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// An async operation is in progress (login, register, logout, forgot password).
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// An operation succeeded (used for one-shot UI events like "email sent").
final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.message});
  final String message;
}

/// An operation failed.
final class AuthFailure extends AuthState {
  const AuthFailure({required this.message});
  final String message;
}
