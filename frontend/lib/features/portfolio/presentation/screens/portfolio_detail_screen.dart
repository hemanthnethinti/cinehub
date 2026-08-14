import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/portfolio/presentation/providers/portfolio_providers.dart';
import 'package:cinehubapp/features/portfolio/presentation/widgets/delete_portfolio_dialog.dart';
import 'package:cinehubapp/features/portfolio/presentation/widgets/portfolio_media_carousel.dart';
import 'package:cinehubapp/features/portfolio/presentation/widgets/portfolio_stats.dart';
import 'package:cinehubapp/shared/widgets/chips/chips.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class PortfolioDetailScreen extends ConsumerWidget {
  const PortfolioDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(portfolioDetailProvider(id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => context.push(Routes.portfolioEditorPath(id)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: AppColors.error),
            onPressed: () async {
              final deleted = await showDialog<bool>(
                context: context,
                builder: (context) => DeletePortfolioDialog(id: id),
              );
              if (deleted == true && context.mounted) {
                context.pop();
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: detailState.when(
        data: (item) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: PortfolioMediaCarousel(media: item.media),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(item.title, style: AppTypography.displayMedium),
                          ),
                          StatusChip(
                            label: item.isPublished ? 'Published' : 'Draft',
                            status: item.isPublished ? StatusType.active : StatusType.draft,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GestureDetector(
                        onTap: () {
                          if (item.ownerId.isNotEmpty && item.ownerId != 'unknown') {
                            context.push(Routes.userProfilePath(item.ownerId));
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: item.ownerAvatar != null ? NetworkImage(item.ownerAvatar!) : null,
                              child: item.ownerAvatar == null ? const Icon(Icons.person, size: 16) : null,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(item.ownerName ?? 'Unknown Artist', style: AppTypography.bodyLarge),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(item.description, style: AppTypography.bodyLarge),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Tags', style: AppTypography.headlineSmall),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: item.tags.map((tag) => SkillChip(label: tag)).toList(),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      PortfolioStats(item: item),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const ShimmerBox(width: double.infinity, height: double.infinity),
        error: (error, _) => ErrorStateWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(portfolioDetailProvider(id)),
        ),
      ),
    );
  }
}
