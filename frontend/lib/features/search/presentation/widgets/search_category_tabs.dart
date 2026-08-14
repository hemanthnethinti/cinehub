import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

class SearchCategoryTabs extends StatelessWidget {
  const SearchCategoryTabs({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textTertiary,
      labelStyle: AppTypography.labelLarge,
      tabs: const [
        Tab(text: 'All'),
        Tab(text: 'Creators'),
        Tab(text: 'Projects'),
        Tab(text: 'Portfolios'),
        Tab(text: 'Teams'),
      ],
    );
  }
}
