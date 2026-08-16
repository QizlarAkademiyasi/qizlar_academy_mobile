import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

void main() {
  late AiChatApiDatasource datasource;

  setUp(() => datasource = AiChatApiDatasource(Dio()));

  test('parses empty bootstrap and quick replies', () {
    final result = datasource.parseBootstrapPayload({
      'statusCode': 200,
      'message': 'OK',
      'data': {
        'conversationId': null,
        'messages': <dynamic>[],
        'quickReplies': [
          {
            'id': 'popular',
            'label': 'Mashhur kurslar',
            'prompt': 'Mashhur kurslarni ko‘rsat',
          },
        ],
      },
    });

    expect(result.conversationId, isNull);
    expect(result.messages, isEmpty);
    expect(result.quickReplies.single.id, 'popular');
  });

  test('parses assistant message and course recommendation', () {
    final result = datasource.parseSendPayload(_sendPayload());

    expect(result.conversationId, 'conv-1');
    expect(result.clientMessageId, 'mobile-1');
    expect(result.messages.single.role, AiChatMessageRole.assistant);
    expect(result.messages.single.courses.single.title, 'Grafik dizayn');
    expect(result.messages.single.courses.single.rating, 4.8);
    expect(result.messages.single.courses.single.durationSeconds, 21600);
  });

  test('rejects send response without renderable assistant message', () {
    expect(
      () => datasource.parseSendPayload({
        'data': {
          'conversationId': 'conv-1',
          'clientMessageId': 'mobile-1',
          'messages': <dynamic>[],
          'quickReplies': <dynamic>[],
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
      locale: 'uz',
      timezone: 'UZT',
    );

    expect(adapter.lastMethod, 'POST');
    expect(adapter.lastPath, '/api/v1/ai-chat/messages');
    expect(adapter.lastData, {
      'conversationId': 'conv-1',
      'clientMessageId': 'mobile-1',
      'message': 'Kurs tavsiya qil',
      'locale': 'uz',
      'timezone': 'UZT',
    });
  });
}

Map<String, dynamic> _sendPayload() => {
  'statusCode': 200,
  'message': 'OK',
  'data': {
    'conversationId': 'conv-1',
    'clientMessageId': 'mobile-1',
    'messages': [
      {
        'id': 'assistant-1',
        'role': 'ASSISTANT',
        'content': 'Sizga mos kurs:',
        'createdAt': '2026-08-15T17:42:10.124Z',
        'courses': [
          {
            'id': 'course-1',
            'title': 'Grafik dizayn',
            'mentorName': 'Madina Karimova',
            'imageUrl': '',
            'rating': 4.8,
            'durationSeconds': 21600,
            'reason': 'Boshlang‘ich daraja',
          },
        ],
      },
    ],
    'quickReplies': <dynamic>[],
  },
};

class _AiChatAdapter implements HttpClientAdapter {
  _AiChatAdapter(this.response);

  final Map<String, dynamic> response;
  String? lastMethod;
  String? lastPath;
  dynamic lastData;

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
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
