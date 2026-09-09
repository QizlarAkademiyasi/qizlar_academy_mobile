import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class NotificationSettingsSkeleton extends StatelessWidget {
  const NotificationSettingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        children: const [
          _SwitchBone(),
          SizedBox(height: 24),
          Bone.text(words: 1, fontSize: 12),
          SizedBox(height: 12),
          _SwitchBone(),
          _SwitchBone(),
          _SwitchBone(),
        ],
      ),
    );
  }
}

class _SwitchBone extends StatelessWidget {
  const _SwitchBone();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 4),
                const SizedBox(height: 6),
                Bone.text(words: 6),
              ],
            ),
          ),
          Bone.square(size: 40),
        ],
      ),
    );
  }
}
