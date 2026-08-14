import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';

class GetProjectDetailsUseCase {
  const GetProjectDetailsUseCase(this._repository);
  final ProjectRepository _repository;

  Future<Result<Project>> call(String id) {
    return _repository.getProjectById(id);
  }
}
