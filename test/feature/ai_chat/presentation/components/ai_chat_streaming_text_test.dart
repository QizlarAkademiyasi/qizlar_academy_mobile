import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_bubble.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_markdown_body.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_streaming_text.dart';

void main() {
  test('tokenize keeps spaces and splits words into short tokens', () {
    expect(AiChatStreamingText.tokenize('Salom dunyo'), [
      'Salo',
      'm',
      ' ',
      'duny',
      'o',
    ]);
  });

  testWidgets(
    'animated reply reveals full text instead of showing it at once',
    (tester) async {
      const text = 'Sizga mos uchta kurs topdim';
      await tester.pumpWidget(
        _testApp(
          child: AiChatStreamingText(
            text: text,
            animate: true,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            caretColor: Colors.pink,
          ),
        ),
      );

      expect(find.text(text, findRichText: true), findsNothing);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.text(text, findRichText: true), findsNothing);

      await tester.pump(
        AiChatStreamingText.durationFor(
          AiChatStreamingText.tokenize(text).length,
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));

      expect(find.text(text, findRichText: true), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('assistant markdown hides raw markers', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: AiChatMessageBubble(
          message: AiChatMessageModel(
            id: 'a-md',
            role: AiChatMessageRole.assistant,
            content: 'Sizga mos **uchta** kurs:',
            createdAt: DateTime(2026, 8, 19),
          ),
          onCourseTap: (_) {},
          onRetry: () {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('**uchta**'), findsNothing);
    expect(find.textContaining('uchta', findRichText: true), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('assistant links do not use text decoration', (tester) async {
    await tester.pumpWidget(
      _testApp(
        child: const AiChatMarkdownBody(
          data: '[Qizlar Akademiyasi](https://qizlaracademy.uz)',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );

    final markdown = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdown.styleSheet?.a?.decoration, TextDecoration.none);
  });

  testWidgets('history assistant bubble shows full text immediately', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        child: AiChatMessageBubble(
          message: AiChatMessageModel(
            id: 'a-1',
            role: AiChatMessageRole.assistant,
            content: 'Tarixiy javob',
            createdAt: DateTime(2026, 8, 19),
          ),
          onCourseTap: (_) {},
          onRetry: () {},
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Tarixiy javob', findRichText: true), findsOneWidget);
  });

  testWidgets('course results animate only after the reply is fully revealed', (
    tester,
  ) async {
    const text = 'Sizga mos kurs topdim';
    await tester.pumpWidget(
      _testApp(
        child: AiChatMessageBubble(
          message: AiChatMessageModel(
            id: 'animated-with-course',
            role: AiChatMessageRole.assistant,
            content: text,
            createdAt: DateTime(2026, 8, 20),
            animateReveal: true,
            courses: const [
              AiChatCourseModel(
                id: 'course-1',
                title: 'Grafik dizayn',
                mentorName: 'Madina Karimova',
                imageUrl: '',
              ),
            ],
          ),
          onCourseTap: (_) {},
          onRetry: () {},
        ),
      ),
    );

    expect(find.byKey(const ValueKey('ai-chat-course-reveal-0')), findsNothing);

    await tester.pump(
      AiChatStreamingText.durationFor(
        AiChatStreamingText.tokenize(text).length,
      ),
    );
    await tester.pump(const Duration(milliseconds: 16));

    final reveal = find.byKey(const ValueKey('ai-chat-course-reveal-0'));
    expect(reveal, findsOneWidget);
    final initialOpacity = tester.widget<Opacity>(reveal).opacity;
    await tester.pump(const Duration(milliseconds: 220));
    expect(tester.widget<Opacity>(reveal).opacity, greaterThan(initialOpacity));
  });

  testWidgets('assistant bubble does not replay after remount when settled', (
    tester,
  ) async {
    final settled = <String>{};
    Widget bubble() {
      return AiChatMessageBubble(
        message: AiChatMessageModel(
          id: 'a-1',
          role: AiChatMessageRole.assistant,
          content: 'Sizga mos uchta kurs topdim',
          createdAt: DateTime(2026, 8, 19),
          animateReveal: true,
        ),
        settledRevealIds: settled,
        onCourseTap: (_) {},
        onRetry: () {},
      );
    }

    await tester.pumpWidget(_testApp(child: bubble()));
    await tester.pump();
    expect(settled.contains('a-1'), isTrue);

    await tester.pumpWidget(_testApp(child: const SizedBox.shrink()));
    await tester.pumpWidget(_testApp(child: bubble()));
    await tester.pump();

    expect(
      find.text('Sizga mos uchta kurs topdim', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('streaming text does not restart on same-text rebuild', (
    tester,
  ) async {
    const text = 'Sizga mos uchta kurs topdim';
    Widget stream() {
      return AiChatStreamingText(
        key: const ValueKey('stream'),
        text: text,
        animate: true,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        caretColor: Colors.pink,
      );
    }

    await tester.pumpWidget(_testApp(child: stream()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    await tester.pumpWidget(_testApp(child: stream()));
    await tester.pump();

    expect(find.text(text, findRichText: true), findsNothing);
    expect(find.textContaining('Siz', findRichText: true), findsWidgets);

    await tester.pump(
      AiChatStreamingText.durationFor(
        AiChatStreamingText.tokenize(text).length,
      ),
    );
    await tester.pump(const Duration(milliseconds: 16));
    expect(find.text(text, findRichText: true), findsOneWidget);
  });
}

Widget _testApp({required Widget child}) {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
