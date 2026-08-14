import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';

abstract interface class ProjectRepository {
  Future<Result<ProjectPage>> getProjects({
    String? search,
    String? type,
    String? status,
    String? genre,
    required int page,
    required int limit,
  });

  Future<Result<Project>> getProjectById(String id);

  Future<Result<Project>> createProject(Map<String, dynamic> data);

  Future<Result<Project>> updateProject(String id, Map<String, dynamic> data);

  Future<Result<void>> deleteProject(String id);
}
