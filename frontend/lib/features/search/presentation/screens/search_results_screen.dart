import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/features/search/presentation/providers/search_providers.dart';
import 'package:cinehubapp/features/search/presentation/widgets/empty_search_state.dart';
import 'package:cinehubapp/features/search/presentation/widgets/search_category_tabs.dart';
import 'package:cinehubapp/features/search/presentation/widgets/search_loading_skeleton.dart';
import 'package:cinehubapp/shared/widgets/media/app_cached_image.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key, required this.query});
  final String query;

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchResultsProvider(widget.query));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Search: ${widget.query}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SearchCategoryTabs(tabController: _tabController),
        ),
      ),
      body: searchState.when(
        data: (result) {
          if (result.isEmpty) {
            return const EmptySearchState();
          }
          return TabBarView(
            controller: _tabController,
            children: [
              // All
              _buildAllTab(result.users, result.projects, result.portfolios),
              // Creators
              _buildList(result.users, _buildUserTile),
              // Projects
              _buildList(result.projects, _buildProjectTile),
              // Portfolios
              _buildList(result.portfolios, _buildPortfolioTile),
              // Teams
              const EmptySearchState(), // Teams not supported globally yet
            ],
          );
        },
        loading: () => const SearchLoadingSkeleton(),
        error: (error, _) => ErrorStateWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(searchResultsProvider(widget.query)),
        ),
      ),
    );
  }

  Widget _buildAllTab(List<Profile> users, List<Project> projects, List<PortfolioItemEntity> portfolios) {
    final allItems = [...users, ...projects, ...portfolios];
    return _buildList(allItems, (item) {
      if (item is Profile) return _buildUserTile(item);
      if (item is Project) return _buildProjectTile(item);
      if (item is PortfolioItemEntity) return _buildPortfolioTile(item);
      return const SizedBox();
    });
  }

  Widget _buildList<T>(List<T> items, Widget Function(T) builder) {
    if (items.isEmpty) return const EmptySearchState();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => builder(items[index]),
    );
  }

  Widget _buildUserTile(Profile user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null ? Text(user.initials) : null,
      ),
      title: Text(user.fullName),
      subtitle: Text(user.headline ?? 'Creator'),
      onTap: () => context.push(Routes.userProfilePath(user.id)),
    );
  }

  Widget _buildProjectTile(Project project) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        color: AppColors.surfaceElevated,
        child: const Icon(Icons.movie_creation_rounded),
      ),
      title: Text(project.title),
      subtitle: Text('${project.type} • ${project.status}'),
      onTap: () => context.push(Routes.projectDetailPath(project.id)),
    );
  }

  Widget _buildPortfolioTile(PortfolioItemEntity portfolio) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        color: AppColors.surfaceElevated,
        child: portfolio.media.isNotEmpty 
          ? AppCachedImage(imageUrl: portfolio.media.first.thumbnail ?? portfolio.media.first.url, fit: BoxFit.cover)
          : const Icon(Icons.image_rounded),
      ),
      title: Text(portfolio.title),
      subtitle: Text(portfolio.category),
      onTap: () => context.push(Routes.portfolioDetailPath(portfolio.id)),
    );
  }
}
