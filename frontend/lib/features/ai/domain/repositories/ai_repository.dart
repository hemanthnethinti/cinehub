import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/ai/domain/entities/ai_entity.dart';

abstract interface class AiRepository {
  Future<Result<AiGenerationEntity>> generate({
    required String module,
    required String task,
    required dynamic input,
    Map<String, dynamic>? options,
  });

  Future<Result<List<AiHistoryEntity>>> getHistory();
}
