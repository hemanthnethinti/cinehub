import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:cinehubapp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:cinehubapp/features/settings/domain/entities/settings_entity.dart';
import 'package:cinehubapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:cinehubapp/features/settings/domain/usecases/settings_usecases.dart';

// ── Data & Domain ────────────────────────────────────────────────────────────

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  return SettingsRemoteDataSource(ref.watch(apiClientProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider));
});

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  return GetSettingsUseCase(ref.watch(settingsRepositoryProvider));
});

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>((ref) {
  return UpdateSettingsUseCase(ref.watch(settingsRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(settingsRepositoryProvider));
});

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  return DeleteAccountUseCase(ref.watch(settingsRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

final settingsProvider = AsyncNotifierProvider.autoDispose<SettingsNotifier, SettingsEntity>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AutoDisposeAsyncNotifier<SettingsEntity> {
  @override
  Future<SettingsEntity> build() async {
    final result = await ref.read(getSettingsUseCaseProvider).call();
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  Future<void> updateSettings(SettingsEntity newSettings) async {
    final oldState = state.valueOrNull;
    if (oldState == null) return;

    // Optimistic update
    state = AsyncData(newSettings);

    final result = await ref.read(updateSettingsUseCaseProvider).call(newSettings);
    result.when(
      success: (_) {},
      failure: (e) {
        // Revert on failure
        state = AsyncData(oldState);
        throw Exception(e.userMessage);
      },
    );
  }
}
