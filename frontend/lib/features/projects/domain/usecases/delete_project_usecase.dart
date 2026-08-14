import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/projects/domain/repositories/project_repository.dart';

class DeleteProjectUseCase {
  const DeleteProjectUseCase(this._repository);
  final ProjectRepository _repository;

  Future<Result<void>> call(String id) {
    return _repository.deleteProject(id);
  }
}
