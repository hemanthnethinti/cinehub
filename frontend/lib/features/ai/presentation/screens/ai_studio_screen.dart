import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/ai/presentation/providers/ai_providers.dart';
import 'package:cinehubapp/features/ai/presentation/widgets/prompt_card.dart';
import 'package:cinehubapp/features/ai/presentation/widgets/prompt_input.dart';
import 'package:cinehubapp/features/ai/presentation/widgets/ai_result_card.dart';
import 'package:cinehubapp/features/ai/presentation/widgets/ai_loading_skeleton.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

enum AiTaskType { bio, headline, projectDescription, portfolioDescription, skills }

class AiStudioScreen extends ConsumerStatefulWidget {
  const AiStudioScreen({super.key});

  @override
  ConsumerState<AiStudioScreen> createState() => _AiStudioScreenState();
}

class _AiStudioScreenState extends ConsumerState<AiStudioScreen> {
  AiTaskType _selectedTask = AiTaskType.bio;
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_inputController.text.trim().isEmpty) return;

    ref.read(aiResultProvider.notifier).state = const AsyncLoading();

    try {
      final input = _inputController.text.trim();
      final result = await switch (_selectedTask) {
        AiTaskType.bio => ref.read(generateBioUseCaseProvider).call(input),
        AiTaskType.headline => ref.read(generateHeadlineUseCaseProvider).call(input),
        AiTaskType.projectDescription => ref.read(generateProjectDescriptionUseCaseProvider).call(input, 'General'),
        AiTaskType.portfolioDescription => ref.read(generatePortfolioDescriptionUseCaseProvider).call('General', input),
        AiTaskType.skills => ref.read(generateSkillsUseCaseProvider).call(input),
      };

      result.when(
        success: (data) {
          ref.read(aiResultProvider.notifier).state = AsyncData(data);
          ref.invalidate(aiHistoryProvider);
        },
        failure: (error) {
          ref.read(aiResultProvider.notifier).state = AsyncError(error.userMessage, StackTrace.current);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.userMessage)));
        },
      );
    } catch (e) {
      ref.read(aiResultProvider.notifier).state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(aiResultProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Studio'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => context.push(Routes.aiHistory),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What would you like to generate?', style: AppTypography.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.5,
              children: [
                PromptCard(
                  title: 'Professional Bio',
                  icon: Icons.person_rounded,
                  isSelected: _selectedTask == AiTaskType.bio,
                  onTap: () => setState(() => _selectedTask = AiTaskType.bio),
                ),
                PromptCard(
                  title: 'Headline',
                  icon: Icons.short_text_rounded,
                  isSelected: _selectedTask == AiTaskType.headline,
                  onTap: () => setState(() => _selectedTask = AiTaskType.headline),
                ),
                PromptCard(
                  title: 'Project Description',
                  icon: Icons.movie_creation_rounded,
                  isSelected: _selectedTask == AiTaskType.projectDescription,
                  onTap: () => setState(() => _selectedTask = AiTaskType.projectDescription),
                ),
                PromptCard(
                  title: 'Skills Suggestion',
                  icon: Icons.psychology_rounded,
                  isSelected: _selectedTask == AiTaskType.skills,
                  onTap: () => setState(() => _selectedTask = AiTaskType.skills),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Provide some context:', style: AppTypography.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            PromptInput(
              controller: _inputController,
              label: 'Context',
              hint: 'E.g., I am a cinematographer from New York...',
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: resultState.isLoading ? null : _generate,
                icon: const Icon(Icons.auto_awesome),
                label: Text(resultState.isLoading ? 'Generating...' : 'Generate'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            resultState.when(
              data: (data) {
                if (data == null) return const SizedBox();
                final text = data.data is Map ? (data.data['text'] ?? data.data.toString()) : data.data.toString();
                return AiResultCard(
                  resultText: text,
                  onShare: () {},
                );
              },
              loading: () => const AiLoadingSkeleton(),
              error: (e, _) => ErrorStateWidget(
                message: e.toString(),
                onRetry: _generate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
