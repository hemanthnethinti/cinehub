import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selectedIndex = 0;
  final List<String> _categories = [
    'For You',
    'Trending',
    'Screenplays',
    'Short Films',
    'Documentary',
    'Animation',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return FilterChip(
            label: Text(_categories[index]),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedIndex = index);
                // TODO: Filter feed based on category
              }
            },
            showCheckmark: false,
            selectedColor: AppColors.primaryMuted,
            backgroundColor: AppColors.surfaceElevated,
          );
        },
      ),
    );
  }
}
