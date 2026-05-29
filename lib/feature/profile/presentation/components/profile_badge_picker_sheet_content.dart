import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';

String _profileBadgePickerLabel(ProfileBadgeDefinition badge) {
  final key = badge.key?.trim();
  if (key == null || key.isEmpty) {
    return '#${badge.id}';
  }
  return key
      .split('_')
      .map((word) {
        if (word.isEmpty) return word;
        return '${word[0].toUpperCase()}${word.length > 1 ? word.substring(1) : ''}';
      })
      .join(' ');
}

class ProfileBadgePickerSheetContent extends StatelessWidget {
  const ProfileBadgePickerSheetContent({
    super.key,
    required this.badges,
    required this.selectedBadgeId,
    required this.onSelected,
  });

  final List<ProfileBadgeDefinition> badges;
  final int selectedBadgeId;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.55),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: context.appColors.onContainer,
            borderRadius: AppRadius.radiusXl,
            border: Border.all(color: context.appColors.stroke),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(badges.length, (index) {
              final badge = badges[index];
              final isSelected = badge.id == selectedBadgeId;
              return Column(
                children: [
                  InkWell(
                    borderRadius: AppRadius.radiusMd,
                    onTap: () => onSelected(badge.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 44,
                            height: 44,
                            child: Lottie.asset(badge.packageAssetPath, fit: BoxFit.contain, repeat: true),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _profileBadgePickerLabel(badge),
                              style: context.textTheme.bodyMediumSemibold.copyWith(color: context.appColors.text),
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
                                color: isSelected ? context.appColors.primary : context.appColors.stroke,
                                width: 2,
                              ),
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? context.appColors.primary : Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index != badges.length - 1) Divider(height: 1, thickness: 1, color: context.appColors.stroke),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
