import 'dart:async' show unawaited;
import 'dart:ui' as ui;

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/logs/app_logger.dart';

/// iOS 26 scroll edge effect (`.soft`): variable-radius progressive blur.
///
/// Impeller'da separable 2-pass Gaussian shader blur radiusini Y bo'yicha
/// kamaytiradi. Shader yo'li bo'lmasa stacked fallback ham sigma'ni
/// pastga qarab 0 ga tushiradi — uniform blur + alpha fade emas.
class AppScrollEdgeBlur extends StatefulWidget {
  const AppScrollEdgeBlur({
    super.key,
    required this.progress,
    this.fadeExtent = 72,
    this.maxBlurSigma = 22,
  }) : assert(fadeExtent > 0);

  static const shaderAsset = 'shaders/app_scroll_edge_blur.frag';

  /// `0` — effect yo'q, `1` — to'liq progressive blur.
  final double progress;

  /// Toolbar ostidagi fade pocket. Shader/fallback `solidEnd` ni shundan hisoblaydi.
  final double fadeExtent;

  /// Overlay yuqorisidagi (status + toolbar) maksimal sigma.
  final double maxBlurSigma;

  @override
  State<AppScrollEdgeBlur> createState() => _AppScrollEdgeBlurState();
}

/// Overlay-normalized Y (`0` tepada, `1` pastda) uchun iOS `.soft` sigma og'irligi.
@visibleForTesting
double appScrollEdgeSigmaWeight(double y, {required double solidEnd}) {
  final start = solidEnd.clamp(0.05, 0.95);
  final ny = y.clamp(0.0, 1.0);
  if (ny <= start) {
    return ui.lerpDouble(1, 0.92, _smoothStep(0, start, ny))!;
  }
  final t = _smoothStep(start, 1, ny);
  final eased = t * t * (3 - 2 * t);
  return ui.lerpDouble(0.92, 0, eased)!;
}

double _smoothStep(double edge0, double edge1, double x) {
  if (edge1 <= edge0) return x >= edge1 ? 1 : 0;
  final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
  return t * t * (3 - 2 * t);
}

class _AppScrollEdgeBlurState extends State<AppScrollEdgeBlur> {
  static ui.FragmentProgram? _cachedProgram;
  static Future<ui.FragmentProgram>? _programLoader;

  ui.FragmentShader? _horizontal;
  ui.FragmentShader? _vertical;

  @override
  void initState() {
    super.initState();
    if (ui.ImageFilter.isShaderFilterSupported) {
      unawaited(_loadShader());
    }
  }

  Future<void> _loadShader() async {
    try {
      final cached = _cachedProgram;
      if (cached != null) {
        if (mounted) {
          setState(() => _bindShaders(cached));
        }
        return;
      }

      final loader = _programLoader ??= ui.FragmentProgram.fromAsset(
        AppScrollEdgeBlur.shaderAsset,
      );
      final program = await loader;
      _cachedProgram = program;
      if (mounted) {
        setState(() => _bindShaders(program));
      }
    } catch (error, stackTrace) {
      AppLogger.e(
        'Progressive AppBar blur shader failed to load',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _bindShaders(ui.FragmentProgram program) {
    _horizontal?.dispose();
    _vertical?.dispose();
    _horizontal = program.fragmentShader();
    _vertical = program.fragmentShader();
  }

  @override
  void dispose() {
    _horizontal?.dispose();
    _vertical?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawProgress = widget.progress.clamp(0.0, 1.0);
    if (rawProgress <= 0.001) {
      return const SizedBox.expand(
        key: ValueKey('app-scroll-edge-blur-inactive'),
      );
    }

    final media = MediaQuery.of(context);
    final flatten = media.disableAnimations || media.highContrast;
    final effectProgress = flatten
        ? rawProgress
        : Curves.easeOutCubic.transform(rawProgress);
    final maxSigma =
        widget.maxBlurSigma * (flatten ? 0.35 : 1.0) * effectProgress;

    final horizontal = _horizontal;
    final vertical = _vertical;
    if (horizontal == null ||
        vertical == null ||
        !ui.ImageFilter.isShaderFilterSupported) {
      return _ProgressiveBlurFallback(
        progress: effectProgress,
        fadeExtent: widget.fadeExtent,
        maxBlurSigma: widget.maxBlurSigma * (flatten ? 0.35 : 1.0),
        flattenTint: flatten,
      );
    }

    return IgnorePointer(
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final solidEnd = ((height - widget.fadeExtent) / height).clamp(
              0.05,
              0.95,
            );
            _configurePass(
              horizontal,
              direction: 0,
              maxSigma: maxSigma,
              solidEnd: solidEnd,
            );
            _configurePass(
              vertical,
              direction: 1,
              maxSigma: maxSigma,
              solidEnd: solidEnd,
            );

            return BackdropFilter(
              key: const ValueKey('app-scroll-edge-progressive-filter'),
              filter: ui.ImageFilter.compose(
                inner: ui.ImageFilter.shader(horizontal),
                outer: ui.ImageFilter.shader(vertical),
              ),
              child: _AdaptiveTint(
                progress: effectProgress,
                flatten: flatten,
              ),
            );
          },
        ),
      ),
    );
  }
}

