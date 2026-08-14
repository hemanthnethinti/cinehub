import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_providers.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_state.dart';
import 'package:cinehubapp/features/projects/presentation/widgets/project_card.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/features/projects/presentation/widgets/project_loading_skeleton.dart';
import 'dart:async';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  final _projectTypes = ['short_film', 'feature_film', 'documentary', 'web_series', 'commercial'];
  final _projectStatuses = ['draft', 'pre_production', 'in_production', 'post_production', 'completed', 'archived'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.text = ref.read(projectsSearchQueryProvider);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(projectsNotifierProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(projectsSearchQueryProvider.notifier).state = value;
    });
  }

  String _formatEnum(String value) {
    return value.split('_').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Projects', style: AppTypography.headlineMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              context.push(Routes.createProject);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(projectsNotifierProvider.notifier).refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: AppTypography.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    children: [
                      _buildFilterDropdown(
                        value: ref.watch(projectsTypeFilterProvider),
                        options: _projectTypes,
                        label: 'Type',
                        onChanged: (val) => ref.read(projectsTypeFilterProvider.notifier).state = val,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildFilterDropdown(
                        value: ref.watch(projectsStatusFilterProvider),
                        options: _projectStatuses,
                        label: 'Status',
                        onChanged: (val) => ref.read(projectsStatusFilterProvider.notifier).state = val,
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
              _buildProjectList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String? value,
    required List<String> options,
    required String label,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: value != null ? AppColors.primaryMuted : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: value != null ? AppColors.primary : AppColors.border, width: 0.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          hint: Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('All $label', style: AppTypography.labelMedium),
            ),
            ...options.map((opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(_formatEnum(opt), style: AppTypography.labelMedium),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildProjectList() {
    final state = ref.watch(projectsNotifierProvider);

    return switch (state) {
      ProjectsInitial() => const SliverToBoxAdapter(child: SizedBox.shrink()),
      ProjectsLoading() => const SliverToBoxAdapter(child: ProjectLoadingSkeleton()),
      ProjectsLoaded(:final items, :final isLoadingMore) => items.isEmpty
          ? const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.xxl),
                child: EmptyState(
                  icon: Icons.movie_filter_rounded,
                  title: 'No projects found',
                  subtitle: 'Try adjusting your filters or search query.',
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
                  return ProjectCard(project: items[index]);
                },
                childCount: items.length + 1,
              ),
            ),
      ProjectsFailure(:final error, :final previousItems) => previousItems != null
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProjectCard(project: previousItems[index]),
                childCount: previousItems.length,
              ),
            )
          : SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: ErrorStateWidget(
                  message: error.userMessage,
                  onRetry: () => ref.read(projectsNotifierProvider.notifier).refresh(),
                ),
              ),
            ),
    };
  }
}
