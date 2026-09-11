import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';

class PortfolioStoryBar extends StatelessWidget {
  const PortfolioStoryBar({
    super.key,
    required this.items,
    required this.onTap,
    this.viewedIds = const {},
    this.isLoading = false,
  });
  final List<StoryModel> items;
  final Set<String> viewedIds;
  final bool isLoading;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64 + 6 + MediaQuery.textScalerOf(context).scale(20),
    child: ListView.separated(
      key: const ValueKey('portfolio-story-list'),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: isLoading ? 6 : items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final story = isLoading ? null : items[index];
        final viewed =
            story != null &&
            story.canTrackView &&
            (story.isViewed || viewedIds.contains(story.id));
        final colors = [
          context.appColors.primary,
          const Color(0xFF9333EA),
          const Color(0xFF2563EB),
          const Color(0xFFEA580C),
          const Color(0xFF059669),
        ];
        final color = viewed
            ? context.appColors.secondaryGrey
            : colors[index % colors.length];
        return SizedBox(
          width: 68,
          child: GestureDetector(
            onTap: isLoading ? null : () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Hero(
                  tag: 'story_${story?.id}_$index',
                  child: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: .53)],
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.appColors.background,
                      ),
                      child: ClipOval(
                        child: isLoading || story!.thumbnailUrl.isEmpty
                            ? Skeletonizer.zone(child: Bone.circle(size: 54))
                            : AppCachedNetworkImage(
                                imageUrl: story.thumbnailUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  story == null
                      ? 'Story'
                      : story.isBirthday && story.name.trim().isEmpty
                      ? context.l10n.birthdayStoryLabel
                      : story.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmallMedium.copyWith(
                    color: context.appColors.text,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
