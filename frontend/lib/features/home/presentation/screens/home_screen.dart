import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/home/presentation/providers/home_providers.dart';
import 'package:cinehubapp/features/home/presentation/providers/home_state.dart';
import 'package:cinehubapp/features/home/presentation/widgets/category_chips.dart';
import 'package:cinehubapp/features/home/presentation/widgets/featured_banner.dart';
import 'package:cinehubapp/features/home/presentation/widgets/feed_card.dart';
import 'package:cinehubapp/features/home/presentation/widgets/home_app_bar.dart';
import 'package:cinehubapp/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(homeNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeNotifierProvider.notifier).refreshFeed(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const HomeAppBar(),
            
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
                child: CategoryChips(),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: FeaturedBanner(),
            ),

            _buildContent(state),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeState state) {
    return switch (state) {
      HomeInitial() => const SliverToBoxAdapter(child: SizedBox.shrink()),
      HomeLoading() => const SliverToBoxAdapter(child: HomeLoadingSkeleton()),
      HomeLoaded(:final items, :final isLoadingMore) => items.isEmpty
          ? const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.feed_outlined,
                  title: 'No feed items found',
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == items.length) {
                    if (isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: ShimmerBox(width: double.infinity, height: 120),
                        ),
                      );
                    }
                    return const SizedBox(height: AppSpacing.xl);
                  }
                  return FeedCard(item: items[index]);
                },
                childCount: items.length + 1,
              ),
            ),
      HomeFailure(:final error, :final previousItems) => previousItems != null 
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => FeedCard(item: previousItems[index]),
                childCount: previousItems.length,
              ),
            )
          : SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ErrorStateWidget(
                  message: error.userMessage,
                  onRetry: () => ref.read(homeNotifierProvider.notifier).refreshFeed(),
                ),
              ),
            ),
    };
  }
}
