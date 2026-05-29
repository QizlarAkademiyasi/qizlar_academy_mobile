import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// YouTube iframe player URL ekanini tekshiradi ([CourseLessonPlayerScreen] layout uchun).
bool isYoutubeLessonVideoUrl(String? rawUrl) {
  final trimmed = rawUrl?.trim() ?? '';
  if (trimmed.isEmpty) return false;
  var u = Uri.tryParse(trimmed);
  if (u == null || !u.hasScheme) {
    u = Uri.tryParse('https://$trimmed');
  }
  if (u == null || u.host.isEmpty) return false;
  final host = u.host.toLowerCase();
  if (!host.contains('youtube.com') && !host.contains('youtu.be')) return false;
  return YoutubePlayer.convertUrlToId(u.toString()) != null;
}

/// Dars videosi:
/// - YouTube URL → [YoutubePlayer] (iframe/webview)
/// - Boshqa URL  → [OmniVideoPlayer] (network stream)
///
/// [SliverPersistentHeader] ichida ishlashi uchun player pinned bo'lib ekranda qoladi.
class CourseLessonVideoPlayer extends StatefulWidget {
  const CourseLessonVideoPlayer({
    super.key,
    required this.lessonId,
    required this.videoUrl,
    this.onPlaybackFinished,
    this.controller,
  });

  final String lessonId;
  final String? videoUrl;
  final VoidCallback? onPlaybackFinished;
  final CourseLessonVideoPlayerController? controller;

  @override
  State<CourseLessonVideoPlayer> createState() => _CourseLessonVideoPlayerState();
}

class CourseLessonVideoPlayerController {
  _CourseLessonVideoPlayerState? _state;

  bool get isAttached => _state != null;

  Future<void> pause() async {
    final s = _state;
    if (s == null) return;
    await s._pause();
  }
}

class _CourseLessonVideoPlayerState extends State<CourseLessonVideoPlayer> {
  Uri? _parsedUri;
  YoutubePlayerController? _youtubeController;
  String? _youtubeVideoId;
  OmniPlaybackController? _omniController;

  static const Duration _playbackTimeout = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    _resolveUri();
  }

  @override
  void didUpdateWidget(covariant CourseLessonVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._state = null;
      widget.controller?._state = this;
    }
    if (oldWidget.videoUrl != widget.videoUrl) {
      _resolveUri();
    }
  }

  void _resolveUri() {
    final rawUrl = widget.videoUrl?.trim() ?? '';
    if (rawUrl.isEmpty) {
      setState(() {
        _parsedUri = null;
      });
      _disposeYoutubeController();
      return;
    }

    var u = Uri.tryParse(rawUrl);
    if (u == null || !u.hasScheme) {
      u = Uri.tryParse('https://$rawUrl');
    }
    if (u == null || u.host.isEmpty) {
      setState(() {
        _parsedUri = null;
      });
      _disposeYoutubeController();
      return;
    }

    final youtubeId = YoutubePlayer.convertUrlToId(u.toString());
    final shouldUseYoutube = youtubeId != null;

    setState(() {
      _parsedUri = u;
      _youtubeVideoId = youtubeId;
    });

    if (shouldUseYoutube) {
      _ensureYoutubeController(videoId: youtubeId);
    } else {
      _disposeYoutubeController();
    }
  }

  void _ensureYoutubeController({required String videoId}) {
    final currentId = _youtubeController?.initialVideoId;
    if (_youtubeController != null && currentId == videoId) return;

    _youtubeController?.dispose();
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  void _disposeYoutubeController() {
    _youtubeController?.dispose();
    _youtubeController = null;
    _youtubeVideoId = null;
  }

  Future<void> _pause() async {
    try {
      _youtubeController?.pause();
    } catch (_) {
      // ignore
    }
    try {
      await _omniController?.pause();
    } catch (_) {
      // ignore
    }
  }

  VideoSourceConfiguration _source() {
    final uri = _parsedUri!;
    final base = VideoSourceConfiguration.network(videoUrl: uri);
    return base.copyWith(
      autoPlay: true,
      pauseWhenOutOfView: false,
      timeoutDuration: _playbackTimeout,
      initialPlaybackSpeed: 1.0,
      availablePlaybackSpeed: const [0.5, 1.0, 1.25, 1.5, 2.0],
    );
  }

  @override
  void dispose() {
    widget.controller?._state = null;
    _disposeYoutubeController();
    _omniController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_parsedUri == null) {
      return Container(
        color: context.appColors.onContainer,
        alignment: Alignment.center,
        child: Icon(LucideIcons.videoOff, color: context.appColors.grey, size: 28),
      );
    }

    final youtubeId = _youtubeVideoId;
    final controller = _youtubeController;
    if (youtubeId != null && controller != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: controller,
          onEnded: (_) => Future.microtask(() => widget.onPlaybackFinished?.call()),
          onReady: () {},
          progressIndicatorColor: context.appColors.primary,
          showVideoProgressIndicator: true,
          bottomActions: const [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
            RemainingDuration(),
            PlaybackSpeedButton(),
            FullScreenButton(),
          ],
        ),
        builder: (context, player) => player,
      );
    }

    final scheme = const VideoPlayerColorScheme().copyWith(
      backgroundError: context.appColors.onContainer,
      textError: context.appColors.text,
      volumeColorActiveSlider: context.appColors.primary,
      volumeColorInactiveSlider: context.appColors.primary,
    );
    return OmniVideoPlayer(
      key: ValueKey<String>('omni_${widget.lessonId}_$_parsedUri'),
      configuration: VideoPlayerConfiguration(
        videoSourceConfiguration: _source(),
        playerUIVisibilityOptions: const PlayerUIVisibilityOptions(showPlaybackSpeedButton: true),
        playerTheme: OmniVideoPlayerThemeData(colors: scheme),
        customPlayerWidgets: CustomPlayerWidgets(
          errorPlaceholder: _LessonVideoErrorPlaceholder(isYoutube: false, openUri: _parsedUri!),
        ),
      ),
      callbacks: VideoPlayerCallbacks(
        onControllerCreated: (controller) => _omniController = controller,
        onFinished: () => Future.microtask(() => widget.onPlaybackFinished?.call()),
      ),
    );
  }
}

class _LessonVideoErrorPlaceholder extends StatelessWidget {
  const _LessonVideoErrorPlaceholder({required this.isYoutube, required this.openUri});

  final bool isYoutube;
  final Uri openUri;

  Future<void> _openExternal() async {
    if (await canLaunchUrl(openUri)) {
      await launchUrl(openUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ColoredBox(
      color: context.appColors.onContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.circleAlert, color: context.appColors.grey, size: 40),
            const SizedBox(height: 12),
            Text(
              l10n.lessonVideoPlaybackError,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMediumBold.copyWith(color: context.appColors.text),
            ),
            if (isYoutube) ...[
              const SizedBox(height: 8),
              Text(
                l10n.lessonVideoPlaybackErrorYoutube,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmallRegular.copyWith(color: context.appColors.grey, height: 1.35),
              ),
            ],
            const SizedBox(height: 16),
            PrimaryButton.elevated(
              label: l10n.lessonVideoOpenExternal,
              onPressed: _openExternal,
              expand: false,
              height: 48,
              shape: AppPrimaryButtonShape.roundedRectangle,
              borderRadius: AppRadius.radius3xl,
              textStyle: context.textTheme.bodySmallSemibold.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
