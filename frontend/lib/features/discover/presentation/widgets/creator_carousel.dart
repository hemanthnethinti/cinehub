import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class CreatorCarousel extends StatelessWidget {
  const CreatorCarousel({super.key, required this.creators});

  final List<Profile> creators;

  @override
  Widget build(BuildContext context) {
    if (creators.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text('Top Creators', style: AppTypography.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: creators.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final creator = creators[index];
              return _CreatorCard(creator: creator);
            },
          ),
        ),
      ],
    );
  }
}

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({required this.creator});
  final Profile creator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.userProfile.replaceFirst(':id', creator.id));
      },
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedAvatar(
              imageUrl: creator.avatarUrl,
              size: 64,
              initials: creator.firstName.isNotEmpty ? creator.firstName.substring(0, 1) : '?',
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${creator.firstName} ${creator.lastName}',
              style: AppTypography.labelLarge,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              creator.headline ?? creator.role.name.toUpperCase(),
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
