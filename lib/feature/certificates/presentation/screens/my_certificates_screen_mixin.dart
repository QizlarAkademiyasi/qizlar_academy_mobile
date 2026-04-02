import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';
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
      await getIt<CertificateFileActions>().downloadAndShare(
        item.fileUrl,
        fileBaseName: 'certificate_${item.id}',
      );
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
      onShare: () => onCertificateShareOrDownload(parentContext, item),
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
