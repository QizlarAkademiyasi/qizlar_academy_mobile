import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(this._repository) : super(const NotificationState()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationRetryRequested>(_onRetryRequested);
    on<NotificationMarkAllReadRequested>(_onMarkAllReadRequested);
    on<NotificationItemOpened>(_onNotificationItemOpened);
    on<NotificationTabSelected>(_onTabSelected);
  }

  final NotificationRepository _repository;

  Future<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(status: NotificationStatus.loading, clearMessage: true),
    );
    try {
      final sections = await _repository.fetchNotificationSections();
      emit(
        state.copyWith(status: NotificationStatus.success, sections: sections),
      );
    } catch (e, st) {
      AppLogger.e('NotificationBloc: load failed', error: e, stackTrace: st);
      emit(
        state.copyWith(status: NotificationStatus.failure, clearMessage: true),
      );
    }
  }

  Future<void> _onRetryRequested(
    NotificationRetryRequested event,
    Emitter<NotificationState> emit,
  ) async {
    add(const NotificationStarted());
  }

  Future<void> _onMarkAllReadRequested(
    NotificationMarkAllReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    if (!state.hasUnread) return;
    emit(
      state.copyWith(status: NotificationStatus.updating, clearMessage: true),
    );
    try {
      final sections = await _repository.markAllAsRead();
      emit(
        state.copyWith(status: NotificationStatus.success, sections: sections),
      );
    } catch (e, st) {
      AppLogger.e(
        'NotificationBloc: mark all read failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(status: NotificationStatus.failure, clearMessage: true),
      );
    }
  }

  void _onTabSelected(
    NotificationTabSelected event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  Future<void> _onNotificationItemOpened(
    NotificationItemOpened event,
    Emitter<NotificationState> emit,
  ) async {
    final selectedItem = _findNotification(event.notificationId);
    if (selectedItem == null || selectedItem.isRead) return;
    try {
      await _repository.markAsRead(notificationId: event.notificationId);
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          sections: _sectionsWithNotificationMarkedRead(
            state.sections,
            event.notificationId,
          ),
        ),
      );
    } catch (e, st) {
      AppLogger.e(
        'NotificationBloc: mark read failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(status: NotificationStatus.failure, clearMessage: true),
      );
    }
  }

  List<NotificationSectionModel> _sectionsWithNotificationMarkedRead(
    List<NotificationSectionModel> sections,
    String notificationId,
  ) {
    return sections
        .map(
          (section) => NotificationSectionModel(
            title: section.title,
            items: section.items
                .map(
                  (item) => item.id == notificationId
                      ? item.copyWith(isRead: true)
                      : item,
                )
                .toList(),
          ),
        )
        .toList(growable: false);
  }

  NotificationItemModel? _findNotification(String notificationId) {
    for (final section in state.sections) {
      for (final item in section.items) {
        if (item.id == notificationId) return item;
      }
    }
    return null;
  }
}
