class SettingsEntity {
  const SettingsEntity({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.marketingNotifications,
    required this.mentionNotifications,
    required this.messageNotifications,
    required this.projectInviteNotifications,
    required this.profileVisibility,
    required this.showEmail,
    required this.showPhone,
    required this.discoverability,
  });

  // Backed by backend 'preferences.emailNotifications'
  final bool emailNotifications;
  
  // Backed by backend 'preferences.pushNotifications'
  final bool pushNotifications;
  
  // Missing backend support
  final bool marketingNotifications;
  final bool mentionNotifications;
  final bool messageNotifications;
  final bool projectInviteNotifications;

  // Backed by backend 'preferences.profileVisibility' ('public', 'private', 'connections')
  final String profileVisibility;

  // Missing backend support
  final bool showEmail;
  final bool showPhone;
  final bool discoverability;

  SettingsEntity copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? marketingNotifications,
    bool? mentionNotifications,
    bool? messageNotifications,
    bool? projectInviteNotifications,
    String? profileVisibility,
    bool? showEmail,
    bool? showPhone,
    bool? discoverability,
  }) {
    return SettingsEntity(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      marketingNotifications: marketingNotifications ?? this.marketingNotifications,
      mentionNotifications: mentionNotifications ?? this.mentionNotifications,
      messageNotifications: messageNotifications ?? this.messageNotifications,
      projectInviteNotifications: projectInviteNotifications ?? this.projectInviteNotifications,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      showEmail: showEmail ?? this.showEmail,
      showPhone: showPhone ?? this.showPhone,
      discoverability: discoverability ?? this.discoverability,
    );
  }
}
