part of 'notification_settings_bloc.dart';

enum NotificationSettingsStatus { initial, loading, success, failure }

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.initial,
    this.masterEnabled = false,
    this.topics = const [],
    this.pageNumber = 0,
    this.pageCount = 1,
    this.pageSize = 10,
    this.isLoadingMore = false,
    this.isUpdatingMaster = false,
    this.updateFailureVersion = 0,
  });

  final NotificationSettingsStatus status;
  final bool masterEnabled;
  final List<NotificationTopicModel> topics;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool isLoadingMore;
  final bool isUpdatingMaster;
  final int updateFailureVersion;

  bool get hasMore => pageNumber < pageCount;
  bool get isInitialLoading =>
      status == NotificationSettingsStatus.loading && topics.isEmpty;

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    bool? masterEnabled,
    List<NotificationTopicModel>? topics,
    int? pageNumber,
    int? pageCount,
    int? pageSize,
    bool? isLoadingMore,
    bool? isUpdatingMaster,
    int? updateFailureVersion,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      masterEnabled: masterEnabled ?? this.masterEnabled,
      topics: topics ?? this.topics,
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      pageSize: pageSize ?? this.pageSize,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isUpdatingMaster: isUpdatingMaster ?? this.isUpdatingMaster,
      updateFailureVersion:
          updateFailureVersion ?? this.updateFailureVersion,
    );
  }

  @override
  List<Object?> get props => [
    status,
    masterEnabled,
    topics,
    pageNumber,
    pageCount,
    pageSize,
    isLoadingMore,
    isUpdatingMaster,
    updateFailureVersion,
  ];
}
