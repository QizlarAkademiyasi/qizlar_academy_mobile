import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// App Store 5.1.1(v): hisobni o‘chirish — chiqishdan farqli, doimiy o‘chirish.
class ProfileDeleteAccountTile extends StatelessWidget {
  const ProfileDeleteAccountTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: InkWell(
        borderRadius: AppRadius.radiusXl,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Icon(LucideIcons.userRoundX, size: 18, color: context.appColors.secondaryGrey),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.profileDeleteAccountTile,
                  style: context.textTheme.bodySmallSemibold.copyWith(
                    color: context.appColors.secondaryGrey,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 16, color: context.appColors.secondaryGrey.withValues(alpha: 0.75)),
            ],
          ),
        ),
      ),
    );
  }
}
