part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, updating, success, failure }

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.initial,
    this.sections = const [],
    this.message,
  });

  final NotificationStatus status;
  final List<NotificationSectionModel> sections;
  final String? message;

  bool get hasUnread =>
      sections.any((section) => section.items.any((item) => !item.isRead));

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationSectionModel>? sections,
    String? message,
    bool clearMessage = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, sections, message];
}
