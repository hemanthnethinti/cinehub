import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

class NotificationEntity {
  const NotificationEntity({
    required this.id,
    this.sender,
    required this.type,
    required this.priority,
    required this.title,
    required this.message,
    this.actionUrl,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final Profile? sender;
  final NotificationType type;
  final String priority;
  final String title;
  final String message;
  final String? actionUrl;
  final bool isRead;
  final DateTime createdAt;
}

enum NotificationType {
  system,
  mention,
  project,
  message,
  teamInvite,
  unknown
}
