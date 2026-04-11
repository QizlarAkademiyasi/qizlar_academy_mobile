part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, updating, success, failure }

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.initial,
    this.sections = const [],
    this.message,
    this.selectedTab = NotificationListTab.community,
  });

  final NotificationStatus status;
  final List<NotificationSectionModel> sections;
  final String? message;
  final NotificationListTab selectedTab;

  bool get hasUnread =>
      sections.any((section) => section.items.any((item) => !item.isRead));

  List<NotificationSectionModel> visibleSectionsForTab(
    NotificationListTab tab,
  ) {
    final channel = tab == NotificationListTab.platform
        ? NotificationChannelType.push
        : NotificationChannelType.global;
    return sections
        .map(
          (s) => NotificationSectionModel(
            title: s.title,
            items: s.items.where((i) => i.channelType == channel).toList(),
          ),
        )
        .where((s) => s.items.isNotEmpty)
        .toList(growable: false);
  }

  List<NotificationSectionModel> get visibleSections =>
      visibleSectionsForTab(selectedTab);

  bool get hasItemsInSelectedTab => visibleSections.isNotEmpty;

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationSectionModel>? sections,
    String? message,
    NotificationListTab? selectedTab,
    bool clearMessage = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      message: clearMessage ? null : (message ?? this.message),
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [status, sections, message, selectedTab];
}
