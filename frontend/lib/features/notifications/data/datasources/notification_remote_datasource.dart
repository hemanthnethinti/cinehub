import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/notifications/data/models/notification_dto.dart';

class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<NotificationDto>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (type != null) queryParams['type'] = type;
    if (isRead != null) queryParams['isRead'] = isRead;

    final response = await _client.get('notifications', queryParameters: queryParams);
    
    // Backend uses ApiResponse.paginated → { success, data: [...], meta: { pagination } }
    if (response.data == null) return [];
    final dataField = response.data['data'];
    if (dataField == null) return [];
    
    return (dataField as List)
        .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _client.get('notifications/unread-count');
    return response.data?['data']?['unreadCount'] ?? 0;
  }

  Future<void> markAsRead(String id) async {
    await _client.patch('notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _client.patch('notifications/read-all');
  }

  Future<void> deleteNotification(String id) async {
    await _client.delete('notifications/$id');
  }
}
