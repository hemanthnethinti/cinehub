import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/portfolio/presentation/providers/portfolio_providers.dart';
import 'package:cinehubapp/features/portfolio/presentation/widgets/empty_portfolio_state.dart';
import 'package:cinehubapp/features/portfolio/presentation/widgets/portfolio_grid.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';


class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Featured Portfolio', style: AppTypography.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create Portfolio',
            onPressed: () => context.push(Routes.portfolioEditorPath('new')),
          ),
        ],
      ),
      body: state.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyPortfolioState();
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(portfolioListProvider.notifier).refresh(),
            child: PortfolioGrid(
              items: items,
              onItemTap: (item) => context.push(Routes.portfolioDetailPath(item.id)),
            ),
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: double.infinity),
        ),
        error: (error, _) => ErrorStateWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(portfolioListProvider),
        ),
      ),
    );
  }
}
