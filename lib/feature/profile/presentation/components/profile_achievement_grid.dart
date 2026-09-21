import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileAchievementGridItem {
  const ProfileAchievementGridItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.badgeCount,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final int? badgeCount;
  final VoidCallback onTap;
}

class ProfileAchievementGrid extends StatelessWidget {
  const ProfileAchievementGrid({
    super.key,
    required this.sectionTitle,
    required this.items,
    this.showSurface = true,
  });

  static const EdgeInsets surfacePadding = EdgeInsets.all(14);

  final String sectionTitle;
  final List<ProfileAchievementGridItem> items;
  final bool showSurface;

  @override
  Widget build(BuildContext context) {
    final grid = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _AchievementCard(item: items[0])),
            const SizedBox(width: 16),
            Expanded(child: _AchievementCard(item: items[1])),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _AchievementCard(item: items[2])),
            const SizedBox(width: 16),
            Expanded(child: _AchievementCard(item: items[3])),
          ],
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle.toUpperCase(),
          style: context.textTheme.bodyMediumSemibold.copyWith(
            fontSize: 11,
            height: 16 / 11,
            letterSpacing: 0.6,
            color: context.appColors.secondaryGrey,
          ),
        ),
        const SizedBox(height: 10),
        if (showSurface)
          Container(
            key: const ValueKey('profile-achievement-solid-surface'),
            padding: surfacePadding,
            decoration: BoxDecoration(
              borderRadius: AppRadius.radiusXl,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: grid,
          )
        else
          grid,
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item});

  final ProfileAchievementGridItem item;

  static const double _cardHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('profile-achievement-card'),
      height: _cardHeight,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusLg,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: AppRadius.radiusLg,
        child: InkWell(
          onTap: () {
            Gaimon.light();
            item.onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.appColors.iconSecondary,
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: item.badgeCount != null
                            ? AppColors.primary
                            : context.appColors.grey,
                      ),
                    ),
                    if (item.badgeCount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.appColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.badgeCount}',
                          style: context.textTheme.bodySmallBold.copyWith(
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      Icon(
                        LucideIcons.chevronRight,
                        size: 12,
                        color: context.appColors.secondaryGrey,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMediumSemibold.copyWith(
                        color: context.appColors.text,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
