import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/teams/domain/entities/team.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/features/teams/presentation/widgets/role_badge.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    required this.onRemove,
    required this.canManage,
  });

  final TeamMember member;
  final VoidCallback onRemove;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (member.user.id != 'unknown') {
          context.push(Routes.userProfilePath(member.user.id));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.md,
      ),
      child: Row(
        children: [
          CachedAvatar(
            imageUrl: member.user.avatarUrl,
            size: 48,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${member.user.firstName} ${member.user.lastName}',
                  style: AppTypography.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                RoleBadge(role: member.role, status: member.status),
              ],
            ),
          ),
          if (canManage && member.role != 'owner')
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
              onPressed: onRemove,
              tooltip: 'Remove member',
            ),
        ],
      ),
    ));
  }
}
