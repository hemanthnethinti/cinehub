import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/admin/domain/entities/admin_entities.dart';

abstract interface class AdminRepository {
  Future<Result<DashboardStatsEntity>> getDashboardStats();
  
  Future<Result<List<AdminUserEntity>>> getUsers({int page = 1, int limit = 20, String? search});
  Future<Result<void>> banUser(String userId);
  Future<Result<void>> unbanUser(String userId);
  Future<Result<void>> deleteUser(String userId);

  Future<Result<List<AdminProjectEntity>>> getProjects({int page = 1, int limit = 20, String? search});
  Future<Result<void>> deleteProject(String projectId);

  Future<Result<List<ModerationItemEntity>>> getModerationQueue({int page = 1, int limit = 20});
  Future<Result<void>> approveContent(String id, String type);
  Future<Result<void>> rejectContent(String id, String type, String reason);

  Future<Result<List<ReportEntity>>> getReports({int page = 1, int limit = 20});
  Future<Result<void>> resolveReport(String reportId);
  Future<Result<void>> ignoreReport(String reportId);
}
