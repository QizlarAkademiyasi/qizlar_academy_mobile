import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Katalog dastlabki yuklanishi — [Bone] + [Skeletonizer.zone] (oddiy [Container] shimmer bermaydi).
class CoursesListSkeleton extends StatelessWidget {
  const CoursesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _InProgressSkeletonCard(),
            SizedBox(height: 16),
            _CatalogCourseSkeletonCard(),
            SizedBox(height: 16),
            _CatalogCourseSkeletonCard(),
          ],
        ),
      ),
    );
  }
}

/// «Oxirgi ko‘rilgan» kartasiga yaqin layout.
class _InProgressSkeletonCard extends StatelessWidget {
  const _InProgressSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        color: context.appColors.onContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Bone.text(words: 3)),
              Bone.text(words: 2),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.radiusLg,
                child: SizedBox(width: 72, height: 72, child: Bone.icon()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 5),
                    const SizedBox(height: 8),
                    Bone.text(words: 4),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(height: 7, width: double.infinity, child: Bone.button()),
          ),
          const SizedBox(height: 10),
          Bone.text(words: 4),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Bone.button(),
          ),
        ],
      ),
    );
  }
}

/// [AppCourseListItemCard] tuzilmasi: rasm + sarlavha + mentor + qator.
class _CatalogCourseSkeletonCard extends StatelessWidget {
  const _CatalogCourseSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
        color: context.appColors.onContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              width: double.infinity,
              height: 156,
              child: Bone.button(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 8),
                const SizedBox(height: 8),
                Bone.text(words: 3),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Bone.icon(size: 14),
                    const SizedBox(width: 6),
                    Expanded(child: Bone.text(words: 6)),
                    const SizedBox(width: 8),
                    Bone.icon(size: 14),
                    const SizedBox(width: 6),
                    Bone.text(words: 2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
