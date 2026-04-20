import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_share_links.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_instagram_story_share.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_tier.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/components/certificate_preview_sheet.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/components/my_certificate_card.dart';
import 'package:qizlar_academy_mobile/feature/courses/presentation/screens/my_courses/presentation/components/my_courses_top_bar.dart';

mixin MyCertificatesScreenMixin<T extends StatefulWidget> on State<T> {
  void onMyCertificatesBackTap(BuildContext context) {
    Gaimon.light();
    context.pop();
  }

  Future<void> onCertificatesCommunityFabTap(BuildContext context) async {
    Gaimon.light();
    final l10n = context.l10n;
    await showAppLinkPromptDialog(
      context,
      title: l10n.communityTelegramInviteTitle,
      description: l10n.communityTelegramInviteDescription,
      negativeLabel: l10n.linkPromptNo,
      positiveLabel: l10n.linkPromptYes,
      uri: Uri.parse(AppShareLinks.telegramCommunityChannel),
      tgsAsset: UiKitAssets.lottie.rabbit.cuttyRabbit,
      tgsSize: 108,
    );
  }

  IconData certificateCategoryIcon(int indexInList) {
    switch (indexInList % 3) {
      case 0:
        return LucideIcons.userRound;
      case 1:
        return LucideIcons.palette;
      default:
        return LucideIcons.codeXml;
    }
  }

  String certificateTierLabel(AppLocalizations l10n, CertificateTier tier) {
    switch (tier) {
      case CertificateTier.gold:
        return l10n.certificatesBadgeGold;
      case CertificateTier.silver:
        return l10n.certificatesBadgeSilver;
      case CertificateTier.bronze:
        return l10n.certificatesBadgeBronze;
    }
  }

  String? certificateSubtitleLine(BuildContext context, CertificateItemModel item) {
    final at = item.createdAt;
    if (at == null) return null;
    return MaterialLocalizations.of(context).formatFullDate(at.toLocal());
  }

  Future<void> onCertificateShareOrDownload(BuildContext context, CertificateItemModel item) async {
    Gaimon.light();
    if (item.fileUrl.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
      }
      return;
    }
    try {
      await getIt<CertificateFileActions>().downloadAndShare(item.fileUrl, fileBaseName: 'certificate_${item.id}');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
      }
    }
  }

  /// Instagram Story: `/api/v1/certificate/image/{courseId}` dan PNG, [appinio_social_share] orqali sticker.
  Future<void> onCertificateInstagramStoryShare(BuildContext context, CertificateItemModel item) async {
    Gaimon.light();
    if (item.courseId.trim().isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
      }
      return;
    }
    final name = item.courseName.trim().isNotEmpty ? 'certificate_${item.courseName}' : 'certificate_${item.id}';
    try {
      await getIt<CertificateInstagramStoryShare>().shareCertificateSticker(item.courseId, fileBaseName: name);
    } on StateError catch (e) {
      if (!context.mounted) return;
      final l10n = context.l10n;
      final text = e.message == 'facebook_app_id_missing' ? l10n.certificatesInstagramStoryNotConfigured : l10n.certificatesInstagramShareFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.certificatesInstagramShareFailed), behavior: SnackBarBehavior.floating));
      }
    }
  }

  /// Bottom sheetdagi ulashish: `/api/v1/certificate/image/{courseId}` dan PNG.
  Future<void> onCertificateImageShare(BuildContext context, CertificateItemModel item) async {
    Gaimon.light();
    if (item.courseId.trim().isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
      }
      return;
    }
    final name = item.courseName.trim().isNotEmpty ? 'certificate_${item.courseName}' : 'certificate_${item.id}';
    try {
      await getIt<CertificateFileActions>().downloadCertificatePngAndShare(item.courseId, fileBaseName: name);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
      }
    }
  }

  Future<void> onCertificateView(BuildContext context, CertificateItemModel item) async {
    Gaimon.light();
    final l10n = context.l10n;
    final parentContext = context;
    await CertificatePreviewSheet.open(
      parentContext,
      item: item,
      heading: l10n.certificatesSheetHeading(item.courseName),
      description: l10n.certificatesSheetDescription,
      downloadLabel: l10n.certificatesSheetDownload,
      onDownload: () => onCertificateShareOrDownload(parentContext, item),
      instagramStoryLabel: l10n.certificatesSheetInstagramStory,
      onInstagramStory: item.courseId.trim().isEmpty ? null : () => onCertificateInstagramStoryShare(parentContext, item),
      onShare: () => onCertificateImageShare(parentContext, item),
    );
  }

  Widget buildMyCertificatesTopBar(BuildContext context) {
    return MyCoursesTopBar(title: context.l10n.profileMenuCertificates, onBackTap: () => onMyCertificatesBackTap(context));
  }

  Widget buildCertificateCard(BuildContext context, CertificateItemModel item, int index) {
    final l10n = context.l10n;
    return MyCertificateCard(
      item: item,
      badgeLabel: certificateTierLabel(l10n, item.tier),
      subtitle: certificateSubtitleLine(context, item),
      categoryIcon: certificateCategoryIcon(index),
      viewLabel: l10n.certificatesView,
      onView: () => onCertificateView(context, item),
      onDownload: () => onCertificateShareOrDownload(context, item),
    );
  }
}
