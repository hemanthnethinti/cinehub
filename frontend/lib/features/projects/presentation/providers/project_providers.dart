import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/projects/data/datasources/project_remote_datasource.dart';
import 'package:cinehubapp/features/projects/data/repositories/project_repository_impl.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';
import 'package:cinehubapp/features/projects/domain/usecases/create_project_usecase.dart';
import 'package:cinehubapp/features/projects/domain/usecases/delete_project_usecase.dart';
import 'package:cinehubapp/features/projects/domain/usecases/get_project_details_usecase.dart';
import 'package:cinehubapp/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:cinehubapp/features/projects/domain/usecases/update_project_usecase.dart';
import 'package:cinehubapp/features/projects/presentation/providers/project_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Dependencies ────────────────────────────────────────────────────────────

final projectRemoteDataSourceProvider = Provider<ProjectRemoteDataSource>((ref) {
  return ProjectRemoteDataSource(ref.watch(apiClientProvider));
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl(ref.watch(projectRemoteDataSourceProvider));
});

final getProjectsUseCaseProvider = Provider<GetProjectsUseCase>((ref) {
  return GetProjectsUseCase(ref.watch(projectRepositoryProvider));
});

final getProjectDetailsUseCaseProvider = Provider<GetProjectDetailsUseCase>((ref) {
  return GetProjectDetailsUseCase(ref.watch(projectRepositoryProvider));
});

final createProjectUseCaseProvider = Provider<CreateProjectUseCase>((ref) {
  return CreateProjectUseCase(ref.watch(projectRepositoryProvider));
});

final updateProjectUseCaseProvider = Provider<UpdateProjectUseCase>((ref) {
  return UpdateProjectUseCase(ref.watch(projectRepositoryProvider));
});

final deleteProjectUseCaseProvider = Provider<DeleteProjectUseCase>((ref) {
  return DeleteProjectUseCase(ref.watch(projectRepositoryProvider));
});

// ── State Providers ─────────────────────────────────────────────────────────

final projectsSearchQueryProvider = StateProvider<String>((ref) => '');
final projectsTypeFilterProvider = StateProvider<String?>((ref) => null);
final projectsStatusFilterProvider = StateProvider<String?>((ref) => null);

final projectsNotifierProvider = NotifierProvider<ProjectsNotifier, ProjectsState>(ProjectsNotifier.new);

class ProjectsNotifier extends Notifier<ProjectsState> {
  static const _limit = 20;
  int _currentPage = 1;

  @override
  ProjectsState build() {
    // Re-fetch when filters change
    ref.listen(projectsSearchQueryProvider, (_, __) => refresh());
    ref.listen(projectsTypeFilterProvider, (_, __) => refresh());
    ref.listen(projectsStatusFilterProvider, (_, __) => refresh());

    Future.microtask(refresh);
    return const ProjectsInitial();
  }

  Future<void> refresh() async {
    state = const ProjectsLoading();
    _currentPage = 1;
    
    final query = ref.read(projectsSearchQueryProvider);
    final type = ref.read(projectsTypeFilterProvider);
    final status = ref.read(projectsStatusFilterProvider);

    final result = await ref.read(getProjectsUseCaseProvider).call(
      search: query.isNotEmpty ? query : null,
      type: type,
      status: status,
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = ProjectsLoaded(
          items: pageData.items,
          hasMore: pageData.hasNext,
        );
      },
      failure: (error) {
        state = ProjectsFailure(error: error);
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! ProjectsLoaded || currentState.isLoadingMore || !currentState.hasMore) return;

    state = ProjectsLoaded(
      items: currentState.items,
      hasMore: currentState.hasMore,
      isLoadingMore: true,
    );

    _currentPage++;

    final query = ref.read(projectsSearchQueryProvider);
    final type = ref.read(projectsTypeFilterProvider);
    final status = ref.read(projectsStatusFilterProvider);

    final result = await ref.read(getProjectsUseCaseProvider).call(
      search: query.isNotEmpty ? query : null,
      type: type,
      status: status,
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = ProjectsLoaded(
          items: [...currentState.items, ...pageData.items],
          hasMore: pageData.hasNext,
          isLoadingMore: false,
        );
      },
      failure: (error) {
        state = ProjectsLoaded(
          items: currentState.items,
          hasMore: currentState.hasMore,
          isLoadingMore: false,
        );
      },
    );
  }
}

// ── Detail Provider ─────────────────────────────────────────────────────────

final projectDetailProvider = AsyncNotifierProvider.autoDispose.family<ProjectDetailNotifier, Project, String>(
  ProjectDetailNotifier.new,
);

class ProjectDetailNotifier extends AutoDisposeFamilyAsyncNotifier<Project, String> {
  @override
  Future<Project> build(String arg) async {
    final result = await ref.watch(getProjectDetailsUseCaseProvider).call(arg);
    return result.when(
      success: (project) => project,
      failure: (error) => throw error,
    );
  }
}
