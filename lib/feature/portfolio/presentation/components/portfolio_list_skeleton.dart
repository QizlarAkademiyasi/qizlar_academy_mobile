import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class PortfolioListSkeleton extends StatelessWidget {
  const PortfolioListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Bone.circle(size: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 3),
                        SizedBox(height: 6),
                        Bone.text(width: 72),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
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
      ),
    );
  }
}
