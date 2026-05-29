import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: [
          Center(child: Bone.circle(size: 88)),
          const SizedBox(height: 14),
          Center(child: Bone.text(words: 2, fontSize: 15)),
          const SizedBox(height: 6),
          Center(child: Bone.text(words: 1, fontSize: 12)),
          const SizedBox(height: 18),
          Container(
            height: 74,
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: context.appColors.stroke),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: Bone.button()),
              SizedBox(width: 8),
              Expanded(child: Bone.button()),
              SizedBox(width: 8),
              Expanded(child: Bone.button()),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusXl,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: const Column(
              children: [
                Bone.multiText(lines: 1),
                SizedBox(height: 12),
                Bone.multiText(lines: 1),
                SizedBox(height: 12),
                Bone.multiText(lines: 1),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.onContainer,
              borderRadius: AppRadius.radiusXl,
              border: Border.all(color: context.appColors.stroke),
            ),
            child: const Column(
              children: [
                Bone.multiText(lines: 1),
                SizedBox(height: 12),
                Bone.multiText(lines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
