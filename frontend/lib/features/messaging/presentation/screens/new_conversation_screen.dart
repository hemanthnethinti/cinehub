import 'dart:async';

import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewConversationScreen extends ConsumerStatefulWidget {
  const NewConversationScreen({super.key});

  @override
  ConsumerState<NewConversationScreen> createState() =>
      _NewConversationScreenState();
}

class _NewConversationScreenState
    extends ConsumerState<NewConversationScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';
  String? _startingUserId;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  Future<void> _startConversation(Profile profile) async {
    setState(() => _startingUserId = profile.id);
    final result = await ref
        .read(startConversationUseCaseProvider)
        .call(profile.id);

    if (!mounted) return;
    setState(() => _startingUserId = null);
    result.when(
      success: (conversationId) {
        ref.invalidate(conversationsProvider);
        context.pushReplacement(Routes.chatPath(conversationId));
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.userMessage)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : null;
    final results = _query.length >= 2
        ? ref.watch(messageUserSearchProvider(_query))
        : const AsyncData<List<Profile>>([]);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'New Message',
          style: AppTypography.headlineSmall,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _debounce?.cancel();
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
              onChanged: (value) {
                _onSearchChanged(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: _query.length < 2
                ? _SearchPrompt(hasQuery: _query.isNotEmpty)
                : results.when(
                    data: (profiles) {
                      final users = profiles
                          .where((profile) => profile.id != currentUserId)
                          .toList();
                      if (users.isEmpty) {
                        return const Center(
                          child: Text('No people found.'),
                        );
                      }
                      return ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final profile = users[index];
                          final isStarting = _startingUserId == profile.id;
                          return ListTile(
                            leading: CachedAvatar(
                              imageUrl: profile.avatarUrl,
                              size: 44,
                            ),
                            title: Text(
                              profile.fullName,
                              style: AppTypography.bodyLarge,
                            ),
                            subtitle: Text(
                              profile.headline ?? profile.role.label,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            trailing: isStarting
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.chevron_right_rounded),
                            enabled: _startingUserId == null,
                            onTap: () => _startConversation(profile),
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, _) => ErrorStateWidget(
                      message: error.toString(),
                      onRetry: () =>
                          ref.invalidate(messageUserSearchProvider(_query)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          hasQuery
              ? 'Type at least 2 characters to search.'
              : 'Search for someone to start a conversation.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
