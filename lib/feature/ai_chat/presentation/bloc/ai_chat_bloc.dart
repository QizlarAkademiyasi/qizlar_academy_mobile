import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/service/ai_chat_app_session.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc(this._repository, {AiChatAppSession? appSession})
    : _startsFreshOnBootstrap = (appSession ?? AiChatAppSession())
          .takeShouldStartFresh(),
      super(const AiChatState()) {
    on<AiChatStarted>(_onStarted);
    on<AiChatConversationsRequested>(_onConversationsRequested);
    on<AiChatConversationsLoadMoreRequested>(_onConversationsLoadMoreRequested);
    on<AiChatConversationSelected>(_onConversationSelected);
    on<AiChatMessageSubmitted>(_onMessageSubmitted);
    on<AiChatFailedMessageRetried>(_onFailedMessageRetried);
    on<AiChatNewConversationRequested>(_onNewConversationRequested);
    on<AiChatMessageRevealSettled>(_onMessageRevealSettled);
  }

  static const int _conversationsPageSize = 20;

  final AiChatRepository _repository;
  final bool _startsFreshOnBootstrap;
  int _clientMessageCounter = 0;

  Future<void> _onStarted(
    AiChatStarted event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading, clearLoadError: true));
    try {
      final result = await _repository.bootstrap();
      final startsFresh = _startsFreshOnBootstrap;
      emit(
        state.copyWith(
          status: AiChatStatus.ready,
          conversationId: startsFresh ? null : result.conversationId,
          conversationTitle: startsFresh ? null : result.title,
          messages: startsFresh ? const [] : result.messages,
          conversationLoadFailed: false,
          clearConversation: startsFresh || result.conversationId == null,
          clearLoadError: true,
        ),
      );
      await _loadConversations(emit, refresh: true);
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

  Future<void> _onConversationsRequested(
    AiChatConversationsRequested event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.status != AiChatStatus.ready || state.isLoadingConversations) {
      return;
    }
    await _loadConversations(emit, refresh: true);
  }

  Future<void> _onConversationsLoadMoreRequested(
    AiChatConversationsLoadMoreRequested event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.status != AiChatStatus.ready ||
        !state.conversationsHasMore ||
        state.isLoadingConversations ||
        state.isLoadingMoreConversations) {
      return;
    }
    emit(state.copyWith(isLoadingMoreConversations: true));
    try {
      final page = await _repository.getConversations(
        pageNumber: state.conversationsPage + 1,
        pageSize: _conversationsPageSize,
      );
      emit(
        state.copyWith(
          conversations: _mergeConversations(state.conversations, page.items),
          conversationsPage: page.pageNumber,
          conversationsHasMore: page.hasMore,
          isLoadingMoreConversations: false,
          conversationsLoadFailed: false,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'AiChatBloc: conversations load more failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoadingMoreConversations: false));
    }
  }

  Future<void> _onConversationSelected(
    AiChatConversationSelected event,
    Emitter<AiChatState> emit,
  ) async {
    final conversationId = event.conversationId.trim();
    if (conversationId.isEmpty ||
        state.isBusy ||
        state.status != AiChatStatus.ready) {
      return;
    }
    if (conversationId == state.conversationId &&
        !state.conversationLoadFailed &&
        state.messages.isNotEmpty) {
      return;
    }
    final selected = state.conversations
        .where((item) => item.id == conversationId)
        .firstOrNull;
    emit(
      state.copyWith(
        conversationId: conversationId,
        conversationTitle: selected?.title,
        clearConversationTitle: selected != null && selected.title == null,
        messages: const [],
        isLoadingConversation: true,
        conversationLoadFailed: false,
        isSending: false,
        clearLoadError: true,
      ),
    );
    try {
      final messages = await _repository.getConversationMessages(
        conversationId: conversationId,
      );
      if (state.conversationId != conversationId) return;
      emit(
        state.copyWith(
          status: AiChatStatus.ready,
          messages: messages,
          conversationTitle: selected?.title,
          clearConversationTitle: selected != null && selected.title == null,
          isLoadingConversation: false,
          conversationLoadFailed: false,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'AiChatBloc: conversation messages failed',
        error: error,
        stackTrace: stackTrace,
      );
      if (state.conversationId != conversationId) return;
      emit(
        state.copyWith(
          isLoadingConversation: false,
          conversationLoadFailed: true,
        ),
      );
    }
  }

  Future<void> _onMessageSubmitted(
    AiChatMessageSubmitted event,
    Emitter<AiChatState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty || text.length > 1000 || state.isBusy) return;

    final now = DateTime.now();
    final clientMessageId =
        'mobile-${now.microsecondsSinceEpoch}-${++_clientMessageCounter}';
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
        conversationLoadFailed: false,
        clearLoadError: true,
      ),
    );
    await _send(emit, clientMessageId: clientMessageId, message: text);
  }

  Future<void> _onFailedMessageRetried(
    AiChatFailedMessageRetried event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.isBusy) return;
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
    await _send(emit, clientMessageId: failed.id, message: failed.content);
  }

  Future<void> _onNewConversationRequested(
    AiChatNewConversationRequested event,
    Emitter<AiChatState> emit,
  ) async {
    if (state.isBusy || !state.canStartNewConversation) return;
    emit(
      state.copyWith(
        status: AiChatStatus.ready,
        messages: const [],
        isSending: false,
        isLoadingConversation: false,
        conversationLoadFailed: false,
        clearConversation: true,
        clearLoadError: true,
      ),
    );
  }

  void _onMessageRevealSettled(
    AiChatMessageRevealSettled event,
    Emitter<AiChatState> emit,
  ) {
    final index = state.messages.indexWhere(
      (message) => message.id == event.messageId && message.animateReveal,
    );
    if (index < 0) return;
    final messages = [...state.messages];
    messages[index] = messages[index].copyWith(animateReveal: false);
    emit(state.copyWith(messages: messages));
  }

  Future<void> _send(
    Emitter<AiChatState> emit, {
    required String clientMessageId,
    required String message,
  }) async {
    try {
      final result = await _repository.sendMessage(
        conversationId: state.conversationId,
        clientMessageId: clientMessageId,
        message: message,
      );
      final settledMessages =
          state.messages
              .map(
                (item) => item.id == clientMessageId
                    ? item.copyWith(delivery: AiChatMessageDelivery.sent)
                    : item,
              )
              .toList(growable: true)
            ..add(result.toAssistantMessage());
      emit(
        state.copyWith(
          status: AiChatStatus.ready,
          conversationId: result.conversationId,
          conversationTitle: result.title ?? state.conversationTitle,
          messages: settledMessages,
          conversations: _upsertConversation(
            id: result.conversationId,
            title: result.title,
          ),
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

  Future<void> _loadConversations(
    Emitter<AiChatState> emit, {
    required bool refresh,
  }) async {
    emit(
      state.copyWith(
        isLoadingConversations: true,
        conversationsLoadFailed: false,
      ),
    );
    try {
      final page = await _repository.getConversations(
        pageNumber: 1,
        pageSize: _conversationsPageSize,
      );
      emit(
        state.copyWith(
          conversations: _reconcileConversations(page.items),
          conversationsPage: page.pageNumber,
          conversationsHasMore: page.hasMore,
          isLoadingConversations: false,
          conversationsLoadFailed: false,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.e(
        'AiChatBloc: conversations failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoadingConversations: false,
          conversationsLoadFailed: refresh && state.conversations.isEmpty,
        ),
      );
    }
  }

  List<AiChatConversationModel> _upsertConversation({
    required String id,
    required String? title,
  }) {
    final now = DateTime.now();
    AiChatConversationModel? existing;
    for (final item in state.conversations) {
      if (item.id == id) {
        existing = item;
        break;
      }
    }
    final updated = AiChatConversationModel(
      id: id,
      title: title ?? existing?.title,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    return [updated, ...state.conversations.where((item) => item.id != id)];
  }

  List<AiChatConversationModel> _mergeConversations(
    List<AiChatConversationModel> current,
    List<AiChatConversationModel> incoming,
  ) {
    final seen = <String>{for (final item in current) item.id};
    return [...current, ...incoming.where((item) => seen.add(item.id))];
  }

  List<AiChatConversationModel> _reconcileConversations(
    List<AiChatConversationModel> fetched,
  ) {
    final fetchedIds = <String>{for (final item in fetched) item.id};
    final locals = state.conversations.where(
      (item) => !fetchedIds.contains(item.id),
    );
    return [...locals, ...fetched];
  }
}
