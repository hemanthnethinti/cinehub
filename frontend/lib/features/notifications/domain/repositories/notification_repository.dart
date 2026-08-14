import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';

abstract interface class NotificationRepository {
  Future<Result<List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  });

  Future<Result<int>> getUnreadCount();

  Future<Result<void>> markAsRead(String id);

  Future<Result<void>> markAllAsRead();

  Future<Result<void>> deleteNotification(String id);
}
