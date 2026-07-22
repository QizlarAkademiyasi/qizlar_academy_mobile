import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_share_links.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_post_model.dart';

abstract final class PortfolioShare {
  PortfolioShare._();

  static Future<void> share(
    BuildContext context,
    PortfolioPostModel post,
  ) async {
    final url = AppShareLinks.portfolioPostHttpsUrl(post.id);
    final caption = post.caption.trim();
    final text = caption.isEmpty
        ? context.l10n.portfolioShareMessageWithoutCaption(url)
        : context.l10n.portfolioShareMessage(caption, url);
    final renderBox = context.findRenderObject();
    final origin = renderBox is RenderBox && renderBox.hasSize
        ? renderBox.localToGlobal(Offset.zero) & renderBox.size
        : null;

    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: context.l10n.portfolioShareSubject,
          sharePositionOrigin: origin,
        ),
      );
      if (result.status == ShareResultStatus.unavailable) {
        AppLogger.w('Portfolio share unavailable: ${post.id}');
        if (!context.mounted) return;
        AppToast.error(context, message: context.l10n.portfolioShareError);
      }
    } catch (error, stackTrace) {
      AppLogger.e(
        'Portfolio share failed: ${post.id}',
        error: error,
        stackTrace: stackTrace,
      );
      if (!context.mounted) return;
      AppToast.error(context, message: context.l10n.portfolioShareError);
    }
  }
}
