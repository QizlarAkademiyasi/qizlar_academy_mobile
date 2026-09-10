import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_topic_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/repository/notification_repository.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/bloc/notification_bloc.dart';

void main() {
  test('loads platform tab first and lazy-loads community', () async {
    final repository = _FakeNotificationRepository();
    final bloc = NotificationBloc(repository);
    addTearDown(bloc.close);

    expect(bloc.state.selectedTab, NotificationListTab.platform);
    bloc.add(const NotificationStarted());
    final loaded = await bloc.stream.firstWhere(
      (s) => s.platform.status == NotificationTabStatus.success,
    );
    expect(loaded.community.status, NotificationTabStatus.initial);
    expect(repository.pushCalls, 1);
    expect(repository.globalCalls, 0);

    bloc.add(const NotificationTabSelected(NotificationListTab.community));
    final community = await bloc.stream.firstWhere(
      (s) => s.community.status == NotificationTabStatus.success,
    );
    expect(community.selectedTab, NotificationListTab.community);
    expect(repository.globalCalls, 1);
  });

  test('load more dedupes and keeps tab pages independent', () async {
    final repository = _FakeNotificationRepository();
    final bloc = NotificationBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const NotificationStarted());
    await bloc.stream.firstWhere(
      (s) => s.platform.status == NotificationTabStatus.success,
    );

    bloc.add(const NotificationLoadMoreRequested(NotificationListTab.platform));
    final more = await bloc.stream.firstWhere(
      (s) => s.platform.pageNumber == 2 && !s.platform.isLoadingMore,
    );
    expect(more.platform.items.map((e) => e.id).toSet(), {'p1', 'p2'});
    expect(more.community.items, isEmpty);
  });

  test('marks one item and all items as read', () async {
    final repository = _FakeNotificationRepository();
    final bloc = NotificationBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const NotificationStarted());
    await bloc.stream.firstWhere(
      (s) => s.platform.status == NotificationTabStatus.success,
    );

    bloc.add(const NotificationItemOpened(notificationId: 'p1'));
    final one = await bloc.stream.firstWhere(
      (s) => s.platform.items.singleWhere((e) => e.id == 'p1').isRead,
    );
    expect(one.hasUnread, isFalse);

    repository.pushItems = [
      _item('p1', read: false),
      _item('p2', read: false),
    ];
    bloc.add(const NotificationRetryRequested(tab: NotificationListTab.platform));
    await bloc.stream.firstWhere(
      (s) => s.platform.items.length == 2 && s.hasUnread,
    );
    bloc.add(const NotificationMarkAllReadRequested());
    final all = await bloc.stream.firstWhere((s) => !s.hasUnread);
    expect(all.platform.items.every((e) => e.isRead), isTrue);
  });

  test('load more failure increments version and keeps items', () async {
    final repository = _FakeNotificationRepository()..failLoadMore = true;
    final bloc = NotificationBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const NotificationStarted());
    await bloc.stream.firstWhere(
      (s) => s.platform.status == NotificationTabStatus.success,
    );
    bloc.add(const NotificationLoadMoreRequested(NotificationListTab.platform));
    final failed = await bloc.stream.firstWhere(
      (s) => s.loadMoreFailureVersion == 1,
    );
    expect(failed.platform.items, isNotEmpty);
    expect(failed.platform.isLoadingMore, isFalse);
  });
}

NotificationItemModel _item(String id, {bool read = false, int hour = 10}) {
  return NotificationItemModel(
    id: id,
    title: id,
    description: id,
    createdAt: DateTime(2026, 9, 9, hour),
    channelType: NotificationChannelType.push,
    isRead: read,
  );
}

class _FakeNotificationRepository implements NotificationRepository {
  int pushCalls = 0;
  int globalCalls = 0;
  bool failLoadMore = false;
  List<NotificationItemModel> pushItems = [_item('p1')];

  @override
  Future<NotificationPageModel> fetchPage({
    required NotificationChannelType type,
    required int pageNumber,
    int pageSize = 10,
  }) async {
    if (type == NotificationChannelType.push) {
      pushCalls += 1;
      if (failLoadMore && pageNumber > 1) {
        throw StateError('load more failed');
      }
      final items = pageNumber == 1 ? pushItems : [_item('p2', hour: 11)];
      return NotificationPageModel(
        items: items,
        pagination: NotificationPaginationModel(
          pageNumber: pageNumber,
          pageSize: pageSize,
          count: 2,
          pageCount: 2,
        ),
      );
    }
    globalCalls += 1;
    return NotificationPageModel(
      items: [
        NotificationItemModel(
          id: 'g1',
          title: 'Global',
          description: 'Body',
          createdAt: DateTime(2026, 9, 8),
          channelType: NotificationChannelType.global,
          isRead: true,
        ),
      ],
      pagination: NotificationPaginationModel(
        pageNumber: 1,
        pageSize: pageSize,
        count: 1,
        pageCount: 1,
      ),
    );
  }

  @override
  Future<void> markAllAsRead() async {}

  @override
  Future<void> markAsRead({required String notificationId}) async {}

  @override
  Future<NotificationTopicPageModel> fetchTopicsPage({
    required int pageNumber,
    int pageSize = 10,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> toggleTopic({required String topicId}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> subscribePushToken(String token) async {}

  @override
  Future<void> unsubscribePushToken(String token) async {}
}
