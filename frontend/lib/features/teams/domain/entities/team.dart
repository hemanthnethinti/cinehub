import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

class Team {
  const Team({
    required this.id,
    required this.name,
    this.description,
    required this.projectId,
    required this.ownerId,
    required this.members,
    required this.isPublic,
    required this.memberCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String projectId;
  final String ownerId;
  final List<TeamMember> members;
  final bool isPublic;
  final int memberCount;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class TeamMember {
  const TeamMember({
    required this.user,
    required this.role,
    required this.status,
    required this.permissions,
    this.joinedAt,
    required this.invitedAt,
  });

  final Profile user;
  final String role; // owner, director, member, etc.
  final String status; // invited, active, inactive, removed
  final TeamPermissions permissions;
  final DateTime? joinedAt;
  final DateTime invitedAt;
}

class TeamPermissions {
  const TeamPermissions({
    this.canEdit = false,
    this.canInvite = false,
    this.canRemove = false,
    this.canManageScripts = false,
  });

  final bool canEdit;
  final bool canInvite;
  final bool canRemove;
  final bool canManageScripts;
}
