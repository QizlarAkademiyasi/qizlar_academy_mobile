import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';

enum _PrimaryButtonType { elevated, text }

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
  }) : _type = _PrimaryButtonType.text;

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

  OutlinedBorder _buttonShape(Color resolvedBorder) {
    final side = BorderSide(color: resolvedBorder);
    switch (shape) {
      case AppPrimaryButtonShape.stadium:
        return StadiumBorder(side: side);
      case AppPrimaryButtonShape.roundedRectangle:
        return RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppRadius.radius3xl,
          side: side,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && !isLoading && onPressed != null;
    final resolvedForeground =
        foregroundColor ??
        (_type == _PrimaryButtonType.text
            ? context.appColors.primary
            : AppColors.white);
    final resolvedBackground =
        backgroundColor ??
        (_type == _PrimaryButtonType.text
            ? Colors.transparent
            : context.appColors.primary);
    final resolvedBorder = borderColor ?? Colors.transparent;
    final labelStyle =
        textStyle ??
        context.textTheme.bodyLargeBold.copyWith(color: resolvedForeground);

    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: resolvedForeground,
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 10),
              ],
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
      final OutlinedBorder textShape = shape == AppPrimaryButtonShape.roundedRectangle
          ? RoundedRectangleBorder(
              borderRadius: borderRadius ?? AppRadius.radiusLg,
            )
          : const StadiumBorder();
      return Bounce(
        child: TextButton(
          onPressed: handler,
          style: TextButton.styleFrom(
            minimumSize: Size(expand ? double.infinity : 0, height),
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            foregroundColor: resolvedForeground,
            overlayColor: resolvedForeground.withValues(alpha: 0.08),
            shape: textShape,
          ),
          child: child,
        ),
      );
    }

    return Bounce(
      child: ElevatedButton(
        onPressed: handler,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: Size(expand ? double.infinity : 0, height),
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: resolvedBackground,
          disabledBackgroundColor: resolvedBackground.withValues(alpha: 0.55),
          foregroundColor: resolvedForeground,
          shape: _buttonShape(resolvedBorder),
        ),
        child: child,
      ),
    );
  }
}
