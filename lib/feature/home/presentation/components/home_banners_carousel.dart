import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/banner_model.dart';

class HomeBannersCarousel extends StatefulWidget {
  const HomeBannersCarousel({
    super.key,
    required this.banners,
    this.onBannerTap,
    this.isLoading = false,
    this.autoPlay = true,
  });

  static const double stretchSlack = 16;
  static const double _designWidth = 342;
  static const double _designHeight = 182;

  final List<BannerModel> banners;
  final ValueChanged<BannerModel>? onBannerTap;
  final bool isLoading;
  final bool autoPlay;

  static double bannerCardHeight(BuildContext context) =>
      (MediaQuery.sizeOf(context).width - 48) * _designHeight / _designWidth;

  static double viewportHeight(BuildContext context) =>
      bannerCardHeight(context) + stretchSlack * 2;

  @override
  State<HomeBannersCarousel> createState() => _HomeBannersCarouselState();
}

class _HomeBannersCarouselState extends State<HomeBannersCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    final cardHeight = HomeBannersCarousel.bannerCardHeight(context);
    final viewportHeight = HomeBannersCarousel.viewportHeight(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          key: const ValueKey('home-banner-viewport'),
          height: viewportHeight,
          child: CarouselSlider.builder(
            itemCount: banners.length,
            options: CarouselOptions(
              height: viewportHeight,
              viewportFraction: 1,
              autoPlay: widget.autoPlay,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              onPageChanged: (value, _) => setState(() => _index = value),
            ),
            itemBuilder: (context, i, _) {
              final banner = banners[i];
              return _BannerCard(
                banner: banner,
                cardHeight: cardHeight,
                onTap: widget.onBannerTap,
                isLoading: widget.isLoading,
              );
            },
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: AppGap.gapSm),
          _DotsIndicator(length: banners.length, index: _index),
        ],
      ],
    );
  }
}

class _BannerCardMedia extends StatelessWidget {
  const _BannerCardMedia({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) => AppCachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    alignment: Alignment.topCenter,
    placeholder: (_, _) => const _BannerImageShimmer(),
  );
}

/// Rasm tarmoqqa chiqishi / decode bo‘lganicha — silliq shimmer.
class _BannerImageShimmer extends StatelessWidget {
  const _BannerImageShimmer();

  @override
  Widget build(BuildContext context) {
    return AppImageShimmer(
      borderRadius: AppRadius.radius2xl,
      baseColor: context.appColors.onSecondaryContainer,
      highlightColor:
          Color.lerp(
            context.appColors.onSecondaryContainer,
            context.appColors.onContainer,
            0.42,
          ) ??
          context.appColors.onSecondaryContainer,
    );
  }
}

class _BannerCardSkeleton extends StatelessWidget {
  const _BannerCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ClipRRect(
        borderRadius: AppRadius.radius2xl,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.text(words: 3, fontSize: 18),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: Bone.button(height: 28, words: 2)),
                          const SizedBox(width: 8),
                          Expanded(child: Bone.button(height: 28, words: 2)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Bone(
                  width: 92,
                  height: 124,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.banner,
    required this.cardHeight,
    required this.onTap,
    this.isLoading = false,
  });

  final BannerModel banner;
  final double cardHeight;
  final ValueChanged<BannerModel>? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: HomeBannersCarousel.stretchSlack,
        ),
        child: SizedBox(height: cardHeight, child: const _BannerCardSkeleton()),
      );
    }

    final imageUrl = banner.imageUrl.trim();

    return AppLiquidStretch(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(banner),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: HomeBannersCarousel.stretchSlack,
          ),
          child: SizedBox(
            key: const ValueKey('home-banner-card'),
            height: cardHeight,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: AppRadius.radius2xl,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl.isEmpty
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.appColors.onContainer,
                            border: Border.all(color: context.appColors.stroke),
                          ),
                        )
                      : _BannerCardMedia(
                          key: ValueKey(banner.id),
                          imageUrl: imageUrl,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.length, required this.index});

  final int length;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (length <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: active ? AppColors.primary : context.appColors.secondaryGrey,
          ),
        );
      }),
    );
  }
}
