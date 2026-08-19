import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/domain/model/ai_chat_message_model.dart';

/// Telegram iOS-style bubble geometry for AI chat.
abstract final class AiChatBubbleMetrics {
  static const double corner = 18;
  static const double tail = 5;
  static const double merged = 8;
  static const double groupedSpacing = 3;
  static const double groupSpacing = 8;
  static const double listInset = 8;
  static const double listTopPadding = 16;
  static const double listBottomPadding = 10;
  static const double outgoingMaxWidthFactor = 0.78;
  static const double incomingMaxWidthFactor = 0.86;
  static const double composerFieldRadius = 31;
  static const Duration sendFlightDuration = Duration(milliseconds: 280);
  static const EdgeInsets textPadding = EdgeInsets.symmetric(
    horizontal: 11,
    vertical: 8,
  );

  static BorderRadius outgoing({
    required bool isGroupStart,
    required bool isGroupEnd,
  }) {
    return BorderRadius.only(
      topLeft: const Radius.circular(corner),
      topRight: Radius.circular(isGroupStart ? corner : merged),
      bottomLeft: const Radius.circular(corner),
      bottomRight: Radius.circular(isGroupEnd ? tail : merged),
    );
  }

  static BorderRadius incoming({
    required bool isGroupStart,
    required bool isGroupEnd,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(isGroupStart ? corner : merged),
      topRight: const Radius.circular(corner),
      bottomLeft: Radius.circular(isGroupEnd ? tail : merged),
      bottomRight: const Radius.circular(corner),
    );
  }

  static AiChatBubbleGroup groupingAt(
    List<AiChatMessageModel> messages,
    int chronologicalIndex,
  ) {
    final current = messages[chronologicalIndex];
    final withPrevious =
        chronologicalIndex > 0 &&
        messages[chronologicalIndex - 1].role == current.role;
    final withNext =
        chronologicalIndex < messages.length - 1 &&
        messages[chronologicalIndex + 1].role == current.role;
    return AiChatBubbleGroup(
      isGroupStart: !withPrevious,
      isGroupEnd: !withNext,
      spacingBefore: chronologicalIndex == 0
          ? 0
          : (withPrevious ? groupedSpacing : groupSpacing),
    );
  }

  static Size measureText({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 4,
    )..layout(maxWidth: maxWidth.clamp(1, double.infinity));
    return painter.size;
  }

  static Rect inflateTextRect(Rect textRect) {
    return Rect.fromLTWH(
      textRect.left - textPadding.left,
      textRect.top - textPadding.top,
      textRect.width + textPadding.horizontal,
      textRect.height + textPadding.vertical,
    );
  }
}

class AiChatBubbleGroup {
  const AiChatBubbleGroup({
    required this.isGroupStart,
    required this.isGroupEnd,
    required this.spacingBefore,
  });

  final bool isGroupStart;
  final bool isGroupEnd;
  final double spacingBefore;
}
