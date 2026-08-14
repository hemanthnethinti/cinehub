import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/features/portfolio/presentation/widgets/portfolio_card.dart';

class PortfolioGrid extends StatelessWidget {
  const PortfolioGrid({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<PortfolioItemEntity> items;
  final ValueChanged<PortfolioItemEntity> onItemTap;

  @override
  Widget build(BuildContext context) {
    // using GridView.builder for standard grid (masonry requires staggered grid package)
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return PortfolioCard(
          item: item,
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}
