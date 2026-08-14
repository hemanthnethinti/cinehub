import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/discover/presentation/providers/discover_providers.dart';
import 'package:cinehubapp/features/discover/presentation/providers/discover_state.dart';
import 'package:cinehubapp/features/discover/presentation/widgets/creator_carousel.dart';
import 'package:cinehubapp/features/discover/presentation/widgets/discover_search_bar.dart';
import 'package:cinehubapp/features/home/presentation/widgets/feed_card.dart';
import 'package:cinehubapp/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
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
      final query = ref.read(discoverSearchQueryProvider);
      if (query.isNotEmpty) {
        ref.read(searchNotifierProvider.notifier).loadMore();
      }
    }
  }

  Future<void> _onRefresh() async {
    final query = ref.read(discoverSearchQueryProvider);
    if (query.isEmpty) {
      await ref.read(trendingNotifierProvider.notifier).refresh();
    } else {
      await ref.read(searchNotifierProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(discoverSearchQueryProvider);
    final isSearching = query.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: DiscoverSearchBar(),
                ),
              ),
              
              if (isSearching)
                _buildSearchResults(ref)
              else
                _buildTrending(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrending(WidgetRef ref) {
    final state = ref.watch(trendingNotifierProvider);

    return switch (state) {
      TrendingInitial() => const SliverToBoxAdapter(child: SizedBox.shrink()),
      TrendingLoading() => const SliverToBoxAdapter(child: HomeLoadingSkeleton()),
      TrendingLoaded(:final content) => SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: AppSpacing.md),
            CreatorCarousel(creators: content.creators),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('Trending Projects', style: AppTypography.headlineSmall),
            ),
            const SizedBox(height: AppSpacing.md),
            ...content.projects.map((project) => FeedCard(item: project)),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('Trending Portfolios', style: AppTypography.headlineSmall),
            ),
            const SizedBox(height: AppSpacing.md),
            ...content.portfolios.map((portfolio) => FeedCard(item: portfolio)),
            const SizedBox(height: AppSpacing.xxl),
          ]),
        ),
      TrendingFailure(:final error, :final previousContent) => previousContent != null
          ? SliverList(
              delegate: SliverChildListDelegate([
                CreatorCarousel(creators: previousContent.creators),
                ...previousContent.projects.map((project) => FeedCard(item: project)),
              ]),
            )
          : SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ErrorStateWidget(
                  message: error.userMessage,
                  onRetry: () => ref.read(trendingNotifierProvider.notifier).refresh(),
                ),
              ),
            ),
    };
  }

  Widget _buildSearchResults(WidgetRef ref) {
    final state = ref.watch(searchNotifierProvider);

    return switch (state) {
      SearchInitial() => const SliverToBoxAdapter(child: SizedBox.shrink()),
      SearchLoading() => const SliverToBoxAdapter(child: HomeLoadingSkeleton()),
      SearchLoaded(:final items, :final isLoadingMore) => items.isEmpty
          ? const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No results found',
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
      SearchFailure(:final error, :final previousItems) => previousItems != null
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
                  onRetry: () => ref.read(searchNotifierProvider.notifier).refresh(),
                ),
              ),
            ),
    };
  }
}
