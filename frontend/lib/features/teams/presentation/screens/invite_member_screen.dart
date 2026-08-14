import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/teams/presentation/providers/team_providers.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/shared/widgets/inputs/inputs.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'dart:async';

final userSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchUsersProvider = FutureProvider.autoDispose.family<List<Profile>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final repo = ref.watch(teamRepositoryProvider);
  final result = await repo.searchUsers(query);
  return result.when(
    success: (profiles) => profiles,
    failure: (error) => throw Exception(error.userMessage),
  );
});

class InviteMemberScreen extends ConsumerStatefulWidget {
  const InviteMemberScreen({super.key, required this.projectId});
  final String projectId;

  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(userSearchQueryProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(userSearchQueryProvider);
    final searchResults = ref.watch(searchUsersProvider(query));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Invite Member'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppSearchBar(
              controller: _searchController,
              hint: 'Search by name or email...',
              onChanged: _onSearchChanged,
              autofocus: true,
            ),
          ),
          Expanded(
            child: query.trim().isEmpty
                ? Center(
                    child: Text(
                      'Search for users to invite.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                    ),
                  )
                : searchResults.when(
                    data: (users) {
                      if (users.isEmpty) {
                        return Center(
                          child: Text(
                            'No users found.',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            leading: CachedAvatar(imageUrl: user.avatarUrl, size: 40),
                            title: Text('${user.firstName} ${user.lastName}', style: AppTypography.headlineSmall),
                            subtitle: Text(user.email, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                            trailing: PrimaryButton(
                              label: 'Invite',
                              height: 32,
                              onPressed: () => _showRoleDialog(context, user),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => ListView.separated(
                      shrinkWrap: true,
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 60),
                    ),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
          ),
        ],
      ),
    );
  }

  void _showRoleDialog(BuildContext context, Profile user) {
    String selectedRole = 'member';
    final roles = ['director', 'producer', 'writer', 'cinematographer', 'editor', 'actor', 'member'];
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceElevated,
            title: Text('Select Role for ${user.firstName}'),
            content: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRole,
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceElevated,
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (v) => setDialogState(() => selectedRole = v!),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              PrimaryButton(
                label: 'Send Invite',
                height: 40,
                onPressed: () {
                  Navigator.pop(ctx);
                  _sendInvite(user.id, selectedRole);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _sendInvite(String userId, String role) {
    ref.read(teamProvider(widget.projectId).notifier).inviteMember(userId, role).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invitation sent successfully!'), backgroundColor: AppColors.success),
        );
        context.pop();
      }
    });
  }
}
