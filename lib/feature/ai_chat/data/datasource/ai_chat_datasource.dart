import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';

abstract class AiChatDatasource {
  Future<AiChatBootstrapModel> bootstrap();

  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
    required String locale,
    required String timezone,
  });
}
