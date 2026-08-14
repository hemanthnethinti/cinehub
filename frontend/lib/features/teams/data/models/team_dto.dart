import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'package:cinehubapp/features/teams/domain/entities/team.dart';

final class TeamDto {
  const TeamDto({
    required this.id,
    required this.name,
    this.description,
    required this.projectId,
    required this.ownerId,
    required this.members,
    required this.isPublic,
    required this.memberCount,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String projectId;
  final String ownerId;
  final List<TeamMemberDto> members;
  final bool isPublic;
  final int memberCount;
  final String? createdAt;
  final String? updatedAt;

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled Team',
      description: json['description'] as String?,
      projectId: _extractId(json['project']),
      ownerId: _extractId(json['owner']),
      members: (json['members'] as List<dynamic>? ?? [])
          .map((m) => TeamMemberDto.fromJson(m as Map<String, dynamic>))
          .toList(),
      isPublic: json['isPublic'] as bool? ?? false,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  static String _extractId(dynamic field) {
    if (field is Map<String, dynamic>) {
      return field['_id'] as String? ?? field['id'] as String? ?? '';
    } else if (field is String) {
      return field;
    }
    return '';
  }

  Team toDomain() {
    return Team(
      id: id,
      name: name,
      description: description,
      projectId: projectId,
      ownerId: ownerId,
      members: members.map((e) => e.toDomain()).toList(),
      isPublic: isPublic,
      memberCount: memberCount,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) ?? DateTime.now() : DateTime.now(),
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) ?? DateTime.now() : DateTime.now(),
    );
  }
}

final class TeamMemberDto {
  const TeamMemberDto({
    required this.user,
    required this.role,
    required this.status,
    this.permissions,
    this.joinedAt,
    this.invitedAt,
  });

  final ProfileDto? user;
  final String role;
  final String status;
  final Map<String, dynamic>? permissions;
  final String? joinedAt;
  final String? invitedAt;

  factory TeamMemberDto.fromJson(Map<String, dynamic> json) {
    return TeamMemberDto(
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? ProfileDto.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      role: json['role'] as String? ?? 'member',
      status: json['status'] as String? ?? 'invited',
      permissions: json['permissions'] as Map<String, dynamic>?,
      joinedAt: json['joinedAt'] as String?,
      invitedAt: json['invitedAt'] as String?,
    );
  }

  TeamMember toDomain() {
    final perms = TeamPermissions(
      canEdit: permissions?['canEdit'] as bool? ?? false,
      canInvite: permissions?['canInvite'] as bool? ?? false,
      canRemove: permissions?['canRemove'] as bool? ?? false,
      canManageScripts: permissions?['canManageScripts'] as bool? ?? false,
    );

    return TeamMember(
      user: user?.toDomain() ?? _fallbackProfile(),
      role: role,
      status: status,
      permissions: perms,
      joinedAt: joinedAt != null ? DateTime.tryParse(joinedAt!) : null,
      invitedAt: invitedAt != null ? DateTime.tryParse(invitedAt!) ?? DateTime.now() : DateTime.now(),
    );
  }

  Profile _fallbackProfile() {
    return Profile(
      id: 'unknown',
      email: '',
      firstName: 'Unknown',
      lastName: 'User',
      role: UserRole.user,
      isActive: false,
      isEmailVerified: false,
    );
  }
}
