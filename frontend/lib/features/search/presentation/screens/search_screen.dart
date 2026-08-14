import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/search/presentation/providers/search_providers.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/features/search/presentation/widgets/recent_search_tile.dart';
import 'package:cinehubapp/features/search/presentation/widgets/search_bar.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    ref.read(searchQueryProvider.notifier).state = query.trim();
    context.push('/search/results/${Uri.encodeComponent(query.trim())}');
  }

  @override
  Widget build(BuildContext context) {
    final recentSearches = ref.watch(recentSearchesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: CustomSearchBar(
          controller: _searchController,
          autoFocus: true,
          onSubmitted: _onSearch,
          onChanged: (val) => setState(() {}),
        ),
      ),
      body: recentSearches.when(
        data: (searches) {
          if (searches.isEmpty) {
            return const Center(child: Text('Search for creators, projects, and more.', style: AppTypography.bodyLarge));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Searches', style: AppTypography.bodyLarge),
                    TextButton(
                      onPressed: () {
                        ref.read(clearRecentSearchesUseCaseProvider).call();
                        ref.invalidate(recentSearchesProvider);
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searches.length,
                  itemBuilder: (context, index) {
                    final query = searches[index];
                    return RecentSearchTile(
                      query: query,
                      onTap: () {
                        _searchController.text = query;
                        _onSearch(query);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 80),
        ),
        error: (_, __) => const SizedBox(),
      ),
    );
  }
}
