import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_kit/gen/assets.gen.dart';
import 'package:qizlar_academy_mobile/config/constants/colors.dart';
import 'package:qizlar_academy_mobile/config/constants/theme/theme_extension.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

class AiChatWelcomeContent extends StatelessWidget {
  const AiChatWelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final logoColor = context.isDarkTheme
        ? AppColors.white
        : context.appColors.primary;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 58).clamp(0, double.infinity),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 42),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(logoColor, BlendMode.srcIn),
                  child: UiKitAssets.images.logoRemoved.image(
                    width: 92,
                    height: 92,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.l10n.aiChatGreeting,
                  textAlign: TextAlign.center,
                  style: context.textTheme.heading3.copyWith(
                    color: context.appColors.text,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  context.l10n.aiChatGreetingSubtitle,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMediumRegular.copyWith(
                    color: context.appColors.secondaryGrey,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
