import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/ai_chat/presentation/components/ai_chat_markdown_body.dart';

class AiChatStreamingText extends StatefulWidget {
  const AiChatStreamingText({
    super.key,
    required this.text,
    required this.style,
    required this.caretColor,
    this.animate = false,
    this.footer,
    this.onTick,
    this.onComplete,
  });

  final String text;
  final TextStyle style;
  final Color caretColor;
  final bool animate;
  final Widget? footer;
  final VoidCallback? onTick;
  final VoidCallback? onComplete;

  @visibleForTesting
  static List<String> tokenize(String text) {
    if (text.isEmpty) return const [];
    final tokens = <String>[];
    var index = 0;
    while (index < text.length) {
      final current = text[index];
      if (_isWhitespace(current)) {
        tokens.add(current);
        index += 1;
        continue;
      }
      var end = index + 1;
      while (end < text.length &&
          end < index + 4 &&
          !_isWhitespace(text[end])) {
        end += 1;
      }
      tokens.add(text.substring(index, end));
      index = end;
    }
    return tokens;
  }

  static bool _isWhitespace(String char) {
    final code = char.codeUnitAt(0);
    return code == 0x20 || code == 0x0A || code == 0x0D || code == 0x09;
  }

  @visibleForTesting
  static Duration durationFor(int tokenCount) {
    final tokenMs = tokenCount > 160
        ? 12
        : tokenCount > 80
        ? 16
        : 22;
    return Duration(milliseconds: (tokenCount * tokenMs).clamp(280, 4800));
  }

  @override
  State<AiChatStreamingText> createState() => _AiChatStreamingTextState();
}

class _AiChatStreamingTextState extends State<AiChatStreamingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<String> _tokens;
  var _visible = '';
  var _completed = false;

  @override
  void initState() {
    super.initState();
    _tokens = AiChatStreamingText.tokenize(widget.text);
    _controller = AnimationController(vsync: this)
      ..addListener(_onTick)
      ..addStatusListener(_onStatus);
    _start();
  }

  @override
  void didUpdateWidget(AiChatStreamingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == widget.text) {
      if (oldWidget.animate && !widget.animate && !_completed) {
        _controller.stop();
        setState(() {
          _visible = widget.text;
          _completed = true;
        });
        widget.onComplete?.call();
      }
      return;
    }
    _tokens = AiChatStreamingText.tokenize(widget.text);
    setState(_start);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTick)
      ..removeStatusListener(_onStatus)
      ..dispose();
    super.dispose();
  }

  void _start() {
    _completed = false;
    if (!widget.animate || _tokens.isEmpty) {
      _controller.stop();
      _visible = widget.text;
      _completed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onComplete?.call();
      });
      return;
    }
    _visible = '';
    _controller
      ..duration = AiChatStreamingText.durationFor(_tokens.length)
      ..forward(from: 0);
  }

  void _onTick() {
    if (!mounted || _completed) return;
    final count = (_tokens.length * Curves.linear.transform(_controller.value))
        .round()
        .clamp(0, _tokens.length);
    final next = _tokens.take(count).join();
    final changed = next != _visible;
    setState(() => _visible = next);
    if (changed) widget.onTick?.call();
  }

  void _onStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _completed) return;
    setState(() {
      _visible = widget.text;
      _completed = true;
    });
    widget.onTick?.call();
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final showCaret = widget.animate && !_completed && widget.text.isNotEmpty;
    return Semantics(
      label: widget.text,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.text.isNotEmpty)
            ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_visible.isNotEmpty)
                    AiChatMarkdownBody(data: _visible, style: widget.style),
                  if (showCaret)
                    Padding(
                      padding: EdgeInsets.only(top: _visible.isEmpty ? 0 : 2),
                      child: _StreamingCaret(
                        color: widget.caretColor,
                        elapsed: _controller.lastElapsedDuration,
                      ),
                    ),
                ],
              ),
            ),
          if (widget.footer != null && _completed) ...[
            if (widget.text.isNotEmpty) const SizedBox(height: 10),
            widget.footer!,
          ],
        ],
      ),
    );
  }
}

class _StreamingCaret extends StatelessWidget {
  const _StreamingCaret({required this.color, required this.elapsed});

  final Color color;
  final Duration? elapsed;

  @override
  Widget build(BuildContext context) {
    final visible = ((elapsed?.inMilliseconds ?? 0) ~/ 380).isEven;
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: Opacity(
        opacity: visible ? 1 : 0,
        child: ColoredBox(
          color: color,
          child: const SizedBox(width: 2, height: 16),
        ),
      ),
    );
  }
}
