import 'package:cinehubapp/core/network/api_client.dart';

class AdminRemoteDataSource {
  const AdminRemoteDataSource(this._client);
  
  // ignore: unused_field
  final ApiClient _client;

  Future<Map<String, dynamic>> getDashboardStats() async {
    throw UnimplementedError('Backend endpoint required: GET /api/v1/admin/dashboard/stats');
  }

  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20, String? search}) async {
    throw UnimplementedError('Backend endpoint required: GET /api/v1/admin/users');
  }

  Future<void> banUser(String userId) async {
    throw UnimplementedError('Backend endpoint required: POST /api/v1/admin/users/\$userId/ban');
  }

  Future<void> unbanUser(String userId) async {
    throw UnimplementedError('Backend endpoint required: POST /api/v1/admin/users/\$userId/unban');
  }

  Future<void> deleteUser(String userId) async {
    throw UnimplementedError('Backend endpoint required: DELETE /api/v1/admin/users/\$userId');
  }

  Future<Map<String, dynamic>> getProjects({int page = 1, int limit = 20, String? search}) async {
    throw UnimplementedError('Backend endpoint required: GET /api/v1/admin/projects');
  }

  Future<void> deleteProject(String projectId) async {
    throw UnimplementedError('Backend endpoint required: DELETE /api/v1/admin/projects/\$projectId');
  }

  Future<Map<String, dynamic>> getModerationQueue({int page = 1, int limit = 20}) async {
    throw UnimplementedError('Backend endpoint required: GET /api/v1/admin/moderation');
  }

  Future<void> approveContent(String id, String type) async {
    throw UnimplementedError('Backend endpoint required: POST /api/v1/admin/moderation/\$id/approve');
  }

  Future<void> rejectContent(String id, String type, String reason) async {
    throw UnimplementedError('Backend endpoint required: POST /api/v1/admin/moderation/\$id/reject');
  }

  Future<Map<String, dynamic>> getReports({int page = 1, int limit = 20}) async {
    throw UnimplementedError('Backend endpoint required: GET /api/v1/admin/reports');
  }

  Future<void> resolveReport(String reportId) async {
    throw UnimplementedError('Backend endpoint required: POST /api/v1/admin/reports/\$reportId/resolve');
  }

  Future<void> ignoreReport(String reportId) async {
    throw UnimplementedError('Backend endpoint required: POST /api/v1/admin/reports/\$reportId/ignore');
  }
}
