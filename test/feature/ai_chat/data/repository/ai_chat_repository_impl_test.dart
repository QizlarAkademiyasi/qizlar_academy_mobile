import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/datasource/ai_chat_datasource.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/data/repository/ai_chat_repository_impl.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_course_resolver.dart';

void main() {
  test(
    'hydrates bootstrap history courses in recommendedCourseIds order',
    () async {
      final resolver = _FakeCourseResolver()
        ..courses = const {
          'course-b': AiChatCourseModel(
            id: 'course-b',
            title: 'Second',
            mentorName: 'B',
            imageUrl: '',
          ),
          'course-a': AiChatCourseModel(
            id: 'course-a',
            title: 'First',
            mentorName: 'A',
            imageUrl: '',
          ),
        };
      final repository = AiChatRepositoryImpl(
        _FakeDatasource(
          bootstrapResult: AiChatBootstrapModel(
            conversationId: 'conv-1',
            messages: [
              AiChatMessageModel(
                id: 'assistant-1',
                role: AiChatMessageRole.assistant,
                content: 'Sizga mos kurslar',
                createdAt: DateTime(2026, 8, 19),
                recommendedCourseIds: const ['course-a', 'missing', 'course-b'],
              ),
            ],
          ),
        ),
        resolver,
      );

      final result = await repository.bootstrap();

      expect(resolver.lastResolved, ['course-a', 'missing', 'course-b']);
      expect(result.messages.single.courses.map((course) => course.id), [
        'course-a',
        'course-b',
      ]);
    },
  );

  test('remembers recommended courses after send', () async {
    final resolver = _FakeCourseResolver();
    const course = AiChatCourseModel(
      id: 'course-1',
      title: 'Grafik dizayn',
      mentorName: 'Madina',
      imageUrl: '',
    );
    final repository = AiChatRepositoryImpl(
      _FakeDatasource(
        sendResult: const AiChatSendResultModel(
          conversationId: 'conv-1',
          clientMessageId: 'mobile-1',
          reply: 'Mana kurs',
          recommendedCourses: [course],
        ),
      ),
      resolver,
    );

    await repository.sendMessage(
      conversationId: null,
      clientMessageId: 'mobile-1',
      message: 'Kurs kerak',
    );

    expect(resolver.remembered, [course]);
  });
}

class _FakeCourseResolver implements AiChatCourseResolver {
  Map<String, AiChatCourseModel> courses = const {};
  List<String> lastResolved = const [];
  List<AiChatCourseModel> remembered = const [];

  @override
  void remember(Iterable<AiChatCourseModel> courses) {
    remembered = courses.toList(growable: false);
  }

  @override
  Future<List<AiChatCourseModel>> resolve(List<String> ids) async {
    lastResolved = List<String>.of(ids);
    return [
      for (final id in ids)
        if (courses[id] != null) courses[id]!,
    ];
  }
}

class _FakeDatasource implements AiChatDatasource {
  _FakeDatasource({this.bootstrapResult, this.sendResult});

  final AiChatBootstrapModel? bootstrapResult;
  final AiChatSendResultModel? sendResult;

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    return bootstrapResult ??
        const AiChatBootstrapModel(conversationId: null, messages: []);
  }

  @override
  Future<AiChatConversationsPageModel> getConversations({
    required int pageNumber,
    int pageSize = 20,
  }) async {
    return const AiChatConversationsPageModel(
      items: [],
      pageNumber: 1,
      hasMore: false,
    );
  }

  @override
  Future<List<AiChatMessageModel>> getConversationMessages({
    required String conversationId,
  }) async {
    return bootstrapResult?.messages ?? const [];
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
  }) async {
    return sendResult!;
  }
}
