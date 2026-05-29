import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/store/domain/model/store_media_model.dart';

class StoreDetailGallery extends StatefulWidget {
  const StoreDetailGallery({super.key, required this.media, this.showIndicator = true});

  final List<StoreMediaModel> media;
  final bool showIndicator;

  @override
  State<StoreDetailGallery> createState() => _StoreDetailGalleryState();
}

class _StoreDetailGalleryState extends State<StoreDetailGallery> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showIndicator) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (widget.media.isEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: context.appColors.stroke,
                child: Center(child: Icon(LucideIcons.image, size: 48, color: context.appColors.grey)),
              ),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: PageView.builder(
                physics: ClampingScrollPhysics(),
                controller: _controller,
                itemCount: widget.media.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => Container(
                  decoration: BoxDecoration(color: AppColors.lightScaffold),
                  child: AppCachedNetworkImage(imageUrl: widget.media[i].url, fit: BoxFit.cover, fallback: const AppNetworkImageFallbackCourse()),
                ),
              ),
            ),
          );
        },
      );
    }

    if (widget.media.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: context.appColors.stroke, borderRadius: BorderRadius.circular(20)),
          child: Center(child: Icon(LucideIcons.image, size: 48, color: context.appColors.grey)),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.media.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => AppCachedNetworkImage(imageUrl: widget.media[i].url, fit: BoxFit.cover, fallback: const AppNetworkImageFallbackCourse()),
            ),
          ),
        ),
        if (widget.showIndicator && widget.media.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.media.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: i == _currentPage ? 8 : 6,
                height: i == _currentPage ? 8 : 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(shape: BoxShape.circle, color: i == _currentPage ? context.appColors.text : context.appColors.stroke),
              );
            }),
          ),
        ],
      ],
    );
  }
}
