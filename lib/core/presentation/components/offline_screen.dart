import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/assets/assets.gen.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key, required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Lottie.asset(
                        UiKitAssets.lottie.rabbit.boredRabbit,
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      context.l10n.offlineTitle,
                      textAlign: TextAlign.center,
                      style: context.textTheme.heading4.copyWith(
                        color: colors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.offlineDescription,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMediumRegular.copyWith(
                        color: colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(LucideIcons.refreshCw, size: 19),
                      label: Text(context.l10n.offlineRetry),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(220, 52),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: const StadiumBorder(),
                        textStyle: context.textTheme.bodyLargeBold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            context.l10n.offlineWaiting,
                            style: context.textTheme.bodySmallRegular.copyWith(
                              color: colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