void _configurePass(
  ui.FragmentShader shader, {
  required double direction,
  required double maxSigma,
  required double solidEnd,
}) {
  shader.setFloat(2, direction);
  shader.setFloat(3, maxSigma);
  shader.setFloat(4, solidEnd);
}

/// Skia/web fallback. Har bir qatlamning o'z sigma'si bor; pastki qatlam 0.
class _ProgressiveBlurFallback extends StatelessWidget {
  const _ProgressiveBlurFallback({
    required this.progress,
    required this.fadeExtent,
    required this.maxBlurSigma,
    required this.flattenTint,
  });

  static const stepCount = 12;

  final double progress;
  final double fadeExtent;
  final double maxBlurSigma;
  final bool flattenTint;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final safeFadeExtent = fadeExtent.clamp(1.0, height);
            final solidExtent = height - safeFadeExtent;
            final stepExtent = safeFadeExtent / stepCount;
            final solidEnd = (solidExtent / height).clamp(0.05, 0.95);

            return Stack(
              fit: StackFit.expand,
              children: [
                if (solidExtent > 0.5)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: solidExtent,
                    child: _BlurRegion(
                      sigma: maxBlurSigma * progress,
                    ),
                  ),
                for (var index = 0; index < stepCount; index++)
                  Positioned(
                    top: solidExtent + stepExtent * index,
                    left: 0,
                    right: 0,
                    height: stepExtent,
                    child: _BlurRegion(
                      sigma:
                          maxBlurSigma *
                          progress *
                          appScrollEdgeSigmaWeight(
                            (solidExtent + stepExtent * (index + 0.5)) /
                                height,
                            solidEnd: solidEnd,
                          ),
                    ),
                  ),
                _AdaptiveTint(progress: progress, flatten: flattenTint),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BlurRegion extends StatelessWidget {
  const _BlurRegion({required this.sigma});

  final double sigma;

  @override
  Widget build(BuildContext context) {
    if (sigma < 0.08) return const SizedBox.expand();
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _AdaptiveTint extends StatelessWidget {
  const _AdaptiveTint({required this.progress, this.flatten = false});

  final double progress;
  final bool flatten;

  @override
  Widget build(BuildContext context) {
    final tint = context.isDarkTheme ? Colors.black : Colors.white;
    final opacity = (context.isDarkTheme ? 0.08 : 0.06) * (flatten ? 2.2 : 1);
    return DecoratedBox(
      key: const ValueKey('app-scroll-edge-adaptive-tint'),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tint.withValues(alpha: opacity * progress),
            tint.withValues(alpha: opacity * progress * 0.92),
            tint.withValues(alpha: opacity * progress * 0.45),
            tint.withValues(alpha: 0),
          ],
          stops: const [0, 0.42, 0.72, 1],
        ),
      ),
    );
  }
}
