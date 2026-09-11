import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/home/presentation/components/home_course_card.dart';

class HomeAllCoursesCard extends StatelessWidget {
  const HomeAllCoursesCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkTheme;
    return AppLiquidStretch(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Gaimon.selection();
          onTap?.call();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusLg,
            border: Border.all(
              color: dark ? context.appColors.stroke : const Color(0xFFEAEAEA),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: dark
                  ? const [Color(0xFF3A2030), Color(0xFF1E2438)]
                  : const [Color(0xFFFCE7F3), Color(0xFFE0E7FF)],
            ),
            boxShadow: homeCourseSoftShadows(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.coursesAllTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: context.appColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.storeViewButton,
                    style: context.textTheme.bodySmallMedium.copyWith(
                      color: AppColors.secondaryGrey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.arrowRight,
                    size: 20,
                    color: AppColors.secondaryGrey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
