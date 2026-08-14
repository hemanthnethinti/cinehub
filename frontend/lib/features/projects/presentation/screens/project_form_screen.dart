import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_providers.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_form_provider.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_form_state.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/features/projects/presentation/widgets/project_form.dart';

class ProjectFormScreen extends ConsumerWidget {
  const ProjectFormScreen({super.key, this.projectId});

  final String? projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(projectFormProvider, (previous, next) {
      if (next is ProjectFormSuccess) {
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(projectId == null ? 'Project created successfully!' : 'Project updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        // Pop the screen
        context.pop();
      }
    });

    if (projectId != null) {
      final detailState = ref.watch(projectDetailProvider(projectId!));
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Edit Project'),
          backgroundColor: AppColors.background,
          elevation: 0,
        ),
        body: detailState.when(
          data: (project) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ProjectForm(initialProject: project),
          ),
          loading: () => const ShimmerBox(width: double.infinity, height: double.infinity),
          error: (error, _) => Center(
            child: ErrorStateWidget(
              message: 'Failed to load project details.',
              onRetry: () => ref.invalidate(projectDetailProvider(projectId!)),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Project'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: ProjectForm(),
      ),
    );
  }
}
