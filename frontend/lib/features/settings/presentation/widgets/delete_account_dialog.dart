import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/settings/presentation/providers/settings_providers.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:shimmer/shimmer.dart';

class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  ConsumerState<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    setState(() => _isLoading = true);
    
    final result = await ref.read(deleteAccountUseCaseProvider).call();
    
    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (_) {
        Navigator.of(context).pop();
        ref.read(authNotifierProvider.notifier).logout();
      },
      failure: (error) {
        Navigator.of(context).pop();
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
      title: Text('Delete Account', style: AppTypography.headlineSmall.copyWith(color: AppColors.error)),
      content: const Text(
        'Your account will be deactivated and you will be signed out. '
        'You will no longer appear to other CineHub users.',
        style: AppTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _deleteAccount,
          child: _isLoading 
            ? Shimmer.fromColors(
                baseColor: AppColors.error,
                highlightColor: Colors.white,
                child: const Text('Deleting...'),
              )
            : Text('Deactivate Account', style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
        ),
      ],
    );
  }
}
