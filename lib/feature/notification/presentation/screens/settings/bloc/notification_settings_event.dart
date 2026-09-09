part of 'notification_settings_bloc.dart';

sealed class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object?> get props => [];
}

final class NotificationSettingsStarted extends NotificationSettingsEvent {
  const NotificationSettingsStarted({this.masterEnabled});

  final bool? masterEnabled;

  @override
  List<Object?> get props => [masterEnabled];
}

final class NotificationSettingsRetryRequested
    extends NotificationSettingsEvent {
  const NotificationSettingsRetryRequested();
}

final class NotificationSettingsLoadMoreRequested
    extends NotificationSettingsEvent {
  const NotificationSettingsLoadMoreRequested();
}

final class NotificationSettingsMasterToggled
    extends NotificationSettingsEvent {
  const NotificationSettingsMasterToggled({required this.enabled});

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class NotificationSettingsTopicToggled extends NotificationSettingsEvent {
  const NotificationSettingsTopicToggled({
    required this.topicId,
    required this.enabled,
  });

  final String topicId;
  final bool enabled;

  @override
  List<Object?> get props => [topicId, enabled];
}
