import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

/// H1 matnini yashiradi (masalan, sarlavha allaqachon [AppBar] da bo‘lsa).
class CollapseH1MarkdownBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return const SizedBox.shrink();
  }
}

/// H2 bo‘lim sarlavhasi — chapda vertikal accent chizig‘i.
class PinkBarH2MarkdownBuilder extends MarkdownElementBuilder {
  PinkBarH2MarkdownBuilder({required this.barColor, this.barWidth = 3, this.gap = 10});

  final Color barColor;
  final double barWidth;
  final double gap;

  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final title = element.textContent.trim();
    final style = preferredStyle ?? const TextStyle();
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: barWidth,
              margin: const EdgeInsets.only(top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: style),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
