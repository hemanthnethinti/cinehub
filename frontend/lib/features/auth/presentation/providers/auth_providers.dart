import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/auth/domain/entities/user.dart';
import 'package:cinehubapp/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:cinehubapp/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:cinehubapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:cinehubapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:cinehubapp/features/auth/domain/usecases/register_usecase.dart';
import 'package:cinehubapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cinehubapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cinehubapp/features/auth/domain/repositories/auth_repository.dart';
import 'auth_state.dart';
export 'auth_state.dart';


// ═══════════════════════════════════════════════════════════════
//  INFRASTRUCTURE PROVIDERS — Data → Repository → Use Cases
// ═══════════════════════════════════════════════════════════════

final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
  name: 'AuthRemoteDataSource',
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    dataSource: ref.watch(_authRemoteDataSourceProvider),
    storage: ref.watch(secureStorageProvider),
  ),
  name: 'AuthRepository',
);

// ── Use Case Providers ────────────────────────────────────────

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
  name: 'LoginUseCase',
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
  name: 'RegisterUseCase',
);

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>(
  (ref) => ForgotPasswordUseCase(ref.watch(authRepositoryProvider)),
  name: 'ForgotPasswordUseCase',
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
  name: 'LogoutUseCase',
);

final checkSessionUseCaseProvider = Provider<CheckSessionUseCase>(
  (ref) => CheckSessionUseCase(ref.watch(authRepositoryProvider)),
  name: 'CheckSessionUseCase',
);

// ═══════════════════════════════════════════════════════════════
//  AUTH NOTIFIER
// ═══════════════════════════════════════════════════════════════

/// Drives all authentication state transitions.
///
/// State machine:
/// ```
/// AuthInitial
///   → [checkSession]   → AuthAuthenticated | AuthUnauthenticated
///
/// AuthUnauthenticated
///   → [login]          → AuthLoading → AuthAuthenticated | AuthFailure
///   → [register]       → AuthLoading → AuthAuthenticated | AuthFailure
///   → [forgotPassword] → AuthLoading → AuthSuccess | AuthFailure
///
/// AuthAuthenticated
///   → [logout]         → AuthLoading → AuthUnauthenticated
/// ```
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  // ── Session Check ─────────────────────────────────────────────

  Future<void> checkSession() async {
    state = const AuthLoading();
    final result = await ref.read(checkSessionUseCaseProvider).call();
    result.when(
      success: (user) =>
          state = user != null ? AuthAuthenticated(user) : const AuthUnauthenticated(),
      failure: (_) => state = const AuthUnauthenticated(),
    );
  }

  // ── Login ─────────────────────────────────────────────────────

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    final result = await ref
        .read(loginUseCaseProvider)
        .call(email: email, password: password);
    result.when(
      success: (user) => state = AuthAuthenticated(user),
      failure: (error) => state = AuthFailure(message: error.userMessage),
    );
  }

  // ── Register ──────────────────────────────────────────────────

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    state = const AuthLoading();
    final result = await ref.read(registerUseCaseProvider).call(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          role: role,
        );
    result.when(
      success: (user) => state = AuthAuthenticated(user),
      failure: (error) => state = AuthFailure(message: error.userMessage),
    );
  }

  // ── Forgot Password ───────────────────────────────────────────

  Future<void> forgotPassword({required String email}) async {
    state = const AuthLoading();
    final result = await ref.read(forgotPasswordUseCaseProvider).call(email: email);
    result.when(
      success: (_) => state = const AuthSuccess(
        message: 'If that email exists, a reset link is on its way.',
      ),
      failure: (error) => state = AuthFailure(message: error.userMessage),
    );
  }

  // ── Logout ────────────────────────────────────────────────────

  Future<void> logout() async {
    state = const AuthLoading();
    await ref.read(logoutUseCaseProvider).call();
    state = const AuthUnauthenticated();
  }

  // ── Helpers ───────────────────────────────────────────────────

  void clearError() {
    if (state is AuthFailure || state is AuthSuccess) {
      state = const AuthUnauthenticated();
    }
  }

  User? get currentUser =>
      state is AuthAuthenticated ? (state as AuthAuthenticated).user : null;

  bool get isAuthenticated => state is AuthAuthenticated;
}

// ═══════════════════════════════════════════════════════════════
//  ROOT PROVIDER
// ═══════════════════════════════════════════════════════════════

/// The root auth provider. Observed by screens and the router.
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
