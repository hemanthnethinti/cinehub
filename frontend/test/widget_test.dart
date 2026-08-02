import 'package:flutter_test/flutter_test.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'package:cinehubapp/features/auth/domain/entities/user.dart';
import 'package:cinehubapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:cinehubapp/features/auth/domain/usecases/register_usecase.dart';
import 'package:cinehubapp/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/features/auth/domain/repositories/auth_repository.dart';

// ── Fake Repository ───────────────────────────────────────────

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<User>> login({required String email, required String password}) async =>
      Result.success(_testUser);

  @override
  Future<Result<User>> register({
    required String email, required String password,
    required String firstName, required String lastName, required String role,
  }) async => Result.success(_testUser);

  @override
  Future<Result<void>> forgotPassword({required String email}) async => Result.success(null);

  @override
  Future<Result<void>> logout() async => Result.success(null);

  @override
  Future<Result<User>> getMe() async => Result.success(_testUser);

  @override
  Future<bool> hasStoredSession() async => false;
}

final _testUser = User(
  id: 'test-id',
  email: 'jane@example.com',
  firstName: 'Jane',
  lastName: 'Doe',
  role: UserRole.creator,
);

void main() {
  final repo = _FakeAuthRepository();

  // ── UserRole ──────────────────────────────────────────────────
  group('UserRole', () {
    test('fromValue returns correct role', () {
      expect(UserRole.fromValue('creator'), UserRole.creator);
      expect(UserRole.fromValue('producer'), UserRole.producer);
      expect(UserRole.fromValue('unknown'), UserRole.user);
    });

    test('registrationRoles contains only selectable roles', () {
      expect(UserRole.registrationRoles, [UserRole.user, UserRole.creator, UserRole.producer]);
    });

    test('value matches backend constant', () {
      expect(UserRole.superAdmin.value, 'superAdmin');
    });
  });

  // ── User entity ───────────────────────────────────────────────
  group('User entity', () {
    test('fullName concatenates correctly', () {
      expect(_testUser.fullName, 'Jane Doe');
    });

    test('initials derived from names', () {
      expect(_testUser.initials, 'JD');
    });

    test('copyWith produces new instance', () {
      final updated = _testUser.copyWith(firstName: 'Alice');
      expect(updated.firstName, 'Alice');
      expect(updated.lastName, 'Doe');
      expect(updated.id, _testUser.id);
    });

    test('equality based on id', () {
      final other = _testUser.copyWith(email: 'other@example.com');
      expect(_testUser, equals(other)); // same id
    });
  });

  // ── LoginUseCase ──────────────────────────────────────────────
  group('LoginUseCase', () {
    final useCase = LoginUseCase(repo);

    test('succeeds with valid credentials', () async {
      final result = await useCase.call(email: 'jane@example.com', password: 'password');
      expect(result.isSuccess, isTrue);
    });

    test('fails with empty email', () async {
      final result = await useCase.call(email: '', password: 'password');
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull?.userMessage, contains('Email'));
    });

    test('fails with invalid email format', () async {
      final result = await useCase.call(email: 'not-an-email', password: 'password');
      expect(result.isFailure, isTrue);
    });

    test('fails with empty password', () async {
      final result = await useCase.call(email: 'jane@example.com', password: '');
      expect(result.isFailure, isTrue);
    });
  });

  // ── RegisterUseCase ───────────────────────────────────────────
  group('RegisterUseCase', () {
    final useCase = RegisterUseCase(repo);

    test('succeeds with valid data', () async {
      final result = await useCase.call(
        email: 'jane@example.com',
        password: 'StrongPass1',
        firstName: 'Jane',
        lastName: 'Doe',
        role: 'creator',
      );
      expect(result.isSuccess, isTrue);
    });

    test('fails with weak password', () async {
      final result = await useCase.call(
        email: 'jane@example.com',
        password: 'weak',
        firstName: 'Jane',
        lastName: 'Doe',
        role: 'creator',
      );
      expect(result.isFailure, isTrue);
    });

    test('fails with missing first name', () async {
      final result = await useCase.call(
        email: 'jane@example.com',
        password: 'StrongPass1',
        firstName: '',
        lastName: 'Doe',
        role: 'creator',
      );
      expect(result.isFailure, isTrue);
    });

    test('fails with no uppercase in password', () async {
      final result = await useCase.call(
        email: 'jane@example.com',
        password: 'alllower1',
        firstName: 'Jane',
        lastName: 'Doe',
        role: 'creator',
      );
      expect(result.isFailure, isTrue);
    });
  });

  // ── ForgotPasswordUseCase ────────────────────────────────────
  group('ForgotPasswordUseCase', () {
    final useCase = ForgotPasswordUseCase(repo);

    test('succeeds with valid email', () async {
      final result = await useCase.call(email: 'jane@example.com');
      expect(result.isSuccess, isTrue);
    });

    test('fails with empty email', () async {
      final result = await useCase.call(email: '');
      expect(result.isFailure, isTrue);
    });

    test('fails with invalid email', () async {
      final result = await useCase.call(email: 'not-valid');
      expect(result.isFailure, isTrue);
    });
  });

  // ── Result<T> ────────────────────────────────────────────────
  group('Result<T>', () {
    test('success holds data', () {
      final r = Result.success(42);
      expect(r.dataOrNull, 42);
      expect(r.isSuccess, isTrue);
    });

    test('failure holds error', () {
      const error = AppError.auth(message: 'Oops');
      final r = Result.failure<int>(error);
      expect(r.isFailure, isTrue);
      expect(r.errorOrNull?.userMessage, 'Oops');
    });

    test('map transforms success value', () {
      final r = Result.success(5).map((v) => v * 2);
      expect(r.dataOrNull, 10);
    });

    test('map preserves failure', () {
      const error = AppError.unknown(message: 'err');
      final r = Result.failure<int>(error).map((v) => v * 2);
      expect(r.isFailure, isTrue);
    });
  });
}
