import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/settings/domain/entities/settings_entity.dart';

abstract interface class SettingsRepository {
  Future<Result<SettingsEntity>> getSettings();

  Future<Result<void>> updateSettings(SettingsEntity settings);

  Future<Result<void>> changePassword(String currentPassword, String newPassword);

  Future<Result<void>> deleteAccount();
}
