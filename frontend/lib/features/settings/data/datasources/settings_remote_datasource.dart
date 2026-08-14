import 'package:cinehubapp/core/network/api_client.dart';

class SettingsRemoteDataSource {
  const SettingsRemoteDataSource(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> getSettings() async {
    final response = await _client.get('auth/me');
    return response.data?['data']?['preferences'] as Map<String, dynamic>? ?? {};
  }

  Future<void> updateSettings(Map<String, dynamic> preferences) async {
    await _client.patch(
      '/users/profile',
      data: {'preferences': preferences},
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _client.post(
      '/auth/change-password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> deleteAccount() async {
    // Missing backend support
    throw UnimplementedError('Delete account endpoint does not exist yet');
  }
}
