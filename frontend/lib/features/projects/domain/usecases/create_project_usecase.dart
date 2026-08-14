import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';

class CreateProjectUseCase {
  const CreateProjectUseCase(this._repository);
  final ProjectRepository _repository;

  Future<Result<Project>> call(Map<String, dynamic> data) {
    return _repository.createProject(data);
  }
}
