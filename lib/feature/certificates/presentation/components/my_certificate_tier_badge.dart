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
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: AppRadius.radiusSm,
      ),
      child: Text(
        label,
        style: context.textTheme.bodyXSmallRegular.copyWith(
          color: style.foreground,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }

  _BadgeStyle _styleFor(CertificateTier tier) {
    switch (tier) {
      case CertificateTier.gold:
        return const _BadgeStyle(background: Color(0xFFFFD700), foreground: AppColors.black);
      case CertificateTier.silver:
        return const _BadgeStyle(background: Color(0xFF4A4A4A), foreground: AppColors.white);
      case CertificateTier.bronze:
        return const _BadgeStyle(background: Color(0xFFFF5722), foreground: AppColors.white);
    }
  }
}

class _BadgeStyle {
  const _BadgeStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
