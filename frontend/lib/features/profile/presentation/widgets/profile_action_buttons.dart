import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';

/// Row of primary actions for a profile.
///
/// Adapts its content based on whether viewing your [isOwnProfile]
/// or someone else's profile.
class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    super.key,
    required this.isOwnProfile,
    this.isFollowing = false,
    this.isFollowLoading = false,
    this.onEditProfile,
    this.onShareProfile,
    this.onFollowToggle,
    this.onMessageTap,
  });

  final bool isOwnProfile;

  /// Used when [isOwnProfile] is false.
  final bool isFollowing;
  final bool isFollowLoading;

  final VoidCallback? onEditProfile;
  final VoidCallback? onShareProfile;
  final VoidCallback? onFollowToggle;
  final VoidCallback? onMessageTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: isOwnProfile
            ? [
                Expanded(
                  child: PrimaryButton(
                    label: 'Edit Profile',
                    icon: Icons.edit_outlined,
                    onPressed: onEditProfile,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GhostButton(
                    label: 'Share Profile',
                    icon: Icons.share_outlined,
                    onPressed: onShareProfile,
                  ),
                ),
              ]
            : [
                Expanded(
                  child: isFollowing
                      ? GhostButton(
                          label: 'Following',
                          icon: Icons.check,
                          color: AppColors.primaryLight,
                          onPressed: isFollowLoading ? null : onFollowToggle,
                        )
                      : PrimaryButton(
                          label: 'Follow',
                          icon: Icons.person_add_outlined,
                          isLoading: isFollowLoading,
                          onPressed: onFollowToggle,
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GhostButton(
                    label: 'Message',
                    icon: Icons.mail_outline,
                    onPressed: onMessageTap,
                  ),
                ),
              ],
      ),
    );
  }
}
