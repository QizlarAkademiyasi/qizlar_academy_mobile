import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/service/ai_chat_app_session.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';

void main() {
  test('loads bootstrap into ready state', () async {
    final bloc = AiChatBloc(_FakeAiChatRepository());
    addTearDown(bloc.close);

    bloc.add(const AiChatStarted());

    final ready = await bloc.stream.firstWhere(
      (state) =>
          state.status == AiChatStatus.ready &&
          !state.isLoadingConversations &&
          state.conversations.isNotEmpty,
    );
    expect(ready.conversationId, isNull);
    expect(ready.messages, isEmpty);
    expect(ready.conversations, hasLength(1));
  });

  test(
    'starts fresh once per app process and restores on later opens',
    () async {
      final repository = _FakeAiChatRepository(
        bootstrapResult: AiChatBootstrapModel(
          conversationId: 'previous-conversation',
          title: 'Oldingi suhbat',
          messages: [
            AiChatMessageModel(
              id: 'old-message',
              role: AiChatMessageRole.assistant,
              content: 'Oldingi javob',
              createdAt: DateTime(2026, 8, 20),
            ),
          ],
        ),
      );
      final appSession = AiChatAppSession();
      final firstBloc = AiChatBloc(repository, appSession: appSession);
      addTearDown(firstBloc.close);
      firstBloc.add(const AiChatStarted());
      final fresh = await firstBloc.stream.firstWhere(
        (state) => state.status == AiChatStatus.ready,
      );

      expect(fresh.conversationId, isNull);
      expect(fresh.messages, isEmpty);

      final secondBloc = AiChatBloc(repository, appSession: appSession);
      addTearDown(secondBloc.close);
      secondBloc.add(const AiChatStarted());
      final restored = await secondBloc.stream.firstWhere(
        (state) => state.status == AiChatStatus.ready,
      );

      expect(restored.conversationId, 'previous-conversation');
      expect(restored.messages.single.content, 'Oldingi javob');
    },
  );

  test(
    'optimistically adds user message then appends assistant response',
    () async {
      final bloc = AiChatBloc(_FakeAiChatRepository());
      addTearDown(bloc.close);
      bloc.add(const AiChatStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == AiChatStatus.ready,
      );

      final emitted = <AiChatState>[];
      final subscription = bloc.stream.listen(emitted.add);
      addTearDown(subscription.cancel);
      bloc.add(const AiChatMessageSubmitted(message: 'Kurs tavsiya qil'));

      final ready = await bloc.stream.firstWhere(
        (state) =>
            !state.isSending &&
            state.messages.any(
              (message) => message.role == AiChatMessageRole.assistant,
            ),
      );

      expect(
        emitted.any(
          (state) =>
              state.isSending &&
              state.messages.last.delivery == AiChatMessageDelivery.sending,
        ),
        isTrue,
      );
      expect(ready.messages, hasLength(2));
      expect(ready.messages.first.delivery, AiChatMessageDelivery.sent);
      expect(ready.messages.last.content, 'Mana sizga mos kurs.');
      expect(ready.messages.last.courses.single.title, 'Grafik dizayn');
      expect(ready.conversationId, 'conv-1');
      expect(ready.conversationTitle, 'Grafik dizayn');
      expect(ready.conversations.first.id, 'conv-1');
      expect(ready.conversations.first.title, 'Grafik dizayn');
    },
  );

  test('failed send remains visible and can be retried', () async {
    final repository = _FakeAiChatRepository()..failSend = true;
    final bloc = AiChatBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const AiChatStarted());
    await bloc.stream.firstWhere((state) => state.status == AiChatStatus.ready);
    bloc.add(const AiChatMessageSubmitted(message: 'Kurs tavsiya qil'));
    final failed = await bloc.stream.firstWhere(
      (state) =>
          !state.isSending &&
          state.messages.any(
            (message) => message.delivery == AiChatMessageDelivery.failed,
          ),
    );

    repository.failSend = false;
    bloc.add(AiChatFailedMessageRetried(messageId: failed.messages.single.id));
    final retried = await bloc.stream.firstWhere(
      (state) =>
          !state.isSending &&
          state.messages.length == 2 &&
          state.messages.first.delivery == AiChatMessageDelivery.sent,
    );

    expect(retried.messages.last.role, AiChatMessageRole.assistant);
    expect(repository.lastClientMessageId, failed.messages.single.id);
  });

  test('new conversation clears locally without an API call', () async {
    final repository = _FakeAiChatRepository();
    final bloc = AiChatBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const AiChatStarted());
    await bloc.stream.firstWhere((state) => state.status == AiChatStatus.ready);
    bloc.add(const AiChatMessageSubmitted(message: 'Kurs tavsiya qil'));
    await bloc.stream.firstWhere(
      (state) => !state.isSending && state.messages.length == 2,
    );

    bloc.add(const AiChatNewConversationRequested());
    final cleared = await bloc.stream.firstWhere(
      (state) => state.messages.isEmpty && state.conversationId == null,
    );

    expect(repository.getConversationMessagesCount, 0);
    expect(cleared.status, AiChatStatus.ready);
    expect(cleared.conversationTitle, isNull);
    expect(cleared.canStartNewConversation, isFalse);
    expect(cleared.conversations, isNotEmpty);
  });

  test('selecting a conversation loads its messages', () async {
    final repository = _FakeAiChatRepository();
    final bloc = AiChatBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const AiChatStarted());
    await bloc.stream.firstWhere(
      (state) =>
          state.status == AiChatStatus.ready && state.conversations.isNotEmpty,
    );

    bloc.add(const AiChatConversationSelected(conversationId: 'conv-old'));
    final loaded = await bloc.stream.firstWhere(
      (state) =>
          !state.isLoadingConversation &&
          state.conversationId == 'conv-old' &&
          state.messages.isNotEmpty,
    );

    expect(repository.lastLoadedConversationId, 'conv-old');
    expect(loaded.messages.single.content, 'Eski suhbat xabari');
    expect(loaded.conversationTitle, 'Eski suhbat');
  });

  test('settling a reveal disables replay on that message', () async {
    final repository = _FakeAiChatRepository();
    final bloc = AiChatBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const AiChatStarted());
    await bloc.stream.firstWhere((state) => state.status == AiChatStatus.ready);

    bloc.add(const AiChatMessageSubmitted(message: 'Salom'));
    final sent = await bloc.stream.firstWhere(
      (state) =>
          !state.isSending &&
          state.messages.any(
            (message) => message.role == AiChatMessageRole.assistant,
          ),
    );
    final assistant = sent.messages.last;
    expect(assistant.animateReveal, isTrue);

    bloc.add(AiChatMessageRevealSettled(messageId: assistant.id));
    final settled = await bloc.stream.firstWhere(
      (state) =>
          state.messages.any((m) => m.id == assistant.id && !m.animateReveal),
    );

    expect(
      settled.messages.firstWhere((m) => m.id == assistant.id).animateReveal,
      isFalse,
    );
  });
}

