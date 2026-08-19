import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

class AiChatApiDatasource implements AiChatDatasource {
  const AiChatApiDatasource(this._dio);

  static const int maxRecommendedCourses = 3;
  static const int messagesPageSize = 50;

  /// Gemini javobi (ayniqsa birinchi xabar + title) 20s dan oshishi mumkin.
  static const Duration sendReceiveTimeout = Duration(seconds: 90);

  final Dio _dio;

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    final response = await _dio.get<dynamic>(UserApis.aiChatBootstrap);
    return parseBootstrapPayload(response.data);
  }

  @override
  Future<AiChatConversationsPageModel> getConversations({
    required int pageNumber,
    int pageSize = 20,
  }) async {
    final response = await _dio.get<dynamic>(
      UserApis.aiChatConversations,
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    return parseConversationsPayload(
      response.data,
      fallbackPageNumber: pageNumber,
    );
  }

  @override
  Future<List<AiChatMessageModel>> getConversationMessages({
    required String conversationId,
  }) async {
    final first = await _fetchMessagesPage(
      conversationId: conversationId,
      pageNumber: 1,
    );
    if (first.pageCount <= 1) return first.messages;

    final last = await _fetchMessagesPage(
      conversationId: conversationId,
      pageNumber: first.pageCount,
    );
    if (first.pageCount == 2) {
      return _takeLatest([
        ...first.messages,
        ...last.messages,
      ], messagesPageSize);
    }

    final previous = await _fetchMessagesPage(
      conversationId: conversationId,
      pageNumber: first.pageCount - 1,
    );
    return _takeLatest([
      ...previous.messages,
      ...last.messages,
    ], messagesPageSize);
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
  }) async {
    final response = await _dio.post<dynamic>(
      UserApis.aiChatMessages,
      data: <String, dynamic>{
        'conversationId': conversationId,
        'clientMessageId': clientMessageId,
        'message': message,
      },
      options: Options(receiveTimeout: sendReceiveTimeout),
    );
    return parseSendPayload(response.data);
  }

  Future<AiChatMessagesPageModel> _fetchMessagesPage({
    required String conversationId,
    required int pageNumber,
  }) async {
    final response = await _dio.get<dynamic>(
      UserApis.aiChatConversationMessages(conversationId),
      queryParameters: <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': messagesPageSize,
      },
    );
    return parseMessagesPayload(response.data, fallbackPageNumber: pageNumber);
  }

  AiChatBootstrapModel parseBootstrapPayload(dynamic payload) {
    final data = _asMap(_asMap(payload)['data']);
    final conversationId = _nullableString(data['conversationId']);
    final messages = _asList(
      data['messages'],
    ).map(_mapMessage).where(_isRenderableMessage).toList(growable: false);
    return AiChatBootstrapModel(
      conversationId: conversationId,
      title: _nullableString(data['title']),
      messages: messages,
    );
  }

  AiChatConversationsPageModel parseConversationsPayload(
    dynamic payload, {
    required int fallbackPageNumber,
  }) {
    final data = _asMap(_asMap(payload)['data']);
    final items = _asList(data['data'])
        .map(_mapConversation)
        .where((item) => item.id.isNotEmpty)
        .toList(growable: false);
    final pagination = _asMap(_asMap(data['meta'])['pagination']);
    final pageNumber = _positiveInt(
      pagination['pageNumber'],
      fallback: fallbackPageNumber,
    );
    final rawPageCount = int.tryParse('${pagination['pageCount'] ?? ''}') ?? 1;
    final pageCount = rawPageCount <= 0 ? 1 : rawPageCount;
    return AiChatConversationsPageModel(
      items: items,
      pageNumber: pageNumber,
      hasMore: pageNumber < pageCount,
    );
  }

  AiChatMessagesPageModel parseMessagesPayload(
    dynamic payload, {
    required int fallbackPageNumber,
  }) {
    final data = _asMap(_asMap(payload)['data']);
    final messages = _asList(
      data['data'],
    ).map(_mapMessage).where(_isRenderableMessage).toList(growable: false);
    final pagination = _asMap(_asMap(data['meta'])['pagination']);
    final pageNumber = _positiveInt(
      pagination['pageNumber'],
      fallback: fallbackPageNumber,
    );
    final rawPageCount = int.tryParse('${pagination['pageCount'] ?? ''}') ?? 1;
    return AiChatMessagesPageModel(
      messages: messages,
      pageNumber: pageNumber,
      pageCount: rawPageCount <= 0 ? 1 : rawPageCount,
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
    final reply = (data['reply'] ?? '').toString().trim();
    final recommendedCourses = _asList(data['recommendedCourses'])
        .map(_mapCourse)
        .where((course) => course.id.isNotEmpty && course.title.isNotEmpty)
        .take(maxRecommendedCourses)
        .toList(growable: false);
    if (reply.isEmpty && recommendedCourses.isEmpty) {
      throw const FormatException(
        'AI chat response must contain a reply or recommended courses.',
      );
    }
    return AiChatSendResultModel(
      conversationId: conversationId,
      title: _nullableString(data['title']),
      clientMessageId: clientMessageId,
      reply: reply,
      recommendedCourses: recommendedCourses,
      needsMoreInfo: data['needsMoreInfo'] == true,
    );
  }

  AiChatConversationModel _mapConversation(Map<String, dynamic> raw) {
    return AiChatConversationModel(
      id: _requiredString(raw['id'], field: 'conversation.id'),
      title: _nullableString(raw['title']),
      createdAt: _parseDate(raw['createdAt']),
      updatedAt: _parseDate(raw['updatedAt']),
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
      createdAt: _parseDate(raw['createdAt']),
      recommendedCourseIds: _asStringList(raw['recommendedCourseIds']),
    );
  }

  AiChatCourseModel _mapCourse(Map<String, dynamic> raw) {
    final banner = (raw['bannerImage'] ?? '').toString().trim();
    final icon = (raw['icon'] ?? '').toString().trim();
    return AiChatCourseModel(
      id: (raw['id'] ?? '').toString().trim(),
      title: (raw['name'] ?? '').toString().trim(),
      mentorName: (raw['teacherFullname'] ?? '').toString().trim(),
      imageUrl: Apis.resolveUrl(banner.isNotEmpty ? banner : icon),
      rating: _nullableDouble(raw['avgRating']),
      totalRatings: _nullableInt(raw['totalRatings']),
      durationMinutes: _nullableInt(raw['totalDuration']),
      lessonCount: _nullableInt(raw['lessonCount']),
      studentCount: _nullableInt(raw['enrollmentCount']),
    );
  }

  List<AiChatMessageModel> _takeLatest(
    List<AiChatMessageModel> messages,
    int limit,
  ) {
    if (messages.length <= limit) return List<AiChatMessageModel>.of(messages);
    return messages.sublist(messages.length - limit);
  }

  bool _isRenderableMessage(AiChatMessageModel message) =>
      message.content.isNotEmpty ||
      message.courses.isNotEmpty ||
      message.recommendedCourseIds.isNotEmpty;

  DateTime _parseDate(dynamic value) {
    return DateTime.tryParse((value ?? '').toString())?.toLocal() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
  }

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

  List<String> _asStringList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
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

  int _positiveInt(dynamic value, {required int fallback}) {
    final parsed = int.tryParse((value ?? '').toString());
    if (parsed == null || parsed < 1) return fallback < 1 ? 1 : fallback;
    return parsed;
  }
}
