import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';

class UpdateProjectUseCase {
  const UpdateProjectUseCase(this._repository);
  final ProjectRepository _repository;

  Future<Result<Project>> call(String id, Map<String, dynamic> data) {
    return _repository.updateProject(id, data);
  }
}
