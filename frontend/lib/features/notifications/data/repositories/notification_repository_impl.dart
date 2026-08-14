import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';
import 'package:cinehubapp/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remote);
  final NotificationRemoteDataSource _remote;

  @override
  Future<Result<List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) async {
    try {
      final dtos = await _remote.getNotifications(
        page: page,
        limit: limit,
        type: type,
        isRead: isRead,
      );
      return Result.success(dtos.map((e) => e.toDomain()).toList());
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    try {
      final count = await _remote.getUnreadCount();
      return Result.success(count);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String id) async {
    try {
      await _remote.markAsRead(id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      await _remote.markAllAsRead();
      return Result.success(null);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteNotification(String id) async {
    try {
      await _remote.deleteNotification(id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
