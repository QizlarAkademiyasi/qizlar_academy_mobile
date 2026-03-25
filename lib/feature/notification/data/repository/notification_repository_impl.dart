import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationApiDatasource apiDatasource,
    required AuthSessionCubit authSessionCubit,
  }) : _apiDatasource = apiDatasource,
       _authSessionCubit = authSessionCubit;

  final NotificationApiDatasource _apiDatasource;
  final AuthSessionCubit _authSessionCubit;

  void _ensureRegistered() {
    if (_authSessionCubit.state.isAnonymous) {
      throw StateError('Notifications are available only for registered users.');
    }
  }

  @override
  Future<List<NotificationSectionModel>> fetchNotificationSections() {
    _ensureRegistered();
    return _apiDatasource.fetchNotificationSections();
  }

  @override
  Future<List<NotificationSectionModel>> markAllAsRead() {
    _ensureRegistered();
    return _apiDatasource.markAllAsRead();
  }

  @override
  Future<List<NotificationSectionModel>> markAsRead({
    required String notificationId,
  }) {
    _ensureRegistered();
    return _apiDatasource.markAsRead(notificationId: notificationId);
  }
}
