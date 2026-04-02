import 'dart:ui';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Kurs ekrani pastki «dok» tugmasi: blur fon + [PrimaryButton] ([AppPrimaryButtonShape.roundedRectangle]).
class CourseBottomAction extends StatelessWidget {
  const CourseBottomAction({
    super.key,
    required this.label,
    required this.onTap,
    this.showLeadingIcon = true,
    this.leadingIcon,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool showLeadingIcon;

  /// `null` bo‘lsa va [showLeadingIcon] `true` bo‘lsa — [LucideIcons.play].
  final IconData? leadingIcon;
  final bool enabled;
  final bool isLoading;

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
          child: PrimaryButton.elevated(
            label: label,
            onPressed: onTap,
            isEnabled: enabled,
            isLoading: isLoading,
            shape: AppPrimaryButtonShape.roundedRectangle,
            borderRadius: AppRadius.radius3xl,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            textStyle: context.textTheme.bodyLargeBold.copyWith(color: AppColors.white),
            leading: showLeadingIcon
                ? Icon(
                    leadingIcon ?? LucideIcons.play,
                    color: AppColors.white,
                    size: 20,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
