import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';

final class NotificationDto {
  const NotificationDto({
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
  final ProfileDto? sender;
  final String type;
  final String priority;
  final String title;
  final String message;
  final String? actionUrl;
  final bool isRead;
  final String createdAt;

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      sender: json['sender'] != null && json['sender'] is Map<String, dynamic>
          ? ProfileDto.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      type: json['type'] as String? ?? 'system',
      priority: json['priority'] as String? ?? 'medium',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      actionUrl: json['actionUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  NotificationEntity toDomain() {
    NotificationType parsedType;
    switch (type.toLowerCase()) {
      case 'mention':
        parsedType = NotificationType.mention;
        break;
      case 'project':
        parsedType = NotificationType.project;
        break;
      case 'message':
        parsedType = NotificationType.message;
        break;
      case 'team_invite':
        parsedType = NotificationType.teamInvite;
        break;
      case 'system':
      default:
        parsedType = NotificationType.system;
        break;
    }

    return NotificationEntity(
      id: id,
      sender: sender?.toDomain(),
      type: parsedType,
      priority: priority,
      title: title,
      message: message,
      actionUrl: actionUrl,
      isRead: isRead,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}
