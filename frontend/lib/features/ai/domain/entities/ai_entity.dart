class AiGenerationEntity {
  const AiGenerationEntity({
    required this.module,
    required this.task,
    required this.data,
    required this.meta,
  });

  final String module;
  final String task;
  final dynamic data;
  final Map<String, dynamic> meta;
}

class AiHistoryEntity {
  const AiHistoryEntity({
    required this.id,
    required this.module,
    required this.task,
    required this.input,
    required this.output,
    required this.createdAt,
  });

  final String id;
  final String module;
  final String task;
  final dynamic input;
  final dynamic output;
  final DateTime createdAt;
}
