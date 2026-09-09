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
    on<NotificationLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationMarkAllReadRequested>(_onMarkAllReadRequested);
    on<NotificationItemOpened>(_onNotificationItemOpened);
    on<NotificationTabSelected>(_onTabSelected);
  }

  static const int _pageSize = 10;
  final NotificationRepository _repository;

  Future<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) => _loadFirstPage(NotificationListTab.platform, emit);

  Future<void> _onRetryRequested(
    NotificationRetryRequested event,
    Emitter<NotificationState> emit,
  ) => _loadFirstPage(event.tab ?? state.selectedTab, emit);

  Future<void> _loadFirstPage(
    NotificationListTab tab,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.withTabData(tab, state.dataFor(tab).copyWith(status: NotificationTabStatus.loading)));
    try {
      final page = await _repository.fetchPage(
        type: tab.channelType,
        pageNumber: 1,
        pageSize: _pageSize,
      );
      emit(
        state.withTabData(
          tab,
          NotificationTabData(
            status: NotificationTabStatus.success,
            items: page.items,
            pageNumber: page.pagination.pageNumber,
            pageCount: page.pagination.pageCount,
            pageSize: page.pagination.pageSize,
          ),
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationBloc: first page failed (${tab.name})',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.withTabData(
          tab,
          state.dataFor(tab).copyWith(status: NotificationTabStatus.failure),
        ),
      );
    }
  }

  Future<void> _onLoadMoreRequested(
    NotificationLoadMoreRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final current = state.dataFor(event.tab);
    if (!current.hasMore || current.isLoadingMore) return;
    emit(state.withTabData(event.tab, current.copyWith(isLoadingMore: true)));
    try {
      final page = await _repository.fetchPage(
        type: event.tab.channelType,
        pageNumber: current.pageNumber + 1,
        pageSize: current.pageSize,
      );
      final byId = <String, NotificationItemModel>{
        for (final item in current.items) item.id: item,
        for (final item in page.items) item.id: item,
      };
      final items = byId.values.toList(growable: false)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        state.withTabData(
          event.tab,
          current.copyWith(
            status: NotificationTabStatus.success,
            items: items,
            pageNumber: page.pagination.pageNumber,
            pageCount: page.pagination.pageCount,
            pageSize: page.pagination.pageSize,
            isLoadingMore: false,
          ),
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationBloc: load more failed (${event.tab.name})',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state
            .withTabData(event.tab, current.copyWith(isLoadingMore: false))
            .copyWith(loadMoreFailureVersion: state.loadMoreFailureVersion + 1),
      );
    }
  }

  Future<void> _onMarkAllReadRequested(
    NotificationMarkAllReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    if (!state.hasUnread || state.isMarkingAllRead) return;
    emit(state.copyWith(isMarkingAllRead: true));
    try {
      await _repository.markAllAsRead();
      emit(
        state.copyWith(
          isMarkingAllRead: false,
          platform: state.platform.markAllRead(),
          community: state.community.markAllRead(),
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationBloc: mark all read failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isMarkingAllRead: false,
          actionFailureVersion: state.actionFailureVersion + 1,
        ),
      );
    }
  }

  Future<void> _onNotificationItemOpened(
    NotificationItemOpened event,
    Emitter<NotificationState> emit,
  ) async {
    final item = state.findItem(event.notificationId);
    if (item == null || item.isRead) return;
    try {
      await _repository.markAsRead(notificationId: event.notificationId);
      emit(state.markItemRead(event.notificationId));
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationBloc: mark read failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(actionFailureVersion: state.actionFailureVersion + 1));
    }
  }

  Future<void> _onTabSelected(
    NotificationTabSelected event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(selectedTab: event.tab));
    if (state.dataFor(event.tab).status == NotificationTabStatus.initial) {
      await _loadFirstPage(event.tab, emit);
    }
  }
}
