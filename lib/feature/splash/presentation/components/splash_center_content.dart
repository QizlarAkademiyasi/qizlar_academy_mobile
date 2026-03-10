import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/components/app_components.dart';

/// Splash ekranining markaziy qismi — asosiy logo.
class SplashCenterContent extends StatelessWidget {
  const SplashCenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UiKitAssets.images.splashLogoSvg.svg(
          width: 72,
          height: 72,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ],
    );
  }
}
