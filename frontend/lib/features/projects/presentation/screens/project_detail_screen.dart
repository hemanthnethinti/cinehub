import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_providers.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectDetailProvider(projectId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Project Details'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_rounded),
            onPressed: () {
              context.push(Routes.projectTeamPath(projectId));
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              context.push(Routes.editProjectPath(projectId));
            },
          ),
        ],
      ),
      body: state.when(
        data: (project) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (project.coverUrl != null || project.posterUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedImage(
                    url: project.coverUrl ?? project.posterUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              Text(project.title, style: AppTypography.headlineLarge),
              if (project.tagline != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(project.tagline!, style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text('Synopsis', style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                project.synopsis ?? 'No synopsis provided.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  CachedAvatar(
                    imageUrl: project.owner.avatarUrl,
                    size: 40,
                    initials: project.owner.firstName.isNotEmpty ? project.owner.firstName.substring(0, 1) : '?',
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Creator', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                      Text(
                        '${project.owner.firstName} ${project.owner.lastName}',
                        style: AppTypography.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
        loading: () => const ShimmerBox(width: double.infinity, height: double.infinity),
        error: (err, _) => ErrorStateWidget(
          message: 'Failed to load project details.',
          onRetry: () => ref.invalidate(projectDetailProvider(projectId)),
        ),
      ),
    );
  }
}
