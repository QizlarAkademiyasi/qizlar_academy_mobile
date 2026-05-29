import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/certificates/data/service/certificate_file_actions.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/repository/course_certificate_claim_repository.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/components/certificate_preview_sheet.dart';

/// Oxirgi modul oxirgi dars testidan muvaffaqiyatli o‘tgach: sertifikat API + [CertificatePreviewSheet].
Future<void> showCourseCertificateAfterTerminalQuiz(
  BuildContext context, {
  required String courseId,
  required String courseName,
}) async {
  final id = courseId.trim();
  if (id.isEmpty) return;

  final l10n = context.l10n;
  try {
    final item = await getIt<CourseCertificateClaimRepository>().claimForCourse(courseId: id, courseDisplayName: courseName);
    if (!context.mounted) return;

    final nav = context;
    await CertificatePreviewSheet.open(
      context,
      item: item,
      heading: l10n.certificatesSheetHeading(item.courseName),
      description: l10n.certificatesSheetDescription,
      downloadLabel: l10n.certificatesSheetDownload,
      onDownload: () async {
        if (item.fileUrl.isEmpty) {
          if (nav.mounted) {
            ScaffoldMessenger.of(nav).showSnackBar(SnackBar(content: Text(nav.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
          }
          return;
        }
        try {
          await getIt<CertificateFileActions>().downloadAndShare(item.fileUrl, fileBaseName: 'certificate_${item.id}');
        } catch (_) {
          if (nav.mounted) {
            ScaffoldMessenger.of(nav).showSnackBar(SnackBar(content: Text(nav.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
          }
        }
      },
      onShare: () async {
        try {
          final name = item.courseName.trim().isNotEmpty ? 'certificate_${item.courseName}' : 'certificate_${item.id}';
          await getIt<CertificateFileActions>().downloadCertificatePngAndShare(item.courseId, fileBaseName: name);
        } catch (_) {
          if (nav.mounted) {
            ScaffoldMessenger.of(nav).showSnackBar(SnackBar(content: Text(nav.l10n.certificatesFileActionError), behavior: SnackBarBehavior.floating));
          }
        }
      },
      openCertificatesLabel: l10n.profileMenuCertificates,
      onOpenCertificates: () {
        if (nav.mounted) nav.push(Routes.myCertificates);
      },
    );
  } catch (e, st) {
    AppLogger.e('showCourseCertificateAfterTerminalQuiz: claim failed', error: e, stackTrace: st);
    if (context.mounted) {
      AppToast.error(context, message: l10n.certificateClaimError);
    }
  }
}
