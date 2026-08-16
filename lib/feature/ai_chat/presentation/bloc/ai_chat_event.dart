part of 'ai_chat_bloc.dart';

sealed class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

final class AiChatStarted extends AiChatEvent {
  const AiChatStarted();
}

final class AiChatMessageSubmitted extends AiChatEvent {
  const AiChatMessageSubmitted({
    required this.message,
    required this.locale,
    required this.timezone,
  });

  final String message;
  final String locale;
  final String timezone;

  @override
  List<Object?> get props => [message, locale, timezone];
}

final class AiChatFailedMessageRetried extends AiChatEvent {
  const AiChatFailedMessageRetried({
    required this.messageId,
    required this.locale,
    required this.timezone,
  });

  final String messageId;
  final String locale;
  final String timezone;

  @override
  List<Object?> get props => [messageId, locale, timezone];
}
