part of 'ai_chat_bloc.dart';

sealed class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

final class AiChatStarted extends AiChatEvent {
  const AiChatStarted();
}

final class AiChatConversationsRequested extends AiChatEvent {
  const AiChatConversationsRequested();
}

final class AiChatConversationsLoadMoreRequested extends AiChatEvent {
  const AiChatConversationsLoadMoreRequested();
}

final class AiChatConversationSelected extends AiChatEvent {
  const AiChatConversationSelected({required this.conversationId});

  final String conversationId;

  @override
  List<Object?> get props => [conversationId];
}

final class AiChatMessageSubmitted extends AiChatEvent {
  const AiChatMessageSubmitted({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AiChatFailedMessageRetried extends AiChatEvent {
  const AiChatFailedMessageRetried({required this.messageId});

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

final class AiChatNewConversationRequested extends AiChatEvent {
  const AiChatNewConversationRequested();
}

final class AiChatMessageRevealSettled extends AiChatEvent {
  const AiChatMessageRevealSettled({required this.messageId});

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}
