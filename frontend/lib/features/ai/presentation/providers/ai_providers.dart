import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/ai/data/datasources/ai_remote_datasource.dart';
import 'package:cinehubapp/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:cinehubapp/features/ai/domain/entities/ai_entity.dart';
import 'package:cinehubapp/features/ai/domain/repositories/ai_repository.dart';
import 'package:cinehubapp/features/ai/domain/usecases/ai_usecases.dart';

// ── Data & Domain ────────────────────────────────────────────────────────────

final aiRemoteDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  return AiRemoteDataSource(ref.watch(apiClientProvider));
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(ref.watch(aiRemoteDataSourceProvider));
});

final generateBioUseCaseProvider = Provider<GenerateBioUseCase>((ref) {
  return GenerateBioUseCase(ref.watch(aiRepositoryProvider));
});

final generateHeadlineUseCaseProvider = Provider<GenerateHeadlineUseCase>((ref) {
  return GenerateHeadlineUseCase(ref.watch(aiRepositoryProvider));
});

final generateProjectDescriptionUseCaseProvider = Provider<GenerateProjectDescriptionUseCase>((ref) {
  return GenerateProjectDescriptionUseCase(ref.watch(aiRepositoryProvider));
});

final generatePortfolioDescriptionUseCaseProvider = Provider<GeneratePortfolioDescriptionUseCase>((ref) {
  return GeneratePortfolioDescriptionUseCase(ref.watch(aiRepositoryProvider));
});

final generateSkillsUseCaseProvider = Provider<GenerateSkillsUseCase>((ref) {
  return GenerateSkillsUseCase(ref.watch(aiRepositoryProvider));
});

final getGenerationHistoryUseCaseProvider = Provider<GetGenerationHistoryUseCase>((ref) {
  return GetGenerationHistoryUseCase(ref.watch(aiRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

// Used to track the output of the currently generated text
final aiResultProvider = StateProvider.autoDispose<AsyncValue<AiGenerationEntity?>>((ref) => const AsyncData(null));

// History provider
final aiHistoryProvider = FutureProvider.autoDispose<List<AiHistoryEntity>>((ref) async {
  final result = await ref.read(getGenerationHistoryUseCaseProvider).call();
  return result.when(
    success: (data) => data,
    failure: (error) => throw Exception(error.userMessage),
  );
});
