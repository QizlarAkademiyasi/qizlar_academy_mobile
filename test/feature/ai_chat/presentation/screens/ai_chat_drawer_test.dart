import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/text_styles.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/app_options.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_bootstrap_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_conversation_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/repository/ai_chat_repository.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/screens/ai_chat_screen.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<AiChatBloc>(
      () => AiChatBloc(const _DrawerTestRepository()),
    );
  });

  tearDown(() => getIt.reset());

  testWidgets('menu pushes and scales chat, then surface tap closes drawer', (
    tester,
  ) async {
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    expect(scaffold.resizeToAvoidBottomInset, isTrue);

    final mainSurface = find.byKey(const ValueKey('ai-chat-main-surface'));
    final initialRect = tester.getRect(mainSurface);

    await tester.tap(find.byKey(const ValueKey('ai-chat-open-drawer')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 170));

    final animatedRect = tester.getRect(mainSurface);
    expect(animatedRect.left, greaterThan(initialRect.left));
    expect(animatedRect.width, lessThan(initialRect.width));

    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('ai-chat-side-drawer')), findsOneWidget);

    await tester.tapAt(const Offset(365, 420));
    await tester.pumpAndSettle();

    expect(tester.getRect(mainSurface).left, closeTo(0, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('edge swipe opens drawer without narrow-screen overflow', (
    tester,
  ) async {
    await _setViewport(tester, const Size(320, 700));
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(2, 350));
    await gesture.moveBy(const Offset(250, 0));
    await gesture.up();
    await tester.pumpAndSettle();

    final mainRect = tester.getRect(
      find.byKey(const ValueKey('ai-chat-main-surface')),
    );
    expect(mainRect.left, greaterThan(200));
    expect(
      find.byKey(const ValueKey('ai-chat-drawer-new-conversation')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('drawer lists conversations and opens selected history', (
    tester,
  ) async {
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('ai-chat-open-drawer')));
    await tester.pumpAndSettle();

    expect(find.text('Grafik dizayn'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('ai-chat-conversation-tile-conv-drawer')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dizayn kursi kerak'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp() {
  return AppThemeProvider(
    builder: (context) => MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppOptions.lightThemeData(context),
      home: const AiChatScreen(),
    ),
  );
}

class _DrawerTestRepository implements AiChatRepository {
  const _DrawerTestRepository();

  @override
  Future<AiChatBootstrapModel> bootstrap() async {
    return const AiChatBootstrapModel(conversationId: null, messages: []);
  }

  static final _conversationDate = DateTime.utc(2026, 8, 15);

  @override
  Future<AiChatConversationsPageModel> getConversations({
    required int pageNumber,
    int pageSize = 20,
  }) async {
    return AiChatConversationsPageModel(
      items: [
        AiChatConversationModel(
          id: 'conv-drawer',
          title: 'Grafik dizayn',
          createdAt: _conversationDate,
          updatedAt: _conversationDate,
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
    return [
      AiChatMessageModel(
        id: 'msg-1',
        role: AiChatMessageRole.user,
        content: 'Dizayn kursi kerak',
        createdAt: _conversationDate,
      ),
    ];
  }

  @override
  Future<AiChatSendResultModel> sendMessage({
    required String? conversationId,
    required String clientMessageId,
    required String message,
  }) {
    throw UnimplementedError();
  }
}
