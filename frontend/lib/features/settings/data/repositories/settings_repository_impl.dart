import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:cinehubapp/features/settings/domain/entities/settings_entity.dart';
import 'package:cinehubapp/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._remote);
  final SettingsRemoteDataSource _remote;

  @override
  Future<Result<SettingsEntity>> getSettings() async {
    try {
      final data = await _remote.getSettings();
      final entity = SettingsEntity(
        emailNotifications: data['emailNotifications'] as bool? ?? true,
        pushNotifications: data['pushNotifications'] as bool? ?? true,
        marketingNotifications: true, // Mock default
        mentionNotifications: true, // Mock default
        messageNotifications: true, // Mock default
        projectInviteNotifications: true, // Mock default
        profileVisibility: data['profileVisibility'] as String? ?? 'public',
        showEmail: false, // Mock default
        showPhone: false, // Mock default
        discoverability: true, // Mock default
      );
      return Result.success(entity);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateSettings(SettingsEntity settings) async {
    try {
      // Only send what backend supports
      final preferences = {
        'emailNotifications': settings.emailNotifications,
        'pushNotifications': settings.pushNotifications,
        'profileVisibility': settings.profileVisibility,
      };
      await _remote.updateSettings(preferences);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> changePassword(String currentPassword, String newPassword) async {
    try {
      await _remote.changePassword(currentPassword, newPassword);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _remote.deleteAccount();
      return Result.success(null);
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
