import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

const Color _privacyLinkBlue = Color(0xFF60A5FA);

class PrivacyPolicyMarkdownView extends StatelessWidget {
  const PrivacyPolicyMarkdownView({super.key, required this.markdown});

  final String markdown;

  MarkdownStyleSheet _styleSheet(BuildContext context) {
    final colors = context.appColors;
    final tt = context.textTheme;
    final body = tt.bodyLargeRegular.copyWith(color: colors.secondaryGrey, height: 1.5);
    final h2Base = tt.bodyLargeSemibold.copyWith(color: colors.text, height: 1.25);
    return MarkdownStyleSheet(
      textScaler: MediaQuery.textScalerOf(context),
      blockSpacing: 0,
      h1: const TextStyle(fontSize: 0, height: 0),
      h1Padding: EdgeInsets.zero,
      h2: h2Base,
      h2Padding: EdgeInsets.zero,
      p: body,
      pPadding: const EdgeInsets.only(bottom: 12),
      strong: tt.bodyLargeSemibold.copyWith(color: AppColors.primary, height: 1.5),
      a: body.copyWith(
        color: _privacyLinkBlue,
        decoration: TextDecoration.underline,
        decorationColor: _privacyLinkBlue,
      ),
      listBullet: body.copyWith(color: colors.secondaryGrey),
      listIndent: 22,
      listBulletPadding: const EdgeInsets.only(right: 8),
      unorderedListAlign: WrapAlignment.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      selectable: false,
      fitContent: true,
      listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
      softLineBreak: true,
      styleSheet: _styleSheet(context),
      builders: <String, MarkdownElementBuilder>{
        'h1': CollapseH1MarkdownBuilder(),
        'h2': PinkBarH2MarkdownBuilder(barColor: context.appColors.primary),
      },
      onTapLink: (text, href, title) {
        if (href == null || href.isEmpty) return;
        final uri = Uri.tryParse(href);
        if (uri == null) return;
        launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}
