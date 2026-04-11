import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';

abstract interface class NotificationDatasource {
  Future<List<NotificationSectionModel>> fetchNotificationSections();

  Future<List<NotificationSectionModel>> markAllAsRead();

  Future<void> markAsRead({required String notificationId});
}
