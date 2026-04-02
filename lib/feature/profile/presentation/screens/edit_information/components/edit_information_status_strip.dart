import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';

/// [ProfileBadgeDefinition] bo‘yicha gorizontal badge tanlovi; `PATCH` da `badge: id`.
class EditInformationStatusStrip extends StatelessWidget {
  const EditInformationStatusStrip({super.key, required this.badges, required this.selectedBadgeId, required this.onSelected});

  final List<ProfileBadgeDefinition> badges;
  final int selectedBadgeId;
  final ValueChanged<int> onSelected;

  static const double _tileSize = 56;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: _tileSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppPadding.paddingHorizontalMd,
        itemCount: badges.length,
        separatorBuilder: (BuildContext _, int _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final badge = badges[index];
          final selected = badge.id == selectedBadgeId;
          return GestureDetector(
            onTap: () => onSelected(badge.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: _tileSize,
              height: _tileSize,
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? context.appColors.primary : context.appColors.stroke, width: selected ? 2 : 1),
                boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Lottie.asset(badge.packageAssetPath, fit: BoxFit.contain, repeat: true),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
