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
  });

  final List<BannerModel> banners;
  final ValueChanged<BannerModel>? onBannerTap;
  final bool isLoading;

  @override
  State<HomeBannersCarousel> createState() => _HomeBannersCarouselState();
}

class _HomeBannersCarouselState extends State<HomeBannersCarousel> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            // padEnds: false,
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, i) {
              final banner = banners[i];
              return Padding(
                padding: EdgeInsets.only(
                  right: i == banners.length - 1 ? 0 : AppGap.gapSm,
                ),
                child: _BannerCard(
                  banner: banner,
                  onTap: widget.onBannerTap,
                  isLoading: widget.isLoading,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppGap.gapSm),
        _DotsIndicator(length: banners.length, index: _index),
      ],
    );
  }
}

class _BannerCardMedia extends StatefulWidget {
  const _BannerCardMedia({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<_BannerCardMedia> createState() => _BannerCardMediaState();
}

class _BannerCardMediaState extends State<_BannerCardMedia> {
  bool _showGradientOverlay = false;
  bool _overlayRevealPending = false;

  void _scheduleGradientReveal() {
    if (_showGradientOverlay || _overlayRevealPending) return;
    _overlayRevealPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayRevealPending = false;
      if (!mounted) return;
      setState(() => _showGradientOverlay = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholder: (context, url) => const _BannerCardSkeleton(),
          errorWidget: (context, url, error) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: AppRadius.radius2xl,
                border: Border.all(color: context.appColors.stroke),
              ),
            );
          },
          imageBuilder: (context, imageProvider) {
            return Image(
              image: imageProvider,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.medium,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  _scheduleGradientReveal();
                  return child;
                }
                return const _BannerCardSkeleton();
              },
            );
          },
        ),
        if (_showGradientOverlay)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  AppColors.black.withValues(alpha: 0.55),
                  AppColors.black.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
      ],
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
                          Expanded(
                            child: Bone.button(height: 28, words: 2),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Bone.button(height: 28, words: 2),
                          ),
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
    required this.onTap,
    this.isLoading = false,
  });

  final BannerModel banner;
  final ValueChanged<BannerModel>? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _BannerCardSkeleton();
    }

    final imageUrl = banner.imageUrl.trim();

    return Bounce(
      tilt: false,
      onTap: () => onTap?.call(banner),
      child: ClipRRect(
        borderRadius: AppRadius.radius2xl,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox.expand(
              child: imageUrl.isEmpty
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
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Skeletonizer(
            //         enabled: isLoading,
            //         child: Text(
            //           banner.title,
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //           style: context.textTheme.bodyLargeBold.copyWith(
            //             color: AppColors.white,
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 4),
            //       Skeletonizer(
            //         enabled: isLoading,
            //         child: Text(
            //           banner.subtitle,
            //           maxLines: 2,
            //           overflow: TextOverflow.ellipsis,
            //           style: context.textTheme.bodySmallRegular.copyWith(
            //             color: AppColors.white.withValues(alpha: 0.9),
            //             height: 1.25,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
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
