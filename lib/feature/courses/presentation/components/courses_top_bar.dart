import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CoursesTopBar extends StatelessWidget {
  const CoursesTopBar({super.key, required this.onNotificationTap});

  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.coursesAllTitle,
              style: context.textTheme.heading5.copyWith(
                color: context.appColors.text,
              ),
            ),
          ),
          Bounce(
            tilt: false,
            onTap: () {
              Gaimon.selection();
              onNotificationTap();
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: context.appColors.onContainer,
                borderRadius: AppRadius.radiusXl,
                border: Border.all(color: context.appColors.stroke),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: Icon(
                      LucideIcons.bell,
                      size: 20,
                      color: context.appColors.text,
                    ),
                  ),
                  Positioned(
                    top: 11,
                    right: 11,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.appColors.onContainer,
                          width: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
