import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';

class GetProjectsUseCase {
  const GetProjectsUseCase(this._repository);
  final ProjectRepository _repository;

  Future<Result<ProjectPage>> call({
    String? search,
    String? type,
    String? status,
    String? genre,
    required int page,
    required int limit,
  }) {
    return _repository.getProjects(
      search: search,
      type: type,
      status: status,
      genre: genre,
      page: page,
      limit: limit,
    );
  }
}
