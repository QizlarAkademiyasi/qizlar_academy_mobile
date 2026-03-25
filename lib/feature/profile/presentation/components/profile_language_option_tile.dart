import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_language_option_model.dart';

class ProfileLanguageOptionTile extends StatelessWidget {
  const ProfileLanguageOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    this.showDivider = true,
  });

  final ProfileLanguageOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: AppRadius.radiusMd,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Text(option.flagEmoji, style: context.textTheme.heading3),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.title,
                    style: context.textTheme.bodyMediumSemibold.copyWith(
                      color: context.appColors.text,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18,
                  height: 18,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? context.appColors.primary
                          : context.appColors.stroke,
                      width: 2,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? context.appColors.primary
                          : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: context.appColors.stroke),
      ],
    );
  }
}
