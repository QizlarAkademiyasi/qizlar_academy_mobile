import 'dart:ui';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class CourseBottomAction extends StatelessWidget {
  const CourseBottomAction({
    super.key,
    required this.label,
    required this.onTap,
    this.showLeadingIcon = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool showLeadingIcon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.radius3xl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.appColors.onContainer.withValues(alpha: 0.85),
            borderRadius: AppRadius.radius3xl,
            border: Border.all(color: context.appColors.stroke),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadow.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Bounce(
            onTap: () {
              Gaimon.light();
              onTap();
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.radius3xl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showLeadingIcon) ...[
                    Icon(LucideIcons.play, color: AppColors.white, size: 18),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: context.textTheme.bodyLargeBold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
