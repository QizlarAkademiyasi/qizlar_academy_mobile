import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_formatting.dart';

class PortfolioMediaPreview extends StatelessWidget {
  const PortfolioMediaPreview({
    super.key,
    required this.media,
    this.height = 386,
    this.borderRadius = 14,
  });

  final List<PortfolioMediaModel> media;
  final double height;
  final double borderRadius;

  void _openViewer(BuildContext context, int initialIndex) {
    showAppPhotoViewer(
      context: context,
      builders: media.map((m) {
        return (BuildContext ctx) {
          if (m.isVideo) {
            return Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: OmniVideoPlayer(
                  key: ValueKey<String>('portfolio_video_${m.id}'),
                  configuration: VideoPlayerConfiguration(
                    videoSourceConfiguration: VideoSourceConfiguration.network(
                      videoUrl: Uri.parse(m.url),
                    ).copyWith(
                      autoPlay: true,
                      pauseWhenOutOfView: true,
                    ),
                  ),
                  callbacks: VideoPlayerCallbacks(),
                ),
              ),
            );
          } else {
            return Center(
              child: AppCachedNetworkImage(
                imageUrl: m.url,
                fit: BoxFit.contain,
                fallback: const AppNetworkImageFallbackCoverTint(),
              ),
            );
          }
        };
      }).toList(),
      heroTagBuilder: (i) => 'portfolio_media_${media[i].id}',
      initialPage: initialIndex,
      minScale: 1.0,
      maxScale: 3.0,
      showDefaultCloseButton: true,
      enableVerticalDismiss: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) {
      return const SizedBox.shrink();
    }
    if (media.length == 1) {
      return SizedBox(
        height: height,
        child: GestureDetector(
          onTap: () => _openViewer(context, 0),
          child: Hero(
            tag: 'portfolio_media_${media.first.id}',
            child: _MediaTile(
              item: media.first,
              height: height,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: height,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.68,
          child: GestureDetector(
            onTap: () => _openViewer(context, index),
            child: Hero(
              tag: 'portfolio_media_${media[index].id}',
              child: _MediaTile(
                item: media[index],
                height: height,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.item,
    required this.height,
    required this.borderRadius,
  });

  final PortfolioMediaModel item;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final duration = PortfolioFormatting.duration(item.duration);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          item.previewUrl.trim().isEmpty
              ? ColoredBox(color: context.appColors.stroke)
              : AppCachedNetworkImage(
                  imageUrl: item.previewUrl,
                  height: height,
                  width: double.infinity,
                  fallback: const AppNetworkImageFallbackCoverTint(),
                ),
          if (item.isVideo) ...[
            Center(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.play,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),
            if (duration.isNotEmpty)
              Positioned(
                left: 14,
                bottom: 12,
                child: Text(
                  duration,
                  style: context.textTheme.bodySmallMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
