import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Splash ekranining pastki qismi — hamkor logolari (Yoshlar ishlari agentligi, Qizlar ovozi).
class SplashBottomPartners extends StatelessWidget {
  const SplashBottomPartners({super.key});

  // PNG ichidagi kontent: YIA 183×42 (matn/greb past bo‘yda), Qizlar 404×94 (belgida yirik grafika).
  // Bir xil `height` o‘ngdagi yirik piksellar tufayli muvozanatsiz — balandlik koeff. bilan vizual tenglashtiriladi.
  static const _yoshlarHeightFactor = 0.86;
  static const _qizlarHeightFactor = 0.86;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final baseH = (w * 0.09).clamp(30.0, 36.0);
    final hYoshlar = baseH * _yoshlarHeightFactor;
    final hQizlar = baseH * _qizlarHeightFactor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: UiKitAssets.images.yoshlarIshlarAgentligi.image(
                height: hYoshlar,
              ),
            ),
          ),
          SizedBox(width: w * 0.05),
          Expanded(
            child: Center(
              child: UiKitAssets.images.qizlarOvoziLogo.image(height: hQizlar),
            ),
          ),
        ],
      ),
    );
  }
}
