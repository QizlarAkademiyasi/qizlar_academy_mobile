import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/notification/data/datasource/notification_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';

void main() {
  late NotificationApiDatasource datasource;
  late _CapturingAdapter adapter;

  setUp(() {
    adapter = _CapturingAdapter();
    datasource = NotificationApiDatasource(Dio()..httpClientAdapter = adapter);
  });

  test('parses actors, post, nullable fields and unknown category', () async {
    adapter.response = {
      'data': {
        'data': [
          {
            'id': 'n1',
            'title': 'Title',
            'body': 'Body text',
            'createdAt': '2026-09-09T10:00:00.000Z',
            'type': 'push',
            'isRead': false,
            'photo': null,
            'targetId': null,
            'category': 'SOMETHING_ELSE',
            'actors': [
              {
                'id': 'u1',
                'firstname': 'Ali',
                'lastname': 'Vali',
                'photo': 'https://cdn.example/a.png',
              },
            ],
            'post': {'id': 'p1', 'thumbnail': null},
          },
        ],
        'meta': {
          'pagination': {
            'pageNumber': 1,
            'pageSize': 10,
            'count': 1,
            'pageCount': 3,
          },
        },
      },
    };

    final page = await datasource.fetchPage(
      type: NotificationChannelType.push,
      pageNumber: 1,
      pageSize: 10,
    );

    expect(adapter.lastPath, '/api/v1/notification');
    expect(adapter.lastQuery, {
      'pageNumber': 1,
      'pageSize': 10,
      'type': 'push',
    });
    expect(page.pagination.pageCount, 3);
    expect(page.items, hasLength(1));
    expect(page.items.single.category, NotificationCategory.unknown);
    expect(page.items.single.actors.single.firstName, 'Ali');
    expect(page.items.single.post?.id, 'p1');
    expect(page.items.single.post?.thumbnailUrl, isNull);
    expect(page.items.single.avatarUrl, isNull);
    expect(page.items.single.targetId, isNull);
  });

  test('maps known categories and global type query', () async {
    adapter.response = {
      'data': {
        'data': [
          {
            'id': 'n2',
            'title': 'Liked',
            'body': 'liked your post',
            'createdAt': '2026-09-09T11:00:00.000Z',
            'type': 'global',
            'isRead': true,
            'category': 'POST_LIKED',
            'actors': [],
            'post': {'id': 'p2', 'thumbnail': 'https://cdn.example/t.png'},
          },
        ],
        'meta': {
          'pagination': {
            'pageNumber': 2,
            'pageSize': 10,
            'count': 11,
            'pageCount': 2,
          },
        },
      },
    };

    final page = await datasource.fetchPage(
      type: NotificationChannelType.global,
      pageNumber: 2,
      pageSize: 10,
    );

    expect(adapter.lastQuery?['type'], 'global');
    expect(page.items.single.category, NotificationCategory.postLiked);
    expect(page.items.single.channelType, NotificationChannelType.global);
    expect(page.pagination.hasNextPage, isFalse);
  });

  test('parses topics page and toggle payload', () async {
    adapter.response = {
      'data': {
        'data': [
          {'id': 't1', 'topic': 'news', 'isSubscribed': true},
          {'id': '', 'topic': 'skip', 'isSubscribed': false},
        ],
        'meta': {
          'pagination': {
            'pageNumber': 1,
            'pageSize': 10,
            'count': 1,
            'pageCount': 1,
          },
        },
      },
    };

    final page = await datasource.fetchTopicsPage(pageNumber: 1, pageSize: 10);
    expect(adapter.lastPath, '/api/v1/notification-topic');
    expect(page.items, hasLength(1));
    expect(page.items.single.isSubscribed, isTrue);

    adapter.response = {
      'data': {'isSubscribed': false},
    };
    final next = await datasource.toggleTopic(topicId: 't1');
    expect(adapter.lastPath, '/api/v1/notification-topic/t1/toggle');
    expect(next, isFalse);
  });
}

class _CapturingAdapter implements HttpClientAdapter {
  Map<String, dynamic> response = const {};
  String? lastPath;
  Map<String, dynamic>? lastQuery;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastPath = options.path;
    lastQuery = options.queryParameters;
    return ResponseBody.fromBytes(
      Uint8List.fromList(utf8.encode(jsonEncode(response))),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
