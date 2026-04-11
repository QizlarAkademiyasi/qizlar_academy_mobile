import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/certificates/domain/model/certificate_tier.dart';

class MyCertificateTierBadge extends StatelessWidget {
  const MyCertificateTierBadge({super.key, required this.tier, required this.label});

  final CertificateTier tier;
  final String label;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(tier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: style.background, borderRadius: AppRadius.radiusSm),
      child: Text(label, style: context.textTheme.bodyXSmallBold.copyWith(color: context.appColors.background)),
    );
  }

  _BadgeStyle _styleFor(CertificateTier tier) {
    switch (tier) {
      case CertificateTier.gold:
        return _BadgeStyle(background: AppColors.otherAmber, foreground: AppColors.otherAmber);
      case CertificateTier.silver:
        return _BadgeStyle(background: AppColors.grey, foreground: AppColors.grey);
      case CertificateTier.bronze:
        return _BadgeStyle(background: AppColors.otherOrange, foreground: AppColors.otherOrange);
    }
  }
}

class _BadgeStyle {
  const _BadgeStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
