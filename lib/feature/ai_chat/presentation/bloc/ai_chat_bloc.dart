import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_quick_reply_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc(this._repository) : super(const AiChatState()) {
    on<AiChatStarted>(_onStarted);
    on<AiChatMessageSubmitted>(_onMessageSubmitted);
    on<AiChatFailedMessageRetried>(_onFailedMessageRetried);
  }

  final AiChatRepository _repository;

  Future<void> _onStarted(
    AiChatStarted event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading, clearLoadError: true));
    try {
      final result = await _repository.bootstrap();
      emit(
        state.copyWith(
          status: AiChatStatus.ready,
          conversationId: result.conversationId,
          messages: result.messages,
          quickReplies: result.quickReplies,
          clearLoadError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'AiChatBloc: bootstrap failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(status: AiChatStatus.failure, loadError: 'connection'),
      );
    }
  }

  Future<void> _onMessageSubmitted(
    AiChatMessageSubmitted event,
    Emitter<AiChatState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty || text.length > 1000 || state.isSending) return;

    final now = DateTime.now();
    final clientMessageId =
        'mobile-${now.microsecondsSinceEpoch}-${state.messages.length}';
    final optimisticMessage = AiChatMessageModel(
      id: clientMessageId,
      role: AiChatMessageRole.user,
      content: text,
      createdAt: now,
      delivery: AiChatMessageDelivery.sending,
    );
    emit(
      state.copyWith(
        status: AiChatStatus.ready,
        messages: [...state.messages, optimisticMessage],
        isSending: true,
        clearLoadError: true,
      ),
    );
    await _send(
      emit,
      clientMessageId: clientMessageId,
      message: text,
      locale: event.locale,
      timezone: event.timezone,
    );
  }

  Future<void> _onFailedMessageRetried(
    AiChatFailedMessageRetried event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.isSending) return;
    final index = state.messages.indexWhere(
      (message) =>
          message.id == event.messageId &&
          message.delivery == AiChatMessageDelivery.failed,
    );
    if (index < 0) return;
    final failed = state.messages[index];
    final messages = [...state.messages];
    messages[index] = failed.copyWith(delivery: AiChatMessageDelivery.sending);
    emit(state.copyWith(messages: messages, isSending: true));
    await _send(
      emit,
      clientMessageId: failed.id,
      message: failed.content,
      locale: event.locale,
      timezone: event.timezone,
    );
  }

  Future<void> _send(
    Emitter<AiChatState> emit, {
    required String clientMessageId,
    required String message,
    required String locale,
    required String timezone,
  }) async {
    try {
      final result = await _repository.sendMessage(
        conversationId: state.conversationId,
        clientMessageId: clientMessageId,
        message: message,
        locale: locale,
        timezone: timezone,
      );
      final settledMessages =
          state.messages
              .map(
                (item) => item.id == clientMessageId
                    ? item.copyWith(delivery: AiChatMessageDelivery.sent)
                    : item,
              )
              .toList(growable: true)
            ..addAll(result.messages);
      emit(
        state.copyWith(
          status: AiChatStatus.ready,
          conversationId: result.conversationId,
          messages: settledMessages,
          quickReplies: result.quickReplies,
          isSending: false,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'AiChatBloc: send failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          messages: state.messages
              .map(
                (item) => item.id == clientMessageId
                    ? item.copyWith(delivery: AiChatMessageDelivery.failed)
                    : item,
              )
              .toList(growable: false),
          isSending: false,
          sendErrorNonce: state.sendErrorNonce + 1,
        ),
      );
    }
  }
}
