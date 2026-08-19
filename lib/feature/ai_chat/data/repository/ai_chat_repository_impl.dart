import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_course_resolver.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  const AiChatRepositoryImpl(this._datasource, this._courseResolver);

  final AiChatDatasource _datasource;
  final AiChatCourseResolver _courseResolver;

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    final result = await _datasource.bootstrap();
    return result.copyWith(messages: await _hydrate(result.messages));
  }

  @override
  Future<AiChatConversationsPageModel> getConversations({
    required int pageNumber,
    int pageSize = 20,
  }) {
    return _datasource.getConversations(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<AiChatMessageModel>> getConversationMessages({
    required String conversationId,
  }) async {
    final messages = await _datasource.getConversationMessages(
      conversationId: conversationId,
    );
    return _hydrate(messages);
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
  }) async {
    final result = await _datasource.sendMessage(
      conversationId: conversationId,
      clientMessageId: clientMessageId,
      message: message,
    );
    _courseResolver.remember(result.recommendedCourses);
    return result;
  }

  Future<List<AiChatMessageModel>> _hydrate(
    List<AiChatMessageModel> messages,
  ) async {
    final ids = <String>[];
    final seen = <String>{};
    for (final message in messages) {
      for (final id in message.recommendedCourseIds.take(
        AiChatApiDatasource.maxRecommendedCourses,
      )) {
        if (seen.add(id)) ids.add(id);
      }
    }
    if (ids.isEmpty) return messages;
    final resolved = await _courseResolver.resolve(ids);
    final byId = <String, AiChatCourseModel>{
      for (final course in resolved) course.id: course,
    };
    return [
      for (final message in messages)
        if (message.recommendedCourseIds.isEmpty)
          message
        else
          message.copyWith(
            courses: [
              for (final id in message.recommendedCourseIds.take(
                AiChatApiDatasource.maxRecommendedCourses,
              ))
                if (byId[id] != null) byId[id]!,
            ],
          ),
    ];
  }
}
