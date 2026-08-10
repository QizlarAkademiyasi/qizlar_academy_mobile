import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/format/coin_compact_format.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_product_item_model.dart';

class StoreProductCard extends StatelessWidget {
  const StoreProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onLikeTap,
  });

  final StoreProductItemModel product;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    final mediaUrls = product.media.map((m) => m.url).toList();

    return AppLiquidStretch(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    key: const ValueKey('store-product-media'),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.lightScaffold,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: mediaUrls.isNotEmpty
                        ? _ImageCarousel(urls: mediaUrls)
                        : ColoredBox(
                            color: context.appColors.stroke,
                            child: Center(
                              child: Icon(
                                LucideIcons.image,
                                size: 32,
                                color: context.appColors.grey,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onLikeTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: context.appColors.shadow.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: AppColors.lightOnContainer.withValues(
                            alpha: 0.85,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            product.isLiked
                                ? Icons.favorite
                                : LucideIcons.heart,
                            key: ValueKey(product.isLiked),
                            size: 16,
                            color: product.isLiked
                                ? AppColors.primary
                                : context.appColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (mediaUrls.length > 1) ...[
              const SizedBox(height: 6),
              _PageIndicator(
                count: mediaUrls.length,
                pageNotifier: ValueNotifier(0),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              product.title,
              style: context.textTheme.bodyMediumBold.copyWith(
                color: context.appColors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  LucideIcons.circleStar,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${CoinCompactFormat.short(product.basePrice)} Tanga',
                  style: context.textTheme.bodySmallSemibold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${product.totalStock} ta',
                  style: context.textTheme.bodySmallMedium.copyWith(
                    color: context.appColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.urls});

  final List<String> urls;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.urls.length,
          onPageChanged: (i) => setState(() => _current = i),
          itemBuilder: (_, i) => AppCachedNetworkImage(
            imageUrl: widget.urls[i],
            fit: BoxFit.contain,
            fallback: const AppNetworkImageFallbackCourse(),
          ),
        ),
        if (widget.urls.length > 1)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.urls.length, (i) {
                return Container(
                  width: i == _current ? 8 : 6,
                  height: i == _current ? 8 : 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _current
                        ? AppColors.white
                        : AppColors.white.withValues(alpha: 0.5),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.pageNotifier});

  final int count;
  final ValueNotifier<int> pageNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: pageNotifier,
      builder: (_, page, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            return Container(
              width: i == page ? 7 : 5,
              height: i == page ? 7 : 5,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == page
                    ? context.appColors.text
                    : context.appColors.stroke,
              ),
            );
          }),
        );
      },
    );
  }
}
