import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/portfolio/data/datasources/portfolio_remote_datasource.dart';
import 'package:cinehubapp/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:cinehubapp/features/portfolio/domain/usecases/portfolio_usecases.dart';

// ── Data & Domain ────────────────────────────────────────────────────────────

final portfolioRemoteDataSourceProvider = Provider<PortfolioRemoteDataSource>((ref) {
  return PortfolioRemoteDataSource(ref.watch(apiClientProvider));
});

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return PortfolioRepositoryImpl(ref.watch(portfolioRemoteDataSourceProvider));
});

final getPortfolioUseCaseProvider = Provider<GetPortfolioUseCase>((ref) {
  return GetPortfolioUseCase(ref.watch(portfolioRepositoryProvider));
});

final getPortfolioItemUseCaseProvider = Provider<GetPortfolioItemUseCase>((ref) {
  return GetPortfolioItemUseCase(ref.watch(portfolioRepositoryProvider));
});

final createPortfolioItemUseCaseProvider = Provider<CreatePortfolioItemUseCase>((ref) {
  return CreatePortfolioItemUseCase(ref.watch(portfolioRepositoryProvider));
});

final updatePortfolioItemUseCaseProvider = Provider<UpdatePortfolioItemUseCase>((ref) {
  return UpdatePortfolioItemUseCase(ref.watch(portfolioRepositoryProvider));
});

final deletePortfolioItemUseCaseProvider = Provider<DeletePortfolioItemUseCase>((ref) {
  return DeletePortfolioItemUseCase(ref.watch(portfolioRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

// For simplicity in UI, we fetch featured portfolios for the main feed
final portfolioListProvider = AsyncNotifierProvider<PortfolioListNotifier, List<PortfolioItemEntity>>(
  PortfolioListNotifier.new,
);

class PortfolioListNotifier extends AsyncNotifier<List<PortfolioItemEntity>> {
  @override
  Future<List<PortfolioItemEntity>> build() async {
    return _fetch(1);
  }

  Future<List<PortfolioItemEntity>> _fetch(int page) async {
    final result = await ref.read(getPortfolioUseCaseProvider).getFeatured(page: page);
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(1));
  }

  Future<void> toggleLike(String id) async {
    final oldState = state.valueOrNull;
    if (oldState == null) return;

    // Optimistic UI update
    final updatedList = oldState.map((e) {
      if (e.id == id) {
        return PortfolioItemEntity(
          id: e.id,
          ownerId: e.ownerId,
          title: e.title,
          description: e.description,
          category: e.category,
          tags: e.tags,
          media: e.media,
          likeCount: e.likeCount + 1, // simplified toggle logic
          viewCount: e.viewCount,
          isPublished: e.isPublished,
          createdAt: e.createdAt,
          ownerName: e.ownerName,
          ownerAvatar: e.ownerAvatar,
        );
      }
      return e;
    }).toList();
    state = AsyncData(updatedList);

    final result = await ref.read(portfolioRepositoryProvider).toggleLike(id);
    result.when(
      success: (_) {},
      failure: (error) {
        // Revert
        state = AsyncData(oldState);
      },
    );
  }
}

// Fetch single portfolio item
final portfolioDetailProvider = FutureProvider.autoDispose.family<PortfolioItemEntity, String>((ref, id) async {
  final result = await ref.read(getPortfolioItemUseCaseProvider).call(id);
  return result.when(
    success: (data) => data,
    failure: (error) => throw Exception(error.userMessage),
  );
});
