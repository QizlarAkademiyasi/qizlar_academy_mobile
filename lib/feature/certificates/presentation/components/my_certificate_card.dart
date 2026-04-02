import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_item_model.dart';
import 'package:qizlar_academy_mobile/feature/certificates/presentation/components/my_certificate_tier_badge.dart';

class MyCertificateCard extends StatelessWidget {
  const MyCertificateCard({
    super.key,
    required this.item,
    required this.badgeLabel,
    required this.subtitle,
    required this.categoryIcon,
    required this.viewLabel,
    required this.onView,
    required this.onDownload,
  });

  final CertificateItemModel item;
  final String badgeLabel;
  final String? subtitle;
  final IconData categoryIcon;
  final String viewLabel;
  final VoidCallback onView;
  final VoidCallback onDownload;

  static const Color _iconWell = Color(0xFFFFE8DC);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: _iconWell, borderRadius: AppRadius.radiusSm),
                      child: Icon(categoryIcon, size: 22, color: AppColors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  item.courseName,
                  style: context.textTheme.bodyLargeSemibold.copyWith(color: context.appColors.text, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.secondaryGrey, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onView,
                        icon: Icon(LucideIcons.eye, size: 18, color: AppColors.white),
                        label: Text(viewLabel, style: context.textTheme.bodyMediumSemibold.copyWith(color: AppColors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: context.appColors.stroke.withValues(alpha: 0.35),
                      borderRadius: AppRadius.radiusSm,
                      child: InkWell(
                        borderRadius: AppRadius.radiusSm,
                        onTap: onDownload,
                        child: SizedBox(width: 48, height: 48, child: Icon(LucideIcons.download, size: 22, color: context.appColors.text)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: MyCertificateTierBadge(tier: item.tier, label: badgeLabel),
          ),
        ],
      ),
    );
  }
}
