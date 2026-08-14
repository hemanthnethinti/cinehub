import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:cinehubapp/features/admin/domain/entities/admin_entities.dart';
import 'package:cinehubapp/features/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl(this._remote);
  final AdminRemoteDataSource _remote;

  @override
  Future<Result<DashboardStatsEntity>> getDashboardStats() async {
    try {
      await _remote.getDashboardStats();
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<AdminUserEntity>>> getUsers({int page = 1, int limit = 20, String? search}) async {
    try {
      await _remote.getUsers(page: page, limit: limit, search: search);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> banUser(String userId) async {
    try {
      await _remote.banUser(userId);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> unbanUser(String userId) async {
    try {
      await _remote.unbanUser(userId);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteUser(String userId) async {
    try {
      await _remote.deleteUser(userId);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<AdminProjectEntity>>> getProjects({int page = 1, int limit = 20, String? search}) async {
    try {
      await _remote.getProjects(page: page, limit: limit, search: search);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteProject(String projectId) async {
    try {
      await _remote.deleteProject(projectId);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<ModerationItemEntity>>> getModerationQueue({int page = 1, int limit = 20}) async {
    try {
      await _remote.getModerationQueue(page: page, limit: limit);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> approveContent(String id, String type) async {
    try {
      await _remote.approveContent(id, type);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> rejectContent(String id, String type, String reason) async {
    try {
      await _remote.rejectContent(id, type, reason);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<ReportEntity>>> getReports({int page = 1, int limit = 20}) async {
    try {
      await _remote.getReports(page: page, limit: limit);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resolveReport(String reportId) async {
    try {
      await _remote.resolveReport(reportId);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> ignoreReport(String reportId) async {
    try {
      await _remote.ignoreReport(reportId);
      throw Exception('Should not reach here');
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
