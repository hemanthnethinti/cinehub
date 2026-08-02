/// Roles a user can hold on the CineHub platform.
///
/// Mirrors [USER_ROLES] in `backend/src/utils/constants.js`.
/// Only `user`, `creator`, `producer` are selectable at registration.
enum UserRole {
  user,
  creator,
  producer,
  admin,
  superAdmin;

  /// Display name shown in the UI.
  String get label => switch (this) {
        UserRole.user       => 'User',
        UserRole.creator    => 'Creator',
        UserRole.producer   => 'Producer',
        UserRole.admin      => 'Admin',
        UserRole.superAdmin => 'Super Admin',
      };

  /// Description shown on the registration role picker.
  String get description => switch (this) {
        UserRole.user       => 'Browse and discover filmmakers',
        UserRole.creator    => 'Directors, writers, editors, and crew',
        UserRole.producer   => 'Investors, executive producers, studios',
        UserRole.admin      => 'Platform administrator',
        UserRole.superAdmin => 'Full platform access',
      };

  /// JSON value sent to / received from the backend.
  String get value => switch (this) {
        UserRole.user       => 'user',
        UserRole.creator    => 'creator',
        UserRole.producer   => 'producer',
        UserRole.admin      => 'admin',
        UserRole.superAdmin => 'superAdmin',
      };

  static UserRole fromValue(String v) => switch (v) {
        'creator'    => UserRole.creator,
        'producer'   => UserRole.producer,
        'admin'      => UserRole.admin,
        'superAdmin' => UserRole.superAdmin,
        _            => UserRole.user,
      };

  /// Only these roles are selectable at registration.
  static const List<UserRole> registrationRoles = [
    UserRole.user,
    UserRole.creator,
    UserRole.producer,
  ];
}
