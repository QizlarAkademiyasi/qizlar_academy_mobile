import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';

class NotificationEmptyContent extends StatelessWidget {
  const NotificationEmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: TgsEmptyContent(
          message: l10n.notificationsEmpty,
          subtitle: l10n.notificationsEmptySubtitle,
          tgsAsset: UiKitAssets.lottie.rabbit.sleepRabbit,
          animationSize: 112,
        ),
      ),
    );
  }
}
