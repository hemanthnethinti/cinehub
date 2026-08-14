import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';
import 'package:cinehubapp/features/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  const GetNotificationsUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<List<NotificationEntity>>> call({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) {
    return _repository.getNotifications(
      page: page,
      limit: limit,
      type: type,
      isRead: isRead,
    );
  }
}

class GetUnreadCountUseCase {
  const GetUnreadCountUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<int>> call() => _repository.getUnreadCount();
}

class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<void>> call(String id) => _repository.markAsRead(id);
}

class MarkAllReadUseCase {
  const MarkAllReadUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<void>> call() => _repository.markAllAsRead();
}

class DeleteNotificationUseCase {
  const DeleteNotificationUseCase(this._repository);
  final NotificationRepository _repository;

  Future<Result<void>> call(String id) => _repository.deleteNotification(id);
}
