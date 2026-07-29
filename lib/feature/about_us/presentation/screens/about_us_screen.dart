import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/bloc/about_us_bloc.dart';
import 'package:qizlar_academy_mobile/feature/about_us/presentation/screens/about_us_screen_mixin.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_failure_content.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with AboutUsScreenMixin<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AboutUsBloc>()..add(const AboutUsStarted()),
      child: AppPageScaffold(
        title: context.l10n.profileMenuAbout,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                //   child: Row(
                //     children: [
                //       AppBackButton(onTap: () => onAboutUsBackTap(context)),
                //       Expanded(
                //         child: Text(
                //           context.l10n.profileMenuAbout,
                //           textAlign: TextAlign.center,
                //           style: context.textTheme.heading6.copyWith(color: context.appColors.text),
                //         ),
                //       ),
                //       const SizedBox(width: 48),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 8),
                Expanded(
                  child: BlocBuilder<AboutUsBloc, AboutUsState>(
                    buildWhen: (p, c) =>
                        p.status != c.status ||
                        p.content != c.content ||
                        p.messageKey != c.messageKey,
                    builder: (context, state) {
                      switch (state.status) {
                        case AboutUsStatus.initial:
                        case AboutUsStatus.loading:
                          if (state.content == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return buildAboutUsBody(
                            context,
                            model: state.content!,
                          );
                        case AboutUsStatus.success:
                          final model = state.content;
                          if (model == null) {
                            return const SizedBox.shrink();
                          }
                          return buildAboutUsBody(context, model: model);
                        case AboutUsStatus.failure:
                          return TgsFailureContent(
                            message: context.l10n.aboutUsLoadError,
                            onRetry: () => context.read<AboutUsBloc>().add(
                              const AboutUsRetryRequested(),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: context.isDarkTheme
                  ? UiKitAssets.images.bottomNavDark.image(fit: BoxFit.cover)
                  : UiKitAssets.images.bottomNavLight.image(fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
