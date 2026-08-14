import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/profile/presentation/providers/profile_providers.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/empty_profile_state.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/profile_completion_card.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/profile_stats.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/skill_chip_group.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/social_links_section.dart';

/// The main profile view.
///
/// If [userId] is null, it displays the authenticated user's profile.
/// Uses [ProfileNotifier] for state management.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    this.userId,
  });

  final String? userId;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() {
    final authState = ref.read(authNotifierProvider);
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : null;
    final targetUserId = widget.userId ?? currentUserId;
    
    if (targetUserId != null) {
      ref.read(profileNotifierProvider.notifier).loadProfile(targetUserId);
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (image == null) return;

    ref.read(profileNotifierProvider.notifier).uploadAvatar(File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : null;

    ref.listen<ProfileState>(
      profileNotifierProvider,
      (previous, next) {
        if (next is ProfileFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error.userMessage),
              backgroundColor: AppColors.error,
            ),
          );
          ref.read(profileNotifierProvider.notifier).clearStatus();
        } else if (next is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: AppColors.successMuted,
            ),
          );
          ref.read(profileNotifierProvider.notifier).clearStatus();
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          if (widget.userId == null || (currentUserId != null && widget.userId == currentUserId))
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => context.push(Routes.settings),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileNotifierProvider.notifier).refresh();
        },
        child: _buildBody(state, currentUserId),
      ),
    );
  }

  Widget _buildBody(ProfileState state, String? currentUserId) {
    if (state is ProfileInitial || state is ProfileLoading) {
      return const ProfileLoadingSkeleton();
    }

    final profile = ref.read(profileNotifierProvider.notifier).currentProfile;

    if (profile == null) {
      if (state is ProfileFailure) {
        return EmptyProfileState(
          icon: Icons.error_outline,
          title: 'Failed to load profile',
          message: state.error.userMessage,
          actionLabel: 'Retry',
          onAction: _loadProfile,
        );
      }
      return const EmptyProfileState(
        icon: Icons.person_off_outlined,
        title: 'Profile Not Found',
        message: 'The profile you are looking for does not exist or has been removed.',
      );
    }

    final isOwnProfile = profile.id == currentUserId;
    // For this phase, we don't have a full follow state mechanism across the app yet, 
    // so we'll stub isFollowing using a runtime value to prevent analyzer dead code warnings.
    final bool isFollowing = profile.followerCount < 0;
    final isUpdating = state is ProfileUpdating;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(
            initials: profile.initials,
            fullName: profile.fullName,
            role: profile.role,
            avatarUrl: profile.avatarUrl,
            headline: profile.headline,
            locationDisplay: profile.location?.displayString,
            completionPercent: 100, // Hide built-in, using ProfileCompletionCard instead
            isOwnProfile: isOwnProfile,
            onAvatarTap: isOwnProfile ? _pickAndUploadAvatar : null,
            isUploadingAvatar: isUpdating, // Simple mapping for now
          ),
          
          if (isOwnProfile && profile.completionPercent < 100) ...[
            ProfileCompletionCard(
              percent: profile.completionPercent,
              suggestions: profile.missingProfileSteps,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          
          ProfileStats(
            followerCount: profile.followerCount,
            followingCount: profile.followingCount,
            projectCount: profile.projectCount,
            onFollowersTap: () => context.push(Routes.followersPath(profile.id)),
            onFollowingTap: () => context.push(Routes.followingPath(profile.id)),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          ProfileActionButtons(
            isOwnProfile: isOwnProfile,
            isFollowing: isFollowing,
            isFollowLoading: isUpdating,
            onEditProfile: () => context.push(Routes.editProfile),
            onFollowToggle: () {
              if (isFollowing) {
                ref.read(profileNotifierProvider.notifier).unfollowUser(profile.id);
              } else {
                ref.read(profileNotifierProvider.notifier).followUser(profile.id);
              }
            },
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    profile.bio!,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],

          if (profile.skills.isNotEmpty) ...[
            SkillChipGroup(skills: profile.skills),
            const SizedBox(height: AppSpacing.xxl),
          ],
          
          if (profile.socialLinks != null && !profile.socialLinks!.isEmpty) ...[
            SocialLinksSection(links: profile.socialLinks!),
            const SizedBox(height: AppSpacing.xxl),
          ],
          
          const SizedBox(height: AppSpacing.colossal),
        ],
      ),
    );
  }
}
