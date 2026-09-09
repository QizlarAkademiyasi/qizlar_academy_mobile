part of 'notification_bloc.dart';

enum NotificationTabStatus { initial, loading, success, failure }

class NotificationTabData extends Equatable {
  const NotificationTabData({
    this.status = NotificationTabStatus.initial,
    this.items = const [],
    this.pageNumber = 0,
    this.pageCount = 1,
    this.pageSize = 10,
    this.isLoadingMore = false,
  });

  final NotificationTabStatus status;
  final List<NotificationItemModel> items;
  final int pageNumber;
  final int pageCount;
  final int pageSize;
  final bool isLoadingMore;

  bool get hasMore => pageNumber < pageCount;
  bool get isInitialLoading => status == NotificationTabStatus.loading && items.isEmpty;

  NotificationTabData copyWith({
    NotificationTabStatus? status,
    List<NotificationItemModel>? items,
    int? pageNumber,
    int? pageCount,
    int? pageSize,
    bool? isLoadingMore,
  }) {
    return NotificationTabData(
      status: status ?? this.status,
      items: items ?? this.items,
      pageNumber: pageNumber ?? this.pageNumber,
      pageCount: pageCount ?? this.pageCount,
      pageSize: pageSize ?? this.pageSize,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  NotificationTabData markAllRead() => copyWith(
    items: items.map((item) => item.copyWith(isRead: true)).toList(growable: false),
  );

  NotificationTabData markItemRead(String id) => copyWith(
    items: items
        .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
        .toList(growable: false),
  );

  @override
  List<Object?> get props => [status, items, pageNumber, pageCount, pageSize, isLoadingMore];
}

class NotificationState extends Equatable {
  const NotificationState({
    this.platform = const NotificationTabData(),
    this.community = const NotificationTabData(),
    this.selectedTab = NotificationListTab.platform,
    this.isMarkingAllRead = false,
    this.actionFailureVersion = 0,
    this.loadMoreFailureVersion = 0,
  });

  final NotificationTabData platform;
  final NotificationTabData community;
  final NotificationListTab selectedTab;
  final bool isMarkingAllRead;
  final int actionFailureVersion;
  final int loadMoreFailureVersion;

  NotificationTabData dataFor(NotificationListTab tab) =>
      tab == NotificationListTab.platform ? platform : community;

  bool get hasUnread => [...platform.items, ...community.items].any((item) => !item.isRead);

  NotificationItemModel? findItem(String id) {
    for (final item in [...platform.items, ...community.items]) {
      if (item.id == id) return item;
    }
    return null;
  }

  NotificationState withTabData(NotificationListTab tab, NotificationTabData data) {
    return tab == NotificationListTab.platform
        ? copyWith(platform: data)
        : copyWith(community: data);
  }

  NotificationState markItemRead(String id) => copyWith(
    platform: platform.markItemRead(id),
    community: community.markItemRead(id),
  );

  NotificationState copyWith({
    NotificationTabData? platform,
    NotificationTabData? community,
    NotificationListTab? selectedTab,
    bool? isMarkingAllRead,
    int? actionFailureVersion,
    int? loadMoreFailureVersion,
  }) {
    return NotificationState(
      platform: platform ?? this.platform,
      community: community ?? this.community,
      selectedTab: selectedTab ?? this.selectedTab,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      actionFailureVersion: actionFailureVersion ?? this.actionFailureVersion,
      loadMoreFailureVersion: loadMoreFailureVersion ?? this.loadMoreFailureVersion,
    );
  }

  @override
  List<Object?> get props => [
    platform,
    community,
    selectedTab,
    isMarkingAllRead,
    actionFailureVersion,
    loadMoreFailureVersion,
  ];
}
