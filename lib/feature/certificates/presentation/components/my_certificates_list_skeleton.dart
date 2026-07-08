import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Dastlabki yuklanish — aylanuvchi indikator o'rniga skeleton.
class MyCertificatesListSkeleton extends StatelessWidget {
  const MyCertificatesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          MyCertificateSkeletonCard(),
          SizedBox(height: 14),
          MyCertificateSkeletonCard(),
          SizedBox(height: 14),
          MyCertificateSkeletonCard(),
        ],
      ),
    );
  }
}

/// [MyCertificateCard] tuzilmasi: icon well, sarlavha, tugmalar qatori.
class MyCertificateSkeletonCard extends StatelessWidget {
  const MyCertificateSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.radiusSm,
                      child: const SizedBox(width: 44, height: 44, child: Bone.icon()),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone(width: width * 0.82, height: 18),
                        const SizedBox(height: 4),
                        Bone(width: width * 0.48, height: 14),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: AppRadius.radiusSm,
                        child: const SizedBox(height: 48, child: Bone.button()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: AppRadius.radiusSm,
                      child: const SizedBox(width: 48, height: 48, child: Bone.button()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: ClipRRect(
              borderRadius: AppRadius.radiusSm,
              child: const SizedBox(width: 72, height: 24, child: Bone.button()),
            ),
          ),
        ],
      ),
    );
  }
}
