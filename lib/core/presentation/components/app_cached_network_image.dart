import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

/// Loyiha bo‘ylab tarmoq rasmlari uchun yagona [CachedNetworkImage] o‘rami.
/// Standart placeholder/xato holatlari [AppNetworkImageFallback] orqali beriladi;
/// maxsus UI uchun [placeholder] / [errorWidget] berib, fallbackni bekor qilish mumkin.
class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.cacheKey,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.fallback = const AppNetworkImageFallbackAvatar(),
  });

  final String imageUrl;
  final String? cacheKey;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  /// Berilsa, [fallback] o‘rniga ishlatiladi.
  final PlaceholderWidgetBuilder? placeholder;

  /// Berilsa, [fallback] o‘rniga ishlatiladi.
  final LoadingErrorWidgetBuilder? errorWidget;

  /// [placeholder] yoki [errorWidget] null bo‘lganda qo‘llanadi.
  final AppNetworkImageFallback fallback;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      placeholder: placeholder ?? (ctx, url) => fallback.buildPlaceholder(ctx, width: width, height: height),
      errorWidget: errorWidget ?? (ctx, url, err) => fallback.buildError(ctx, err, width: width, height: height),
    );
  }
}

/// [AppCachedNetworkImage] uchun placeholder va xato holatlarini ifodalovchi strategiya.
sealed class AppNetworkImageFallback {
  const AppNetworkImageFallback();

  Widget buildPlaceholder(BuildContext context, {double? width, double? height});

  Widget buildError(BuildContext context, Object error, {double? width, double? height});
}

/// Avatar: odatda `stroke` fon, markazda foydalanuvchi ikonkasi.
final class AppNetworkImageFallbackAvatar extends AppNetworkImageFallback {
  const AppNetworkImageFallbackAvatar({this.iconSize = 22, this.icon = LucideIcons.user, this.placeholderShowsIcon = true, this.errorShowsBackground = true, this.iconColor});

  final double iconSize;
  final IconData icon;
  final bool placeholderShowsIcon;
  final bool errorShowsBackground;
  final Color? iconColor;

  @override
  Widget buildPlaceholder(BuildContext context, {double? width, double? height}) {
    final stroke = context.appColors.stroke;
    final grey = iconColor ?? context.appColors.grey;
    final iconWidget = Icon(icon, size: iconSize, color: grey);
    final Widget child = placeholderShowsIcon
        ? ColoredBox(
            color: stroke,
            child: Center(child: iconWidget),
          )
        : ColoredBox(color: stroke);
    return _maybeConstrain(child, width, height);
  }

  @override
  Widget buildError(BuildContext context, Object error, {double? width, double? height}) {
    final grey = iconColor ?? context.appColors.grey;
    final iconWidget = Icon(icon, size: iconSize, color: grey);
    final Widget child = errorShowsBackground
        ? ColoredBox(
            color: context.appColors.stroke,
            child: Center(child: iconWidget),
          )
        : Center(child: iconWidget);
    return _maybeConstrain(child, width, height);
  }
}

/// Kurs / kontent kartochkalari: primary tint + kitob ikonkasi.
final class AppNetworkImageFallbackCourse extends AppNetworkImageFallback {
  const AppNetworkImageFallbackCourse({this.iconSize = 32, this.tintAlpha = 0.08});

  final double iconSize;
  final double tintAlpha;

  @override
  Widget buildPlaceholder(BuildContext context, {double? width, double? height}) {
    return _courseBox(width, height);
  }

  @override
  Widget buildError(BuildContext context, Object error, {double? width, double? height}) {
    return _courseBox(width, height);
  }

  Widget _courseBox(double? width, double? height) {
    final child = ColoredBox(
      color: AppColors.primary.withValues(alpha: tintAlpha),
      child: Center(
        child: Icon(LucideIcons.bookOpen, color: AppColors.primary, size: iconSize),
      ),
    );
    return _maybeConstrain(child, width, height);
  }
}

/// Katta cover (masalan kurs detali sarlavhasi): bir xil primary tint.
final class AppNetworkImageFallbackCoverTint extends AppNetworkImageFallback {
  const AppNetworkImageFallbackCoverTint({this.tintAlpha = 0.12});

  final double tintAlpha;

  @override
  Widget buildPlaceholder(BuildContext context, {double? width, double? height}) {
    return _box(context);
  }

  @override
  Widget buildError(BuildContext context, Object error, {double? width, double? height}) {
    return _box(context);
  }

  Widget _box(BuildContext context) {
    return ColoredBox(color: AppColors.primary.withValues(alpha: tintAlpha));
  }
}

/// To‘liq ekran / story fon uchun soket rang.
final class AppNetworkImageFallbackSurface extends AppNetworkImageFallback {
  const AppNetworkImageFallbackSurface();

  @override
  Widget buildPlaceholder(BuildContext context, {double? width, double? height}) {
    return ColoredBox(color: context.appColors.onContainer);
  }

  @override
  Widget buildError(BuildContext context, Object error, {double? width, double? height}) {
    return ColoredBox(color: context.appColors.onContainer);
  }
}

Widget _maybeConstrain(Widget child, double? width, double? height) {
  if (width != null || height != null) {
    return SizedBox(width: width, height: height, child: child);
  }
  return child;
}
