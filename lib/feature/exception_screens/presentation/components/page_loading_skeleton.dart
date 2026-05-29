import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Sahifa boshlang'ich yuklanishi uchun skeleton UI.
/// [CircularProgressIndicator] o'rniga ishlatiladi — loyiha qoidasiga muvofiq.
///
/// Umumiy sahifa strukturasini aks ettiradi: sarlavha, pastki matn,
/// tab/chip qator, dropdown va ro'yxat elementlari.
class PageLoadingSkeleton extends StatelessWidget {
  const PageLoadingSkeleton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 8,
            left: padding.left,
            right: padding.right,
            bottom: 24 + MediaQuery.paddingOf(context).bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Skeletonizer.zone(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 2),
                    const SizedBox(height: 4),
                    Bone.text(words: 4),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Bone.button(),
                        const SizedBox(width: 8),
                        Bone.button(),
                        const SizedBox(width: 8),
                        Bone.button(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Bone.text(words: 2),
                    const SizedBox(height: 20),
                    _skeletonCard(context),
                    const SizedBox(height: 24),
                    Bone.text(words: 2),
                    const SizedBox(height: 12),
                    ...List.generate(5, (_) => _skeletonListItem(context)),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _skeletonCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppPadding.paddingMd,
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Bone.circle(size: 40),
              const SizedBox(height: 8),
              Bone.text(words: 1),
            ],
          ),
          Column(
            children: [
              Bone.circle(size: 48),
              const SizedBox(height: 8),
              Bone.text(words: 1),
            ],
          ),
          Column(
            children: [
              Bone.circle(size: 40),
              const SizedBox(height: 8),
              Bone.text(words: 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _skeletonListItem(BuildContext context) {
    return Padding(
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
    );
  }
}