class _FakeAiChatRepository implements AiChatRepository {
  _FakeAiChatRepository({
    this.bootstrapResult = const AiChatBootstrapModel(
      conversationId: null,
      messages: [],
    ),
  });

  final AiChatBootstrapModel bootstrapResult;
  bool failSend = false;
  int getConversationMessagesCount = 0;
  String? lastClientMessageId;
  String? lastLoadedConversationId;

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    return bootstrapResult;
  }

  @override
  Future<AiChatConversationsPageModel> getConversations({
    required int pageNumber,
    int pageSize = 20,
  }) async {
    return AiChatConversationsPageModel(
      items: [
        AiChatConversationModel(
          id: 'conv-old',
          title: 'Eski suhbat',
          createdAt: DateTime(2026, 8, 14),
          updatedAt: DateTime(2026, 8, 14),
        ),
      ],
      pageNumber: 1,
      hasMore: false,
    );
  }

  @override
  Future<List<AiChatMessageModel>> getConversationMessages({
    required String conversationId,
  }) async {
    getConversationMessagesCount += 1;
    lastLoadedConversationId = conversationId;
    return [
      AiChatMessageModel(
        id: 'msg-1',
        role: AiChatMessageRole.user,
        content: 'Eski suhbat xabari',
        createdAt: DateTime(2026, 8, 14),
      ),
    ];
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
  }) async {
    lastClientMessageId = clientMessageId;
    if (failSend) throw TimeoutException('offline');
    return const AiChatSendResultModel(
      conversationId: 'conv-1',
      title: 'Grafik dizayn',
      clientMessageId: 'ignored',
      reply: 'Mana sizga mos kurs.',
      recommendedCourses: [
        AiChatCourseModel(
          id: 'course-1',
          title: 'Grafik dizayn',
          mentorName: 'Madina Karimova',
          imageUrl: '',
          rating: 4.8,
          durationMinutes: 360,
        ),
      ],
    );
  }
}
