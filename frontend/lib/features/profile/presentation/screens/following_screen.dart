import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/profile/presentation/providers/profile_providers.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/empty_profile_state.dart';
import 'package:cinehubapp/features/profile/presentation/widgets/user_list_tile.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class FollowingScreen extends ConsumerStatefulWidget {
  const FollowingScreen({super.key, required this.userId});
  
  final String userId;

  @override
  ConsumerState<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends ConsumerState<FollowingScreen> {
  final _scrollController = ScrollController();
  final List<Profile> _following = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasNext = true;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _following.clear();
      _currentPage = 1;
      _hasNext = true;
    });

    try {
      final page = await ref.read(followingProvider((widget.userId, _currentPage)).future);
      setState(() {
        _following.addAll(page.profiles);
        _hasNext = page.hasNext;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (!_hasNext || _isLoadingMore || _isLoading) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;
    try {
      final page = await ref.read(followingProvider((widget.userId, _currentPage)).future);
      setState(() {
        _following.addAll(page.profiles);
        _hasNext = page.hasNext;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Following'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 60),
      );
    }

    if (_error != null) {
      return EmptyProfileState(
        icon: Icons.error_outline,
        title: 'Failed to load following',
        message: _error!,
        actionLabel: 'Retry',
        onAction: _loadInitial,
      );
    }

    if (_following.isEmpty) {
      return const EmptyProfileState(
        icon: Icons.person_add_disabled_outlined,
        title: 'Not following anyone',
        message: 'When this user follows someone, they\'ll show up here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitial,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _following.length + (_hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _following.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: ShimmerBox(width: double.infinity, height: 60),
              ),
            );
          }

          final user = _following[index];
          return UserListTile(
            profile: user,
            onTap: () => context.push(Routes.userProfilePath(user.id)),
          );
        },
      ),
    );
  }
}
