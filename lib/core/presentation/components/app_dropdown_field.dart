import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_radius.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_tablet_max_width.dart';

/// Dropdown ko'rinishidagi tanlash maydoni. Bosilganda [onTap] chaqiriladi.
class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.hint,
    this.value,
    this.onTap,
    this.enabled = true,
  });

  final String hint;
  final String? value;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasValue = value != null && value!.isNotEmpty;
    final textStyle = context.textTheme.bodyLargeMedium.copyWith(
      color: hasValue ? colors.text : colors.secondaryGrey,
    );

    return AppTabletMaxWidth(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56, maxHeight: 56),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.onContainer,
              borderRadius: AppRadius.radiusLg,
              border: Border.all(color: colors.stroke),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value! : hint,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(LucideIcons.chevronDown, size: 20, color: colors.secondaryGrey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
