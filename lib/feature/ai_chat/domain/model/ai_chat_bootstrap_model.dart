import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_quick_reply_model.dart';

class AiChatBootstrapModel extends Equatable {
  const AiChatBootstrapModel({
    required this.conversationId,
    required this.messages,
    required this.quickReplies,
  });

  final String? conversationId;
  final List<AiChatMessageModel> messages;
  final List<AiChatQuickReplyModel> quickReplies;

  @override
  List<Object?> get props => [conversationId, messages, quickReplies];
}

class AiChatSendResultModel extends Equatable {
  const AiChatSendResultModel({
    required this.conversationId,
    required this.clientMessageId,
    required this.messages,
    required this.quickReplies,
  });

  final String conversationId;
  final String clientMessageId;
  final List<AiChatMessageModel> messages;
  final List<AiChatQuickReplyModel> quickReplies;

  @override
  List<Object?> get props => [
    conversationId,
    clientMessageId,
    messages,
    quickReplies,
  ];
}
