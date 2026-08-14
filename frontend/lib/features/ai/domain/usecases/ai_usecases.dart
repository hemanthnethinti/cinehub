import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/ai/domain/entities/ai_entity.dart';
import 'package:cinehubapp/features/ai/domain/repositories/ai_repository.dart';

class GenerateBioUseCase {
  const GenerateBioUseCase(this._repository);
  final AiRepository _repository;

  Future<Result<AiGenerationEntity>> call(String background) {
    return _repository.generate(
      module: 'profile',
      task: 'bio',
      input: {'background': background},
    );
  }
}

class GenerateHeadlineUseCase {
  const GenerateHeadlineUseCase(this._repository);
  final AiRepository _repository;

  Future<Result<AiGenerationEntity>> call(String background) {
    return _repository.generate(
      module: 'profile',
      task: 'headline',
      input: {'background': background},
    );
  }
}

class GenerateProjectDescriptionUseCase {
  const GenerateProjectDescriptionUseCase(this._repository);
  final AiRepository _repository;

  Future<Result<AiGenerationEntity>> call(String title, String logline) {
    return _repository.generate(
      module: 'project',
      task: 'description',
      input: {'title': title, 'logline': logline},
    );
  }
}

class GeneratePortfolioDescriptionUseCase {
  const GeneratePortfolioDescriptionUseCase(this._repository);
  final AiRepository _repository;

  Future<Result<AiGenerationEntity>> call(String type, String details) {
    return _repository.generate(
      module: 'portfolio',
      task: 'description',
      input: {'type': type, 'details': details},
    );
  }
}

class GenerateSkillsUseCase {
  const GenerateSkillsUseCase(this._repository);
  final AiRepository _repository;

  Future<Result<AiGenerationEntity>> call(String role) {
    return _repository.generate(
      module: 'profile',
      task: 'skills',
      input: {'role': role},
    );
  }
}

class GetGenerationHistoryUseCase {
  const GetGenerationHistoryUseCase(this._repository);
  final AiRepository _repository;

  Future<Result<List<AiHistoryEntity>>> call() {
    return _repository.getHistory();
  }
}
