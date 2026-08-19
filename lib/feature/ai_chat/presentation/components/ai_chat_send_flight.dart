import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_bubble_metrics.dart';

class AiChatSendFlight {
  AiChatSendFlight(this._vsync);

  final TickerProvider _vsync;
  OverlayEntry? _entry;
  AnimationController? _controller;
  Completer<void>? _running;

  bool get isActive => _controller?.isAnimating ?? false;

  Future<void> play({
    required BuildContext context,
    required String text,
    required TextStyle textStyle,
    required Color bubbleColor,
    required Rect sourceRect,
    required Rect destRect,
    required BorderRadius endRadius,
  }) async {
    dispose();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null || sourceRect.isEmpty || destRect.isEmpty) {
      return;
    }

    final controller = AnimationController(
      vsync: _vsync,
      duration: AiChatBubbleMetrics.sendFlightDuration,
    );
    _controller = controller;
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    final startRadius = BorderRadius.circular(
      AiChatBubbleMetrics.composerFieldRadius,
    );
    final completer = Completer<void>();
    _running = completer;

    _entry = OverlayEntry(
      builder: (context) {
        return IgnorePointer(
          child: SizedBox.expand(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final t = animation.value;
                final rect = Rect.lerp(sourceRect, destRect, t)!;
                final radius = BorderRadius.lerp(startRadius, endRadius, t)!;
                return Stack(
                  children: [
                    Positioned(
                      left: rect.left,
                      top: rect.top,
                      width: rect.width.clamp(1, double.infinity),
                      height: rect.height.clamp(1, double.infinity),
                      child: DecoratedBox(
                        key: const ValueKey('ai-chat-send-flight'),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: radius,
                        ),
                        child: Padding(
                          padding: AiChatBubbleMetrics.textPadding,
                          child: Text(
                            text,
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                            style: textStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
    overlay.insert(_entry!);
    try {
      await controller.forward();
    } on TickerCanceled {
      // Flight was cancelled by a newer send or dispose.
    } finally {
      _removeEntry();
      if (!identical(_controller, controller)) {
        return;
      }
      controller.dispose();
      _controller = null;
      if (!completer.isCompleted) completer.complete();
      if (identical(_running, completer)) {
        _running = null;
      }
    }
  }

  void dispose() {
    _removeEntry();
    _controller?.dispose();
    _controller = null;
    final running = _running;
    _running = null;
    if (running != null && !running.isCompleted) {
      running.complete();
    }
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }
}
