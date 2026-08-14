import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';

// ── Projects List State ─────────────────────────────────────────────────────

sealed class ProjectsState {
  const ProjectsState();
}

final class ProjectsInitial extends ProjectsState { const ProjectsInitial(); }
final class ProjectsLoading extends ProjectsState { const ProjectsLoading(); }
final class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded({
    required this.items,
    this.hasMore = true,
    this.isLoadingMore = false,
  });
  final List<Project> items;
  final bool hasMore;
  final bool isLoadingMore;
}
final class ProjectsFailure extends ProjectsState {
  const ProjectsFailure({required this.error, this.previousItems});
  final AppError error;
  final List<Project>? previousItems;
}

// ── Project Detail State ────────────────────────────────────────────────────

sealed class ProjectDetailState {
  const ProjectDetailState();
}

final class ProjectDetailInitial extends ProjectDetailState { const ProjectDetailInitial(); }
final class ProjectDetailLoading extends ProjectDetailState { const ProjectDetailLoading(); }
final class ProjectDetailLoaded extends ProjectDetailState {
  const ProjectDetailLoaded(this.project);
  final Project project;
}
final class ProjectDetailFailure extends ProjectDetailState {
  const ProjectDetailFailure({required this.error});
  final AppError error;
}
