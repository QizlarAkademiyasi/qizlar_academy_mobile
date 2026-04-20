import 'dart:ui';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

enum AppBackButtonType { plain, glass }

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.type = AppBackButtonType.plain,
    this.onTap,
    this.iconColor,
  });

  const AppBackButton.glass({super.key, this.onTap, this.iconColor})
    : type = AppBackButtonType.glass;

  final AppBackButtonType type;
  final VoidCallback? onTap;
  final Color? iconColor;

  void _handleBack(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go(Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    if (type == AppBackButtonType.glass) {
      return Bounce(
        onTap: () {
          Gaimon.light();
          _handleBack(context);
        },
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.22),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.14),
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.arrowLeft,
                color: iconColor ?? AppColors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    return IconButton(
      onPressed: () {
        Gaimon.light();
        _handleBack(context);
      },
      splashRadius: 20,
      icon: Icon(
        LucideIcons.chevronLeft,
        color: iconColor ?? context.appColors.text,
      ),
    );
  }
}
