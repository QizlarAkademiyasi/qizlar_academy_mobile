import 'package:flutter/services.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_gap.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_tablet_max_width.dart';

/// Ilova bo‘ylab bir xil fon, radius, chegarasi va ichki padding bilan matn maydoni.
/// [labelText] berilsa, u maydon ustida alohida [Text] sifatida chiqadi (ichida emas).
/// Vertikal markazlash va chap/o‘ng padding muammolarini bartaraf etadi.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;

  static const double _minHeight = 52;
  static const double _maxHeight = 56;
  static const double _horizontalInset = 16;
  static const double _verticalPadding = 14;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyle = context.textTheme.bodyLargeMedium.copyWith(color: colors.text);
    final secondaryStyle = context.textTheme.bodyLargeMedium.copyWith(color: colors.secondaryGrey);

    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      style: textStyle,
      cursorColor: colors.primary,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: EdgeInsets.only(left: prefix == null ? _horizontalInset : 0, right: suffix == null ? _horizontalInset : 8, top: _verticalPadding, bottom: _verticalPadding),
        hintText: hintText,
        hintStyle: secondaryStyle,
      ),
    );

    final input = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _maxHeight, maxHeight: _maxHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.onContainer,
          borderRadius: AppRadius.radiusLg,
          border: Border.all(color: colors.stroke),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.radiusLg,
          child: Material(
            type: MaterialType.transparency,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (prefix != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: _horizontalInset),
                    child: DefaultTextStyle.merge(style: secondaryStyle, child: prefix!),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 1,
                    height: 24,
                    child: DecoratedBox(decoration: BoxDecoration(color: colors.stroke)),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(child: field),
                if (suffix != null) Padding(padding: const EdgeInsets.only(right: 8), child: suffix!),
              ],
            ),
          ),
        ),
      ),
    );

    if (labelText == null || labelText!.isEmpty) {
      return AppTabletMaxWidth(child: input);
    }

    return AppTabletMaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(labelText!, style: secondaryStyle),
          SizedBox(height: AppGap.gapXs),
          input,
        ],
      ),
    );
  }
}
