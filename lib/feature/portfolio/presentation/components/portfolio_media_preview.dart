import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_formatting.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/utils/portfolio_media_aspect.dart';

class PortfolioMediaPreview extends StatefulWidget {
  const PortfolioMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 14,
  });

  final List<PortfolioMediaModel> media;
  final double borderRadius;

  @override
  State<PortfolioMediaPreview> createState() => _PortfolioMediaPreviewState();
}

class _PortfolioMediaPreviewState extends State<PortfolioMediaPreview> {
  late Map<String, double> _ratios;

  @override
  void initState() {
    super.initState();
    _ratios = _ratiosFor(widget.media);
  }

  @override
  void didUpdateWidget(PortfolioMediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media != widget.media) {
      _ratios = _ratiosFor(widget.media);
    }
  }

  Map<String, double> _ratiosFor(List<PortfolioMediaModel> media) {
    return <String, double>{
      for (final item in media)
        item.id:
            PortfolioMediaAspectCache.get(item.previewUrl) ??
            PortfolioMediaAspect.fallbackRatio(isVideo: item.isVideo),
    };
  }

  void _onRatioResolved(PortfolioMediaModel item, double ratio) {
    if (!mounted || _ratios[item.id] == ratio) {
      return;
    }
    setState(() => _ratios[item.id] = ratio);
  }

  double _ratioFor(PortfolioMediaModel item) {
    return _ratios[item.id] ??
        PortfolioMediaAspect.fallbackRatio(isVideo: item.isVideo);
  }

  void _openViewer(BuildContext context, int initialIndex) {
    showAppPhotoViewer(
      context: context,
      builders: widget.media.map((m) {
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
                    ).copyWith(autoPlay: true, pauseWhenOutOfView: true),
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
      heroTagBuilder: (i) => 'portfolio_media_${widget.media[i].id}',
      initialPage: initialIndex,
      minScale: 1.0,
      maxScale: 3.0,
      showDefaultCloseButton: true,
      enableVerticalDismiss: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.media;
    if (media.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = media.length == 1
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width * 0.68;
        final cacheWidth = (tileWidth * MediaQuery.devicePixelRatioOf(context))
            .ceil();

        Widget buildTile(int index) {
          final item = media[index];
          return SizedBox(
            key: ValueKey<String>('portfolio-media-tile-$index'),
            width: tileWidth,
            child: GestureDetector(
              onTap: () => _openViewer(context, index),
              child: Hero(
                tag: 'portfolio_media_${item.id}',
                child: _MediaTile(
                  item: item,
                  ratio: _ratioFor(item),
                  borderRadius: widget.borderRadius,
                  cacheWidth: cacheWidth,
                  onRatioResolved: (ratio) => _onRatioResolved(item, ratio),
                ),
              ),
            ),
          );
        }

        if (media.length == 1) {
          return buildTile(0);
        }

        var maxHeight = 0.0;
        for (final item in media) {
          final height = tileWidth / _ratioFor(item);
          if (height > maxHeight) {
            maxHeight = height;
          }
        }

        return SizedBox(
          height: maxHeight,
          child: ListView.separated(
            key: const ValueKey<String>('portfolio-media-list'),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            // Flutter < 3.41 bilan ham ishlashi uchun eski API saqlanadi.
            // ignore: deprecated_member_use
            cacheExtent: tileWidth * 2,
            itemCount: media.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) => Align(
              alignment: Alignment.topCenter,
              child: buildTile(index),
            ),
          ),
        );
      },
    );
  }
}

class _MediaTile extends StatefulWidget {
  const _MediaTile({
    required this.item,
    required this.ratio,
    required this.borderRadius,
    required this.cacheWidth,
    required this.onRatioResolved,
  });

  final PortfolioMediaModel item;
  final double ratio;
  final double borderRadius;
  final int cacheWidth;
  final ValueChanged<double> onRatioResolved;

  @override
  State<_MediaTile> createState() => _MediaTileState();
}

class _MediaTileState extends State<_MediaTile> {
  ImageStream? _stream;
  late ImageStreamListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = ImageStreamListener(_onImage, onError: _onError);
    _resolve();
  }

  @override
  void didUpdateWidget(_MediaTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.previewUrl != widget.item.previewUrl ||
        oldWidget.item.id != widget.item.id) {
      _detach();
      _resolve();
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  bool get _canResolve {
    final url = widget.item.previewUrl.trim();
    if (url.isEmpty) {
      return false;
    }
    if (widget.item.isVideo && widget.item.thumbnailUrl.trim().isEmpty) {
      return false;
    }
    return PortfolioMediaAspectCache.get(url) == null;
  }

  void _resolve() {
    if (!_canResolve) {
      return;
    }
    final provider = CachedNetworkImageProvider(widget.item.previewUrl);
    _stream = provider.resolve(const ImageConfiguration());
    _stream!.addListener(_listener);
  }

  void _detach() {
    _stream?.removeListener(_listener);
    _stream = null;
  }

  void _onImage(ImageInfo info, bool synchronousCall) {
    final ratio = PortfolioMediaAspect.clampRatio(
      info.image.width.toDouble(),
      info.image.height.toDouble(),
    );
    PortfolioMediaAspectCache.set(widget.item.previewUrl, ratio);
    widget.onRatioResolved(ratio);
  }

  void _onError(Object error, StackTrace? stackTrace) {}

  @override
  Widget build(BuildContext context) {
    final duration = PortfolioFormatting.duration(widget.item.duration);
    return AspectRatio(
      aspectRatio: widget.ratio,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.item.previewUrl.trim().isEmpty
                  ? ColoredBox(color: context.appColors.stroke)
                  : AppCachedNetworkImage(
                      imageUrl: widget.item.previewUrl,
                      width: double.infinity,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      useOldImageOnUrlChange: true,
                      memCacheWidth: widget.cacheWidth,
                      fallback: const AppNetworkImageFallbackCoverTint(),
                    ),
              if (widget.item.isVideo) ...[
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
        ),
      ),
    );
  }
}
