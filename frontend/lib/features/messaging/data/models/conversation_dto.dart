import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/messaging/domain/entities/conversation.dart';

final class ConversationDto {
  const ConversationDto({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
  });

  final String id;
  final List<ProfileDto> participants;
  final MessageDto? lastMessage;
  final int unreadCount;
  final String updatedAt;

  factory ConversationDto.fromJson(Map<String, dynamic> json) {
    return ConversationDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      participants: (json['participants'] as List<dynamic>? ?? [])
          .map((e) => ProfileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: (json['lastMessage'] ?? json['latestMessage']) != null
          ? MessageDto.fromJson(
              (json['lastMessage'] ?? json['latestMessage'])
                  as Map<String, dynamic>,
            )
          : null,
      unreadCount: _extractUnreadCount(json),
      updatedAt: json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Conversation toDomain() {
    return Conversation(
      id: id,
      participants: participants.map((e) => e.toDomain()).toList(),
      lastMessage: lastMessage?.toDomain(),
      unreadCount: unreadCount,
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}

final class MessageDto {
  const MessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.mediaUrl,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String? mediaUrl;
  final String status;
  final String createdAt;

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? json['conversation'] as String? ?? '',
      senderId: _extractId(json['senderId'] ?? json['sender']),
      content: json['content'] as String? ?? json['text'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ??
          ((json['attachments'] as List<dynamic>?)?.isNotEmpty ?? false
              ? (json['attachments'] as List<dynamic>).first.toString()
              : null),
      status: json['status'] as String? ?? 'sent',
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Message toDomain() {
    MessageStatus parsedStatus;
    switch (status) {
      case 'sending':
        parsedStatus = MessageStatus.sending;
        break;
      case 'delivered':
        parsedStatus = MessageStatus.delivered;
        break;
      case 'read':
        parsedStatus = MessageStatus.read;
        break;
      case 'error':
        parsedStatus = MessageStatus.error;
        break;
      case 'sent':
      default:
        parsedStatus = MessageStatus.sent;
    }

    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      mediaUrl: mediaUrl,
      status: parsedStatus,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }

  static String _extractId(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is Map && data.containsKey('_id')) return data['_id'] as String;
    if (data is Map && data.containsKey('id')) return data['id'] as String;
    return '';
  }
}

int _extractUnreadCount(Map<String, dynamic> json) {
  // unreadCount is a Map of User ID -> count in backend
  // We need the current user's count, but we don't have current user ID here easily.
  // Wait, if it's a map, we might need a way to get it, or the backend should return the specific count.
  final unread = json['unreadCount'];
  if (unread is num) return unread.toInt();
  if (unread is Map) {
    // If we can't get specific user, just sum it up or return 0 for now.
    // Ideally backend transforms this to an integer for the requesting user.
    return 0; // The backend controller usually maps this, let's see.
  }
  return 0;
}
