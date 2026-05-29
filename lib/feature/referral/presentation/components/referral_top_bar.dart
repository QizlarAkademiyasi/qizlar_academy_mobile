import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class ReferralTopBar extends StatelessWidget {
  const ReferralTopBar({super.key, required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton.ghost(onTap: onBackTap),
            ),
            Text(
              'Bizning elchilarimiz',
              style: context.textTheme.bodyXLargeSemibold.copyWith(
                color: context.appColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
