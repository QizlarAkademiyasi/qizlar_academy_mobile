import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileLogoutTile extends StatelessWidget {
  const ProfileLogoutTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: InkWell(
        borderRadius: AppRadius.radiusXl,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: context.appColors.error.withValues(alpha: 0.09), borderRadius: AppRadius.radiusMd),
                child: Icon(LucideIcons.logOut, size: 15, color: context.appColors.error),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(context.l10n.profileLogout, style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.error)),
              ),
              Icon(LucideIcons.chevronRight, size: 16, color: context.appColors.error.withValues(alpha: 0.85)),
            ],
          ),
        ),
      ),
    );
  }
}
