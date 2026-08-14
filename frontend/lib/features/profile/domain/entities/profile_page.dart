import 'profile.dart';

/// Domain-level paginated wrapper for profile lists.
///
/// Used by [GetFollowersUseCase] and [GetFollowingUseCase].
/// Mirrors the backend pagination shape without coupling to JSON.
final class ProfilePage {
  const ProfilePage({
    required this.profiles,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.hasNext,
  });

  final List<Profile> profiles;
  final int page;
  final int totalPages;
  final int total;
  final bool hasNext;

  bool get isEmpty => profiles.isEmpty;
  bool get isLastPage => !hasNext;
}
