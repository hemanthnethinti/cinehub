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

class FollowersScreen extends ConsumerStatefulWidget {
  const FollowersScreen({super.key, required this.userId});
  
  final String userId;

  @override
  ConsumerState<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends ConsumerState<FollowersScreen> {
  final _scrollController = ScrollController();
  final List<Profile> _followers = [];
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
      _followers.clear();
      _currentPage = 1;
      _hasNext = true;
    });

    try {
      final page = await ref.read(followersProvider((widget.userId, _currentPage)).future);
      setState(() {
        _followers.addAll(page.profiles);
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
      final page = await ref.read(followersProvider((widget.userId, _currentPage)).future);
      setState(() {
        _followers.addAll(page.profiles);
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
        title: const Text('Followers'),
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
        title: 'Failed to load followers',
        message: _error!,
        actionLabel: 'Retry',
        onAction: _loadInitial,
      );
    }

    if (_followers.isEmpty) {
      return const EmptyProfileState(
        icon: Icons.people_outline,
        title: 'No followers yet',
        message: 'When someone follows this user, they\'ll show up here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitial,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _followers.length + (_hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _followers.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: ShimmerBox(width: double.infinity, height: 60),
              ),
            );
          }

          final follower = _followers[index];
          return UserListTile(
            profile: follower,
            onTap: () => context.push(Routes.userProfilePath(follower.id)),
          );
        },
      ),
    );
  }
}
