import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class LeaderboardCategoryDropdown extends StatelessWidget {
  const LeaderboardCategoryDropdown({
    super.key,
    required this.selectedCourseName,
    required this.onTap,
  });

  final String selectedCourseName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Gaimon.soft();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.appColors.onContainer,
          borderRadius: AppRadius.radius5xl,
          border: Border.all(color: context.appColors.stroke),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedCourseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMediumMedium.copyWith(
                  color: context.appColors.text,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronDown,
              size: 20,
              color: context.appColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
