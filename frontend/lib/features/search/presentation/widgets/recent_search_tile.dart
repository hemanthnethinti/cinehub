import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

class RecentSearchTile extends StatelessWidget {
  const RecentSearchTile({
    super.key,
    required this.query,
    required this.onTap,
  });

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history_rounded, color: AppColors.textTertiary),
      title: Text(query, style: AppTypography.bodyLarge),
      trailing: const Icon(Icons.north_west_rounded, color: AppColors.textTertiary, size: 16),
      onTap: onTap,
    );
  }
}
