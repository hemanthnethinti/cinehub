import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.projectDetail.replaceFirst(':id', project.id));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (project.coverUrl != null || project.posterUrl != null)
              CachedImage(
                url: project.coverUrl ?? project.posterUrl!,
                height: 160,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 120,
                color: AppColors.surfaceElevated,
                child: const Icon(Icons.movie_creation_outlined, color: AppColors.textTertiary, size: 48),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMuted,
                          borderRadius: AppRadius.sm,
                        ),
                        child: Text(
                          _formatEnum(project.type),
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(project.status).withValues(alpha: 0.1),
                          borderRadius: AppRadius.sm,
                        ),
                        child: Text(
                          _formatEnum(project.status),
                          style: AppTypography.labelSmall.copyWith(color: _getStatusColor(project.status)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    project.title,
                    style: AppTypography.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (project.tagline != null && project.tagline!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      project.tagline!,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (project.owner.id != 'unknown') {
                        context.push(Routes.userProfilePath(project.owner.id));
                      }
                    },
                    child: Row(
                      children: [
                        CachedAvatar(
                          imageUrl: project.owner.avatarUrl,
                          size: 24,
                          initials: project.owner.firstName.isNotEmpty ? project.owner.firstName.substring(0, 1) : '?',
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            '${project.owner.firstName} ${project.owner.lastName}',
                            style: AppTypography.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  String _formatEnum(String value) {
    return value.split('_').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
      case 'completed':
        return AppColors.success;
      case 'in_development':
      case 'pre_production':
      case 'production':
      case 'post_production':
        return AppColors.primary;
      case 'cancelled':
      case 'on_hold':
        return AppColors.error;
      case 'draft':
      default:
        return AppColors.textSecondary;
    }
  }
}
