import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';

void main() {
  test('loads bootstrap into ready state', () async {
    final bloc = AiChatBloc(_FakeAiChatRepository());
    addTearDown(bloc.close);

    bloc.add(const AiChatStarted());

    final ready = await bloc.stream.firstWhere(
      (state) => state.status == AiChatStatus.ready,
    );
    expect(ready.conversationId, isNull);
    expect(ready.messages, isEmpty);
  });

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
      bloc.add(
        const AiChatMessageSubmitted(
          message: 'Kurs tavsiya qil',
          locale: 'uz',
          timezone: 'UZT',
        ),
      );

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
    },
  );

  test('failed send remains visible and can be retried', () async {
    final repository = _FakeAiChatRepository()..failSend = true;
    final bloc = AiChatBloc(repository);
    addTearDown(bloc.close);
    bloc.add(const AiChatStarted());
    await bloc.stream.firstWhere((state) => state.status == AiChatStatus.ready);
    bloc.add(
      const AiChatMessageSubmitted(
        message: 'Kurs tavsiya qil',
        locale: 'uz',
        timezone: 'UZT',
      ),
    );
    final failed = await bloc.stream.firstWhere(
      (state) =>
          !state.isSending &&
          state.messages.any(
            (message) => message.delivery == AiChatMessageDelivery.failed,
          ),
    );

    repository.failSend = false;
    bloc.add(
      AiChatFailedMessageRetried(
        messageId: failed.messages.single.id,
        locale: 'uz',
        timezone: 'UZT',
      ),
    );
    final retried = await bloc.stream.firstWhere(
      (state) =>
          !state.isSending &&
          state.messages.length == 2 &&
          state.messages.first.delivery == AiChatMessageDelivery.sent,
    );

    expect(retried.messages.last.role, AiChatMessageRole.assistant);
  });
}

class _FakeAiChatRepository implements AiChatRepository {
  bool failSend = false;

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    return const AiChatBootstrapModel(
      conversationId: null,
      messages: [],
      quickReplies: [],
    );
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
    required String locale,
    required String timezone,
  }) async {
    if (failSend) throw TimeoutException('offline');
    return AiChatSendResultModel(
      conversationId: 'conv-1',
      clientMessageId: clientMessageId,
      messages: [
        AiChatMessageModel(
          id: 'assistant-1',
          role: AiChatMessageRole.assistant,
          content: 'Mana sizga mos kurs.',
          createdAt: DateTime.utc(2026, 8, 15),
        ),
      ],
      quickReplies: const [],
    );
  }
}
