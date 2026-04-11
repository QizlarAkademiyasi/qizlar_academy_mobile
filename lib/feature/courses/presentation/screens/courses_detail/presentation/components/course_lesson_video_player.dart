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
/// - YouTube URL → [YoutubePlayer] (youtube_player_flutter)
/// - Boshqa URL  → [OmniVideoPlayer] (network stream)
///
/// [SliverPersistentHeader] ichida ishlashi uchun YouTube player'da
/// `controller.pause()` / `play()` to'g'ri ishlaydi chunki widget
/// pinned bo'lib ekranda qoladi.
class CourseLessonVideoPlayer extends StatefulWidget {
  const CourseLessonVideoPlayer({super.key, required this.lessonId, required this.videoUrl, this.onPlaybackFinished});

  final String lessonId;
  final String? videoUrl;
  final VoidCallback? onPlaybackFinished;

  @override
  State<CourseLessonVideoPlayer> createState() => _CourseLessonVideoPlayerState();
}

class _CourseLessonVideoPlayerState extends State<CourseLessonVideoPlayer> {
  Uri? _parsedUri;
  bool _isYoutube = false;
  String? _youtubeVideoId;

  YoutubePlayerController? _ytController;

  static const Duration _playbackTimeout = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _resolveUri();
  }

  @override
  void didUpdateWidget(covariant CourseLessonVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeYtController();
      _resolveUri();
    }
  }

  @override
  void dispose() {
    _disposeYtController();
    super.dispose();
  }

  void _disposeYtController() {
    _ytController?.dispose();
    _ytController = null;
  }

  void _resolveUri() {
    final rawUrl = widget.videoUrl?.trim() ?? '';
    if (rawUrl.isEmpty) {
      setState(() {
        _parsedUri = null;
        _isYoutube = false;
        _youtubeVideoId = null;
      });
      return;
    }

    var u = Uri.tryParse(rawUrl);
    if (u == null || !u.hasScheme) {
      u = Uri.tryParse('https://$rawUrl');
    }
    if (u == null || u.host.isEmpty) {
      setState(() {
        _parsedUri = null;
        _isYoutube = false;
        _youtubeVideoId = null;
      });
      return;
    }

    final host = u.host.toLowerCase();
    final isYt = host.contains('youtube.com') || host.contains('youtu.be');
    final videoId = isYt ? YoutubePlayer.convertUrlToId(u.toString()) : null;

    if (isYt && videoId != null) {
      final controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false, disableDragSeek: false, enableCaption: false, hideControls: false, controlsVisibleAtStart: true),
      )..addListener(_ytListener);

      setState(() {
        _parsedUri = u;
        _isYoutube = true;
        _youtubeVideoId = videoId;
        _ytController = controller;
      });
    } else {
      setState(() {
        _parsedUri = u;
        _isYoutube = false;
        _youtubeVideoId = null;
      });
    }
  }

  void _ytListener() {
    final controller = _ytController;
    if (controller == null) return;
    if (controller.value.playerState == PlayerState.ended) {
      Future.microtask(() => widget.onPlaybackFinished?.call());
    }
  }

  VideoSourceConfiguration _networkSource() {
    return VideoSourceConfiguration.network(videoUrl: _parsedUri!).copyWith(autoPlay: true, pauseWhenOutOfView: false, timeoutDuration: _playbackTimeout);
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

    if (_isYoutube && _ytController != null) {
      return _YoutubePlayerWidget(key: ValueKey<String>('yt_${widget.lessonId}_$_youtubeVideoId'), controller: _ytController!, openUri: _parsedUri!);
    }

    // Non-YouTube: OmniVideoPlayer (network)
    final scheme = const VideoPlayerColorScheme().copyWith(backgroundError: context.appColors.onContainer, textError: context.appColors.text);
    return OmniVideoPlayer(
      key: ValueKey<String>('net_${widget.lessonId}_$_parsedUri'),
      configuration: VideoPlayerConfiguration(
        videoSourceConfiguration: _networkSource(),
        playerTheme: OmniVideoPlayerThemeData(colors: scheme),
        customPlayerWidgets: CustomPlayerWidgets(errorPlaceholder: _LessonVideoErrorPlaceholder(isYoutube: false, openUri: _parsedUri!)),
      ),
      callbacks: VideoPlayerCallbacks(onFinished: () => Future.microtask(() => widget.onPlaybackFinished?.call())),
    );
  }
}

/// YouTube player widget — [YoutubePlayerController] ni qabul qiladi.
/// [YoutubePlayerBuilder] orqali to'liq ekran rejimi ham ishlaydi.
class _YoutubePlayerWidget extends StatelessWidget {
  const _YoutubePlayerWidget({super.key, required this.controller, required this.openUri});

  final YoutubePlayerController controller;
  final Uri openUri;

  static const ProgressBarColors _progressColors = ProgressBarColors(playedColor: AppColors.primary, handleColor: AppColors.primary);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: _progressColors,
        onEnded: (_) {},
        bottomActions: [
          const SizedBox(width: 14.0),
          const CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(isExpanded: true, colors: _progressColors),
          const RemainingDuration(),
          const FullScreenButton(),
        ],
      ),
      builder: (context, player) => player,
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
