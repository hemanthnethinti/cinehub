import 'package:cinehubapp/features/ai/domain/entities/ai_entity.dart';

class AiGenerationDto {
  const AiGenerationDto({
    required this.module,
    required this.task,
    required this.data,
    required this.meta,
  });

  final String module;
  final String task;
  final dynamic data;
  final Map<String, dynamic> meta;

  factory AiGenerationDto.fromJson(Map<String, dynamic> json) {
    return AiGenerationDto(
      module: json['module']?.toString() ?? '',
      task: json['task']?.toString() ?? '',
      data: json['data'],
      meta: json['meta'] as Map<String, dynamic>? ?? {},
    );
  }

  AiGenerationEntity toDomain() {
    return AiGenerationEntity(
      module: module,
      task: task,
      data: data,
      meta: meta,
    );
  }
}
