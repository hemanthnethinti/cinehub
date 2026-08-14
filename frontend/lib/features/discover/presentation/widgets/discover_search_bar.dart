import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/discover/presentation/providers/discover_providers.dart';

class DiscoverSearchBar extends ConsumerStatefulWidget {
  const DiscoverSearchBar({super.key});

  @override
  ConsumerState<DiscoverSearchBar> createState() => _DiscoverSearchBarState();
}

class _DiscoverSearchBarState extends ConsumerState<DiscoverSearchBar> {
  Timer? _debounceTimer;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(discoverSearchQueryProvider));
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(discoverSearchQueryProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(discoverSearchQueryProvider.notifier).state = '';
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = ref.watch(discoverSearchQueryProvider).isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        style: AppTypography.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search creators, projects...',
          hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          suffixIcon: hasQuery
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: AppColors.surfaceElevated,
          border: OutlineInputBorder(
            borderRadius: AppRadius.card,
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
    );
  }
}
