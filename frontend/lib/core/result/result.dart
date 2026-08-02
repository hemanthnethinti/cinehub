import '../error/app_error.dart';

/// Functional result type for the data layer.
///
/// Replaces `Either<Failure, T>` — no fpdart dependency.
/// Every repository method returns `Result<T>`.
///
/// Usage:
/// ```dart
/// final result = await repository.login(req);
/// result.when(
///   success: (user) => ...,
///   failure: (error) => ...,
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a successful result.
  static Result<T> success<T>(T data) => Success<T>(data);

  /// Creates a failed result.
  static Result<T> failure<T>(AppError error) => Failure<T>(error);

  // ── Convenience accessors ─────────────────────────────────────

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure()            => null,
      };

  AppError? get errorOrNull => switch (this) {
        Success()            => null,
        Failure(:final error) => error,
      };

  // ── Pattern matching ──────────────────────────────────────────

  R when<R>({
    required R Function(T data)      success,
    required R Function(AppError e)  failure,
  }) =>
      switch (this) {
        Success(:final data)  => success(data),
        Failure(:final error) => failure(error),
      };

  // ── Transform ─────────────────────────────────────────────────

  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success(:final data)  => Result.success(transform(data)),
        Failure(:final error) => Result.failure(error),
      };
}

/// Successful result wrapper.
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Failed result wrapper.
final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppError error;
}
