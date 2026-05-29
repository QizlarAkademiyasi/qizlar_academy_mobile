import 'package:flutter/cupertino.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_tablet_max_width.dart';

DateTime _clampDate(DateTime d, DateTime min, DateTime max) {
  if (d.isBefore(min)) return min;
  if (d.isAfter(max)) return max;
  return d;
}

/// Sana tanlash: maydon bosilganda inline [CupertinoDatePicker] ochiladi/yopiladi.
/// Bottom sheet ichida overlay muammolarisiz ishlaydi.
class AppSpinnerDatePickerField extends StatefulWidget {
  const AppSpinnerDatePickerField({
    super.key,
    required this.hint,
    this.value,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.enabled = true,
    this.dateFormatPattern = 'dd.MM.yyyy',
    this.initTimeWhenValueNull,
  });

  final String hint;
  final DateTime? value;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool enabled;
  final String dateFormatPattern;

  /// [value] null bo'lganda picker ochilganda ko'rsatiladigan boshlang'ich sana.
  final DateTime? initTimeWhenValueNull;

  @override
  State<AppSpinnerDatePickerField> createState() =>
      _AppSpinnerDatePickerFieldState();
}

class _AppSpinnerDatePickerFieldState extends State<AppSpinnerDatePickerField> {
  bool _expanded = false;

  DateTime _initialForPicker() {
    if (widget.value != null) {
      return _clampDate(widget.value!, widget.firstDate, widget.lastDate);
    }
    final fallback = widget.initTimeWhenValueNull ??
        DateTime(
          widget.lastDate.year - 16,
          widget.lastDate.month,
          widget.lastDate.day,
        );
    return _clampDate(fallback, widget.firstDate, widget.lastDate);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasValue = widget.value != null;
    final textStyle = context.textTheme.bodyLargeMedium.copyWith(
      color: hasValue ? colors.text : colors.secondaryGrey,
    );
    final label = hasValue
        ? DateFormat(widget.dateFormatPattern).format(widget.value!)
        : widget.hint;

    return AppTabletMaxWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.enabled
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56, maxHeight: 56),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onContainer,
                  borderRadius: _expanded
                      ? const BorderRadius.vertical(
                          top: Radius.circular(12),
                        )
                      : AppRadius.radiusLg,
                  border: Border.all(color: colors.stroke),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: textStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          LucideIcons.chevronDown,
                          size: 20,
                          color: colors.secondaryGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.onContainer,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                      border: Border.all(color: colors.stroke),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _initialForPicker(),
                        minimumDate: widget.firstDate,
                        maximumDate: widget.lastDate,
                        onDateTimeChanged: widget.onDateSelected,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
