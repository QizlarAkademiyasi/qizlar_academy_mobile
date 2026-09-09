import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/repository/profile_repository.dart';

part 'notification_settings_event.dart';
part 'notification_settings_state.dart';

class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  NotificationSettingsBloc({
    required NotificationRepository notificationRepository,
    required ProfileRepository profileRepository,
    required Future<String?> Function() ensurePushToken,
  }) : _notificationRepository = notificationRepository,
       _profileRepository = profileRepository,
       _ensurePushToken = ensurePushToken,
       super(const NotificationSettingsState()) {
    on<NotificationSettingsStarted>(_onStarted);
    on<NotificationSettingsRetryRequested>(_onRetryRequested);
    on<NotificationSettingsLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationSettingsMasterToggled>(_onMasterToggled);
    on<NotificationSettingsTopicToggled>(_onTopicToggled);
  }

  static const int _pageSize = 10;
  final NotificationRepository _notificationRepository;
  final ProfileRepository _profileRepository;
  final Future<String?> Function() _ensurePushToken;

  Future<void> _onStarted(
    NotificationSettingsStarted event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationSettingsStatus.loading,
        masterEnabled: event.masterEnabled ?? state.masterEnabled,
      ),
    );
    try {
      var masterEnabled = event.masterEnabled;
      if (masterEnabled == null) {
        final overview = await _profileRepository.getProfileOverview();
        masterEnabled = overview.notificationsEnabled;
      }
      final page = await _notificationRepository.fetchTopicsPage(
        pageNumber: 1,
        pageSize: _pageSize,
      );
      emit(
        state.copyWith(
          status: NotificationSettingsStatus.success,
          masterEnabled: masterEnabled,
          topics: page.items,
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationSettingsBloc: load failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(status: NotificationSettingsStatus.failure));
    }
  }

  Future<void> _onRetryRequested(
    NotificationSettingsRetryRequested event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    add(NotificationSettingsStarted(masterEnabled: state.masterEnabled));
  }

  Future<void> _onLoadMoreRequested(
    NotificationSettingsLoadMoreRequested event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final page = await _notificationRepository.fetchTopicsPage(
        pageNumber: state.pageNumber + 1,
        pageSize: state.pageSize,
      );
      final byId = <String, NotificationTopicModel>{
        for (final item in state.topics) item.id: item,
        for (final item in page.items) item.id: item,
      };
      emit(
        state.copyWith(
          topics: byId.values.toList(growable: false),
          pageNumber: page.pagination.pageNumber,
          pageCount: page.pagination.pageCount,
          pageSize: page.pagination.pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationSettingsBloc: load more failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoadingMore: false,
          updateFailureVersion: state.updateFailureVersion + 1,
        ),
      );
    }
  }

  Future<void> _onMasterToggled(
    NotificationSettingsMasterToggled event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (state.masterEnabled == event.enabled || state.isUpdatingMaster) {
      return;
    }
    if (event.enabled) {
      final token = await _ensurePushToken();
      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(updateFailureVersion: state.updateFailureVersion + 1),
        );
        return;
      }
    }
    final previous = state.masterEnabled;
    emit(state.copyWith(masterEnabled: event.enabled, isUpdatingMaster: true));
    try {
      final updated = await _profileRepository.updateNotifications(
        enabled: event.enabled,
      );
      emit(
        state.copyWith(
          masterEnabled: updated.notificationsEnabled,
          isUpdatingMaster: false,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationSettingsBloc: master toggle failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          masterEnabled: previous,
          isUpdatingMaster: false,
          updateFailureVersion: state.updateFailureVersion + 1,
        ),
      );
    }
  }

  Future<void> _onTopicToggled(
    NotificationSettingsTopicToggled event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (!state.masterEnabled) return;
    NotificationTopicModel? current;
    for (final topic in state.topics) {
      if (topic.id == event.topicId) {
        current = topic;
        break;
      }
    }
    if (current == null) return;
    final previous = current.isSubscribed;
    emit(
      state.copyWith(
        topics: [
          for (final topic in state.topics)
            if (topic.id == event.topicId)
              topic.copyWith(isSubscribed: event.enabled)
            else
              topic,
        ],
      ),
    );
    try {
      final next = await _notificationRepository.toggleTopic(
        topicId: event.topicId,
      );
      emit(
        state.copyWith(
          topics: [
            for (final topic in state.topics)
              if (topic.id == event.topicId)
                topic.copyWith(isSubscribed: next)
              else
                topic,
          ],
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'NotificationSettingsBloc: topic toggle failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          topics: [
            for (final topic in state.topics)
              if (topic.id == event.topicId)
                topic.copyWith(isSubscribed: previous)
              else
                topic,
          ],
          updateFailureVersion: state.updateFailureVersion + 1,
        ),
      );
    }
  }
}
