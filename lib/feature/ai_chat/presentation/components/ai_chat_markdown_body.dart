import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

class AiChatMarkdownBody extends StatelessWidget {
  const AiChatMarkdownBody({
    super.key,
    required this.data,
    required this.style,
  });

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final strong = style.copyWith(
      fontWeight: FontWeight.w700,
      color: colors.text,
    );
    return SelectionArea(
      child: MarkdownBody(
        data: data,
        selectable: false,
        fitContent: true,
        softLineBreak: true,
        listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
        styleSheet: MarkdownStyleSheet(
          textScaler: MediaQuery.textScalerOf(context),
          p: style,
          pPadding: EdgeInsets.zero,
          blockSpacing: 8,
          strong: strong,
          em: style.copyWith(fontStyle: FontStyle.italic),
          a: style.copyWith(
            color: colors.primary,
            decoration: TextDecoration.none,
          ),
          listBullet: style,
          listIndent: 22,
          listBulletPadding: const EdgeInsets.only(right: 8),
          orderedListAlign: WrapAlignment.start,
          unorderedListAlign: WrapAlignment.start,
          h1: style.copyWith(
            fontSize: (style.fontSize ?? 16) + 4,
            fontWeight: FontWeight.w700,
          ),
          h2: style.copyWith(
            fontSize: (style.fontSize ?? 16) + 2,
            fontWeight: FontWeight.w700,
          ),
          h3: strong,
          h1Padding: const EdgeInsets.only(bottom: 6),
          h2Padding: const EdgeInsets.only(bottom: 4),
          h3Padding: const EdgeInsets.only(bottom: 4),
          code: style.copyWith(
            fontFamily: 'monospace',
            backgroundColor: colors.stroke.withValues(alpha: 0.35),
          ),
          codeblockPadding: const EdgeInsets.all(10),
          codeblockDecoration: BoxDecoration(
            color: colors.stroke.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(12),
          ),
          blockquote: style.copyWith(color: colors.secondaryGrey),
          blockquoteDecoration: BoxDecoration(
            border: Border(left: BorderSide(color: colors.primary, width: 3)),
          ),
          blockquotePadding: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
        ),
        sizedImageBuilder: (config) {
          final label = (config.alt ?? config.title ?? '').trim();
          if (label.isEmpty) return const SizedBox.shrink();
          return Text(label, style: style);
        },
        onTapLink: (text, href, title) {
          if (href == null || href.isEmpty) return;
          final uri = Uri.tryParse(href);
          if (uri == null || !(uri.isScheme('https') || uri.isScheme('http'))) {
            return;
          }
          launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ),
    );
  }
}
