import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class NotificationListSkeleton extends StatelessWidget {
  const NotificationListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 120),
        children: [
          Bone.text(words: 1, fontSize: 20),
          const SizedBox(height: 10),
          const _SkeletonTile(),
          const _SkeletonTile(),
          const SizedBox(height: 14),
          Bone.text(words: 1, fontSize: 20),
          const SizedBox(height: 10),
          const _SkeletonTile(),
          const _SkeletonTile(),
          const _SkeletonTile(),
        ],
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Bone.circle(size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 6),
                const SizedBox(height: 6),
                Bone.text(words: 2),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: context.appColors.stroke,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
