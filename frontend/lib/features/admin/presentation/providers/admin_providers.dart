import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:cinehubapp/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:cinehubapp/features/admin/domain/entities/admin_entities.dart';
import 'package:cinehubapp/features/admin/domain/repositories/admin_repository.dart';

final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  return AdminRemoteDataSource(ref.watch(apiClientProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(adminRemoteDataSourceProvider));
});

final dashboardStatsProvider = FutureProvider<DashboardStatsEntity>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getDashboardStats();
  return result.when(
    success: (stats) => stats,
    failure: (error) => throw error,
  );
});

final adminUsersProvider = FutureProvider.family<List<AdminUserEntity>, String>((ref, search) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getUsers(search: search.isEmpty ? null : search);
  return result.when(
    success: (users) => users,
    failure: (error) => throw error,
  );
});

final adminProjectsProvider = FutureProvider.family<List<AdminProjectEntity>, String>((ref, search) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getProjects(search: search.isEmpty ? null : search);
  return result.when(
    success: (projects) => projects,
    failure: (error) => throw error,
  );
});

final adminModerationProvider = FutureProvider<List<ModerationItemEntity>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getModerationQueue();
  return result.when(
    success: (items) => items,
    failure: (error) => throw error,
  );
});

final adminReportsProvider = FutureProvider<List<ReportEntity>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  final result = await repo.getReports();
  return result.when(
    success: (reports) => reports,
    failure: (error) => throw error,
  );
});
