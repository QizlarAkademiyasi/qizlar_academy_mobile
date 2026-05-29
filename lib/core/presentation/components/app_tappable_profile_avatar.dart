import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_cached_network_image.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_image_shimmer.dart';

/// Profil rasmini ko‘rsatadi; bosilganda [photo_viewer] orqali to‘liq ekran.
/// [Hero] ikkala uchida ham [ClipRRect] — yopish / zoom qaytarishda dumaloq radius saqlanadi.
class AppTappableProfileAvatar extends StatelessWidget {
  const AppTappableProfileAvatar({
    super.key,
    required this.size,
    required this.heroId,
    required this.placeholder,
    this.resolvedNetworkUrl = '',
    this.localFileAbsolutePath,
    this.borderWidth = 2,
    this.borderColor,
    this.fit = BoxFit.cover,
  });

  final double size;
  final String heroId;
  final String resolvedNetworkUrl;
  final String? localFileAbsolutePath;
  final double borderWidth;
  final Color? borderColor;
  final BoxFit fit;
  final Widget placeholder;

  String? get _viewerSource {
    final local = localFileAbsolutePath?.trim() ?? '';
    if (local.isNotEmpty) {
      final f = File(local);
      if (f.existsSync()) return f.absolute.path;
    }
    final net = resolvedNetworkUrl.trim();
    if (net.isNotEmpty) return net;
    return null;
  }

  static String _heroTag(String id, int index, String url) => 'photo_viewer_${id}_${index}_$url';

  BorderRadius get _clipRadius => BorderRadius.circular(size / 2);

  Widget _buildImage(BuildContext context, String source, {double? width, double? height, required BoxFit imageFit}) {
    if (_isNetwork(source)) {
      return AppCachedNetworkImage(
        imageUrl: source,
        fit: imageFit,
        width: width,
        height: height,
        placeholder: (ctx, _) => AppImageShimmer(
          width: width ?? size,
          height: height ?? size,
          shape: BoxShape.circle,
          baseColor: context.appColors.stroke,
          highlightColor: Color.lerp(
                context.appColors.stroke,
                context.appColors.onContainer,
                0.45,
              ) ??
              context.appColors.stroke,
        ),
        errorWidget: (ctx, _, err) => ColoredBox(
          color: context.appColors.stroke,
          child: Icon(LucideIcons.imageOff, color: context.appColors.grey),
        ),
      );
    }
    if (_isPathUrl(source)) {
      return Image.file(
        File(source),
        fit: imageFit,
        width: width,
        height: height,
        errorBuilder: (_, _, err) => ColoredBox(
          color: context.appColors.stroke,
          child: Icon(LucideIcons.imageOff, color: context.appColors.grey),
        ),
      );
    }
    return Image.asset(
      source,
      fit: imageFit,
      width: width,
      height: height,
      errorBuilder: (_, _, err) => ColoredBox(
        color: context.appColors.stroke,
        child: Icon(LucideIcons.imageOff, color: context.appColors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = _viewerSource;
    final clip = _clipRadius;

    final Widget core;
    if (source == null) {
      core = ClipRRect(
        borderRadius: clip,
        child: SizedBox(width: size, height: size, child: placeholder),
      );
    } else {
      final tag = _heroTag(heroId, 0, source);
      core = GestureDetector(
        onTap: () {
          showAppPhotoViewer(
            context: context,
            builders: [
              (ctx) => ClipRRect(
                borderRadius: AppRadius.radiusMd,
                child: _buildImage(context, source, imageFit: BoxFit.contain),
              ),
            ],
            heroTagBuilder: (i) => _heroTag(heroId, i, source),
            initialPage: 0,
            minScale: 1.0,
            maxScale: 3.0,
            showDefaultCloseButton: true,
            enableVerticalDismiss: true,
          );
        },
        child: Hero(
          tag: tag,
          child: ClipRRect(
            borderRadius: clip,
            child: SizedBox(
              width: size,
              height: size,
              child: _buildImage(context, source, width: size, height: size, imageFit: fit),
            ),
          ),
        ),
      );
    }

    final sized = SizedBox(width: size, height: size, child: core);

    if (borderWidth <= 0) {
      return sized;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor ?? context.appColors.primary, width: borderWidth),
      ),
      child: sized,
    );
  }
}

bool _isNetwork(String url) {
  final t = url.trim().toLowerCase();
  return t.startsWith('http://') || t.startsWith('https://');
}

/// [photo_viewer] paketidagi path aniqlash bilan mos.
bool _isPathUrl(String url) {
  if (!Platform.isWindows && url.startsWith('/')) {
    return true;
  }
  if (Platform.isWindows && url.length >= 3) {
    final firstChar = url[0].toUpperCase();
    final firstCharIsInRange = firstChar.compareTo('A') >= 0 && firstChar.compareTo('Z') <= 0;
    final secondCharIsColon = url[1] == ':';
    final thirdCharIsSlash = url[2] == '/' || url[2] == r'\';
    if (firstCharIsInRange && secondCharIsColon && thirdCharIsSlash) {
      return true;
    }
  }
  return false;
}
