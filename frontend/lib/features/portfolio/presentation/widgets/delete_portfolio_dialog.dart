import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/portfolio/presentation/providers/portfolio_providers.dart';

class DeletePortfolioDialog extends ConsumerStatefulWidget {
  const DeletePortfolioDialog({super.key, required this.id});
  
  final String id;

  @override
  ConsumerState<DeletePortfolioDialog> createState() => _DeletePortfolioDialogState();
}

class _DeletePortfolioDialogState extends ConsumerState<DeletePortfolioDialog> {
  bool _isLoading = false;

  Future<void> _delete() async {
    setState(() => _isLoading = true);
    
    final result = await ref.read(deletePortfolioItemUseCaseProvider).call(widget.id);
    
    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        ref.read(portfolioListProvider.notifier).refresh();
        Navigator.of(context).pop(true); // Return true to signal success
      },
      failure: (error) {
        Navigator.of(context).pop(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.userMessage),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: Text('Delete Portfolio Item', style: AppTypography.headlineSmall.copyWith(color: AppColors.error)),
      content: const Text(
        'Are you sure you want to delete this portfolio item? This action cannot be undone.',
        style: AppTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _delete,
          child: _isLoading 
            ? Shimmer.fromColors(
                baseColor: AppColors.error,
                highlightColor: Colors.white,
                child: const Text('Deleting...'),
              )
            : Text('Delete', style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
        ),
      ],
    );
  }
}
