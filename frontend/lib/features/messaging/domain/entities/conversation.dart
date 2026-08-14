import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

class Conversation {
  const Conversation({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
  });

  final String id;
  final List<Profile> participants;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
}

class Message {
  const Message({
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
  final MessageStatus status;
  final DateTime createdAt;
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  error,
}
