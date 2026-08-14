import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/settings/domain/entities/settings_entity.dart';
import 'package:cinehubapp/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  Future<Result<SettingsEntity>> call() => _repository.getSettings();
}

class UpdateSettingsUseCase {
  const UpdateSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  Future<Result<void>> call(SettingsEntity settings) => _repository.updateSettings(settings);
}

class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repository);
  final SettingsRepository _repository;

  Future<Result<void>> call(String currentPassword, String newPassword) {
    return _repository.changePassword(currentPassword, newPassword);
  }
}

class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);
  final SettingsRepository _repository;

  Future<Result<void>> call() => _repository.deleteAccount();
}
