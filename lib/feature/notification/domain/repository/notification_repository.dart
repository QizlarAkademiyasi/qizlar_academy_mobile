import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';

abstract interface class NotificationRepository {
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  });

  Future<void> markAllAsRead();
  Future<void> markAsRead({required String notificationId});

  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    int pageSize = 10,
  });

  Future<bool> toggleTopic({required String topicId});

  Future<void> subscribePushToken(String token);
  Future<void> unsubscribePushToken(String token);
}
