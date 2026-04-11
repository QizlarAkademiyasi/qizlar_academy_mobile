import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/exception_screens/presentation/components/tgs_empty_content.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/bloc/vacancy_detail_bloc.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/components/vacancy_detail_content.dart';
import 'package:qizlar_academy_mobile/feature/vacancy/presentation/screens/vacancy_detail/vacancy_detail_screen_mixin.dart';

class VacancyDetailScreen extends StatefulWidget {
  const VacancyDetailScreen({super.key, required this.vacancyId});

  final String vacancyId;

  @override
  State<VacancyDetailScreen> createState() => _VacancyDetailScreenState();
}

class _VacancyDetailScreenState extends State<VacancyDetailScreen> with VacancyDetailScreenMixin<VacancyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VacancyDetailBloc>()..add(VacancyDetailStarted(widget.vacancyId)),
      child: BlocConsumer<VacancyDetailBloc, VacancyDetailState>(
        listener: vacancyDetailBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: context.appColors.background,
              title: Text(context.l10n.vacancyDetailsTitle, style: context.textTheme.heading6.copyWith(color: context.appColors.text)),
            ),
            backgroundColor: context.theme.scaffoldBackgroundColor,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: switch (state.status) {
                        VacancyDetailStatus.initial || VacancyDetailStatus.loading => const Center(child: CircularProgressIndicator()),
                        VacancyDetailStatus.failure => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TgsEmptyContent(message: context.l10n.vacancyDetailLoadError, animationSize: 120),
                          ),
                        ),
                        VacancyDetailStatus.success when state.detail != null => VacancyDetailContent(detail: state.detail!),
                        _ => const SizedBox.shrink(),
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: context.isDarkTheme ? UiKitAssets.images.bottomNavDark.image(fit: BoxFit.cover) : UiKitAssets.images.bottomNavLight.image(fit: BoxFit.cover),
                ),
                if (state.status == VacancyDetailStatus.success && state.detail != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 8 + MediaQuery.paddingOf(context).bottom),
                      child: PrimaryButton.elevated(label: context.l10n.vacancyApplyCta, onPressed: () => onVacancyDetailApplyTap(context)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
