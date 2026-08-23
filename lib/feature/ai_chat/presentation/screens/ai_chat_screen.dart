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
    with TickerProviderStateMixin<_AiChatView>, AiChatScreenMixin<_AiChatView> {
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
        resizeToAvoidBottomInset: false,
        backgroundColor: dark
            ? const Color(0xFF3C0C25)
            : const Color(0xFFE8357D),
        body: BlocConsumer<AiChatBloc, AiChatState>(
          listenWhen: (previous, current) =>
              previous.messages.length != current.messages.length ||
              previous.isSending != current.isSending ||
              previous.sendErrorNonce != current.sendErrorNonce ||
              previous.conversationId != current.conversationId ||
              previous.isLoadingConversation != current.isLoadingConversation,
          listener: aiChatBlocListener,
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final drawerWidth = constraints.maxWidth < 410
                    ? constraints.maxWidth * 0.78
                    : 320.0;
                return AnimatedBuilder(
                  animation: drawerController,
                  builder: (context, _) {
                    final progress = drawerController.value;
                    final scale = 1 - (0.08 * progress);
                    final radius = 30 * progress;
                    return PopScope(
                      canPop: progress <= 0.001,
                      onPopInvokedWithResult: (didPop, _) {
                        handleSystemBack(didPop);
                      },
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: dark
                                      ? const [
                                          Color(0xFF24101B),
                                          Color(0xFF5B1237),
                                        ]
                                      : const [
                                          Color(0xFFE8357D),
                                          Color(0xFF9F2056),
                                        ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: drawerWidth,
                            child: buildSideDrawer(context, state),
                          ),
                          Transform.translate(
                            offset: Offset(drawerWidth * progress, 0),
                            child: Transform.scale(
                              scale: scale,
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                key: const ValueKey('ai-chat-main-surface'),
                                behavior: HitTestBehavior.opaque,
                                onTap: progress > 0 ? closeDrawer : null,
                                onHorizontalDragStart: progress > 0
                                    ? handleDrawerDragStart
                                    : null,
                                onHorizontalDragUpdate: progress > 0
                                    ? (details) => handleDrawerDragUpdate(
                                        details,
                                        drawerWidth: drawerWidth,
                                      )
                                    : null,
                                onHorizontalDragEnd: progress > 0
                                    ? handleDrawerDragEnd
                                    : null,
                                child: AbsorbPointer(
                                  absorbing: progress > 0,
                                  child: ExcludeSemantics(
                                    excluding: progress > 0.5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          radius,
                                        ),
                                        boxShadow: progress > 0
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(
                                                        alpha: 0.28 * progress,
                                                      ),
                                                  blurRadius: 34 * progress,
                                                  offset: Offset(
                                                    -8 * progress,
                                                    10 * progress,
                                                  ),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          radius,
                                        ),
                                        child: _buildChatSurface(
                                          context,
                                          state,
                                          dark: dark,
                                          drawerProgress: progress,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            key: const ValueKey('ai-chat-edge-drag-area'),
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: 24,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onHorizontalDragStart: handleDrawerDragStart,
                              onHorizontalDragUpdate: (details) =>
                                  handleDrawerDragUpdate(
                                    details,
                                    drawerWidth: drawerWidth,
                                  ),
                              onHorizontalDragEnd: handleDrawerDragEnd,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatSurface(
    BuildContext context,
    AiChatState state, {
    required bool dark,
    required double drawerProgress,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0, 0.54, 1],
          colors: dark
              ? const [Color(0xFF101010), Color(0xFF121011), Color(0xFF5B1237)]
              : const [
                  AppColors.lightBackground,
                  Color(0xFFFFF7FA),
                  Color(0xFFFFD8E8),
                ],
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              buildHeader(context, state),
              Expanded(child: buildBody(context, state)),
              SafeArea(
                top: false,
                bottom: MediaQuery.viewInsetsOf(context).bottom <= 0,
                child: buildComposer(context, state),
              ),
              SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
            ],
          ),
          if (drawerProgress > 0)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.08 * drawerProgress),
              ),
            ),
        ],
      ),
    );
  }
}
