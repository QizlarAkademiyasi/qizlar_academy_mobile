import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Dastlabki yuklanish — aylanuvchi indikator o'rniga skeleton.
class MyCoursesListSkeleton extends StatelessWidget {
  const MyCoursesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: const [
          _SkeletonCard(),
          SizedBox(height: 16),
          _SkeletonCard(),
          SizedBox(height: 16),
          _SkeletonCard(),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadius.radiusXl,
          child: SizedBox(
            width: double.infinity,
            height: 168,
            child: Bone.button(),
          ),
        ),
        const SizedBox(height: 14),
        Bone.text(words: 4),
        const SizedBox(height: 8),
        Bone.text(words: 2),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Bone.text(words: 5)),
            const SizedBox(width: 12),
            Bone.text(words: 2),
          ],
        ),
      ],
    );
  }
}
