import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/teams/presentation/providers/team_providers.dart';
import 'package:cinehubapp/features/teams/presentation/widgets/empty_team_state.dart';
import 'package:cinehubapp/features/teams/presentation/widgets/team_loading_skeleton.dart';
import 'package:cinehubapp/features/teams/presentation/widgets/team_member_card.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider(projectId));
    final authState = ref.watch(authNotifierProvider);
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Project Team'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          teamState.maybeWhen(
            data: (team) {
              final canManage = currentUser?.id == team.ownerId;
              if (canManage) {
                return IconButton(
                  icon: const Icon(Icons.person_add_rounded),
                  onPressed: () {
                    context.push(Routes.inviteMemberPath(projectId));
                  },
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: teamState.when(
        data: (team) {
          final canManage = currentUser?.id == team.ownerId;
          final members = team.members.toList();
          
          if (members.isEmpty) {
            return EmptyTeamState(
              onInvite: () => context.push(Routes.inviteMemberPath(projectId)),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(teamProvider(projectId).future),
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return TeamMemberCard(
                  member: member,
                  canManage: canManage,
                  onRemove: () {
                    _confirmRemove(context, ref, member.user.firstName, member.user.id);
                  },
                );
              },
            ),
          );
        },
        loading: () => const TeamLoadingSkeleton(),
        error: (error, stack) => Center(
          child: ErrorStateWidget(
            message: 'Failed to load team members.',
            onRetry: () => ref.invalidate(teamProvider(projectId)),
          ),
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context, WidgetRef ref, String name, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove $name from the team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(teamProvider(projectId).notifier).removeMember(userId);
            },
            child: const Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
