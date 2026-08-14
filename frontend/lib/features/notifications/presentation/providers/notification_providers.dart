import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:cinehubapp/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';
import 'package:cinehubapp/features/notifications/domain/repositories/notification_repository.dart';
import 'package:cinehubapp/features/notifications/domain/usecases/notification_usecases.dart';

// ── Data & Domain ────────────────────────────────────────────────────────────

final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSource(ref.watch(apiClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationRemoteDataSourceProvider));
});

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(ref.watch(notificationRepositoryProvider));
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  return GetUnreadCountUseCase(ref.watch(notificationRepositoryProvider));
});

final markNotificationReadUseCaseProvider = Provider<MarkNotificationReadUseCase>((ref) {
  return MarkNotificationReadUseCase(ref.watch(notificationRepositoryProvider));
});

final markAllReadUseCaseProvider = Provider<MarkAllReadUseCase>((ref) {
  return MarkAllReadUseCase(ref.watch(notificationRepositoryProvider));
});

final deleteNotificationUseCaseProvider = Provider<DeleteNotificationUseCase>((ref) {
  return DeleteNotificationUseCase(ref.watch(notificationRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

enum NotificationFilter { all, unread, mentions, projects, messages, teamInvites }

final notificationFilterProvider = StateProvider<NotificationFilter>((ref) => NotificationFilter.all);

final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final result = await ref.watch(getUnreadCountUseCaseProvider).call();
  return result.when(
    success: (count) => count,
    failure: (_) => 0,
  );
});

final notificationsProvider = AsyncNotifierProvider.autoDispose<NotificationsNotifier, List<NotificationEntity>>(
  NotificationsNotifier.new,
);

class NotificationsNotifier extends AutoDisposeAsyncNotifier<List<NotificationEntity>> {
  @override
  Future<List<NotificationEntity>> build() async {
    return _fetchNotifications();
  }

  Future<List<NotificationEntity>> _fetchNotifications() async {
    final filter = ref.watch(notificationFilterProvider);
    String? typeParam;
    bool? isReadParam;

    switch (filter) {
      case NotificationFilter.unread:
        isReadParam = false;
        break;
      case NotificationFilter.mentions:
        typeParam = 'mention';
        break;
      case NotificationFilter.projects:
        typeParam = 'project';
        break;
      case NotificationFilter.messages:
        typeParam = 'message';
        break;
      case NotificationFilter.teamInvites:
        typeParam = 'team_invite';
        break;
      case NotificationFilter.all:
        break;
    }

    final result = await ref.read(getNotificationsUseCaseProvider).call(
      type: typeParam,
      isRead: isReadParam,
    );

    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final data = await _fetchNotifications();
      state = AsyncData(data);
      ref.invalidate(unreadCountProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> markAsRead(String id) async {
    final oldState = state.valueOrNull;
    if (oldState == null) return;

    // Optimistic UI
    state = AsyncData(oldState.map((n) {
      if (n.id == id) {
        return NotificationEntity(
          id: n.id,
          sender: n.sender,
          type: n.type,
          priority: n.priority,
          title: n.title,
          message: n.message,
          actionUrl: n.actionUrl,
          isRead: true,
          createdAt: n.createdAt,
        );
      }
      return n;
    }).toList());

    await ref.read(markNotificationReadUseCaseProvider).call(id);
    ref.invalidate(unreadCountProvider);
  }

  Future<void> markAllAsRead() async {
    final oldState = state.valueOrNull;
    if (oldState == null) return;

    // Optimistic UI
    state = AsyncData(oldState.map((n) {
      return NotificationEntity(
        id: n.id,
        sender: n.sender,
        type: n.type,
        priority: n.priority,
        title: n.title,
        message: n.message,
        actionUrl: n.actionUrl,
        isRead: true,
        createdAt: n.createdAt,
      );
    }).toList());

    await ref.read(markAllReadUseCaseProvider).call();
    ref.invalidate(unreadCountProvider);
  }

  Future<void> deleteNotification(String id) async {
    final oldState = state.valueOrNull;
    if (oldState == null) return;

    // Optimistic UI
    state = AsyncData(oldState.where((n) => n.id != id).toList());

    await ref.read(deleteNotificationUseCaseProvider).call(id);
    ref.invalidate(unreadCountProvider);
  }
}
