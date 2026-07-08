import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

class PortfolioListSkeleton extends StatelessWidget {
  const PortfolioListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        itemCount: 3,
        separatorBuilder: (_, _) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Bone(width: double.infinity, height: 2),
        ),
        itemBuilder: (context, index) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Bone.circle(size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Bone.text(words: 3),
                  SizedBox(height: 10),
                  Bone.multiText(lines: 3),
                  SizedBox(height: 12),
                  Bone(
                    width: double.infinity,
                    height: 300,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  SizedBox(height: 12),
                  Bone.text(words: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
