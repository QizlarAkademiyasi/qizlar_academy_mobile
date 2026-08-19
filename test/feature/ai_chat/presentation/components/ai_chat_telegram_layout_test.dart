import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_course_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_bubble_metrics.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_composer.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_course_card.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_bubble.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_message_list.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_send_flight.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';

void main() {
  test('grouped outgoing radii use tail and merged corners', () {
    final isolated = AiChatBubbleMetrics.outgoing(
      isGroupStart: true,
      isGroupEnd: true,
    );
    expect(
      isolated.bottomRight,
      const Radius.circular(AiChatBubbleMetrics.tail),
    );
    expect(
      isolated.topRight,
      const Radius.circular(AiChatBubbleMetrics.corner),
    );

    final grouped = AiChatBubbleMetrics.groupingAt([
      _user('1', 'Salom'),
      _user('2', 'Yana'),
    ], 1);
    expect(grouped.isGroupStart, isFalse);
    expect(grouped.isGroupEnd, isTrue);
    expect(grouped.spacingBefore, AiChatBubbleMetrics.groupedSpacing);
  });

  testWidgets('reverse list keeps the newest message at the bottom', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _testApp(
        child: AiChatMessageList(
          controller: controller,
          messages: [_user('old', 'Eski xabar'), _user('new', 'Yangi xabar')],
          isSending: false,
          onCourseTap: (_) {},
          onRetry: (_) {},
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getTopLeft(find.text('Yangi xabar')).dy,
      greaterThan(tester.getTopLeft(find.text('Eski xabar')).dy),
    );
    expect(controller.offset, 0);
  });

  testWidgets('hydrated history shows course cards under assistant text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        child: AiChatMessageBubble(
          message: AiChatMessageModel(
            id: 'a-1',
            role: AiChatMessageRole.assistant,
            content: 'Sizga mos kurs:',
            createdAt: DateTime(2026, 8, 19),
            recommendedCourseIds: const ['course-1'],
            courses: const [
              AiChatCourseModel(
                id: 'course-1',
                title: 'Grafik dizayn',
                mentorName: 'Madina Karimova',
                imageUrl: '',
                rating: 3.4,
                totalRatings: 5,
                durationMinutes: 4190,
              ),
            ],
          ),
          onCourseTap: (_) {},
          onRetry: () {},
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AiChatCourseCard), findsOneWidget);
    expect(find.byType(HomeCourseCard), findsOneWidget);
    expect(find.text('Grafik dizayn'), findsOneWidget);
    expect(find.text('Madina Karimova'), findsOneWidget);
    expect(find.text('3.4 (5)'), findsOneWidget);
    expect(find.text('69 soat 50 daqiqa'), findsOneWidget);
  });

  testWidgets('send flight overlay appears then settles', (tester) async {
    await tester.pumpWidget(_testApp(child: const _SendFlightHarness()));
    await tester.tap(find.byKey(const ValueKey('fly')));
    await tester.pump();

    expect(find.byKey(const ValueKey('ai-chat-send-flight')), findsOneWidget);
    expect(find.text('Salom'), findsWidgets);

    await tester.pumpAndSettle(AiChatBubbleMetrics.sendFlightDuration);

    expect(find.byKey(const ValueKey('ai-chat-send-flight')), findsNothing);
    expect(find.text('landed'), findsOneWidget);
  });

  testWidgets('composer stays visible when keyboard insets are applied', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    Widget buildChat({required double keyboard}) {
      return _testApp(
        child: Column(
          children: [
            const Expanded(child: SizedBox.expand()),
            SafeArea(
              top: false,
              bottom: keyboard <= 0,
              child: AiChatComposer(
                controller: controller,
                focusNode: focusNode,
                isEnabled: true,
                isSending: false,
                onSend: () {},
              ),
            ),
            SizedBox(height: keyboard),
          ],
        ),
      );
    }

    await tester.pumpWidget(buildChat(keyboard: 0));
    await tester.pump();
    final before = tester.getRect(find.byType(AiChatComposer));

    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(buildChat(keyboard: 280));
    await tester.pump();

    final after = tester.getRect(find.byType(AiChatComposer));
    expect(after.bottom, lessThan(before.bottom));
    expect(find.byKey(const ValueKey('ai-chat-send')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

AiChatMessageModel _user(String id, String text) {
  return AiChatMessageModel(
    id: id,
    role: AiChatMessageRole.user,
    content: text,
    createdAt: DateTime(2026, 8, 19),
  );
}

class _SendFlightHarness extends StatefulWidget {
  const _SendFlightHarness();

  @override
  State<_SendFlightHarness> createState() => _SendFlightHarnessState();
}

class _SendFlightHarnessState extends State<_SendFlightHarness>
    with TickerProviderStateMixin {
  late final AiChatSendFlight _flight;
  var _landed = false;

  @override
  void initState() {
    super.initState();
    _flight = AiChatSendFlight(this);
  }

  @override
  void dispose() {
    _flight.dispose();
    super.dispose();
  }

  Future<void> _fly() async {
    await _flight.play(
      context: context,
      text: 'Salom',
      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
      bubbleColor: Colors.pink,
      sourceRect: const Rect.fromLTWH(20, 700, 80, 36),
      destRect: const Rect.fromLTWH(220, 400, 120, 44),
      endRadius: AiChatBubbleMetrics.outgoing(
        isGroupStart: true,
        isGroupEnd: true,
      ),
    );
    if (mounted) setState(() => _landed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_landed) const Text('landed'),
        Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            key: const ValueKey('fly'),
            onPressed: _fly,
            child: const Text('fly'),
          ),
        ),
      ],
    );
  }
}

Widget _testApp({required Widget child}) {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(body: child),
    ),
  );
}
