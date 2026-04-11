import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_tablet_max_width.dart';

enum _PrimaryButtonType { elevated, text, outlined }

/// Asosiy tugma shakli: stadion (pill) yoki yumaloq to‘rtburchak ([RoundedRectangleBorder]).
enum AppPrimaryButtonShape {
  /// `StadiumBorder` — tugma ikki uchidan to‘liq yumaloq.
  stadium,

  /// [borderRadius] (standart: [AppRadius.radius3xl]) bo‘yicha yumaloq burchaklar.
  roundedRectangle,
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.elevated({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.height = 56,
    this.expand = true,
    this.shape = AppPrimaryButtonShape.stadium,
    this.borderRadius,
    this.applyTabletMaxWidth = true,
  }) : _type = _PrimaryButtonType.elevated;

  const PrimaryButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.height = 44,
    this.expand = false,
    this.shape = AppPrimaryButtonShape.stadium,
    this.borderRadius,
    this.applyTabletMaxWidth = true,
  }) : _type = _PrimaryButtonType.text;

  /// Dialog / ikkilangan CTA — chegarali, matn va border [foregroundColor] / theme matn rangi.
  const PrimaryButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.height = 52,
    this.expand = true,
    this.shape = AppPrimaryButtonShape.stadium,
    this.borderRadius,
    this.applyTabletMaxWidth = true,
  }) : _type = _PrimaryButtonType.outlined;

  final _PrimaryButtonType _type;
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double height;
  final bool expand;
  final AppPrimaryButtonShape shape;
  final BorderRadius? borderRadius;

  /// `false` — dialog, [Row] / [Expanded] ichida: [AppTabletMaxWidth] qo‘llanmaydi.
  final bool applyTabletMaxWidth;

  OutlinedBorder _elevatedShape(Color resolvedBorder) {
    final side = BorderSide(color: resolvedBorder, width: 3);
    switch (shape) {
      case AppPrimaryButtonShape.stadium:
        return StadiumBorder(side: side);
      case AppPrimaryButtonShape.roundedRectangle:
        return RoundedRectangleBorder(borderRadius: borderRadius ?? AppRadius.radius3xl, side: side);
    }
  }

  Widget _wrap(Widget child) {
    final bounced = Bounce(child: child);
    if (!applyTabletMaxWidth) return bounced;
    return AppTabletMaxWidth(child: bounced);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && !isLoading && onPressed != null;

    late final Color resolvedForeground;
    late final Color resolvedBackground;
    late final Color resolvedBorder;
    switch (_type) {
      case _PrimaryButtonType.text:
        resolvedForeground = foregroundColor ?? context.appColors.primary;
        resolvedBackground = backgroundColor ?? Colors.transparent;
        resolvedBorder = borderColor ?? Colors.transparent;
      case _PrimaryButtonType.outlined:
        resolvedForeground = foregroundColor ?? context.appColors.text;
        resolvedBackground = backgroundColor ?? Colors.transparent;
        resolvedBorder = borderColor ?? context.appColors.text;
      case _PrimaryButtonType.elevated:
        resolvedForeground = foregroundColor ?? AppColors.white;
        resolvedBackground = backgroundColor ?? context.appColors.primary;
        resolvedBorder = borderColor ?? Colors.transparent;
    }

    final labelStyle = textStyle ?? context.textTheme.bodyLargeBold.copyWith(color: resolvedForeground);

    final child = isLoading
        ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: resolvedForeground))
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 10)],
              Text(label, style: labelStyle),
            ],
          );

    final handler = enabled
        ? () {
            Gaimon.light();
            onPressed?.call();
          }
        : null;

    if (_type == _PrimaryButtonType.text) {
      final OutlinedBorder textShape = shape == AppPrimaryButtonShape.roundedRectangle ? RoundedRectangleBorder(borderRadius: borderRadius ?? AppRadius.radiusLg) : const StadiumBorder();
      return _wrap(
        TextButton(
          onPressed: handler,
          style: TextButton.styleFrom(
            minimumSize: Size(expand ? double.infinity : 0, height),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            foregroundColor: resolvedForeground,
            overlayColor: resolvedForeground.withValues(alpha: 0.08),
            shape: textShape,
          ),
          child: child,
        ),
      );
    }

    if (_type == _PrimaryButtonType.outlined) {
      final OutlinedBorder outlinedShape;
      if (shape == AppPrimaryButtonShape.roundedRectangle) {
        outlinedShape = RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppRadius.radius3xl,
          side: BorderSide(color: resolvedBorder),
        );
      } else {
        outlinedShape = StadiumBorder(side: BorderSide(color: resolvedBorder));
      }
      return _wrap(
        OutlinedButton(
          onPressed: handler,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(expand ? double.infinity : 0, height),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            foregroundColor: resolvedForeground,
            disabledForegroundColor: resolvedForeground.withValues(alpha: 0.38),
            backgroundColor: resolvedBackground,
            shape: outlinedShape,
          ),
          child: child,
        ),
      );
    }

    return _wrap(
      ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: Size(expand ? double.infinity : 0, height),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: resolvedBackground,
          disabledBackgroundColor: resolvedBackground.withValues(alpha: 0.55),
          foregroundColor: resolvedForeground,
          shape: _elevatedShape(resolvedBorder),
        ),
        child: child,
      ),
    );
  }
}
