import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

enum _PrimaryButtonType { elevated, icon, text }

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
  }) : _type = _PrimaryButtonType.elevated;

  const PrimaryButton.icon({
    super.key,
    required this.label,
    required this.onPressed,
    required this.leading,
    this.isEnabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.height = 56,
    this.expand = true,
  }) : _type = _PrimaryButtonType.icon;

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
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: resolvedForeground,
            ),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_type == _PrimaryButtonType.icon && leading != null) ...[
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
            shape: const StadiumBorder(),
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
          shape: StadiumBorder(side: BorderSide(color: resolvedBorder)),
        ),
        child: child,
      ),
    );
  }
}
