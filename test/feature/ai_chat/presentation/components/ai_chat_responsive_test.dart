import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_composer.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_welcome_content.dart';

void main() {
  testWidgets('welcome greeting stays visible on a narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_testApp(child: const AiChatWelcomeContent()));
    await tester.pump();

    expect(find.textContaining('Assalomu alaykum'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('composer expands for long text and keeps send action visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      _testApp(
        child: AiChatComposer(
          controller: controller,
          focusNode: focusNode,
          isEnabled: true,
          isSending: false,
          onSend: () {},
        ),
      ),
    );
    final initialHeight = tester.getSize(find.byType(TextField)).height;

    await tester.enterText(
      find.byKey(const ValueKey('ai-chat-input')),
      'Bu uzun savol bir necha qatorda ko‘rinishi va composer balandligini '
      'ekranni buzmasdan oshirishi kerak. Yana bir oz matn.',
    );
    await tester.pump();

    expect(
      tester.getSize(find.byType(TextField)).height,
      greaterThan(initialHeight),
    );
    expect(find.byKey(const ValueKey('ai-chat-send')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _testApp({required Widget child}) {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppOptions.lightThemeData(context),
      home: Scaffold(body: SizedBox.expand(child: child)),
    ),
  );
}
