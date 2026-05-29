import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ReferralScreenSkeleton extends StatelessWidget {
  const ReferralScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Bone.text(width: 150),
            const SizedBox(height: 16),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: index == 1 ? 120 : 95,
                      decoration: BoxDecoration(
                        color: context.appColors.onContainer,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Bone.text(width: 130),
            const SizedBox(height: 12),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: context.appColors.onContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
