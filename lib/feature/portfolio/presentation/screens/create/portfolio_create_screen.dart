import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/components/portfolio_avatar.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/bloc/portfolio_create_bloc.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/components/portfolio_create_media_strip.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/portfolio_create_screen_mixin.dart';

class PortfolioCreateScreen extends StatelessWidget {
  const PortfolioCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PortfolioCreateBloc>(),
      child: const _PortfolioCreateView(),
    );
  }
}

class _PortfolioCreateView extends StatefulWidget {
  const _PortfolioCreateView();

  @override
  State<_PortfolioCreateView> createState() => _PortfolioCreateViewState();
}

class _PortfolioCreateViewState extends State<_PortfolioCreateView>
    with PortfolioCreateScreenMixin<_PortfolioCreateView> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<PortfolioCreateBloc>().state;
    final submitting = state.status == PortfolioCreateStatus.submitting;

    return AppPageScaffold(
      title: 'Yangi portfolio',
      onBackTap: () => onCloseTap(context),
      backButton: AppBackButton.ghost(
        icon: LucideIcons.x,
        onTap: () => onCloseTap(context),
      ),
      actions: [
        IconButton(
          onPressed: submitting ? null : () => onAddImageTap(context),
          icon: const Icon(LucideIcons.imagePlus),
        ),
      ],
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: BlocConsumer<PortfolioCreateBloc, PortfolioCreateState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.message != current.message,
        listener: portfolioCreateBlocListener,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    12,
                    24,
                    MediaQuery.paddingOf(context).bottom + 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const PortfolioAvatar(
                            photoUrl: '',
                            name: 'Portfolio',
                            size: 32,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: captionController,
                                  onChanged: (value) =>
                                      onCaptionChanged(context, value),
                                  enabled: !submitting,
                                  minLines: 1,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: 'Enter a message',
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    border: InputBorder.none,
                                    hintStyle: context
                                        .textTheme
                                        .bodyLargeRegular
                                        .copyWith(
                                          color:
                                              context.appColors.secondaryGrey,
                                        ),
                                  ),
                                  style: context.textTheme.bodyLargeRegular
                                      .copyWith(color: context.appColors.text),
                                ),
                                const SizedBox(height: 10),
                                PortfolioCreateMediaStrip(
                                  media: state.media,
                                  onRemove: (index) =>
                                      onRemoveMedia(context, index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 52,
                        child: PrimaryButton.elevated(
                          label: submitting ? 'Joylanmoqda...' : 'Joylash',
                          leading: submitting
                              ? null
                              : const Icon(LucideIcons.filePlus, size: 18),
                          expand: true,
                          onPressed: state.canSubmit
                              ? () => onSubmit(context)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
