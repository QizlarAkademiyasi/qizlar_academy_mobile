import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileLogoutTile extends StatelessWidget {
  const ProfileLogoutTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: InkWell(
        borderRadius: AppRadius.radiusXl,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: context.appColors.error.withValues(alpha: 0.09),
                  borderRadius: AppRadius.radiusXs,
                ),
                child: Icon(
                  LucideIcons.logOut,
                  size: 15,
                  color: context.appColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Chiqish',
                  style: context.textTheme.bodyMediumSemibold.copyWith(
                    color: context.appColors.error,
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: context.appColors.error.withValues(alpha: 0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
