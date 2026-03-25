part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

final class NotificationStarted extends NotificationEvent {
  const NotificationStarted();
}

final class NotificationRetryRequested extends NotificationEvent {
  const NotificationRetryRequested();
}

final class NotificationMarkAllReadRequested extends NotificationEvent {
  const NotificationMarkAllReadRequested();
}

final class NotificationItemOpened extends NotificationEvent {
  const NotificationItemOpened({required this.notificationId});

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}
