import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Courses detallari ekranining skeleton ko'rinishi.
/// CircularProgressIndicator ishlatilmaydi — Skeletonizer + Bone ishlatiladi.
class CoursesPageLoadingSkeleton extends StatelessWidget {
  const CoursesPageLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topInset = MediaQuery.paddingOf(context).top;
    final overlayColor = context.isDarkTheme
        ? AppColors.white.withValues(alpha: 0.1)
        : AppColors.black.withValues(alpha: 0.14);
    final overlayBorderColor = context.isDarkTheme
        ? AppColors.white.withValues(alpha: 0.2)
        : AppColors.white.withValues(alpha: 0.28);

    return Skeletonizer.zone(
      child: Stack(
        children: [
          CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 260,
                  decoration: BoxDecoration(
                    color: context.appColors.primary.withValues(alpha: 0.12),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: topInset + 10,
                        left: 16,
                        child: Bone.circle(size: 44),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 18,
                        child: ClipRRect(
                          borderRadius: AppRadius.radius3xl,
                          child: Container(
                            padding: AppPadding.paddingLg,
                            decoration: BoxDecoration(
                              color: overlayColor,
                              border: Border.all(color: overlayBorderColor),
                              borderRadius: AppRadius.radius3xl,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Bone.circle(size: 46),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Bone.text(words: 3),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(child: Bone.text(words: 2)),
                                          const SizedBox(width: 10),
                                          Bone.text(words: 1),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Bone.text(words: 2),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: Bone.button()),
                          const SizedBox(width: 8),
                          Expanded(child: Bone.button()),
                          const SizedBox(width: 8),
                          Expanded(child: Bone.button()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        6,
                        (_) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Bone.circle(size: 32),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Bone.text(words: 2),
                                    const SizedBox(height: 4),
                                    Bone.text(words: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 16 + bottomInset,
            child: Bone.button(),
          ),
        ],
      ),
    );
  }
}
