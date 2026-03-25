import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badgeCount,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final int? badgeCount;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bounce(
          tilt: false,
          // borderRadius: AppRadius.radiusLg,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: InkWell(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.appColors.iconSecondary,
                      borderRadius: AppRadius.radiusMd,
                    ),
                    child: Icon(icon, size: 18, color: context.appColors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.bodyMediumSemibold.copyWith(
                            color: context.appColors.text,
                          ),
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmallRegular.copyWith(
                              color: context.appColors.secondaryGrey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (badgeCount != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.primary,
                        borderRadius: AppRadius.radiusXl,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: context.textTheme.bodySmallSemibold.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: context.appColors.secondaryGrey,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: context.appColors.stroke,
            indent: 54,
          ),
      ],
    );
  }
}
