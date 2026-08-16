import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_quick_reply_model.dart';

class AiChatApiDatasource implements AiChatDatasource {
  const AiChatApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    final response = await _dio.get<dynamic>(UserApis.aiChatBootstrap);
    return parseBootstrapPayload(response.data);
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
    required String locale,
    required String timezone,
  }) async {
    final response = await _dio.post<dynamic>(
      UserApis.aiChatMessages,
      data: <String, dynamic>{
        'conversationId': conversationId,
        'clientMessageId': clientMessageId,
        'message': message,
        'locale': locale,
        'timezone': timezone,
      },
    );
    return parseSendPayload(response.data);
  }

  AiChatBootstrapModel parseBootstrapPayload(dynamic payload) {
    final data = _asMap(_asMap(payload)['data']);
    final conversationId = _nullableString(data['conversationId']);
    final messages = _asList(
      data['messages'],
    ).map(_mapMessage).where(_isRenderableMessage).toList(growable: false);
    return AiChatBootstrapModel(
      conversationId: conversationId,
      messages: messages,
      quickReplies: _mapQuickReplies(data['quickReplies']),
    );
  }

  AiChatSendResultModel parseSendPayload(dynamic payload) {
    final data = _asMap(_asMap(payload)['data']);
    final conversationId = _requiredString(
      data['conversationId'],
      field: 'data.conversationId',
    );
    final clientMessageId = _requiredString(
      data['clientMessageId'],
      field: 'data.clientMessageId',
    );
    final messages = _asList(
      data['messages'],
    ).map(_mapMessage).where(_isRenderableMessage).toList(growable: false);
    if (messages.isEmpty) {
      throw const FormatException(
        'AI chat response must contain at least one renderable message.',
      );
    }
    return AiChatSendResultModel(
      conversationId: conversationId,
      clientMessageId: clientMessageId,
      messages: messages,
      quickReplies: _mapQuickReplies(data['quickReplies']),
    );
  }

  AiChatMessageModel _mapMessage(Map<String, dynamic> raw) {
    final role = switch ((raw['role'] ?? '').toString().toUpperCase()) {
      'USER' => AiChatMessageRole.user,
      'ASSISTANT' => AiChatMessageRole.assistant,
      final unsupported => throw FormatException(
        'Unsupported AI chat message role: $unsupported',
      ),
    };
    return AiChatMessageModel(
      id: _requiredString(raw['id'], field: 'message.id'),
      role: role,
      content: (raw['content'] ?? '').toString().trim(),
      createdAt:
          DateTime.tryParse((raw['createdAt'] ?? '').toString())?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal(),
      courses: _asList(raw['courses'])
          .map(_mapCourse)
          .where((course) => course.id.isNotEmpty && course.title.isNotEmpty)
          .toList(growable: false),
    );
  }

  AiChatCourseModel _mapCourse(Map<String, dynamic> raw) {
    return AiChatCourseModel(
      id: (raw['id'] ?? '').toString().trim(),
      title: (raw['title'] ?? '').toString().trim(),
      mentorName: (raw['mentorName'] ?? '').toString().trim(),
      imageUrl: Apis.resolveUrl((raw['imageUrl'] ?? '').toString()),
      rating: _nullableDouble(raw['rating']),
      durationSeconds: _nullableInt(raw['durationSeconds']),
      reason: _nullableString(raw['reason']),
    );
  }

  List<AiChatQuickReplyModel> _mapQuickReplies(dynamic raw) {
    return _asList(raw)
        .map(
          (item) => AiChatQuickReplyModel(
            id: (item['id'] ?? '').toString().trim(),
            label: (item['label'] ?? '').toString().trim(),
            prompt: (item['prompt'] ?? '').toString().trim(),
          ),
        )
        .where(
          (item) =>
              item.id.isNotEmpty &&
              item.label.isNotEmpty &&
              item.prompt.isNotEmpty,
        )
        .toList(growable: false);
  }

  bool _isRenderableMessage(AiChatMessageModel message) =>
      message.content.isNotEmpty || message.courses.isNotEmpty;

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return const <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is! List) return const [];
    return value.map(_asMap).where((item) => item.isNotEmpty).toList();
  }

  String _requiredString(dynamic value, {required String field}) {
    final text = (value ?? '').toString().trim();
    if (text.isEmpty) throw FormatException('Missing required $field.');
    return text;
  }

  String? _nullableString(dynamic value) {
    final text = (value ?? '').toString().trim();
    return text.isEmpty ? null : text;
  }

  double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  int? _nullableInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }
}
