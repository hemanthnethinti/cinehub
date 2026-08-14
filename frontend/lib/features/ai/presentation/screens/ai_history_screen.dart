import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/ai/presentation/providers/ai_providers.dart';
import 'package:cinehubapp/features/ai/presentation/widgets/ai_empty_state.dart';
import 'package:cinehubapp/features/ai/presentation/widgets/generation_history_tile.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class AiHistoryScreen extends ConsumerWidget {
  const AiHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(aiHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Generation History'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: historyState.when(
        data: (history) {
          if (history.isEmpty) {
            return const AiEmptyState();
          }
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return GenerationHistoryTile(
                history: history[index],
                onTap: () {
                  // Re-apply or view details
                },
              );
            },
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 100),
        ),
        error: (error, _) => ErrorStateWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(aiHistoryProvider),
        ),
      ),
    );
  }
}
