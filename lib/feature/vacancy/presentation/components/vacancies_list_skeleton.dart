import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class VacanciesListSkeleton extends StatelessWidget {
  const VacanciesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: const [
          VacancySkeletonCard(),
          SizedBox(height: 16),
          VacancySkeletonCard(),
          SizedBox(height: 16),
          VacancySkeletonCard(),
        ],
      ),
    );
  }
}

/// [VacancyCard] tuzilmasi: yuqori tint blok, maosh va CTA qatori.
class VacancySkeletonCard extends StatelessWidget {
  const VacancySkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: context.appColors.stroke),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppPadding.paddingXs,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              decoration: BoxDecoration(
                color: context.appColors.stroke.withValues(alpha: 0.35),
                borderRadius: AppRadius.radiusMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.radiusSm,
                        child: const SizedBox(width: 48, height: 48, child: Bone.icon()),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Bone.text(words: 5),
                            SizedBox(height: 4),
                            Bone.text(words: 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 1, color: context.appColors.secondaryGrey.withValues(alpha: 0.2)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: Row(
                          children: [
                            Bone.icon(size: 16),
                            SizedBox(width: 6),
                            Expanded(child: Bone.text(words: 3)),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            Bone.icon(size: 16),
                            SizedBox(width: 6),
                            Expanded(child: Bone.text(words: 3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Bone.text(words: 4),
                      SizedBox(height: 6),
                      Bone.text(words: 2),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: AppRadius.radius4xl,
                  child: const SizedBox(width: 100, height: 38, child: Bone.button()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
