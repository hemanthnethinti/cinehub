import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

/// All possible states for the profile feature.
///
/// Used by [ProfileNotifier] to drive profile screens:
/// - Own profile tab
/// - Edit profile sheet
/// - Follow / Unfollow interactions
sealed class ProfileState {
  const ProfileState();
}

/// Initial state — no profile has been requested yet.
final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Full-screen load — profile is being fetched for the first time.
final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Profile is loaded and ready to display.
final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);
  final Profile profile;
}

/// A mutation is in progress (update, follow, unfollow).
///
/// The previous [profile] is carried so screens can keep displaying
/// content while showing an overlay indicator.
final class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.profile);
  final Profile profile;
}

/// A one-shot mutation succeeded (follow, unfollow, profile save).
///
/// Screens observe this via [ref.listen] to show a SnackBar.
/// After reacting, screens should call [ProfileNotifier.clearStatus].
final class ProfileSuccess extends ProfileState {
  const ProfileSuccess({required this.profile, required this.message});
  final Profile profile;
  final String message;
}

/// An operation failed.
///
/// Carries the full [AppError] so screens can choose how to render
/// based on the error type (network vs auth vs server).
final class ProfileFailure extends ProfileState {
  const ProfileFailure({required this.error, this.previousProfile});
  final AppError error;

  /// The last known profile, if any — allows screens to remain visible
  /// while showing an error banner rather than replacing the whole UI.
  final Profile? previousProfile;
}
