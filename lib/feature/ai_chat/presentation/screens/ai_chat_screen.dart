import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/bloc/ai_chat_bloc.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/screens/ai_chat_screen_mixin.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AiChatBloc>()..add(const AiChatStarted()),
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView();

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView>
    with AiChatScreenMixin<_AiChatView> {
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final overlay = dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: dark
            ? const Color(0xFF4B102D)
            : const Color(0xFFFFE3EF),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0, 0.54, 1],
              colors: dark
                  ? const [
                      Color(0xFF101010),
                      Color(0xFF121011),
                      Color(0xFF5B1237),
                    ]
                  : const [
                      AppColors.lightBackground,
                      Color(0xFFFFF7FA),
                      Color(0xFFFFD8E8),
                    ],
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<AiChatBloc, AiChatState>(
              listenWhen: (previous, current) =>
                  previous.messages.length != current.messages.length ||
                  previous.isSending != current.isSending ||
                  previous.sendErrorNonce != current.sendErrorNonce,
              listener: aiChatBlocListener,
              builder: (context, state) {
                return Column(
                  children: [
                    buildHeader(context),
                    Expanded(child: buildBody(context, state)),
                    buildComposer(context, state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
