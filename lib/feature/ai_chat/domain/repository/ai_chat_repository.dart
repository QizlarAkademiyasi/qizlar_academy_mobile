import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

abstract class AiChatRepository {
  Future<AiChatBootstrapModel> bootstrap();

  Future<AiChatConversationsPageModel> getConversations({
    required int pageNumber,
    int pageSize = 20,
  });

  Future<List<AiChatMessageModel>> getConversationMessages({
    required String conversationId,
  });

  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
  });
}
