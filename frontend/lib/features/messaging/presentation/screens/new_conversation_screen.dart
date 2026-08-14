import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';
// Note: We'd typically fetch users using a Profile/User repository, 
// but we'll use a mocked UI here to satisfy the design.

class NewConversationScreen extends ConsumerStatefulWidget {
  const NewConversationScreen({super.key});

  @override
  ConsumerState<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends ConsumerState<NewConversationScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('New Message', style: AppTypography.headlineSmall),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              ),
              onChanged: (val) {
                // Trigger search
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Mock search results
                if (_searchController.text.isNotEmpty)
                  ListTile(
                    leading: const CachedAvatar(imageUrl: null, size: 40),
                    title: const Text('Mock User', style: AppTypography.headlineSmall),
                    subtitle: Text('@mockuser', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    onTap: () {
                      context.pushReplacement(
                        Routes.chatPath('new_conversation_mock_id'),
                      );
                    },
                  ),
                if (_searchController.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Center(
                      child: Text(
                        'Search for a user to start a conversation.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
