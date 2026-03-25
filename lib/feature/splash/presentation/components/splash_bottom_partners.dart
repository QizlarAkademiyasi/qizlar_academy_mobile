import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

/// Splash ekranining pastki qismi — hamkor logolari (Yoshlar ishlari agentligi, AloqaBank).
class SplashBottomPartners extends StatelessWidget {
  const SplashBottomPartners({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UiKitAssets.images.yoshlarIshlarAgentligi.image(height: 28),
                const SizedBox(width: 8),
                UiKitAssets.images.aloqaBank.image(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
