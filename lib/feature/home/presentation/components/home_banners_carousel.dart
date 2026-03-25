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
          height: 140,
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
                child: _BannerCard(banner: banner, onTap: widget.onBannerTap, isLoading: widget.isLoading),
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

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner, required this.onTap, this.isLoading = false});

  final BannerModel banner;
  final ValueChanged<BannerModel>? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      tilt: false,
      onTap: () => onTap?.call(banner),
      child: ClipRRect(
        borderRadius: AppRadius.radius2xl,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Skeletonizer(
              enabled: isLoading,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColors.onContainer,
                      borderRadius: AppRadius.radius2xl,
                      border: Border.all(color: context.appColors.stroke),
                    ),
                  );
                },
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      banner.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      banner.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmallRegular.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
