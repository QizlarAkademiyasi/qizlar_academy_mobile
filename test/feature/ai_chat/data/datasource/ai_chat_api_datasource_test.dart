import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

void main() {
  late AiChatApiDatasource datasource;

  setUp(() => datasource = AiChatApiDatasource(Dio()));

  test('parses empty bootstrap without quick replies', () {
    final result = datasource.parseBootstrapPayload({
      'statusCode': 200,
      'message': 'OK',
      'data': {'conversationId': null, 'title': null, 'messages': <dynamic>[]},
    });

    expect(result.conversationId, isNull);
    expect(result.title, isNull);
    expect(result.messages, isEmpty);
  });

  test('parses bootstrap history as text with course IDs only', () {
    final result = datasource.parseBootstrapPayload({
      'statusCode': 200,
      'message': 'OK',
      'data': {
        'conversationId': 'conv-1',
        'title': 'Grafik dizayn bo‘yicha maslahat',
        'messages': [
          {
            'id': 'user-1',
            'role': 'USER',
            'content': 'Dizayn kursi kerak',
            'recommendedCourseIds': <dynamic>[],
            'createdAt': '2026-08-15T17:41:30.000Z',
          },
          {
            'id': 'assistant-1',
            'role': 'ASSISTANT',
            'content': 'Sizga mos kurs topdim',
            'recommendedCourseIds': ['course-1'],
            'createdAt': '2026-08-15T17:41:34.000Z',
          },
        ],
      },
    });

    expect(result.conversationId, 'conv-1');
    expect(result.title, 'Grafik dizayn bo‘yicha maslahat');
    expect(result.messages, hasLength(2));
    expect(result.messages.last.role, AiChatMessageRole.assistant);
    expect(result.messages.last.recommendedCourseIds, ['course-1']);
    expect(result.messages.last.courses, isEmpty);
  });

  test('keeps assistant history with course IDs even without content', () {
    final result = datasource.parseBootstrapPayload({
      'statusCode': 200,
      'message': 'OK',
      'data': {
        'conversationId': 'conv-1',
        'title': 'Tavsiyalar',
        'messages': [
          {
            'id': 'assistant-1',
            'role': 'ASSISTANT',
            'content': '',
            'recommendedCourseIds': ['course-1', 'course-2'],
            'createdAt': '2026-08-15T17:41:34.000Z',
          },
        ],
      },
    });

    expect(result.messages, hasLength(1));
    expect(result.messages.single.content, isEmpty);
    expect(result.messages.single.recommendedCourseIds, [
      'course-1',
      'course-2',
    ]);
  });

  test('parses conversations list with pagination', () {
    final result = datasource.parseConversationsPayload({
      'data': {
        'data': [
          {
            'id': 'conv-1',
            'title': 'Grafik dizayn',
            'createdAt': '2026-08-15T17:41:30.000Z',
            'updatedAt': '2026-08-15T17:42:10.000Z',
          },
          {
            'id': 'conv-2',
            'title': null,
            'createdAt': '2026-08-14T09:00:00.000Z',
            'updatedAt': '2026-08-14T09:00:00.000Z',
          },
        ],
        'meta': {
          'pagination': {
            'pageNumber': 1,
            'pageSize': 10,
            'count': 2,
            'pageCount': 1,
          },
        },
      },
    }, fallbackPageNumber: 1);

    expect(result.items, hasLength(2));
    expect(result.items.first.title, 'Grafik dizayn');
    expect(result.items.last.title, isNull);
    expect(result.hasMore, isFalse);
  });

  test('parses conversation messages page', () {
    final result = datasource.parseMessagesPayload({
      'data': {
        'data': [
          {
            'id': 'user-1',
            'role': 'USER',
            'content': 'Salom',
            'recommendedCourseIds': <dynamic>[],
            'createdAt': '2026-08-15T17:41:30.000Z',
          },
        ],
        'meta': {
          'pagination': {
            'pageNumber': 1,
            'pageSize': 50,
            'count': 1,
            'pageCount': 1,
          },
        },
      },
    }, fallbackPageNumber: 1);

    expect(result.messages.single.content, 'Salom');
    expect(result.pageCount, 1);
  });

  test('parses send reply, title and recommended courses', () {
    final result = datasource.parseSendPayload(_sendPayload());

    expect(result.conversationId, 'conv-1');
    expect(result.title, 'Grafik dizayn bo‘yicha maslahat');
    expect(result.clientMessageId, 'mobile-1');
    expect(result.reply, 'Sizga mos kurs:');
    expect(result.needsMoreInfo, isFalse);
    expect(result.recommendedCourses.single.title, 'Grafik dizayn');
    expect(result.recommendedCourses.single.rating, 4.8);
    expect(result.recommendedCourses.single.durationMinutes, 360);
    expect(result.recommendedCourses.single.lessonCount, 24);
    expect(result.recommendedCourses.single.totalRatings, 120);
    final assistant = result.toAssistantMessage();
    expect(assistant.role, AiChatMessageRole.assistant);
    expect(assistant.courses, hasLength(1));
  });

  test('keeps at most three recommended courses', () {
    final courses = List<Map<String, dynamic>>.generate(
      5,
      (index) => {
        'id': 'course-$index',
        'name': 'Kurs $index',
        'bannerImage': '',
        'icon': '',
        'teacherFullname': 'Mentor',
        'avgRating': 4,
        'totalRatings': 10,
        'totalDuration': 60,
        'lessonCount': 8,
      },
    );
    final result = datasource.parseSendPayload({
      'data': {
        'conversationId': 'conv-1',
        'title': 'Tavsiyalar',
        'clientMessageId': 'mobile-1',
        'reply': 'Tavsiyalar',
        'recommendedCourses': courses,
        'needsMoreInfo': false,
      },
    });

    expect(result.recommendedCourses, hasLength(3));
  });

  test('rejects send response without reply or courses', () {
    expect(
      () => datasource.parseSendPayload({
        'data': {
          'conversationId': 'conv-1',
          'clientMessageId': 'mobile-1',
          'reply': '',
          'recommendedCourses': <dynamic>[],
          'needsMoreInfo': false,
        },
      }),
      throwsFormatException,
    );
  });

  test('send uses expected endpoint and exact request fields', () async {
    final dio = Dio();
    final adapter = _AiChatAdapter(_sendPayload());
    dio.httpClientAdapter = adapter;
    final api = AiChatApiDatasource(dio);

    await api.sendMessage(
      conversationId: 'conv-1',
      clientMessageId: 'mobile-1',
      message: 'Kurs tavsiya qil',
    );

    expect(adapter.lastMethod, 'POST');
    expect(adapter.lastPath, UserApis.aiChatMessages);
    expect(adapter.lastReceiveTimeout, AiChatApiDatasource.sendReceiveTimeout);
    expect(adapter.lastData, {
      'conversationId': 'conv-1',
      'clientMessageId': 'mobile-1',
      'message': 'Kurs tavsiya qil',
    });
  });

  test('lists conversations from conversations endpoint', () async {
    final dio = Dio();
    final adapter = _AiChatAdapter({
      'data': {
        'data': <dynamic>[],
        'meta': {
          'pagination': {
            'pageNumber': 1,
            'pageSize': 20,
            'count': 0,
            'pageCount': 1,
          },
        },
      },
    });
    dio.httpClientAdapter = adapter;
    final api = AiChatApiDatasource(dio);

    await api.getConversations(pageNumber: 1, pageSize: 20);

    expect(adapter.lastMethod, 'GET');
    expect(adapter.lastPath, UserApis.aiChatConversations);
    expect(adapter.lastQuery, {'pageNumber': 1, 'pageSize': 20});
  });

  test('loads conversation messages from conversation path', () async {
    final dio = Dio();
    final adapter = _AiChatAdapter({
      'data': {
        'data': <dynamic>[],
        'meta': {
          'pagination': {
            'pageNumber': 1,
            'pageSize': 50,
            'count': 0,
            'pageCount': 1,
          },
        },
      },
    });
    dio.httpClientAdapter = adapter;
    final api = AiChatApiDatasource(dio);

    await api.getConversationMessages(conversationId: 'conv-1');

    expect(adapter.lastMethod, 'GET');
    expect(adapter.lastPath, UserApis.aiChatConversationMessages('conv-1'));
    expect(adapter.lastQuery, {'pageNumber': 1, 'pageSize': 50});
  });
}

Map<String, dynamic> _sendPayload() => {
  'statusCode': 200,
  'message': 'OK',
  'data': {
    'conversationId': 'conv-1',
    'title': 'Grafik dizayn bo‘yicha maslahat',
    'clientMessageId': 'mobile-1',
    'reply': 'Sizga mos kurs:',
    'recommendedCourses': [
      {
        'id': 'course-1',
        'name': 'Grafik dizayn',
        'bannerImage': 'uploads/default/design.png',
        'icon': 'uploads/default/design-icon.png',
        'teacherFullname': 'Madina Karimova',
        'avgRating': 4.8,
        'totalRatings': 120,
        'totalDuration': 360,
        'lessonCount': 24,
      },
    ],
    'needsMoreInfo': false,
  },
};

class _AiChatAdapter implements HttpClientAdapter {
  _AiChatAdapter(this.response);

  final Map<String, dynamic> response;
  String? lastMethod;
  String? lastPath;
  dynamic lastData;
  Map<String, dynamic>? lastQuery;
  Duration? lastReceiveTimeout;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastMethod = options.method;
    lastPath = options.path;
    lastData = options.data;
    lastQuery = options.queryParameters;
    lastReceiveTimeout = options.receiveTimeout;
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
