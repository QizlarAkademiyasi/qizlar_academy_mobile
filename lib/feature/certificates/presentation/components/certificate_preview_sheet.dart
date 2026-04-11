import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/components/certificate_pdf_preview.dart';

class CertificatePreviewSheet extends StatelessWidget {
  const CertificatePreviewSheet({
    super.key,
    required this.item,
    required this.heading,
    required this.description,
    required this.downloadLabel,
    required this.onDownload,
    this.onInstagramStory,
    required this.onShare,
    this.openCertificatesLabel,
    this.onOpenCertificates,
  });

  final CertificateItemModel item;
  final String heading;
  final String description;
  final String downloadLabel;
  final VoidCallback onDownload;
  final VoidCallback? onInstagramStory;
  final VoidCallback onShare;
  final String? openCertificatesLabel;
  final VoidCallback? onOpenCertificates;

  static Future<void> open(
    BuildContext context, {
    required CertificateItemModel item,
    required String heading,
    required String description,
    required String downloadLabel,
    required VoidCallback onDownload,
    VoidCallback? onInstagramStory,
    required VoidCallback onShare,
    String? openCertificatesLabel,
    VoidCallback? onOpenCertificates,
  }) {
    return showAppBottomSheet<void>(
      context,
      child: CertificatePreviewSheet(
        item: item,
        heading: heading,
        description: description,
        downloadLabel: downloadLabel,
        onDownload: onDownload,
        onInstagramStory: onInstagramStory,
        onShare: onShare,
        openCertificatesLabel: openCertificatesLabel,
        onOpenCertificates: onOpenCertificates,
      ),
    );
  }

  bool get _likelyImage {
    final u = item.fileUrl.toLowerCase();
    return u.endsWith('.png') || u.endsWith('.jpg') || u.endsWith('.jpeg') || u.endsWith('.webp') || u.contains('/image');
  }

  static const double _previewHeight = 226;

  Widget _buildPreview(BuildContext context) {
    if (item.fileUrl.isEmpty) {
      return _previewFallback(context);
    }
    if (_likelyImage) {
      return AppCachedNetworkImage(
        imageUrl: item.fileUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => ColoredBox(
          color: context.appColors.stroke,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, _, _) => _previewFallback(context),
      );
    }
    return CertificatePdfPreview(fileUrl: item.fileUrl, errorFallback: _previewFallback(context));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final maxScrollViewport = (mq.size.height * 0.72).clamp(280.0, 720.0);
    return AppBottomSheetContainer(
      title: null,
      showHandle: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxScrollViewport),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: AppRadius.radiusXl,
                child: SizedBox(height: _previewHeight, width: double.infinity, child: _buildPreview(context)),
              ),
              const SizedBox(height: 18),
              Text(
                heading,
                textAlign: TextAlign.center,
                style: context.textTheme.heading6.copyWith(color: context.appColors.text),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmallMedium.copyWith(color: context.appColors.secondaryGrey),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton.elevated(
                      label: downloadLabel,
                      onPressed: () {
                        Navigator.of(context).pop();
                        WidgetsBinding.instance.addPostFrameCallback((_) => onDownload());
                      },
                      expand: true,
                      applyTabletMaxWidth: false,
                      height: 52,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: context.textTheme.bodyMediumSemibold.copyWith(color: AppColors.white),
                    ),
                  ),
                  // if (onInstagramStory != null) ...[
                  //   const SizedBox(width: 10),
                  //   Material(
                  //     color: context.appColors.stroke.withValues(alpha: 0.35),
                  //     borderRadius: AppRadius.radiusSm,
                  //     child: InkWell(
                  //       borderRadius: AppRadius.radiusSm,
                  //       onTap: () {
                  //         Navigator.of(context).pop();
                  //         WidgetsBinding.instance.addPostFrameCallback((_) => onInstagramStory!());
                  //       },
                  //       child: SizedBox(width: 52, height: 52, child: Icon(LucideIcons.instagram, size: 22, color: const Color(0xFFE4405F))),
                  //     ),
                  //   ),
                  // ],
                  const SizedBox(width: 10),
                  Material(
                    color: context.appColors.stroke.withValues(alpha: 0.35),
                    borderRadius: AppRadius.radiusSm,
                    child: InkWell(
                      borderRadius: AppRadius.radiusSm,

                      onTap: () {
                        Navigator.of(context).pop();
                        WidgetsBinding.instance.addPostFrameCallback((_) => onShare());
                      },
                      child: SizedBox(width: 52, height: 52, child: Icon(LucideIcons.share, size: 22, color: context.appColors.text)),
                    ),
                  ),
                ],
              ),
              if (onOpenCertificates != null && (openCertificatesLabel ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                PrimaryButton.outlined(
                  label: openCertificatesLabel!.trim(),
                  onPressed: () {
                    Navigator.of(context).pop();
                    WidgetsBinding.instance.addPostFrameCallback((_) => onOpenCertificates!());
                  },
                  expand: true,
                  applyTabletMaxWidth: false,
                  height: 52,
                  foregroundColor: AppColors.primary,
                  borderColor: AppColors.primary,
                  textStyle: context.textTheme.bodyMediumSemibold.copyWith(color: AppColors.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewFallback(BuildContext context) {
    return ColoredBox(
      color: context.appColors.stroke,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.fileBadge, size: 40, color: context.appColors.grey),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                item.courseName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
