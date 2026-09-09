import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationDatasource datasource,
    required AuthSessionCubit authSessionCubit,
  }) : _datasource = datasource,
       _authSessionCubit = authSessionCubit;

  final NotificationDatasource _datasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('Notifications are available only for registered users.');
    }
  }

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) {
    _ensureRegistered();
    return _datasource.fetchPage(
      type: type,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<void> markAllAsRead() {
    _ensureRegistered();
    return _datasource.markAllAsRead();
  }

  @override
  Future<void> markAsRead({required String notificationId}) {
    _ensureRegistered();
    return _datasource.markAsRead(notificationId: notificationId);
  }

  @override
  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    int pageSize = 10,
  }) {
    _ensureRegistered();
    return _datasource.fetchTopicsPage(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<bool> toggleTopic({required String topicId}) {
    _ensureRegistered();
    return _datasource.toggleTopic(topicId: topicId);
  }
}
