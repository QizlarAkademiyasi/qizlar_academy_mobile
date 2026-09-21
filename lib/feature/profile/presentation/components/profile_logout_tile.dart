import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileLogoutTile extends StatelessWidget {
  const ProfileLogoutTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('profile-logout-solid-surface'),
      height: 68,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: AppRadius.radiusXl,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.appColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Icon(
                    LucideIcons.logIn,
                    size: 18,
                    color: context.appColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.profileLogout,
                    style: context.textTheme.bodyMediumSemibold.copyWith(
                      color: context.appColors.primary,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 12,
                  color: context.appColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
