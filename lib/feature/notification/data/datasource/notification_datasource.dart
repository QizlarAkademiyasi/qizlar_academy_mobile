import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';

abstract interface class NotificationDatasource {
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    required int pageSize,
  });

  Future<void> markAllAsRead();
  Future<void> markAsRead({required String notificationId});

  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    required int pageSize,
  });

  Future<bool> toggleTopic({required String topicId});
}
