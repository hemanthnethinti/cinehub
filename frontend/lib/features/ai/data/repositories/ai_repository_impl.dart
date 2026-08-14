import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/ai/data/datasources/ai_remote_datasource.dart';
import 'package:cinehubapp/features/ai/data/models/ai_dto.dart';
import 'package:cinehubapp/features/ai/domain/entities/ai_entity.dart';
import 'package:cinehubapp/features/ai/domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  const AiRepositoryImpl(this._remote);
  final AiRemoteDataSource _remote;
  
  // Mock history in memory since there is no backend endpoint
  static final List<AiHistoryEntity> _mockHistory = [];

  @override
  Future<Result<AiGenerationEntity>> generate({
    required String module,
    required String task,
    required dynamic input,
    Map<String, dynamic>? options,
  }) async {
    try {
      final res = await _remote.generate(
        module: module,
        task: task,
        input: input,
        options: options,
      );
      
      // Parse DTO
      final dto = AiGenerationDto.fromJson(res);
      final entity = dto.toDomain();
      
      // Add to local mock history
      _mockHistory.insert(0, AiHistoryEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        module: module,
        task: task,
        input: input,
        output: entity.data,
        createdAt: DateTime.now(),
      ));
      
      return Result.success(entity);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<AiHistoryEntity>>> getHistory() async {
    // Return the local mock history
    return Result.success(_mockHistory);
  }
}
