import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ProfileFilterChips extends StatelessWidget {
  const ProfileFilterChips({super.key, required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final widget = items[index];
          final isActive = index == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? context.appColors.onContainer
                  : context.appColors.onContainer.withValues(alpha: 0.6),
              borderRadius: AppRadius.radiusXl,
              border: Border.all(
                color: isActive
                    ? context.appColors.stroke
                    : context.appColors.stroke.withValues(alpha: 0.7),
              ),
            ),
            child: Center(child: widget),
          );
        },
      ),
    );
  }
}
